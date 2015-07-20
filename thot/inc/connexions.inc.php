<?php
switch ($mode) {
  case 'logins':
    require('inc/lookLogins.inc.php');
    break;
  case 'eleve':

    break;
  case 'classe':

    break;
  case 'date':
    require('inc/connexionsDate.inc.php');
    break;
}
?>
