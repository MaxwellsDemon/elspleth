#!/bin/bash

APP_NAME='%%%app_name%%%'

# ---------------------------------------------------------------------------- #
# Usage                                                                        #
# ---------------------------------------------------------------------------- #

show_usage() {
    # Format:
    #   abc           command
    #   <abc>         arg
    #   --abc         option
    #   --abc <xyz>   option with arg
    #   -a            short option
    #   -a|--abc      option with short variation
    #   (abc|xyz)     1 of
    #   [abc|xyz]     1 of, optional
    #   [...]         optional
    #   [abc=xyz]     optional with default
    #   --abc <xyz>   option with arg

    local color__command='cyan'
    echo "Usage:"
    echo "   $APP_NAME $(colorize "$color__command" example-command) <example arg> [-o|--example-option]"
    echo "   $APP_NAME $(colorize "$color__command" help)"
    echo "      You're looking at it."
}

# ---------------------------------------------------------------------------- #
# Dependencies                                                                 #
# ---------------------------------------------------------------------------- #

dependencies() {
    dependency \
        'jq' \
        --website 'https://stedolan.github.io/jq/' \
        --purpose 'Working with JSON files, such as package.json in NPM projects' \
        --impact 'Parsing JSON will fail' \
        --optional
}

# ---------------------------------------------------------------------------- #
# Common Functions / Framework                                                 #
# ---------------------------------------------------------------------------- #

# Logging -------------------------------------------------------------------- #
colorize() {
    local color="$1"
    local message="$2"
    local color_code__none='\033[0m'
    local color_code
    case $color in
    black)        color_code='\033[0;30m' ;;
    red)          color_code='\033[0;31m' ;;
    green)        color_code='\033[0;32m' ;;
    brown)        color_code='\033[0;33m' ;;
    orange)       color_code='\033[0;33m' ;;
    blue)         color_code='\033[0;34m' ;;
    purple)       color_code='\033[0;35m' ;;
    cyan)         color_code='\033[0;36m' ;;
    light_gray)   color_code='\033[0;37m' ;;
    dark_gray)    color_code='\033[1;30m' ;;
    light_red)    color_code='\033[1;31m' ;;
    light_green)  color_code='\033[1;32m' ;;
    yellow)       color_code='\033[1;33m' ;;
    light_blue)   color_code='\033[1;34m' ;;
    light_purple) color_code='\033[1;35m' ;;
    light_cyan)   color_code='\033[1;36m' ;;
    white)        color_code='\033[1;37m' ;;
    *)            color_code="$color_code__none" ;;
    esac
    echo -e "$color_code$message$color_code__none"
}
log() {
    local message="$1"
    local level="${2:-INFO}"
    local target="${3:-/dev/stdout}"
    echo -e "[$level] $message" > "$target"
}
log__debug() { log "$1" "$(colorize cyan       DEBUG)" ; }
log__info()  { log "$1" "$(colorize green      INFO)"  ; }
log__warn()  { log "$1" "$(colorize yellow     WARN)"  '/dev/stderr' ; }
log__error() { log "$1" "$(colorize red        ERROR)" '/dev/stderr' ; }
log__fatal() { log "$1" "$(colorize light_red  FATAL)" '/dev/stderr' ; [[ "$2" ]] && exit "$2" ; }
log__not_implemented() { log__fatal 'Not implemented' 51 ; }

