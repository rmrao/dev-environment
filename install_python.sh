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


source "${HOME}/.bashrc"
${HOME}/miniconda/bin/conda install "python>=3.6,<3.7" mypy flake8 autopep8 ipython
