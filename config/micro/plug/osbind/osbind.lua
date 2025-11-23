local config = import("micro/config")
local os = import("os")

function init()
    if os.Getenv("OSTYPE") == "darwin" then
        -- macOS
        config.TryBindKey("Cmd-y", "Redo", true)
        config.TryBindKey("Cmd-z", "Undo", true)
        config.TryBindKey("Cmd-Left", "SelectWordLeft", true)
        config.TryBindKey("Cmd-Right", "SelectWordRight", true)
        config.TryBindKey("Cmd-d", "DeleteLine", true)
    else
        -- Linux or other Unix
        config.TryBindKey("Ctrl-y", "Redo", true)
        config.TryBindKey("Ctrl-z", "Undo", true)
        config.TryBindKey("Ctrl-Left", "SelectWordLeft", true)
        config.TryBindKey("Ctrl-Right", "SelectWordRight", true)
        config.TryBindKey("Ctrl-d", "DeleteLine", true)
    end
end
