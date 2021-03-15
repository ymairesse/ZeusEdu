<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

$matiere = isset($_POST['matiere']) ? $_POST['matiere'] : Null;
// $niveau = ($matiere != Null) ? substr($matiere, 0, 1) : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$detailsCours = $Ecole->detailsCours($matiere);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('detailsCours', $detailsCours);

$smarty->assign('cours', $matiere);

// le cours est-il orphelin? Auquel cas il peut être modifié
$smarty->assign('fullEditable', in_array($matiere, $Ecole->listOrphanCours()));

$smarty->assign('listeFormes', $Ecole->listeFormes());

// la liste des sections est celle qui est déclarées dans les paramètres généraux
$smarty->assign('listeSections',$Ecole->listeSections());
$smarty->assign('listeNiveaux', $Ecole->listeNiveaux());

$smarty->assign('listeCadresStatuts', $Ecole->listeCadresStatuts());

$smarty->display('admin/formEditMatiere.tpl');
