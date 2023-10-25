add-content -path c:/users/mrolli/.ssh/config -value @'

Host azmichi
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}
'@
