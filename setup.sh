############
# GIT

echo 'installing git'
sudo apt install git -y

echo 'what name do you want to use in GIT user.name?'
read git_config_user_name
git config --global user.name "$git_config_user_name"

echo 'what email do you want to use in GIT user.email?'
read git_config_user_email
git config --global user.email $git_config_user_email

git config --global core.editor "code --wait"

clear

############

# https://code.visualstudio.com/docs/setup/linux
echo 'installing vscode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y

# https://code.visualstudio.com/docs/editor/extension-gallery?pub=esbenp
echo 'installing vscode extensions'
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension christian-kohler.path-intellisense
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension CoenraadS.bracket-pair-colorizer
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension arcticicestudio.nord-visual-studio-code

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

# https://draculatheme.com/gnome-terminal/
echo 'installing gnome terminal dracula theme'
sudo apt-get install dconf-cli
git clone https://github.com/dracula/gnome-terminal
(cd gnome-terminal/ && install.sh)

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
