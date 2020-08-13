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
$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;

require_once(INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();

$ds = DIRECTORY_SEPARATOR;
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$listeRV = $thot->listeRVParents($idRP, $mode, $niveau);
$listeAttente = $thot->listeAttenteParents($idRP, $mode, $niveau);
$listeLocaux = $thot->getLocauxRp($idRP);
$infoRP = $thot->getInfoRp($idRP);
$date = $infoRP['date'];

// établir une liste complete de tous les élèves qui figurent dans l'une ou dans l'autre liste
$fullListe = array_unique(array_merge(array_keys($listeRV), array_keys($listeAttente)));
$listeEleves = $thot->listeElevesMatricules($fullListe);

$smarty->assign('idRP', $idRP);
$smarty->assign('date', $date);
$smarty->assign('listeRV', $listeRV);
$smarty->assign('listeLocaux', $listeLocaux);

$smarty->assign('listeAttente', $listeAttente);
$smarty->assign('fullListe', $fullListe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeProfsEleves', $thot->listeCoursListeEleves($listeEleves));

$smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));
$smarty->assign('entete', sprintf('%s <br> %s <br> %s <br>',ECOLE, ADRESSE, VILLE));

$rv4PDF =  $smarty->fetch('reunionParents/RVParents2pdf.tpl');


require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$html2pdf->WriteHTML($rv4PDF);

$f_date = str_replace('/', '-', $date);
$nomFichier = sprintf('rp_%s_%s.pdf', $f_date, $niveau);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;

if (!(file_exists($chemin)))
    mkdir ($chemin, 0700, true);

$html2pdf->Output($chemin.$nomFichier, 'F');

echo sprintf('<a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=/%s/%s">sur ce lien</a>', $module, $nomFichier);
