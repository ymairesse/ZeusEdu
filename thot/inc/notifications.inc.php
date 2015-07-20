<?php
switch ($mode) {
  case 'eleves':
    require('inc/notif/notificationEleve.inc.php');
    break;
  case 'classes':
    require('inc/notif/notificationClasse.inc.php');
    break;
  case 'niveau':
    require('inc/notif/notificationNiveau.inc.php');
    break;
  case 'ecole':
    require('inc/notif/notificationEcole.inc.php');
    break;
}
?>
