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

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

$demande = $Athena->getDemandeSuivi($id);

$matricule = $demande['matricule'];

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$smarty->assign('photo', Ecole::photo($matricule));

$listeCoaches = $Athena->getCoachesDe($matricule);

$smarty->assign('listeCoaches', $listeCoaches);
$smarty->assign('demande', $demande);
$smarty->display('eleves/detailsDemande.tpl');
