#!/bin/bash

ipython profile create default
cp -a ipython/ipython_config.py ${HOME}/.ipython/profile_default
cp -a ipython/startup.py ${HOME}/.ipython/profile_default/startup
pip install git+https://github.com/rmrao/pyforest.git
python -m pyforest install_extensions
cp -a ipython/pyforest_autoimport.py ${HOME}/.ipython/profile_default/startup
