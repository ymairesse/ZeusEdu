<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$idretenue = isset($_POST['idretenue']) ? $_POST['idretenue'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$infosRetenue = $Ades->infosRetenue($idretenue);
$smarty->assign('infosRetenue', $infosRetenue);

$date = Application::dateMysql($infosRetenue['dateRetenue']);
$heure = $infosRetenue['heure'];

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

$listeElevesRetenue = $Ades->listeElevesRetenue($idretenue);
$smarty->assign('listeEleves', $listeElevesRetenue);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$smarty->assign('BASEDIR', BASEDIR);

$ficheEleve4PDF = $smarty->fetch('../../templates/retenues/tableauListeRetenues4PDF.tpl');
$html2pdf->WriteHTML($ficheEleve4PDF);

$ds = DIRECTORY_SEPARATOR;
$nomFichier = sprintf('retenue_%s_%s.pdf', $date, $heure);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/upload/$acronyme/$module/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/upload/$acronyme/$module/", 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', $module.$ds.$nomFichier);
echo $smarty->fetch('../../templates/lienDocument.tpl');
