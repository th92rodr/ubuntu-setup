############
# ZSH

# https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
echo 'installing zsh'
sudo apt install zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# https://draculatheme.com/zsh/
echo 'installing zsh dracula theme'
git clone https://github.com/dracula/zsh.git ~/.dracula
cp .dracula/dracula.zsh-theme .oh-my-zsh/themes/
cp -r .dracula/lib/ .oh-my-zsh/themes/
sed -i 's/ZSH_THEME=.*/ZSH_THEME="dracula"/g' ~/.zshrc

# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
echo 'installing zsh autosuggestions'
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc

source ~/.zshrc
chsh -s /bin/zsh

############

# https://github.com/sharkdp/bat
# https://github.com/sharkdp/bat/releases
curl https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-musl_0.15.4_amd64.deb -o bat.deb
dpkg -i bat.deb

# https://github.com/sharkdp/fd
# https://github.com/sharkdp/fd/releases
curl https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-musl_8.1.1_amd64.deb -o fd.deb
dpkg -i fd.deb

# https://github.com/jonas/tig
# https://github.com/jonas/tig/blob/master/INSTALL.adoc
git clone git://github.com/jonas/tig.git ~/Downloads
(cd ~/Downloads/tig/ && make)
(cd ~/Downloads/tig/ && make install)
