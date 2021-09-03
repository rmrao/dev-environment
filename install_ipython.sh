#!/bin/bash

ipython profile create default
cp -a ipython/ipython_config.py ${HOME}/.ipython/profile_default
cp -a ipython/startup.py ${HOME}/.ipython/profile_default/startup
