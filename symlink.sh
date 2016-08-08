dotfiles=$HOME/docs/projects/dotfiles

dirs_needed=(
.i3
.config/yabar
.config/terminator
.config/i3status
.config/i3blocks
)

for dir in $dirs_needed; do
    mkdir -p $HOME/$dir;
done

# compton
ln -s $dotfiles/compton/compton.conf $HOME/.compton.conf

# dunst
[ ! -d $HOME/.config/dunst ] && ln -s $dotfiles/dunst $HOME/.config/dunst

# gtk
# ln -s $dotfiles/gtk/gtk-2.0 $HOME/.gtkrc-2.0
# ln -s $dotfiles/gtk/gtk-3.0 $HOME/.config/gtk-3.0/settings.ini

# i3
ln -s $dotfiles/i3/config $dotfiles/themer/templates/i3/i3.tpl
ln -s $dotfiles/i3/i3status.conf $HOME/.i3status.conf

# i3blocks
ln -s $dotfiles/i3blocks/config $dotfiles/themer/templates/i3/i3blocks.tpl

# i3status
ln -s $dotfiles/i3status/config $dotfiles/themer/templates/i3/i3status.tpl

# ipython
ln -s $dotfiles/ipython/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

# scripts - individually to allow host-specific scripts not in git
for file in $dotfiles/bin/*; do
    ln -s $file $HOME/bin
done

# terminator
ln -s $dotfiles/terminator/config $dotfiles/themer/templates/i3/terminator.tpl

# termite
# ln -s $dotfiles/termite/config $HOME/.config/termite/config
# ln -s $dotfiles/termite/dircolors $HOME/.dircolors

# themer
[ ! -d $HOME/.config/themer ] && ln -s $dotfiles/themer $HOME/.config/themer
ln -s $HOME/.config/themer/current/i3.conf $HOME/.i3/config
ln -s $HOME/.config/themer/current/i3blocks.conf $HOME/.config/i3blocks/config
ln -s $HOME/.config/themer/current/i3status.conf $HOME/.config/i3status/config
ln -s $HOME/.config/themer/current/terminator.conf $HOME/.config/terminator/config
ln -s $HOME/.config/themer/current/Xresources $HOME/.Xresources
ln -s $HOME/.config/themer/current/yabar.conf $HOME/.config/yabar/yabar.conf

# tmux
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
# ln -s $dotfiles/tmux/tmux_powerline.json $HOME/.config/powerline/themes/tmux/default.json
#ln -s $dotfiles/tmux/tmuxinator $HOME/.tmuxinator

# vim
ln -s $dotfiles/vim/vimrc $HOME/.vimrc

# xfluxd
# ln -s $dotfiles/xfluxd/xfluxd.conf /etc/xfluxd.conf

# xorg
# ln -s $dotfiles/xorg/xinitrc $HOME/.xinitrc
# ln -s $dotfiles/xorg/Xmodmap $HOME/.Xmodmap
ln -s $dotfiles/xorg/Xresources $dotfiles/themer/templates/i3/Xresources.tpl
# ln -s $dotfiles/xorg/xorg.conf.d /etc/X11/xorg.conf.d

# yabar
ln -s $dotfiles/yabar/yabar.conf $dotfiles/themer/templates/i3/yabar.tpl

# zsh
ln -s $dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $dotfiles/zsh/zgen.zsh $HOME/.zgen.zsh
