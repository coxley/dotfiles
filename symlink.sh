dotfiles=$HOME/docs/projects/dotfiles

# scripts - individually to allow host-specific scripts not in git
for file in $dotfiles/bin/*; do
    ln -s $file $HOME/bin
done

# vim
ln -s $dotfiles/nvim $HOME/.config/nvim

# zsh
ln -s $dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $dotfiles/zsh/zgen.zsh $HOME/.zgen.zsh
