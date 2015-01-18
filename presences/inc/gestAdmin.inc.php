<?php

switch ($mode) {
  case 'heures':
    include ('gestHeures.inc.php');
    break;
  default:
    echo "default";
    break;
  }

?>