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

$module = $Application->getModule(3);

$idCarnet = isset($_POST['idCarnet'])?$_POST['idCarnet']:Null;

require_once INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

$entete = $Bulletin->getEnteteCote($idCarnet);
$coursGrp = $entete['coursGrp'];
$listeCoursGrp = $User->listeCoursProf();

if (!(in_array($coursGrp, array_keys($listeCoursGrp))))
    die();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('entete',$entete);
$smarty->display('carnet/modal/modalChoixAction.tpl');
