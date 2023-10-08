fg_reset='%{%f%}'
fg_black='%{%F{black}%}'
fg_red='%{%F{red}%}'
fg_green='%{%F{green}%}'
fg_yellow='%{%F{yellow}%}'
fg_blue='%{%F{blue}%}'
fg_magenta='%{%F{magenta}%}'
fg_cyan='%{%F{cyan}%}'
fg_white='%{%F{white}%}'
fg_gray='%{%F{8}%}'  # %F{...} only supports the 8 basic colors by name

PROMPT_SECTIONS=()

render_prompt() {
  setopt localoptions shortloops

  PROMPT_SECTIONS=()
  render_exit_code
  render_user_host
  render_pwd
  render_git
  render_venv
  render_jobs
  render_exec_time

  local separator="${fg_gray} ❯ "
  echo ${(pj.$separator.)PROMPT_SECTIONS}
  echo -n "${fg_gray}"
  printf '❯%.0s' {1..$SHLVL}
  echo -n "${fg_reset} "
}

render_exit_code() {
  if ((PROMPT_EXIT_CODE != 0)); then
    if ((PROMPT_EXIT_CODE > 128 && PROMPT_EXIT_CODE < 160)); then
      PROMPT_SECTIONS+="${fg_white}$(kill -l $PROMPT_EXIT_CODE)"
    else
      PROMPT_SECTIONS+="${fg_red}✘ $PROMPT_EXIT_CODE"
    fi
  fi
}

render_user_host() {
  local parts=()

  # username in red if root, yellow if otherwise relevant
  if [[ $UID == 0 ]]; then
    parts+="${fg_red}%n"
  elif [[ $LOGNAME != $USER ]] || [[ -n $SSH_CONNECTION ]]; then
    parts+="${fg_yellow}%n"
  fi

  # hostname in yellow if relevant
  [[ -n $SSH_CONNECTION ]] && parts+="${fg_yellow}%m"

  (($#parts)) && {
    local separator="${fg_gray}@"
    PROMPT_SECTIONS+="${(pj:$separator:)parts}"
  }
}

render_pwd() {
  PROMPT_SECTIONS+="${fg_cyan}%~${fg_reset}"
}

render_git() {
  local gitstatus  # local swallows git's exit code if not on its own line
  gitstatus=$(command git status --porcelain -b 2>/dev/null) || return

  # Sort through the status of files.
  local untracked=0 dirty=0 staged=0 conflicts=0 branch_line=''
  {
    while IFS='' read -r line; do
      case $line in
        \#\#*) branch_line=$line;;
        \?\?*) ((untracked++));;
        AA*|DD*|U?*|?U*) ((conflicts++));;
        *)
          [[ ${line:0:1} =~ '[MADRC]' ]] && ((staged++))
          [[ ${line:1:1} =~ '[MADRC]' ]] && ((dirty++))
          ;;
      esac
    done <<<$gitstatus
  }

  # Find out branch and upstream.
  local branch='' upstream='' ahead=0 behind=0
  {
    local fields=(${(s:...:)${branch_line#\#\# }})
    branch=$fields[1]
    local tracking=$fields[2]

    if [[ $branch == *'Initial commit on'* ]] \
    || [[ $branch == *'No commits yet on'* ]]; then
      # Branch name is last word in these possible branch lines:
      #   ## Initial commit on <branch>
      #   ## No commits yet on <branch>
      branch=${${(s: :)branch}[-1]}

    elif [[ $branch == *'no branch'* ]]; then
      # Dettached HEAD (also if a tag is checked out), branch line:
      #   ## HEAD (no branch)
      local tag=$(command git describe --tags --exact-match HEAD 2>/dev/null)
      if [[ -n $tag ]]; then
        branch="⚑$tag"
      else
        tag=$(command git describe --tags --long HEAD 2>/dev/null)
        if [[ -n $tag ]]; then
          branch="$tag"
        else
          branch="#$(command git rev-parse --short HEAD 2>/dev/null)"
        fi
      fi

    elif (($#fields > 1)); then
      # There is a tracking branch. Possibilites:
      #   ## <branch>...<upstream>
      #   ## <branch>...<upstream> [ahead 1]
      #   ## <branch>...<upstream> [behind 1]
      #   ## <branch>...<upstream> [ahead 1, behind 1]
      tracking=(${(s: [:)${tracking%]}})
      upstream=$tracking[1]
      if (($#tracking > 1)); then
        for e in ${(s:, :)tracking[2]}; do
          [[ $e == 'ahead '* ]]  && ahead=${e:6}
          [[ $e == 'behind '* ]] && behind=${e:7}
        done
      fi
    fi
  }

  local track_parts=()
  (($ahead > 0 ))  && track_parts+="${fg_blue}↑${ahead}"
  (($behind > 0 )) && track_parts+="${fg_cyan}${behind}↓"

  local state_parts=()
  (($staged > 0))  && state_parts+="${fg_green}+${staged}"
  (($dirty > 0 ))  && state_parts+="${fg_red}${dirty}✶"

  local separator="${fg_gray}"
  local gitinfo=("${fg_blue}${branch}")
  (($#track_parts > 0)) && gitinfo+="${(pj:$separator:)track_parts}"
  (($conflicts > 0 ))   && gitinfo+="${fg_red}${conflicts} "
  (($untracked > 0 ))   && gitinfo+="${fg_white}${untracked}?"
  (($#state_parts))     && gitinfo+="${(pj:$separator:)state_parts}"

  PROMPT_SECTIONS+="${(j: :)gitinfo}"
}

render_venv() {
    [[ -n "$VIRTUAL_ENV" ]] && PROMPT_SECTIONS+="${fg_green}${VIRTUAL_ENV:t}"
}

render_jobs() {
  (($PROMPT_JOB_COUNT > 0)) && PROMPT_SECTIONS+="${fg_magenta}%j bg"
}

render_exec_time() {
  (($PROMPT_EXEC_TIME > 3)) && {  # last command execution time if over 3s
    local parts=(
      "$((PROMPT_EXEC_TIME / 60 / 60 / 24))d"   # days
      "$((PROMPT_EXEC_TIME / 60 / 60 % 24))h"   # hours
      "$((PROMPT_EXEC_TIME / 60 % 60))m"        # minutes
      "$((PROMPT_EXEC_TIME % 60))s"             # seconds
    )
    PROMPT_SECTIONS+=${fg_gray}${parts:#0*}  # only keep non-zero parts
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

