define sftpd::groups ( 
   $groupname		= undef,
   $ensure		= present,
   $members		= [ ],
   $system		= undef,
) {
 
  validate_array($members)
  validate_string($groupname)
 
  if $system != undef {
	validate_string($system)
  }

  group	{ $name:
    name		=> $groupname,
    ensure		=> $ensure,
    members		=> $members,
    system		=> $system,
  }

}
