<?php

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

switch ($mode) {
    case 'adresser':
        require_once 'inc/eleves/adresser.inc.php';
        break;
    case 'priseEnCharge':
        require_once 'inc/eleves/priseEnCharge.inc.php';
        break;
}
