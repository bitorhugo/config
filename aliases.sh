#!/usr/bin

# Function to add an alias, updating only if --force is present
add-alias() {
    local force=false

    if [ "$1" = "--force" ]; then
        force=true
        shift
    fi

    local name="$1"
    local command="$2"

    if [ -z "$name" ] || [ -z "$command" ]; then
        echo "Error: Missing arguments."
        echo "Usage: add-alias [--force] <name> <command>"
        return 1
    fi

    if grep -qE "^alias $name=" ~/.zshrc; then
        if [ "$force" = true ]; then
            sed -i.bak "s|^alias $name=.*|alias $name=\"$command\"|" ~/.zshrc && rm ~/.zshrc.bak
            echo "Alias '$name' updated successfully."
        else
            echo "Error: Alias '$name' already exists. Use '--force' to overwrite."
            return 1
        fi
    else
        echo "alias $name=\"$command\"" >> ~/.zshrc
        echo "Alias '$name' added successfully."
    fi

    source ~/.zshrc
}

# Function to safely remove and unload an alias
rem-alias() {
    if [ -z "$1" ]; then
        echo "Error: Missing argument."
        echo "Usage: remove-alias <name>"
        return 1
    fi

    if ! grep -qE "^alias $1=" ~/.zshrc; then
        echo "Error: Alias '$1' not found in ~/.zshrc."
        return 1
    fi

    sed -i.bak "/^alias $1=/d" ~/.zshrc && rm ~/.zshrc.bak

    unalias "$1" 2>/dev/null

    echo "Alias '$1' removed successfully."
}
