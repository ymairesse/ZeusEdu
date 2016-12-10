<?php

switch ($mode) {
  case 'heures':
    include 'gestHeures.inc.php';
    break;
case 'justifications':
    require_once 'gestJustifications.inc.php';
    break;

  default:
    echo 'default';
    break;
  }
