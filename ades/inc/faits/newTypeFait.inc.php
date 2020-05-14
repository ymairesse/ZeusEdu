<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$typeRetenue = isset($_POST['retenue']) ? $_POST['retenue'] : Null;

$fait = $Ades->createNewTypeFait($typeRetenue);

$champsObligatoires = $Ades->getChampsObligatoires($typeRetenue);

$listeChamps = $Ades->getListeChamps($typeRetenue);
$listeTousChamps = $Ades->listeChamps();
$champsDisponibles = array_diff(array_keys($listeChamps), array_keys($champsObligatoires));

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('fait', $fait);
$smarty->assign('champsObligatoires', $champsObligatoires);
$smarty->assign('listeChamps', $listeChamps);
$smarty->assign('listeTousChamps', $listeTousChamps);
$smarty->assign('disponibles', $champsDisponibles);

$smarty->display('faitDisc/formEditTypeFAit.tpl');
