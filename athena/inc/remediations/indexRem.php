<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';


$listeNiveaux = Ecole::listeNiveaux();

$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'remediations/remediations');
