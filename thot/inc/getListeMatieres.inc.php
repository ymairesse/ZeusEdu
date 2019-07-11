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

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classEcole.inc.php');
$Ecole = new Ecole();
$listeMatieres = $Ecole->listeCoursNiveau($niveau);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeMatieres', $listeMatieres);
$smarty->display('../templates/selecteurs/selectMatieresAjax.tpl');
