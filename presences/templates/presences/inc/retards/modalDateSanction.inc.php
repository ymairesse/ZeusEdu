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

$module = $Application::getmodule(3);

// récupérer le formulaire d'encodage du livre
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$listeIds = isset($_POST['listeIds']) ? $_POST['listeIds'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'edt'.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();
$imageEDT = $Edt->getEdtEleve($matricule);

setlocale(LC_TIME, "fr_FR");
$today = strftime('%A %d/%m/%Y');

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('date', $today);
$smarty->assign('imageEDT', $imageEDT);
$smarty->assign('matricule', $matricule);
$smarty->assign('listeIds', $listeIds);
$smarty->display('retards/modal/choixSanction.tpl');
