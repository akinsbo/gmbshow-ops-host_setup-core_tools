# ansible-playbook -i hosts.ini install-kubectl.yaml --ask-become-pass

# ansible-playbook -i hosts.ini install-kubectl.yaml --extra_vars "controller=vagrant" --ask-become-pass

ansible-playbook -i inventory webservers.yaml --ask-become-pass -vvvv   

# Call the run bastion playbook with ec2.py and parameters
ansible-playbook -i inventory run_from_bastion.yaml --ask-become-pass

# ssh -o IdentitiesOnly=yes-i /home/olaolu/ec2_keys/eu-west-1/mbshow_testi.pem admin@bastion.k8s.maryboye.org