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

// retrouver le nom du module actif
$module = $Application->getModule(3);
$ds = DIRECTORY_SEPARATOR;

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$groupe = isset($_POST['groupe']) ? $_POST['groupe'] : null;

$listeParents = $Thot->generateFichesParents($groupe);

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('P','A4','fr');

foreach ($listeParents as $matricule => $unEleve) {
    $smarty->assign('matricule', $matricule);
    $smarty->assign('secretariat', $unEleve['secretariat']);
    $smarty->assign('thot', $unEleve['thot']);
    $doc4PDF = $smarty->display('../../templates/parents/ficheParents.tpl');
    $html2pdf->WriteHTML($doc4PDF);
}

$nomFichier = 'Parents_'.$groupe.'.pdf';

$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$ds.$nomFichier, 'F');

$smarty->assign('nomFichier', $nomFichier);
$smarty->assign('module', $module);
$smarty->display('../../templates/parents/download.tpl');
