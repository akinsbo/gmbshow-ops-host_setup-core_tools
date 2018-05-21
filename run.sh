ansible-playbook -i hosts.ini install-kubectl.yaml --ask-become-pass

ansible-playbook -i hosts.ini install-kubectl.yaml --extra_vars "controller=vagrant" --ask-become-pass
