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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$form['matricule'] = $matricule;

$debut = Application::dateMySql($form['debut']);
$fin = Application::dateMySql($form['fin']);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listePeriodes = $Ecole->lirePeriodesCours();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listePeriodes', $listePeriodes);
// renvoie la liste des retards durant une période pour un seul élève
$listeRetards = $Presences->getRetards4Periode($debut, $fin, Null, Null, $matricule);

$smarty->assign('dataRetards', $listeRetards[$matricule]);
// le sélecteur de gauche, y compris les dates de début et de fin
$smarty->assign('form', $form);
// le matricule du seul élève concerné
$smarty->assign('matricule', $matricule);

$smarty->display('retards/inc/ligneTraitement.tpl');
