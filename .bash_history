pkg update && pkg upgrade
cls
clear
termux-setup-storage
ls
cp -r storage/downloads/kyyinfinite ~/
ls
cd kyyinfinite
bash kyy-core.sh
3cd
cd
pkg install zsh git curl -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
