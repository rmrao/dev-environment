    #!/bin/bash

set -e
# Install Anaconda

if [[ ! -d ${HOME}/miniconda ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/miniconda
    rm ./Miniconda3-latest-Linux-x86_64.sh
    chown -R ${USER}:${USER} ${HOME}/miniconda
    ${HOME}/miniconda/bin/conda init
fi


source "${HOME}/.zshrc"
${HOME}/miniconda/bin/conda create -n default "python>=3.9" mypy flake8 autopep8 ipython cython pytorch cudatoolkit torchvision biopython jupyter matplotlib seaborn pandas numpy scipy -c pytorch
