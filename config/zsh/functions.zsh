# Source: https://unix.stackexchange.com/a/9124
mkcd() {
  case "$1" in
    */..|*/../)                                                       cd -- "$1"  ;;
    /*/../*)    (cd "${1%/../*}/.."   && mkdir -vp "./${1##*/../}") && cd -- "$1"  ;;
    /*)                                  mkdir -vp "$1"             && cd    "$1"  ;;
    */../*)     (cd "./${1%/../*}/.." && mkdir -vp "./${1##*/../}") && cd    "./$1";;
    ../*)       (cd .. &&                mkdir -vp "${1#.}")        && cd    "$1"  ;;
    *)                                   mkdir -vp "./$1"           && cd    "./$1";;
  esac
}

