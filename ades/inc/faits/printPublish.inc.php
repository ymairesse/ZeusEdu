<?php

$module = $Application->getModule(1);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$listeTypesFaits = $Ades->getListeTypesFaits();

// liste des types de faits existant
$smarty->assign('listeTypesFaits', $listeTypesFaits);

$smarty->assign('corpsPage', 'faitDisc/printPublish');
