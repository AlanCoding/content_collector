#!/bin/bash

# These commands need to be ran, but HOPEFULLY not every time
# git clone https://github.com/ansible/ansible.git
# workon ansible3
# pip install ansible-tower-cli

rm -rf ~/.ansible/*  # start with Ansible default everything
export ANSIBLE_NOCOWS=1  # do we really need to do this every time??
rm -rf awx_modules  # clean up dest project dir in case we ran this before
echo "Going to run the tool now"
# Okay, look, the yes command does not actually answer the prompts
# error of ""
# yes 'y' | ansible-playbook site.yaml  # run content_collector
# ah ha, this is NOT interactive
# you could give 24 lowercase yeses, yep, I did it that way and counted
# capital Y can be given only once
# echo "Y" | ansible-playbook site.yaml
# look, none of us are perfect. Yes, I gave up.
echo "In a little bit, you need to enter a capital Y"
ansible-playbook site.yaml
# go to directory where installs have to be ran from
cd awx_modules/awx/awx/
cp ../../galaxy.yml galaxy.yml  # see issue about this
echo "Cleaning build and install directories"
rm -rf ~/Documents/repos/utility-playbooks/test_build
rm -rf ~/Documents/repos/utility-playbooks/test_install
echo "Running the build command now"
ansible-galaxy collection build --output-path=~/Documents/repos/utility-playbooks/test_build
echo "Go back to where we started"
cd ~/Documents/repos/content_collector
echo "Running the install command now"
ansible-galaxy collection install ~/Documents/repos/utility-playbooks/test_build/awx-awx-1.0.0.tar.gz -p ~/Documents/repos/utility-playbooks/test_install
echo "Now run a playbook to test the installed version"
echo "This should not give the 'this_is_the_old_one' key in output"
cd ~/Documents/repos/utility-playbooks
# if you did not install tower-cli then you need to add this to following command
# -e ansible_python_interpreter=~/.virtualenvs/cli/bin/python
ANSIBLE_COLLECTIONS_PATHS=$(pwd)/test_install/ ansible-playbook -i localhost, -e ansible_python_interpreter=$(which python) tower_module.yml
# lets go back home again
cd ~/Documents/repos/content_collector
echo "Now we are finished, I hope it worked"
