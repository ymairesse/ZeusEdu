<?php

require_once INSTALL_DIR.'/admin/inc/classes/classAdmin.inc.php';
$Admin = new Admin();

$listeAnneesArchives = $Admin->getAnneesArchivesJdc();
$size = $Admin->getSizeArchivesJdc();
Application::afficher($size);

$smarty->assign('listeArchives', $listeAnneesArchives);
$smarty->assign('mode', $mode);
$smarty->assign('corpsPage', 'archJdc');
