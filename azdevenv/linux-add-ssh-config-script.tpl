cat << EOF >> ~/.ssh/config

Host azmichi
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}
EOF
