<?php

require_once("../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$jdc = new Jdc();

$event_id = isset($_POST['event_id'])?$_POST['event_id']:Null;

if ($event_id != Null) {
    $travail = $jdc->getTravail($event_id);
    return $travail;
    }
