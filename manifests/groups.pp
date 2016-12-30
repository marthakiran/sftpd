define sftpd::groups ( 
   $groupname		= undef,
   $ensure		= undef,
   $system		= undef,
) {
 
  validate_string($groupname) 

  if $system != undef {
	validate_string($system)
  }
   if $ensure == 'present' {
     group { $name:
      ensure	     => $ensure,
      name	     => $groupname,
      members	     => $members,
      system	     => $system,
     }
   }
    elsif $ensure == 'absent' {
     group { $name:
      ensure         => $ensure,
      name           => $groupname,
     } 
   }
}
