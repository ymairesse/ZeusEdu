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

$idGhost = isset($_POST['id']) ? $_POST['id'] : Null;
$laDate = isset($_POST['laDate']) ? $_POST['laDate'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$categories = $Jdc->categoriesTravaux();

$travail = $Jdc->getTravailFromGhost($idGhost, $acronyme);

$travail['type'] = 'coursGrp';
$travail['startDate'] = $laDate;
$travail['title'] = $travail['categorie'];
$travail['enonce'] = '';
$travail['listePJ'] = Null;
$travail['lastModif'] = Application::dateNow();

$listePeriodes = $Jdc->lirePeriodesCours();

$coursGrp = $travail['destinataire'];
$lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, 'coursGrp', $coursGrp);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('acronyme', $acronyme);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('destinataire', $coursGrp);
$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('categories', $categories);

$smarty->assign('travail', $travail);

$smarty->assign('type', 'coursGrp');

$smarty->assign('editable', true);
$smarty->assign('mode', Null);

$smarty->display('jdc/jdcEdit.tpl');
