# Nushell Environment Config File
#
# version = "0.84.0"


# def create_left_prompt [] {
#     mut home = ""
#     try {
#         if $nu.os-info.name == "windows" {
#             $home = $env.USERPROFILE
#         } else {
#             $home = $env.HOME
#         }
#     }
#
#     let dir = ([
#         ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
#         ($env.PWD | str substring ($home | str length)..)
#     ] | str join)
#
#     let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
#     let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
#     let path_segment = $"($path_color)($dir)"
#
#     $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
# }
#
# def create_right_prompt [] {
#     # create a right prompt in magenta with green separators and am/pm underlined
#     let time_segment = ([
#         (ansi reset)
#         (ansi magenta)
#         (date now | format date '%Y/%m/%d %r')
#     ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
#         str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")
#
#     let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
#         (ansi rb)
#         ($env.LAST_EXIT_CODE)
#     ] | str join)
#     } else { "" }
#
#     ([$last_exit_code, (char space), $time_segment] | str join)
# }
#
# Use nushell functions to define your right and left prompt
# $env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
# $env.PROMPT_INDICATOR = {|| "〉" }
# $env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
# $env.PROMPT_INDICATOR_VI_NORMAL = {|| "〉" }
# $env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }


### STARSHIP
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
# $env.PROMPT_COMMAND = { create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt

# $env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = "❯ "
$env.PROMPT_INDICATOR_VI_NORMAL = "❮ "
# $env.PROMPT_MULTILINE_INDICATOR = "::: "

$env.PROMPT_INDICATOR = ""
# $env.PROMPT_INDICATOR_VI_INSERT = ""
# $env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# $env.STARSHIP_SESSION_KEY = (random chars -l 16)
# $env.PROMPT_MULTILINE_INDICATOR = (^/opt/homebrew/bin/starship prompt --continuation)





# # Does not play well with default character module.
# # TODO: Also Use starship vi mode indicators?
#
#
# $env.PROMPT_COMMAND = { ||
#     # jobs are not supported
#     let width = (term size).columns
#     ^/opt/homebrew/bin/starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
# }

# # Whether we have config items
# let has_config_items = (not ($env | get -i config | is-empty))

# $env.config = if $has_config_items {
#     $env.config | upsert render_right_prompt_on_last_line true
# } else {
#     {render_right_prompt_on_last_line: true}
# }

# $env.PROMPT_COMMAND_RIGHT = { ||
#     let width = (term size).columns
#     ^/opt/homebrew/bin/starship prompt --right $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
# }

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
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.cargo/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.local/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin')

$env.EDITOR = nvim
$env.VISUAL = code

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu


