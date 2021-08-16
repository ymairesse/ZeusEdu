<?php

// // définition de la class USER utilisée en variable de SESSION
// require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
//
// if (!(isset($_SESSION[APPLICATION]))) {
//     echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
//     exit;
// }
//
// $User = $_SESSION[APPLICATION];

$smarty->assign('listeClasses', $Ecole->listeGroupes());

$smarty->assign('corpsPage', 'visite');
