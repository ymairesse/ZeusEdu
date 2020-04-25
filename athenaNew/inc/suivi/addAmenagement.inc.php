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

$amenagement = isset($_POST['amenagement']) ? $_POST['amenagement'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/class.Athena.php';
$Athena = new Athena();

$nb = $Athena->addAmenagement($amenagement);
$listeAmenagements = $Athena->getAmenagementsEBS();
$infoEBS = $Athena->getEBSeleve($matricule);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeAmenagements', $listeAmenagements);
$smarty->assign('infoEBS', $infoEBS);
$smarty->assign('matricule', $matricule);

$smarty->display('detailSuivi/listeAmenagements.tpl');
