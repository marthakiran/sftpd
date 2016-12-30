define sftpd::config (
  #configuration params of sshd 
    $config_dir	                   = '/etc/ssh', 		#default configuration
    $config_file                   = 'sshd_config',	#config file 
    $ensure                        = file,
    $permission	                   = '0600',		#permission to config file

  #leave it as defaults
    $port                          = undef,		#by default port number 22
    $listen_address                = undef,		#to change listen addr 
    $protocol                      = '2',			#default protocol is 2
    $syslogfacility                = 'AUTHPRIV',		#log facility 
    $maxauthtries                  = undef,		#authentication tries 
    $maxsessions                   = undef, 		#sessions for clients
    $passwordauthentication        = 'yes',		
    $chalengrespauth               = 'no',			# "no" to disable s/key passwords
    $gssapiauth	                   = 'yes',
    $gssapicleancreds              = 'yes',
    $gssapistrictacceptorcheck     = undef,
    $gssapikeyexchange             = undef,
    $usepam                        = 'yes',
    $x11forwarding                 = 'yes',		
    $matchgroup	                   = 'sftponly',  		#match group default to "sftponly"

  #configuration proccess either template or file
    $copy_config                   = no,			#change to "yes" to enable the config file copy to agent
    $template_config               = yes,			#change to "no" to disable the template "erb" file

  #selinux boolean enable/disable params yes/no
    $selenable                     =  undef,

) {
  validate_string($enable)
   
  if (template_config != yes) and  ($copy_config != no) {
   file { "${config_dir}/${config_file}":
      ensure	    => $ensure,
      notify	    => Service['sshd'],
      mode	    => $permission,
      source	    => "puppet:///modules/sftpd/${config_file}",
      require	    => Package['openssh'],
   }
  }
   
  if ($copy_config != yes) and  ($template_config != no) {
   file { "${config_dir}/${config_file}":
      ensure	    => file,
      notify	    => Service['sshd'],
      mode          => $permission,
      require	    => Package['openssh'],
      content	    => template('sftpd/sshd_config.erb'),		
   }
  }
 
  if $selenable != no {
   #changes applies to selinux to upload file via SFTP
   selboolean { 'ssh_chroot_rw_homedirs':
      value         => on,
      persistent    => true,
   }
  }
}
