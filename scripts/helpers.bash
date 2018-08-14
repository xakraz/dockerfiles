# == Variables
#
# The various escape codes that we can use to color our prompt.
#
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
#
        RED="\033[0;31m"
      GREEN="\033[0;32m"
     YELLOW="\033[0;33m"
       BLUE="\033[0;34m"
      WHITE="\033[0;37m"

# BOLD
        BRED="\033[1;31m"
     BYELLOW="\033[1;33m"
      BGREEN="\033[1;32m"
       BBLUE="\033[1;34m"

# Reset
COLOR_NONE="\e[0m"



# == Logging helpers
#
# Regular
function log(){
   ( >&2 echo "$@" )
}

function log_error(){
   ( >&2 printf "${RED}[ERROR] $@${COLOR_NONE}\n" )
}

function log_warn(){
   ( >&2 printf "${YELLOW}$@${COLOR_NONE}\n" )
}

function log_info(){
   ( >&2 printf "${GREEN}$@${COLOR_NONE}\n" )
}

function log_debug(){
  set +o nounset
  [ -n "${DEBUG}" ] \
    && (>&2 printf "${BLUE}$@${COLOR_NONE}\n")
  set -o nounset
}

# Bold
function logb_error(){
   ( >&2 printf "${BRED}[ERROR] $@${COLOR_NONE}\n" )
}

function logb_warn(){
   ( >&2 printf "${BYELLOW}$@${COLOR_NONE}\n" )
}

function logb_info(){
   ( >&2 printf "${BGREEN}$@${COLOR_NONE}\n" )
}

function logb_debug(){
  set +o nounset
  [ -n "${DEBUG}" ] \
    && (>&2 printf "${BBLUE}$@${COLOR_NONE}\n")
  set -o nounset
}