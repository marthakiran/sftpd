class sftpd::service (
	$ensure		= running,
	$enable		= true,

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
    name            => $service_name,
    ensure          => $ensure,
    enable          => $enable,
    provider        => $provider,
    binary          => $binary_use,
  }
}
