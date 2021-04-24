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

$nomProf = User::identiteProf($abreviation);
$listeRV = $Thot->getRVprof($abreviation, $idRP);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

$smarty->assign('listeRV', $listeRV);
$smarty->assign('acronyme', $abreviation);
$smarty->assign('listePeriodes', $Thot->getListePeriodes($idRP));


if ($droit == true)
    $smarty->display('reunionParents/tableRVAdminDroit.tpl');
    else $smarty->display('reunionParents/tableRVAdmin.tpl');
