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

$debut = Application::dateMySql($form['debut']);
$fin = Application::dateMySql($form['fin']);
$niveau = isset($form['niveau']) ? $form['niveau'] : Null;
$classe = isset($form['classe']) ? $form['classe'] : Null;
$matricule = isset($form['matricule']) ? $form['matricule'] : Null;

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
// renvoie la liste des retards durant une période pour un niveau d'étude, une classe ou un élève
$listeRetards = $Presences->getRetards4Periode($debut, $fin, $niveau, $classe, $matricule);

$smarty->assign('listeRetards', $listeRetards);
$smarty->assign('form', $form);

$smarty->display('retards/traitementRetards.tpl');
