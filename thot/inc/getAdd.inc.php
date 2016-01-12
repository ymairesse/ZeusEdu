<?php
require_once("../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classUser.inc.php');
session_start();

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php');
$jdc = new Jdc();

$user = @$_SESSION[APPLICATION];
if ($user == Null)
	die();

$listeCours = $user->getListeCours();
$listeClasses = $user->listeTitulariats("'G','TT','S','C','D'");
$categories = $jdc->categoriesTravaux();

$startDate = isset($_POST['startDate'])?$_POST['startDate']:Null;
$viewState = isset($_POST['viewState'])?$_POST['viewState']:Null;
$heure = isset($_POST['heure'])?$_POST['heure']:Null;
$type = isset($_POST['type'])?$_POST['type']:Null;
$destinataire = isset($_POST['destinataire'])?$_POST['destinataire']:Null;
$lblDestinataire = isset($_POST['lblDestinataire'])?$_POST['lblDestinataire']:Null;

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('categories',$categories);
$smarty->assign('listeCours',$listeCours);
$smarty->assign('listeClasses',$listeClasses);

$smarty->assign('startDate',$startDate);
$smarty->assign('viewState',$viewState);
$smarty->assign('heure',$heure);
$smarty->assign('type',$type);
$smarty->assign('destinataire',$destinataire);
$smarty->assign('lblDestinataire',$lblDestinataire);

$smarty->display('jdc/modalAdd.tpl');
