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

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

$niveau = substr($classe, 0, 1);

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$listeEleves = $Ecole->listeEleves($classe, 'groupe');

$Bulletin->createPDFclasse4archive($listeEleves, $classe, $periode);

$directory = $Bulletin->flatDirectoryArchive('../../archives/'.ANNEESCOLAIRE, $niveau);
$file = $directory[$periode][$classe];

echo json_encode(array('ANNEESCOLAIRE' => ANNEESCOLAIRE, 'file' => $file));
