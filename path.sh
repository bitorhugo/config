#!/bin/sh

# Ensure Zsh automatically drops duplicate entries from the PATH array
typeset -U path

pathadd() {
  if [ -z "$1" ]; then
    echo "Usage: pathadd /path/to/directory"
    return 1
  fi

  # Resolve to absolute path and verify it exists
  local target_dir="${1:A}"
  if [ ! -d "$target_dir" ]; then
    echo "Error: Directory $target_dir does not exist."
    return 1
  fi

  path=("$target_dir" $path)

  # 2. Persist to ~/.zshrc for FUTURE sessions if not already written
  if grep -qF "$target_dir" ~/.zshrc 2>/dev/null; then
    echo "Prepend successful! Current session updated. (Already tracked in ~/.zshrc)"
  else
    # Appends the neat Zsh array syntax to the bottom of your config file
    echo "path=(\"$target_dir\" \$path)" >> ~/.zshrc
    echo "Prepend successful! Current session updated and saved to ~/.zshrc."
  fi
}
