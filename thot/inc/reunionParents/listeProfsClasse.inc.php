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

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$typeRP = isset($_POST['typeRP']) ? $_POST['typeRP'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$listeDirection = $Thot->listeStatutsSpeciaux();

if ($typeRP == 'profs')
    $listeProfs = $Ecole->getListeProfs4classe($classe);
    else $listeProfs = $Ecole->getListeTitulaires4classe($classe);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('listeStatutsSpeciaux', $listeDirection);

$smarty->display('reunionParents/selectProfsCible.tpl');
