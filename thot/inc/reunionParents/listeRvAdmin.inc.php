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

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$idRP = isset($_POST['idRP'])?$_POST['idRP']:Null;

$nomProf = User::identiteProf($acronyme);

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();

$listeRV = $thot->getRVprof($acronyme, $idRP);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

$smarty->assign('listeRV', $listeRV);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));

$smarty->display('reunionParents/tableRVAdmin.tpl');
