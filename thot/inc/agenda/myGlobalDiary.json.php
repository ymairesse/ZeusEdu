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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.Agenda.php';
$Agenda = new Agenda();

$start = $_POST['start'];
$end = $_POST['end'];
$idAgenda = isset($_POST['idAgenda']) ? $_POST['idAgenda'] : Null;

$eventsList = $Agenda->getEvents4Agenda($idAgenda, $start, $end, $acronyme);

echo json_encode($eventsList);
