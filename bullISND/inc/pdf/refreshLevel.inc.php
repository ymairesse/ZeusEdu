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

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

$module = $Application->getModule(3);

$listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe');

foreach ($listeClasses as $classe) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $Bulletin->createPDFclasse4archive($listeEleves, $classe, $periode);
}

$directory = $Bulletin->flatDirectoryArchive('../../archives/'.ANNEESCOLAIRE, $niveau)[$periode];

echo json_encode(array('ANNEESCOLAIRE' => ANNEESCOLAIRE, 'directory' => $directory));