# Dependencies --------------------------------------------------------------- #
dependency() {
    local executable="$1"
    local name
    local version
    local website
    local purpose
    local impact
    local optional
    local notes

    local return_code__success=0
    local return_code__fail__optional=1
    local return_code__fail__mandatory=2

    if [[ ! "$executable" ]]; then
        log__fatal '(Internal Error) Attempted to validate a dependency without providing an executable to test'
        exit 1
    fi
    
    POSITIONAL=()
    while [[ $# -gt 1 ]]; do
        local flag_key="$2"
        case $flag_key in
        -n|--name)
            name="$3"
            [[ $name ]] && shift
            shift
            ;;
        -v|--version)
            version="$3"
            [[ $version ]] && shift
            shift
            ;;
        -w|--website)
            website="$3"
            [[ $website ]] && shift
            shift
            ;;
        -p|--purpose)
            purpose="$3"
            [[ $purpose ]] && shift
            shift
            ;;
        -i|--impact)
            impact="$3"
            [[ $impact ]] && shift
            shift
            ;;
        -o|--optional)
            optional='true'
            shift
            ;;
        --notes)
            notes="$3"
            [[ $notes ]] && shift
            shift
            ;;
        *)
            POSITIONAL+=("$flag_key")
            shift
            ;;
        esac
    done
    set -- "${POSITIONAL[@]}"

    if [[ ! -x "$(command -v "$executable")" ]]; then
        local log_message="Missing dependency:"
        [[ "$name" ]] && log_message+="\n           Name: $name"
        log_message+="\n     Executable: $executable"
        [[ "$version" ]] && log_message+="\n        Version: $version"
        [[ "$website" ]] && log_message+="\n        Website: $website"
        [[ "$purpose" ]] && log_message+="\n        Purpose: $purpose"
        [[ "$impact" ]] && log_message+="\n         Impact: $impact"
        [[ "$notes" ]] && log_message+="\n          Notes: $notes"

        echo >&2
        if [[ "$optional" == 'true' ]]; then
            log_message+="\n   This script will run without it, but some features may be unavailable or non-functional."
            log__warn "$log_message"
            return $return_code__fail__optional
        else
            log_message+="\n   This dependency is required for this script to run. Aborting."
            log__fatal "$log_message" $return_code__fail__mandatory
            exit $return_code__fail__mandatory
        fi
    fi

    return $return_code__success
}

# Environment ---------------------------------------------------------------- #
validate_env() {
    if [[ ! "$PATH_SCRIPTS" ]]; then
        log__fatal "PATH_SCRIPTS env variable does not appear to be set"
        exit 1
    fi
    validate_env_directory() {
        if [[ ! -d "$1" ]]; then
            log__fatal "Directory does not exist: $1"
            exit 1
        fi
    }
    validate_env_directory "$PATH_SCRIPTS"
    validate_env_directory "$PATH_SCRIPTS/app"
    validate_env_directory "$PATH_SCRIPTS/bin"
}

# ---------------------------------------------------------------------------- #
# Common Functions / App                                                       #
# ---------------------------------------------------------------------------- #

# (None yet.)

# ---------------------------------------------------------------------------- #
# Initialization                                                               #
# ---------------------------------------------------------------------------- #

init() {
    validate_env
}

# ---------------------------------------------------------------------------- #
# Command Processing                                                           #
# ---------------------------------------------------------------------------- #

# Global Flags --------------------------------------------------------------- #
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            set -o xtrace
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done
set -- "${POSITIONAL[@]}"

# Command Handler Functions -------------------------------------------------- #
cmd__example-command() {
    local example_arg
    local example_option

    POSITIONAL=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -o|--example-option)
                example_option='true'
                shift # add an additional shift if the option has an argument
                ;;
            *)
                POSITIONAL+=("$1")
                shift
                ;;
        esac
    done
    set -- "${POSITIONAL[@]}"

    example_arg="$1"

    if [[ ! "$example_arg" ]]; then
        show_usage; exit 1
    fi

    if [[ "$example_option" = 'true' ]]; then
        log__info 'Example option was passed'
    fi

    log__not_implemented
}

cmd__help() {
    show_usage
}

# Init & Command Routing ----------------------------------------------------- #
cmd=$1
if [[ ! "$cmd" ]]; then
    show_usage
    dependencies
    exit 1
fi
dependencies
init
case $cmd in
example-command|\
help)
    shift
    $"cmd__$cmd" "$@"
    exit $?
    ;;
*)
    show_usage; exit 1
    ;;
esac
