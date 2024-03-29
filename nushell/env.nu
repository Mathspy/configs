# Nushell Environment Config File

# def create_left_prompt [] {
#     let path_segment = ($env.PWD)
# 
#     $path_segment
# }
# 
# def create_right_prompt [] {
#     let time_segment = ([
#         (date now | date format '%m/%d/%Y %r')
#     ] | str collect)
# 
#     $time_segment
# }

# # Use nushell functions to define your right and left prompt
# let-env PROMPT_COMMAND = { create_left_prompt }
# let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }
# 
# # The prompt indicators are environmental variables that represent
# # the state of the prompt
# let-env PROMPT_INDICATOR = { "〉" }
# let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
# let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
# let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | prepend '/some/path')
$env.PATH = ($env.PATH | append ["/usr/local/bin", "/Users/mathspy/.cargo/bin", "/opt/homebrew/bin", "/Users/mathspy/.volta/bin", "/Users/mathspy/Library/Python/3.9/bin/"])

# Setup starship prompt
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    $"(starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' | str trim) "
}
def create_right_prompt [] {
    starship prompt --right --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "