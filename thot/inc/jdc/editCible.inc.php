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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : Null;
$pastIsOpen = isset($_POST['pastIsOpen']) ? $_POST['pastIsOpen'] : Null;

$travail = $Jdc->getTravail($idTravail, $acronyme);
$travail['startDate'] = Application::datePHP($travail['startDate']);

$types = $Jdc->getTypes();
$destinataire = $travail['destinataire'];
$type = $travail['type'];
$listePeriodes = $Jdc->lirePeriodesCours();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, $type, $destinataire);
$enonce = mb_strimwidth(strip_tags(html_entity_decode($travail['enonce']), '<br><p>'), 0, 95,"...");

$smarty->assign('types', $types);
$smarty->assign('listePeriodes', $listePeriodes);
$smarty->assign('travail', $travail);
$smarty->assign('enonce', $enonce);

$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('idTravail', $idTravail);
$smarty->assign('pastIsOpen', $pastIsOpen);

$smarty->display('jdc/modal/modalChoixCible.tpl');
