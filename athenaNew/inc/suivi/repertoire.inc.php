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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
if ($matricule == null) {
    die();
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

// répertoire des évaluations
$listeCoursGrp = $Ecole->listeCoursGrpEleve($matricule);
$listeCoursGrpAbr = $Ecole->abrListeCoursGrp(array_keys($listeCoursGrp));
$listeCotes = $Bulletin->getCotes4listeCoursGrp($listeCoursGrp, $matricule);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('abrCoursGrp', $listeCoursGrpAbr);
$smarty->assign('listeCotes', $listeCotes);
$smarty->assign('listeCoursGrp', $listeCoursGrp);

$smarty->display('detailSuivi/repertoire.tpl');
