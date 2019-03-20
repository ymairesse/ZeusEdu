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
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
$Agenda = new Agenda();

$idAgenda = isset($_POST['idAgenda']) ? $_POST['idAgenda'] : Null;
$nomAgenda = isset($_POST['nomAgenda']) ? $_POST['nomAgenda'] : Null;

$listePartages = $Agenda->getShares4agenda($idAgenda, $acronyme);
$listeDestinataires = $Agenda->listeDestinataires();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('idAgenda', $idAgenda);
$smarty->assign('nomAgenda', $nomAgenda);
$smarty->assign('listePartages', $listePartages);
$smarty->assign('listeDestinataires', $listeDestinataires);
$smarty->display('agenda/modal/modalShareAgenda.tpl');
