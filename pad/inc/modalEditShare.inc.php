<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

// récupérer le formulaire d'encodage des cours
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$id = isset($_POST['id']) ? $_POST['id'] : Null;
$guest = isset($_POST['guest']) ? $_POST['guest'] : Null;
$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

$listeProfs = $Ecole->listeProfs();
$listeEleves = $Ecole->getInfoListeEleves(array($matricule));

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('guest', $guest);
$smarty->assign('mode', $mode);

$smarty->display('modal/modalAddShare.tpl');
