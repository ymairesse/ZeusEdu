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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.remediation.inc.php';
$remediation = new Remediation();

$idOffre = isset($_POST['idOffre']) ? $_POST['idOffre'] : Null;
$type = isset($_POST['type']) ? $_POST['type'] : Null;
$cible = isset($_POST['cible']) ? $_POST['cible'] : Null;

if ($remediation->isOwner($idOffre, $acronyme)) {
    $nb = $remediation->delGroupeCible($idOffre, $type, $cible);
    echo $nb;
}
