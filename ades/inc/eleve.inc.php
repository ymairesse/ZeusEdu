<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeClasses = $Ecole->listeGroupes();

$smarty->assign('listeClasses', $listeClasses);


if ($mode == 'trombinoscope') {
	// sélection par le trombinoscope
	$smarty->assign('corpsPage', 'eleve/newTrombinoscope');
}
else {
	// sélection par classe / élève
	$smarty->assign('corpsPage', 'eleve/newEleveClasse');
}
