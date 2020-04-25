<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classThot2.inc.php';
$Thot = new Thot();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeNotifications = $Thot->listeUserNotification($acronyme);

// tous les types de destinataires
$listeTypes = $Thot->getTypes();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);

$listeCours = $Ecole->listeCoursProf($acronyme);
$smarty->assign('listeCours', $listeCours);

$listeGroupes = $Thot->getListeGroupes4User($acronyme, 'proprio');
$smarty->assign('listeGroupes', $listeGroupes);

$smarty->assign('listeTypes', $listeTypes);

$smarty->display('notification/selecteurNew.tpl');
