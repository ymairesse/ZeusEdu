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

$module = $Application->getModule(3);
require_once (INSTALL_DIR."/$module/inc/classes/classAdes.inc.php");
$Ades = new Ades();

// récupérer le formulaire d'encodage du livre
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

if ($form['type'] == '')
    $form = $Ades->saveNewTypeFait($form);
    else $form = $Ades->saveTypeFait($form);

$type = $form['type'];
$fait = $Ades->getFaitByType($type);
$champsObligatoires = $Ades->getChampsObligatoires($form['typeRetenue']);
$listeChamps = $Ades->getListeChamps($form['typeRetenue']);
$listeTousChamps = $Ades->listeChamps();
$champsDisponibles = array_diff(array_keys($listeChamps), array_keys($champsObligatoires));
$retenue = $form['typeRetenue'];

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$listeTypesFaits = $Ades->getListeTypesFaits();
$listeInutiles = $Ades->getTypesFaitsInutilises();

$smarty->assign('listeTypesFaits', $listeTypesFaits);
$smarty->assign('listeInutiles', $listeInutiles);

$smarty->display('faitDisc/tableauFait.tpl');
