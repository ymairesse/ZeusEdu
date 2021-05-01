<?php

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$listeDemandesProfs = $Athena->getDemandesSuivi();
$smarty->assign('listeDemandesProfs', $listeDemandesProfs);

$listeDemandesEleves = $Athena->getDemandeAideEleves();
$smarty->assign('listeDemandesEleves', $listeDemandesEleves);

$smarty->assign('corpsPage', 'eleves/listeDemandes');
