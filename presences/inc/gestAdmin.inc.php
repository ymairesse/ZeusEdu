<?php

switch ($mode) {
  case 'heures':
    include 'gestHeures.inc.php';
    break;
case 'justifications':
    require_once 'gestJustifications.inc.php';
    break;
case 'nettoyer':
    require_once 'getArchives.inc.php';
    break;
case 'news':
    require_once 'delEditNews.inc.php';
    break;
default:
    // wtf
    break;
  }
