# # Fail on any command.
# set -eux pipefail

# # Install plug-ins (you can git-pull to update them later).
# (cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting)
# (cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions)

# # Replace the configs with the saved one.
# sudo cp configs/.zshrc ~/.zshrc

# # Copy the modified Agnoster Theme
# sudo cp configs/pixegami-agnoster.zsh-theme ~/.oh-my-zsh/themes/pixegami-agnoster.zsh-theme

# # Color Theme
# dconf load /org/gnome/terminal/legacy/profiles:/:fb358fc9-49ea-4252-ad34-1d25c649e633/ < configs/terminal_profile.dconf

# # Add it to the default list in the terminal
# add_list_id=fb358fc9-49ea-4252-ad34-1d25c649e633
# old_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d "]")

# if [ -z "$old_list" ]
# then
# 	front_list="["
# else
# 	front_list="$old_list, "
# fi

# new_list="$front_list'$add_list_id']"
# dconf write /org/gnome/terminal/legacy/profiles:/list "$new_list" 
# dconf write /org/gnome/terminal/legacy/profiles:/default "'$add_list_id'"

# # Switch the shell.
# chsh -s $(which zsh)

#!/bin/bash
# Fail on any command.
set -eux pipefail

# Ensure necessary packages are installed
sudo dnf install -y dbus-x11

# Function to check if a Git repository is already cloned
is_repo_cloned() {
    [ -d "$1/.git" ]
}

# Install plug-ins (you can git-pull to update them later).
PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"
SYNTAX_HIGHLIGHTING_DIR="$PLUGIN_DIR/zsh-syntax-highlighting"
AUTO_SUGGESTIONS_DIR="$PLUGIN_DIR/zsh-autosuggestions"

mkdir -p "$PLUGIN_DIR"
if ! is_repo_cloned "$SYNTAX_HIGHLIGHTING_DIR"; then
    (cd "$PLUGIN_DIR" && git clone https://github.com/zsh-users/zsh-syntax-highlighting)
else
    echo "zsh-syntax-highlighting already cloned, skipping."
fi

if ! is_repo_cloned "$AUTO_SUGGESTIONS_DIR"; then
    (cd "$PLUGIN_DIR" && git clone https://github.com/zsh-users/zsh-autosuggestions)
else
    echo "zsh-autosuggestions already cloned, skipping."
fi

# Replace the configs with the saved one.
ZSHRC_CONFIG="configs/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"

if [ ! -f "$ZSHRC_DEST" ] || ! cmp -s "$ZSHRC_CONFIG" "$ZSHRC_DEST"; then
    sudo cp "$ZSHRC_CONFIG" "$ZSHRC_DEST"
else
    echo ".zshrc configuration already up-to-date, skipping."
fi

# Copy the modified Agnoster Theme
ZSH_THEME_CONFIG="configs/pixegami-agnoster.zsh-theme"
ZSH_THEME_DEST="$HOME/.oh-my-zsh/themes/pixegami-agnoster.zsh-theme"

if [ ! -f "$ZSH_THEME_DEST" ] || ! cmp -s "$ZSH_THEME_CONFIG" "$ZSH_THEME_DEST"; then
    sudo cp "$ZSH_THEME_CONFIG" "$ZSH_THEME_DEST"
else
    echo "Agnoster theme already up-to-date, skipping."
fi

# Color Theme
DCONF_PROFILE_CONFIG="configs/terminal_profile.dconf"
PROFILE_ID="fb358fc9-49ea-4252-ad34-1d25c649e633"
DCONF_PROFILE_DEST="/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/"

if ! dconf dump "$DCONF_PROFILE_DEST" | cmp -s - "$DCONF_PROFILE_CONFIG"; then
    dconf load "$DCONF_PROFILE_DEST" < "$DCONF_PROFILE_CONFIG"
else
    echo "Terminal profile already up-to-date, skipping."
fi

# Add it to the default list in the terminal
ADD_LIST_ID=$PROFILE_ID
OLD_LIST=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d "]")

if [ -z "$OLD_LIST" ]; then
    FRONT_LIST="["
else
    FRONT_LIST="$OLD_LIST, "
fi

NEW_LIST="$FRONT_LIST'$ADD_LIST_ID']"
dconf write /org/gnome/terminal/legacy/profiles:/list "$NEW_LIST"
dconf write /org/gnome/terminal/legacy/profiles:/default "'$ADD_LIST_ID'"

# Switch the shell to zsh if not already set
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$(which zsh)"
else
    echo "Shell already set to zsh, skipping."
fi

# Indicate completion
echo "Done"
