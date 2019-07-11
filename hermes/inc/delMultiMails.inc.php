<?php

require_once '../../config.inc.php';

require_once '../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$liste = isset($_POST['liste'])?$_POST['liste']:Null;

$module = $Application->getModule(2);

require_once INSTALL_DIR."/$module/inc/classes/classHermes.inc.php";
$hermes = new hermes();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$nb = 0;
foreach ($liste as $id) {
    $nb += $hermes->delArchive($id,$acronyme);
}

// renvoyer le dernier $id traité pour chercher la ligne la plus proche
echo $id;
