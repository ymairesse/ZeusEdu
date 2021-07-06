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

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

// liste de tous les profs
$listeProfs = $Ecole->listeProfs();
// liste des profs déjà prévus
$listeProfsOK = array_keys($Thot->listeProfsAvecRv($idRP));

$listeManquants = array();
foreach ($listeProfs as $acronyme => $data) {
    if (!(in_array($acronyme, $listeProfsOK)))
        $listeManquants[$acronyme] = $data;
}

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeProfs', $listeManquants);

$smarty->display('reunionParents/modal/modalAddProf.tpl');
