<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
//
$listeClasses = $Ecole->listeGroupes();
$classe = isset($_COOKIE['classe']) ? $_COOKIE['classe'] : Null;
$matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : Null;


$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);

$smarty->assign('corpsPage', 'eleve/newTrombinoscope');
