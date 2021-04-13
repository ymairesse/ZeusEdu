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

$module = $Application->getModule(3);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$coursGrp = isset($form['coursGrp']) ? $form['coursGrp'] : Null;
$classe = isset($form['classe']) ? $form['classe'] : Null;
$date = isset($form['date']) ? $form['date'] : Null;
$date = Application::dateMySql($date);
$start = isset($form['start']) ? $form['start'] : Null;
$end = isset($form['end']) ? $form['end'] : Null;

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

if ($coursGrp != Null)
    $listeEleves = $Ecole->listeElevesCours($coursGrp);
    else $listeEleves = $Ecole->listeElevesClasse($classe);

$listeUsers = array();
foreach ($listeEleves as $matricule => $data){
    $user = $data['user'];
    $listeUsers[$user] = $user;
}


require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$listePresences = $Jdc->getPresences($listeUsers, $date, $start, $end);


require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listePresences', $listePresences);

$smarty->display('jdc/listePresences.tpl');
