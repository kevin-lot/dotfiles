#!/bin/bash
# US (\x1f) as separator: tab is IFS whitespace, so empty fields would collapse.
IFS=$'\x1f' read -r project_dir current_dir model added removed ctx_pct \
  has_rl five_pct five_risk week_pct week_risk session_name < <(
  jq -r '
    def pct: if . == null then "" else (. | floor | if . > 100 then 100 elif . < 0 then 0 else . end | tostring) end;
    def epoch: if type == "number" then . elif type == "string" then
      (sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | try fromdateiso8601 catch null) else null end;
    # pace = used / elapsed share of the window; elapsed floored at 10% so a fresh window is not red
    def risk($window): .used_percentage as $u | (.resets_at | epoch) as $r
      | if $u == null then null
        elif $r == null then $u
        else ((1 - ($r - now) / $window) * 100 | if . < 10 then 10 elif . > 100 then 100 else . end) as $elapsed
          | ($u / $elapsed - 0.5) / 1.5 * 100 end
      | pct;
    (.context_window // {}) as $cw
    | ($cw.current_usage // {}) as $u
    | [
        (.workspace.project_dir // .workspace.current_dir // .cwd // ""),
        (.workspace.current_dir // .cwd // ""),
        (.model.id // .model.display_name // "?"),
        (.cost.total_lines_added // 0 | tostring),
        (.cost.total_lines_removed // 0 | tostring),
        ($cw.used_percentage
          // (if ($cw.context_window_size // 0) > 0
              then (($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0)) * 100 / $cw.context_window_size
              else 0 end)
          | pct),
        (if .rate_limits == null then "" else "1" end),
        (.rate_limits.five_hour.used_percentage | pct),
        (.rate_limits.five_hour // {} | risk(18000)),
        (.rate_limits.seven_day.used_percentage | pct),
        (.rate_limits.seven_day // {} | risk(604800)),
        (.session_name // "")
      ] | join("\u001f")'
)

R=$'\033[0m' B=$'\033[1m'
col() { printf -v C '\033[38;2;%d;%d;%dm' "$1" "$2" "$3"; }
col 100 100 100; GRAY=$C
col 60 60 60; DARK=$C
col 0 200 80; GREEN=$C
col 220 40 20; RED=$C
SEP="${GRAY} │ ${R}"
BAR_WIDTH=20

gradient() {
  local f t=$1
  if (( t <= 500 )); then
    f=$(( t * 2 ))
    col $(( 220 * f / 1000 )) 200 $(( 80 - 80 * f / 1000 ))
    return
  fi
  f=$(( (t - 500) * 2 ))
  col 220 $(( 200 - 160 * f / 1000 )) $(( 20 * f / 1000 ))
}

bar() {
  local pct=$1 n=$2 risk=$3 i t filled=$(( ($1 * $2 + 50) / 100 ))
  BAR=""
  for (( i = 0; i < n; i++ )); do
    if (( i >= filled )); then BAR+="${DARK}░"; continue; fi
    t=$(( i * 1000 / (n - 1) ))
    [[ -n $risk ]] && t=$(( risk * 10 * (i + 1) / filled ))
    gradient "$t"
    BAR+="${C}█"
  done
  BAR+=$R
}

header=""
line1=""
[[ -n $session_name ]] && { col 255 140 60; header="${B}${C}${session_name}${R}"; }
col 230 200 40; line1+="📁 ${B}${C}${project_dir##*/}${R}"
if [[ -n $current_dir && $current_dir != "$project_dir" && $current_dir == "$project_dir"/* ]]; then
  col 150 130 30; line1+="${C}/${current_dir#"$project_dir"/}${R}"
fi

if branch=$(git -C "$current_dir" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null \
  || git -C "$current_dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
  dirty=""
  [[ -n $(git -C "$current_dir" --no-optional-locks status --porcelain 2>/dev/null | head -c1) ]] && dirty="${RED}*"
  col 0 200 220; line1+="${SEP}🌿 ${B}${C}(${branch}${dirty}${C})${R}"
fi

line1_right="${GREEN}+${added}${R} ${RED}-${removed}${R}"
col 200 80 220; line1_right+="${SEP}🤖 ${C}${model}${R}"

icon=🚨
(( ctx_pct < 90 )) && icon=🔥
(( ctx_pct < 70 )) && icon=⚡
(( ctx_pct < 20 )) && icon=🟢
bar "$ctx_pct" "$BAR_WIDTH"
line2="${icon} context: ${BAR}"

limit_segment() {
  local label=$1 pct=$2 risk=$3
  bar "$pct" "$BAR_WIDTH" "$risk"
  SEG="${label} ${BAR}"
}

segs=()
if [[ -n $five_pct ]]; then limit_segment "⏳ session:" "$five_pct" "$five_risk"; segs+=("$SEG"); fi
if [[ -n $week_pct ]]; then limit_segment "📅 week:" "$week_pct" "$week_risk"; segs+=("$SEG"); fi

if [[ -n $has_rl ]]; then
  for seg in "${segs[@]}"; do line2+="${SEP}${seg}"; done
fi

shopt -s extglob
# Emojis take 2 columns but count as 1 char; the variation selector counts as 1 but takes none.
width() {
  local LC_ALL=en_US.UTF-8
  local s=${1//$'\e'\[+([0-9;])m/}
  s=${s//$'\xef\xb8\x8f'/}
  local e narrow=$s
  # bash 3.2 matches [...] classes per byte, which would also strip █ and ░.
  for e in 📁 🌿 ⚡ 🟢 🔥 🚨 🤖 ⏳ 📅; do narrow=${narrow//$e/}; done
  W=$(( ${#s} * 2 - ${#narrow} ))
}

width "$line1"; left=$W
width "$line1_right"; right=$W
width "$line2"; gap=$(( W - left - right ))
pad=$SEP
(( gap >= 3 )) && printf -v pad '%*s' "$gap" ''
line1+="${pad}${line1_right}"

if [[ -n $header ]]; then
  max=0
  for l in "$line1" "$line2"; do
    width "$l"
    (( W > max )) && max=$W
  done
  width "$header"
  # Leading reset: Claude Code trims leading whitespace, which would drop the padding.
  printf '%s%*s%s\n%s\n' "$R" $(( (max - W) / 2 )) '' "$header" "$R"
fi
printf '%s\n%s\n%s' "$line1" "$line2" "$R"
