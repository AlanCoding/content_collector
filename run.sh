#!/bin/bash
rm -rf ~/.ansible/*  # start with Ansible default everything
echo "Going to run the tool now"
yes 'y' | ansible-playbook site.yaml  # run content_collector
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
ANSIBLE_COLLECTIONS_PATHS=$(pwd)/test_install/ ansible-playbook -i localhost, -e ansible_python_interpreter=~/.virtualenvs/cli/bin/python tower_module.yml
# lets go back home again
cd ~/Documents/repos/content_collector
echo "Now we are finished, I hope it worked"
