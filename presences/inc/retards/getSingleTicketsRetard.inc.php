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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$nomEleve = isset($_POST['nomEleve']) ? $_POST['nomEleve'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

$form = array(
    'matricule' => array('0' => $matricule),
    'nomEleve' => array('0' => $nomEleve),
    'heure' => array('0' => $heure),
    'date' => array('0' => $date),
    'periode' => array('0' => $periode)
    );

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('form', $form);
$smarty->assign('BASEDIR', BASEDIR);

$smarty->display('retards/ticketRetard.tpl');
