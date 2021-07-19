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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

// $nb = nombre d'enregistrements réalisés
$nb = $Bulletin->enregistrementPonderations($form);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// rechargement de la liste des pondérations
$coursGrp = $form['coursGrp'];
$ponderations = $Bulletin->getPonderations($coursGrp)[$coursGrp];
$listeEleves = $Ecole->listeElevesCours($coursGrp);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('ponderations', $ponderations);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('nbPeriodes', NBPERIODES);
$smarty->assign('listePeriodes', range(1, NBPERIODES));
$smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
$smarty->assign('bulletin', PERIODEENCOURS);

$html = $smarty->fetch('ponderation/tablePonderation.tpl');

echo json_encode(array('nb' => $nb, 'html' => $html));
