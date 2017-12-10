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

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$listeElevesPlus = isset($_POST['listeElevesPlus']) ? $_POST['listeElevesPlus'] : Null;
$listeMatriculesPlus = array();
parse_str($listeElevesPlus, $listeMatriculesPlus);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeEleves = $Ecole->listeEleves($classe);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('matricule', $matricule);
$elevesPlus = isset($listeMatriculesPlus['elevesPlus']) ? $listeMatriculesPlus['elevesPlus'] : Null;
$smarty->assign('listeElevesPlus', $elevesPlus);

$smarty->display('detailSuivi/ulListeEleves.tpl');
