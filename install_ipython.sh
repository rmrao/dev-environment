#!/bin/bash

ipython profile create default
ipython profile create noeager
cp -a ipython/ipython_config.py ${HOME}/.ipython/profile_default
cp -a ipython/ipython_config.py ${HOME}/.ipython/profile_noeager
cp -a ipython/startup_eager.py ${HOME}/.ipython/profile_default/startup
cp -a ipython/startup_noeager.py ${HOME}/.ipython/profile_noeager/startup
