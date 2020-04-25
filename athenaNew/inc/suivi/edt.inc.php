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

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// rechercher l'image de l'horeaire EDT si disponible
require_once INSTALL_DIR.'/edt/inc/classes/classEDT.inc.php';
$Edt = new Edt();

$imageEDT = $Edt->getEdtEleve($matricule);
$smarty->assign('imageEDT', $imageEDT);

$smarty->display('detailSuivi/edt.tpl');
