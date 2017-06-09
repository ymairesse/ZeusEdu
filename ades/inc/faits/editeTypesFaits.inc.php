<?php

$module = $Application->getModule(1);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$listeChamps = $Ades->lireDescriptionChamps();
$listeTypesFaits = $Ades->getListeTypesFaits();
$listeInutiles = $Ades->getTypesFaitsInutilises();

$smarty->assign('listeChamps', $listeChamps);
$smarty->assign('listeTypesFaits', $listeTypesFaits);
$smarty->assign('listeInutiles', $listeInutiles);

$smarty->assign('corpsPage', 'faitDisc/editeTypesFaits');
