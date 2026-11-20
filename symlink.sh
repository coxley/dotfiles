mkdir -p ~/.local/bin
mkdir -p ~/.config

ln -sf $PWD/.local/bin/* $HOME/.local/bin/
ln -sf $PWD/.config/aerospace $HOME/.config/
ln -sf $PWD/.config/atuin $HOME/.config/
ln -sf $PWD/.config/ghostty $HOME/.config/
ln -sf $PWD/.config/git $HOME/.config/
ln -sf $PWD/.config/linearmouse $HOME/.config/
ln -sf $PWD/.config/nvim $HOME/.config/
ln -sf $PWD/.config/rumdl $HOME/.config/
ln -sf $PWD/.config/zsh $HOME/.config/
ln -sf $PWD/.zshrc $HOME/.zshrc
mkdir -p "$HOME/Library/Application Support"
ln -sf "$PWD/Library/Application Support/lspmux" "$HOME/Library/Application Support/"

# launchd may skip symlinked plists at login; copy and (re)load instead.
for plist in com.coxley.ws-tunnels.plist com.coxley.lspmux.plist; do
    cp $PWD/Library/LaunchAgents/$plist $HOME/Library/LaunchAgents/
    launchctl bootout gui/$UID/${plist%.plist} 2>/dev/null
    launchctl bootstrap gui/$UID $HOME/Library/LaunchAgents/$plist
done
