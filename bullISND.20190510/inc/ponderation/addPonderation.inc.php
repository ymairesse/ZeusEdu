<?php
require_once("../../../config.inc.php");

session_start();

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once('../../inc/classes/classBulletin.inc.php');
$Bulletin = new Bulletin();

$listePonderations = $Bulletin->getPonderations($coursGrp)[$coursGrp];
$listePonderations = (isset($listePonderations[$matricule]))?$listePonderations[$matricule]:$listePonderations['all'];

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listePonderations', $listePonderations);
$smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
$smarty->assign('matricule', $matricule);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('bulletin', $bulletin);

$smarty->display('../../templates/ponderation/formPonderation.tpl');
