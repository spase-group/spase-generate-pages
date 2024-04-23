<?php

/*
 * Refresh any updated existing naming authority repositories.
 * Clone a fresh copy of any new repositories.
 * This uses the https://hpde.io/naming_auths.json list of naming authorities.
 */

$root = __DIR__ . '/metadata.src';

$na_set = `curl https://hpde.io/naming_auths.json`;

$list = json_decode ($na_set, JSON_OBJECT_AS_ARRAY);
$ALL_AUTH_INFO = $list['naming_auths'];
$NAMING_AUTHS = array_keys ($ALL_AUTH_INFO);

foreach ($NAMING_AUTHS as $folder) {
  $here = "$root/$folder";

  if (!file_exists ($here)) {
    chdir ($root);
    $git_repo = $ALL_AUTH_INFO[$folder]['repository'];
    $clone = print `git clone $git_repo`;
//    file_put_contents ($logfile, $clone, FILE_APPEND);
  }
  chdir ($here);

  print "Now here: $here\n";

  $result = `git pull`;

//  file_put_contents ($logfile, $result, FILE_APPEND);

  print "$result\n";
}

