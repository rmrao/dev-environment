set -e
# Install Anaconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
rm ./Miniconda3-latest-Linux-x86_64.sh

echo "" >> ~/.bashrc
echo "# added by Anaconda3 installer" >> ~/.bashrc
echo "export PATH=~/miniconda/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc
conda install python==3.6

pip install -U mypy
pip install -U flake8
