class sftpd::package ( 
	$provider	= undef, 
	$ensure		= undef,

) {
	package { 'openssh':
		name		=> 'openssh-server',
		provider	=> $provider,
		ensure		=> $ensure,
	}
	package { 'sshclient':
		name		=> 'openssh-clients',
		provider	=> $provider,
		ensure		=> $ensure,
	}
}
