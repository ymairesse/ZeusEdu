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

$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : $acronyme;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$droit = isset($_POST['droit']) ? $_POST['droit'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

// récupérer la liste d'attente complète
$listeAttente = $Thot->getListeAttenteProf($idRP, $abreviation);

// liste des élèves du prof qui ont des RV et lesquels
$rv4eleves = $Thot->getRVeleves($idRP, $abreviation);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeAttente', $listeAttente);
$smarty->assign('rv4eleves', $rv4eleves);
$smarty->assign('acronyme', $abreviation);
$smarty->assign('idRP', $idRP);

if ($droit == true)
    $smarty->display('reunionParents/listeAttenteAdminDroit.tpl');
    else $smarty->display('reunionParents/listeAttenteAdmin.tpl');
