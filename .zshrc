# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshconfig="vi ~/.zshrc"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# added by me
alias git='LANG=en_US git'
alias git_size='git rev-list --objects --all | git cat-file --batch-check='\''%(objecttype) %(objectname) %(objectsize) %(rest)'\'' | sed -n '\''s/^blob //p'\'' | sort --numeric-sort --key=2 | cut -c 1-12,41- | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest'
alias ls='lsd'
if [[ $OS == 'darwin' ]]; then
    alias vi="nvim" # don't need on Linux thanks to alternatives
fi

if [[ $OS == 'darwin' ]]; then
    # add some paths missing on macOS
    [[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
    [[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"
    rehash # re-apply paths to directly use them
fi

AWS_COMPLETER_PATH="$HOME/bin/aws_completer"
TERRAFORM_PATH="$HOME/bin/terraform"
TERRAGRUNT_PATH="$HOME/bin/terragrunt"
JETBRAINS_TOOLBOX_SCRIPT_PATH="$HOME/.local/share/JetBrains/Toolbox/scripts"
if [[ $OS == 'darwin' ]]; then
    AWS_COMPLETER_PATH="/opt/homebrew/bin/aws_completer"
    TERRAFORM_PATH="$HOME/bin/terraform"
    TERRAGRUNT_PATH="$HOME/bin/terragrunt"
    JETBRAINS_TOOLBOX_SCRIPT_PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

if [[ $OS == 'darwin' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # added by OrbStack: command-line tools and integration
    [[ -d "$HOME/.orbstack/bin" ]] && export PATH="$PATH:$HOME/.orbstack/bin"
    [[ -d "/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh" ]] && cp -f "/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh/*" "$ZSH_CACHE_DIR/completions/." # copy completions in omz completion cache, need a restart of terminal

    export GPG_TTY=$(tty)
fi

# volta
[[ -d "$HOME/.volta" ]] && export VOLTA_HOME="$HOME/.volta"
[[ -d "$VOLTA_HOME/bin" ]] && export PATH="$PATH:$VOLTA_HOME/bin"
[[ -f "$VOLTA_HOME/bin/volta" && -d "$ZSH_CACHE_DIR/completions" ]] && "$VOLTA_HOME/bin/volta" completions zsh --force --output "$ZSH_CACHE_DIR/completions/_volta" --quiet # copy completions in omz completion cache, need a restart of terminal

# fvm
[[ -d "$HOME/.fvm/cache" ]] && export FVM_CACHE_PATH="$HOME/.fvm/cache"
[[ -f "$HOME/.dart-cli-completion/fvm.zsh" ]] && source "$HOME/.dart-cli-completion/fvm.zsh"
[[ -d "$HOME/.fvm/cache/default/bin" ]] && export PATH="$PATH:$HOME/.fvm/cache/default/bin"
[[ -d "$HOME/.pub-cache/bin" ]] && export PATH="$PATH:$HOME/.pub-cache/bin"

# other completions
[[ -f $AWS_COMPLETER_PATH ]] && complete -C $AWS_COMPLETER_PATH aws
[[ -f $TERRAFORM_PATH ]] && complete -o nospace -C $TERRAFORM_PATH terraform
[[ -f $TERRAGRUNT_PATH ]] && complete -o nospace -C $TERRAGRUNT_PATH terragrunt

# added by Toolbox App
[[ -d "$JETBRAINS_TOOLBOX_SCRIPT_PATH" ]] && export PATH="$PATH:$JETBRAINS_TOOLBOX_SCRIPT_PATH"

# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

if [[ $OS == 'darwin' ]]; then
    # THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    export SDKMAN_DIR="$HOME/.sdkman"
    [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

chpwd-hook() {
    if [[ -f providers.tf || -f provider.tf ]]; then tfswitch; fi
    if [[ -f .fvmrc ]]; then fvm use; fi
}
add-zsh-hook chpwd chpwd-hook

echo ".zshrc loaded"
