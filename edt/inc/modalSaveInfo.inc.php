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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$date = isset($form['date']) ? $form['date'] : Null;
$dateSQL = Application::dateMySQL($date);
// abréviation du MP en retard
$abreviation = isset($form['acronyme']) ? strtoupper($form['acronyme']) : Null;
$info = isset($form['info']) ? $form['info'] : Null;
$type = isset($form['type']) ? $form['type'] : Null;
$id = isset($form['id']) ? $form['id'] : Null;
$id = ($id != -1) ? $id : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$n = $Edt->saveInfo($type, $abreviation, $info, $dateSQL, $acronyme, $id);

// on recharge tout pour pouvoir équilibrer les deux colonnes
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeInfos1', $listeInfos1);
$smarty->assign('listeInfos2', $listeInfos2);
$smarty->assign('listeRetards', $listeRetards);

echo $smarty->display('listeInfos.tpl');
