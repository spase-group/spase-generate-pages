<?php

/*
 * Clone a fresh copy of any new repositories into the metadata.src for the next update-pages.sh comparison.
 * This uses the https://hpde.io/naming_auths.json list of naming authorities.
 */

$root = __DIR__ . '/metadata.src';

$na_set = `curl https://hpde.io/naming_auths.json`;

$list = json_decode ($na_set, JSON_OBJECT_AS_ARRAY);
$ALL_AUTH_INFO = $list['naming_auths'];
// Track Deprecated along with the active Naming Authorities for this exercise
$ALL_AUTH_INFO['Deprecated'] = array ();
$ALL_AUTH_INFO['Deprecated']['repository'] = 'https://github.com/hpde/Deprecated';

$NAMING_AUTHS = array_keys ($ALL_AUTH_INFO);

foreach ($NAMING_AUTHS as $folder) {
  $here = "$root/$folder";

  if (!file_exists ($here)) {
    chdir ($root);
    $git_repo = $ALL_AUTH_INFO[$folder]['repository'];
    $clone = print `git clone $git_repo`;
  }

}

