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

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

$listeEleves = $Ecole->listeEleves($classe, 'groupe');
$listeRV = $thot->getRVeleve(array_keys($listeEleves), $idRP);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeRV', $listeRV);
$smarty->display('reunionParents/listeElevesDeployee.tpl');
