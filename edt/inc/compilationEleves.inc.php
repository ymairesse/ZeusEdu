<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// vider la table des EDT des élèves
$Edt->EDTelevesTruncate();

$nomsSimplifies = $Edt->simplifieNom();

$listeImages = $Edt->listeImages('../eleves');

foreach ($nomsSimplifies AS $matricule => $nomSimple) {
    $matches  = preg_grep ('/'.$nomSimple.'(\w+)/i', $listeImages);
    if (current($matches) != ''){
        $nomsSimplifies[$matricule] = array('nomSimple' => $nomSimple, 'image' => current($matches));
    }
    else {
        $nomsSimplifies[$matricule] = array('nomSimple' => $nomSimple, 'image' => Null);
    }
}

$nb = $Edt->saveImagesSimples($nomsSimplifies);

echo sprintf('%d images associées', $nb);
