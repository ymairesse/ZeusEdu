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

$module = $Application::getmodule(3);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$date = isset($_POST['date']) ? $_POST['date'] : null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : null;
$photo = isset($_POST['photo']) ? $_POST['photo'] : null;
$nomEleve = isset($_POST['nomEleve']) ? $_POST['nomEleve'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('matricule', $matricule);
$smarty->assign('photo', $photo);
$smarty->assign('date', $date);
$smarty->assign('periode', $periode);
$smarty->assign('heure', $heure);
$smarty->assign('nomEleve', $nomEleve);

$smarty->display('retards/inputRetard.tpl');
