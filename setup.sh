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
