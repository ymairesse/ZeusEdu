<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$listeProfs = $form['listeProfsCoursGrp'];

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$nbDel = $Ecole->delProfFromCoursGrp($listeProfs, $coursGrp);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$listeProfsCoursGrp = $Ecole->getListeProfs4coursGrp($coursGrp);

$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
$smarty->display('admin/modal/listeProfsCoursGrp.tpl');
