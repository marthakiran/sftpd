define sftpd::users (
  # please dont make any changes here 
  # users params
  $ensure               = 'present',
  $shell                = '/bin/bash',
  $home                 = '/home',				#default home dir for user
  $usergroups           = [ ],
  $user	                = undef,
  $password             = undef,					#pass the hash
  $managehome           = undef, 				#managing the user home dir, default to false
  $comment              = "sftp users created by puppet",
  
  #ftp sharing params
  $owner                = root,					#owner of users home directory
  $upload_dir           = undef,        			#user uploads directory name
  $recursive            = false,				#recursive permission for user home dir
  $recursive_limit      = undef,	
  $ownership_changed    = yes,  				# "yes" - change the sharing dir perm recursively

) {

  validate_string($comment)
  validate_array($usergroups)
  validate_bool($managehome,$recursive)
  validate_re($ensure, '^present$|^absent$')
  
  if $recursive_limit != undef {
    validate_numeric($recursive_limit)
  }

  #this configuration is going to create a user 
  if $ensure == 'present' {
   user { $user:
    ensure         => $ensure,
    shell          => $shell,
    home           => "${home}/${user}",
    groups         => $usergroups,
    managehome     => $managehome,
    password       => $password,
    comment        => $comment,
   } 
  }
  elsif $ensure == 'absent' {
   user { $user:
    ensure         => $ensure,
   }
  }

  #configure the home directory permission and ownership 
  if $ensure != absent {
   file { "${home}/${user}":
    ensure         => directory,
    mode           => 0755,
    recurse        => $recursive,
    recurselimit   => $recursive_limit,
    owner          => $owner,
    group          => $usergroups,
   }
  }

  #configure the upload directory for sftpd user
  if ($ensure != absent) and ($upload_dir != '') {
   file { "${upload_dir}":
    path           => "${home}/${user}/${upload_dir}",
    ensure         => directory,
    owner          => $user,
    group          => $usersgroup,
    mode           => 0755,
   }
  #command run on agent to change the ownership of sftpd directories
  if $ownership_changed != no {
   exec { "${user} ownerships are changed":
    onlyif        => "/bin/ls -ld ${home}/${user}/${upload_dir} | /bin/grep -v ${usergroups}",
    command       => "/bin/chown -R :${usergroups} ${home}/${user}",
    require       => File["${upload_dir}"],
   }
  }
 }
}
