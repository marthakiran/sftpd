class sftpd::service (
  $ensure           = running,
  $enable           = true,

) { 
  validate_bool($enable)
  
  if $::operatingsystem == 'Ubuntu' {
    $service_name    =  ssh
    $binary_use      =  start
  }
  elsif $::operatingsystem =~ /redhat|CentOS/ {
    $provider        =  redhat
    $service_name    =  sshd
  }  

  service { 'ssh_service':
    ensure          => $ensure,
    name            => $service_name,
    enable          => $enable,
    provider        => $provider,
    binary          => $binary_use,
  }
}
