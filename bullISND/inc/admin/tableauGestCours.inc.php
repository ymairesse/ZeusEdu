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
$cours = SUBSTR($coursGrp, 0, strpos($coursGrp,'-'));

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeCoursGrp4Eleves = $Ecole->getListeCoursGrp4elevesCours($cours);
$listeCoursGrp4Profs = $Ecole->getListeCoursGrp4profsCours($cours);

$listeCoursGrp4cours = array_merge($listeCoursGrp4Eleves, $listeCoursGrp4Profs);

$listeLinkedCoursGrp = $Ecole->listeLinkedCoursGroup($listeCoursGrp4cours);
$listeVirtualCoursGrp = $Ecole->listeVirtualCoursGrp($listeCoursGrp4cours);
$listeProfsCoursGrp = $Ecole->listeProfsCoursGrp4cours($listeCoursGrp4cours);

$listeElevesCoursGrp = $Ecole->listeElevesCoursGrp4cours($listeCoursGrp4cours);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('cours', $cours);

$smarty->assign('listeCoursGrp', $listeCoursGrp4cours);

$smarty->assign('listeLinkedCoursGrp', $listeLinkedCoursGrp);
$smarty->assign('listeVirtualCoursGrp', $listeVirtualCoursGrp);
$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
$smarty->assign('listeElevesCoursGrp', $listeElevesCoursGrp);

$smarty->display('admin/tableauGestCours.tpl');
