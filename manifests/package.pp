class sftpd::package ( 
   $ensure     = installed,

) {
   if $::operatingsystem == 'Ubuntu' {
     $provider = apt
     $apps     = [ 'openssh-server', 'openssh-client' ]
   }
   elsif $::operatingsystem == 'CentOS' {
     $provider = yum
     $apps     = [ 'openssh-server', 'openssh-clients' ]
   }

   package { $apps:
     ensure         => $ensure,
     provider       => $provider,
   }
}
