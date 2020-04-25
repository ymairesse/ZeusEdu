<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$userName = isset($_POST['userName']) ? $_POST['userName'] : Null;

if ($userName != Null) {
    $detailsParent = $Thot->listeParentsUserNames($userName);
    $detailsParent = $detailsParent[$userName];
}
else $detailsParent = Null;

echo json_encode($detailsParent);
