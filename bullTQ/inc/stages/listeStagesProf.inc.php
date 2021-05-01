<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

// $module = $Application->getModule(2);
require_once 'classes/classBullTQ.inc.php';
$BullTQ = new bullTQ();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;

$listeStagesSuivis = $BullTQ->listeStagesSuivis($acronyme);

print_r($listeStagesSuivis);
