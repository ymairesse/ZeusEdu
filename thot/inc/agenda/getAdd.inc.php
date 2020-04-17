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

$categories = $Agenda->getCategoriesAgenda();

$startTime = isset($_POST['startTime']) ? $_POST['startTime'] : null;
$endTime = isset($_POST['endTime']) ? $_POST['endTime'] : null;
$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : null;
$endDate = $startDate;
$idAgenda = isset($_POST['idAgenda']) ? $_POST['idAgenda'] : Null;
$editPossible = true;


$event = array(
    'idCategorie' => Null,
    'idAgenda' => $idAgenda,
    'id' => Null,
    'classe' => Null,
    'startDate' => $startDate,
    'endDate' => $endDate,
    'startTime' => $startTime,
    'endTime' => $endTime,
    'title' => Null,
    'enonce' => Null,
    'redacteur' => $acronyme,
    'allDay' => 0,
    'listePJ' => Null,
    'lastModif' => '-',
    );


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('INSTALL_DIR', INSTALL_DIR);

$smarty->assign('event', $event);
$smarty->assign('id', $idAgenda);
$smarty->assign('categories', $categories);
$smarty->assign('editPossible', $editPossible);
$smarty->display('agenda/editEvent.tpl');
