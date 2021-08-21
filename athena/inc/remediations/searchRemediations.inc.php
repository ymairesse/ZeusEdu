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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$dateFrom = isset($form['dateFrom']) ? Application::dateMysql($form['dateFrom']) : Null;
$dateTo = isset($form['dateTo']) ? Application::dateMysql($form['dateTo']) : Null;
$niveau = isset($form['niveau']) ? $form['niveau'] : Null;

// Application::afficher(array($dateFrom, $dateTo, $niveau), true);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

if (($niveau != Null) AND ($dateFrom != Null) AND ($dateTo != Null)) {
    $listeRemediations = $Athena->getRemed4niveauDates($niveau, $dateFrom, $dateTo);
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeRemediations', $listeRemediations);

$smarty->display('remediations/listeRemediations.tpl');
