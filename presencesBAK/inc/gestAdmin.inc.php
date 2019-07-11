<?php

switch ($mode) {
  case 'heures':
    require_once 'gestHeures.inc.php';
    break;

case 'justifications':
    require_once 'gestJustifications.inc.php';
    break;

case 'nettoyer':
    require_once 'getArchives.inc.php';
    break;

case 'assiduite':
    require_once 'gestAssiduite.inc.php';
    break;

default:
    // wtf
    break;
  }
