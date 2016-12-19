class sftpd::service (
	$ensure		= running,
	$provider	= redhat,
	$enable		= true,

) { 
    validate_bool($enable)

    service { 'sshd':
      name            => 'sshd',
      ensure          => $ensure,
      enable          => $enable,
      provider        => $provider,
      require         => Package["openssh"]
    }
}
