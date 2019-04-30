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

$liste = isset($_POST['liste']) ? $_POST['liste'] : Null;

Application::afficher($liste);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
// pour retrouver la photo de l'élève
$smarty->assign('BASEDIR', BASEDIR);

foreach ($liste as $wtf => $data){
    $matricule = $data['matricule'];
    $idTraitement = $data['id'];

    $datesSanction = $Presences->getDatesSanction4ref($idTraitement);
    $datesRetards = $Presences->getDatesRetards4ref($idTraitement);
    $dataEleve = $Ecole->nomPrenomClasse($matricule);

    $smarty->assign('dataEleve', $dataEleve);
    $smarty->assign('datesRetards', $datesRetards);
    $smarty->assign('datesSanction', $datesSanction);
}








define('PAGEWIDTH', 600);

$billet4PDF = $smarty->fetch('retards/billetRetard4PDF.tpl');

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new Html2PDF('L', 'A5', 'fr');
$html2pdf->writeHTML($billet4PDF);

$np = Application::simplifieNom($dataEleve['nom'].$dataEleve['prenom']);
$nomFichier = sprintf('billetRetard_%s.pdf', $np);

// création éventuelle du répertoire au nom de l'utlilisateur
$ds = DIRECTORY_SEPARATOR;
$chemin = INSTALL_DIR.$ds."upload".$ds.$acronyme.$ds.$module.$ds;
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', $module.$ds.$nomFichier);
$link = $smarty->fetch('../../templates/lienDocument.tpl');
echo $link;
