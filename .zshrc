################################################################################
# Powerlevel10k Instant Prompt
# (Keep this at the very top to speed up prompt initialization)
################################################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################################################################################
# Shell History and Basic Keybindings
################################################################################
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

################################################################################
# Zsh Completion Setup (Compinit)
################################################################################
# (Configured by compinstall; ensures proper tab-completion behavior)
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

################################################################################
# Zinit Installer and Plugin Manager Initialization
################################################################################
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}%F{220}Installing %F{33}ZDHARMA-CONTINUUM Zinit…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33}%F{34}Installation successful.%f%b" || \
        print -P "%F{160}The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load required Zinit annexes (without Turbo)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

################################################################################
# Plugin Loading via Zinit
################################################################################
# fzf-tab for interactive file completion
zi light Aloxaf/fzf-tab

# Powerlevel10k (ensure it's loaded before other plugins that wrap widgets)
zi ice depth=1; zi light romkatv/powerlevel10k

# Zsh completions (for additional command completions)
zi light zsh-users/zsh-completions

# Zsh autosuggestions for improved command line experience
zi light zsh-users/zsh-autosuggestions

# Fast syntax highlighting (choose one: either fast-syntax-highlighting or zsh-syntax-highlighting)
zi light zdharma-continuum/fast-syntax-highlighting

################################################################################
# fzf Configuration and Key Bindings
################################################################################
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS='--style=full'

# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

################################################################################
# zoxide Initialization (Directory Jumping)
################################################################################
eval "$(zoxide init --cmd cd zsh)"

################################################################################
# Custom PATH additions
################################################################################
export PATH=$PATH:/home/katzenkoenig/.spicetify

################################################################################
# Aliases
################################################################################
alias speed="speedtest-cli"
alias pak="flatpak"
alias pakin="flatpak install"
alias pakup="flatpak update"
alias pakun="flatpak uninstall"
alias pakse="flatpak search"
alias pakrm="flatpak remove --unused"
alias gamesh="bash gameshell.sh"
alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

################################################################################
# Load Powerlevel10k Configuration (Prompt Customization)
################################################################################
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

################################################################################
# End of .zshrc
################################################################################

