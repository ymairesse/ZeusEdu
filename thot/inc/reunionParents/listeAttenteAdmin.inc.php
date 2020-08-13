<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

// récupérer la liste d'attente complète
$listeAttente = $Thot->getListeAttenteProf($idRP, $acronyme);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeAttente', $listeAttente);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('idRP', $idRP);

$smarty->display('reunionParents/listeAttenteAdmin.tpl');
