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

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$statut = isset($_POST['statut']) ? $_POST['statut'] : Null;
$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();


$nb = 0;
if ($acronyme != Null) {
    $listeHeures = $Thot->getHoraire4randomProf($idRP);
    $nb = $Thot->addNewProf($acronyme, $statut, $listeHeures, $idRP);
}

$listeProfs = $Thot->listeProfsAvecRv($idRP);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeProfs', $listeProfs);
$html = $smarty->fetch('reunionParents/listeProfs4admin.tpl');

echo json_encode(array('html' => $html, 'nb' => $nb));
