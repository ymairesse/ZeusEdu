<?php


// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new thot();

$listeMesGroupes = $Thot->getListeGroupes4User($acronyme);

$statutsMembresGroupes = $Thot->getStatutsMembresGroupes();

$statutsGroupes = $Thot->getStatusGroupes();

$smarty->assign('acronyme', $acronyme);
$smarty->assign('listeMesGroupes', $listeMesGroupes);
$smarty->assign('statutsMembresGroupes', $statutsMembresGroupes);
$smarty->assign('statutsGroupes', $statutsGroupes);

$smarty->assign('corpsPage', 'groupes/gestGroupes');
