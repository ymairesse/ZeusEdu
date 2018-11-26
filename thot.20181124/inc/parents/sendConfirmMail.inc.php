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
$texteFixe = isset($_POST['texteFixe']) ? $_POST['texteFixe'] : Null;
$texteVariable = isset($_POST['texteVariable']) ? $_POST['texteVariable'] : Null;

$texte = ($texteVariable != '') ? $texteFixe.'<hr>'.$texteVariable : $texteFixe;
$texte .= sprintf("<hr><a href='%s'>%s</a>", DISCLAIMER, DISCLAIMER);

$send = false;
if ($userName != Null) {
    $send = $Thot->sendConfirmMail($userName, $texte);
}

echo $send;
