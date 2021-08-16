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
$module = $Application->getModule(2);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$matricule = $form['matricule'];

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$dataEleve = $Eleve->getDetailsEleve();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classInfirmerie.inc.php';
$Infirmerie = new Infirmerie();

$nb = $Infirmerie->saveVisite($form);

// liste des applications activées et accessibles pour savoir si les "présences" sont OK
$applisActives = $Application->listeApplis(true);
$statutPresence = $User->getStatus4appli('presences');
// accès à la "justification speed"
$liste = (array('admin','educ','accueil'));
$okPresences = (in_array('presences', array_keys($applisActives))) && (in_array($statutPresence, $liste));

$consultEleve = $Infirmerie->getVisitesEleve($matricule);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('matricule', $matricule);
$smarty->assign('dataEleve', $dataEleve);
$smarty->assign('consultEleve', $consultEleve);
$smarty->assign('okPresences', $okPresences);

$smarty->display('visitesInfirmerie.tpl');
