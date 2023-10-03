black=0 red=1 green=2 yellow=3 blue=4 magenta=5 cyan=6 white=7 gray=8

PROMPT_SECTIONS=()

render() {  # $1: optional color, $2...: contents
    if [[ -n $2 ]] {
        PROMPT_SECTIONS+="%{%F{$1}%}${@[2,-1]}%{%f%}"
    } else {
        PROMPT_SECTIONS+="$1"
    }
}

render_prompt() {
    setopt localoptions shortloops
    local separator="%{%F{$gray}%} ❯ %{%f%}"

    PROMPT_SECTIONS=()
    for s in exit_code user_host pwd git venv jobs exec_time; { render_$s }

    echo ${(pj.$separator.)PROMPT_SECTIONS}
    echo -n "%{%F{$gray}%}"
    printf '❯%.0s' {1..$SHLVL}
    echo -n "%{%f%} "
}

render_exit_code() {
    if (($PROMPT_EXIT_CODE != 0)) {
        if ((PROMPT_EXIT_CODE > 128 && PROMPT_EXIT_CODE < 160 )) {
            render $white $(kill -l $PROMPT_EXIT_CODE)
        } else {
            render $red "%{%B%}✘ $PROMPT_EXIT_CODE%{%b%}"
        }
    }
}

render_user_host() {
    local sep="%{%F{$gray}%}@%{%f%}"
    local parts=()

    # username in red if root, yellow if otherwise relevant
    if [[ $UID == 0 ]] {
        parts+="%{%F{$red}%}%n%{%f%}"
    } elif [[ $LOGNAME != $USER ]] || [[ -n $SSH_CONNECTION ]] {
        parts+="%{%F{$yellow}%}%n%{%f%}"
    }

    # hostname in yellow if relevant
    [[ -n $SSH_CONNECTION ]] && parts+="%{%F{$yellow}%}%m%{%f%}"

    (($#parts)) && render "${(pj:$sep:)parts}"
}

render_pwd() {
    render $cyan '%~'  # TODO add RO if now write permission
}

# TODO add stash?
# TODO add action?
render_git() {
    local gitstatus  # local swallows git's exit code if not on its own line
    gitstatus=$(command git status --porcelain -b 2>/dev/null) || return

    # Sort through the status of files.
    local untracked=0 dirty=0 staged=0 conflicts=0 branch_line=''
    {
        while IFS='' read -r line || [[ -n $line ]] {
            case $line in
                \#\#*) branch_line=$line;;
                \?\?*) ((untracked++));;
                AA*|DD*|U?*|?U*) ((conflicts++));;
                *)
                    [[ ${line:0:1} =~ '[MADRC]' ]] && ((staged++))
                    [[ ${line:1:1} =~ '[MADRC]' ]] && ((dirty++))
                    ;;
            esac
        } <<<$gitstatus
    }

    # Find out branch and upstream.
    local branch='' upstream='' ahead=0 behind=0
    {
        local fields=(${(s:...:)${branch_line#\#\# }})
        branch=$fields[1]
        local tracking=$fields[2]

        if [[ $branch == *'Initial commit on'* ]] \
        || [[ $branch == *'No commits yet on'* ]] {
            # Branch name is last word in these possible branch lines:
            #   ## Initial commit on <branch>
            #   ## No commits yet on <branch>
            branch=(${${(s: :)branch}[-1]})

        } elif [[ $branch == *'no branch'* ]] {
            # Dettached HEAD (also if a tag is checked out), branch line:
            #   ## HEAD (no branch)
            local tag=$(git describe --tags --exact-match 2>/dev/null)
            if [[ -n $tag ]] {
                branch="⚑$tag"
            } else {
                branch="#$(git rev-parse --short HEAD)"
            }

        } elif (($#fields > 1)) {
            # There is a tracking branch. Possibilites:
            #   ## <branch>...<upstream>
            #   ## <branch>...<upstream> [ahead 1]
            #   ## <branch>...<upstream> [behind 1]
            #   ## <branch>...<upstream> [ahead 1, behind 1]
            tracking=(${(s: [:)${tracking%]}})
            upstream=$tracking[1]
            if (($#tracking > 1)) {
                for e in ${(s:, :)tracking[2]}; {
                    if [[ $e == 'ahead '* ]]  { ahead=${e:6}  }
                    if [[ $e == 'behind '* ]] { behind=${e:7} }
                }
            }
        }
    }

    local color=$blue trackinfo='' state=''
    {
        local attention=()
        (($conflicts > 0 )) && attention+="%{%B%F{$red}%}$conflicts!%{%b%f%}"
        (($untracked > 0 )) && attention+="%{%F{$white}%}$untracked?%{%f%}"

        local changes=()
        (($staged > 0)) && changes+="%{%F{$green}%}+$staged%{%f%}"
        (($dirty > 0 )) && changes+="%{%F{$red}%}$dirty✶%{%f%}"

        if (($#attention > 0 || $#changes > 0)) {
            local sep="%{%F{$gray}%}|%{%f%}"
            local state_array=(${(j: :)attention} ${(pj:$sep:)changes})
            state=${(j: :)state_array}
        }

        local extra=()
        (($ahead > 0 ))  && extra+="↑$ahead"
        (($behind > 0 )) && extra+="%{%F{$cyan}%}↓$behind%{%f%}"
        (($#extra > 0))  && trackinfo="(${(j::)extra}%{%F{$color}%})%{%f%}"
    }

    local gitinfo=("$branch$trackinfo" $state)
    render $color ${(j: :)gitinfo}
}

render_venv() {
    [[ -n $VIRTUAL_ENV ]] && render $green $VIRTUAL_ENV:t  # venv if active
}

render_jobs() {
    (($PROMPT_JOB_COUNT > 0)) && render $magenta '%j bg'  # background jobs if any
}

render_exec_time() {
    (($PROMPT_EXEC_TIME > 5)) && {  # last command execution time if over 5s
        local components=(
            "$((PROMPT_EXEC_TIME / 60 / 60 / 24))d"    # days
            "$((PROMPT_EXEC_TIME / 60 / 60 % 24))h"    # hours
            "$((PROMPT_EXEC_TIME / 60 % 60))m"         # minutes
            "$((PROMPT_EXEC_TIME % 60))s"              # seconds
        )
        render $gray ${components:#0*}  # only keep non-zero parts
    }
}

# Hook triggered when a command is about to be executed.
prompt_preexec_hook() {
    PROMPT_EXEC_START=$EPOCHSECONDS
}

# Hook triggered right before the prompt is drawn.
prompt_precmd_hook() {
    PROMPT_EXIT_CODE=$?  # this needs to be captured before anything else runs

    local stop=$EPOCHSECONDS
    local start=${PROMPT_EXEC_START:-$stop}
    PROMPT_EXEC_TIME=$((stop - start))
    unset PROMPT_EXEC_START  # needed because preexec is not always called

    local job_count='%j'; PROMPT_JOB_COUNT=${(%)job_count}
}

prompt_setup() {
    setopt NO_PROMPT_BANG PROMPT_CR PROMPT_PERCENT PROMPT_SP PROMPT_SUBST
    export PROMPT_EOL_MARK=''  # don't show % when a partial line is preserved
    export VIRTUAL_ENV_DISABLE_PROMPT=1  # we're doing it ourselves

    zmodload zsh/datetime   # so that $EPOCHSECONDS is available

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_precmd_hook
    add-zsh-hook preexec prompt_preexec_hook

    PS1='$(render_prompt)'
}

prompt_setup
