<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

$typeRetenueCourant = isset($_POST['typeRetenue'])?$_POST['typeRetenue']:Null;
$idRetenue = isset($_POST['idRetenue'])?$_POST['idRetenue']:Null;

require_once INSTALL_DIR."/$module/inc/classes/classRetenue.inc.php";
$retenue = new Retenue($idRetenue);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// les types de retenues existantes, pour le "<select>"
$typesRetenues = $Ades->getTypesRetenues();
$smarty->assign('typesRetenues',$typesRetenues);

$smarty->assign('typeRetenueCourant', $typeRetenueCourant);
$smarty->assign('idRetenue', $idRetenue);

$retenue = $retenue->getRetenue();
$smarty->assign('retenue', $retenue);

$formulaire = $smarty->fetch('../../templates/retenues/editRetenue.tpl');

echo $formulaire;
