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

$userStatus = $User->userStatus($module);

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$dateSQL = Application::dateMySQL($date);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// date avec nom du jour en français (locale)
$unixTime = strtotime($dateSQL);
$laDate = strftime("%A %d/%m/%Y", $unixTime);

// la liste des périodes de cours avec début et fin des cours
$periodes = $Edt->getPeriodesCours(true, true);
$absences4day = $Edt->getAbsences4date($dateSQL, $periodes);

// détermination des statuts pour chaque absence
$listeStatuts = array();
foreach ($absences4day as $abreviation => $dataJour){
    foreach ($dataJour as $heure => $dataHeure){
        $statuts = $Edt->getStatuts4periode($abreviation, $dateSQL, $heure);
        // réorganisation des statuts 'move' et "normal"
        foreach ($statuts AS $unStatut) {
            if (($unStatut == 'movedFrom') || ($unStatut == 'movedTo'))
                $listeStatuts[$abreviation][$heure]['move'] = $unStatut;
                else $listeStatuts[$abreviation][$heure]['normal'][] = $unStatut;
            }
        }
    }

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new ecole();

// retrouver l'identité du prof
$listeNomsProfs = array();
foreach ($absences4day as $abreviation => $data) {
    $listeNomsProfs[$abreviation] = $Ecole->abr2name($abreviation);
    }

// infos complémentaires en haut de page
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

// la listes des infos est répartie sur deux colonnes plus ou moins équilibrées
$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

$nbPeriodes = count($periodes);
// 6% de la page pour les acronymes, 94% de la page pour les périodes
$periodeWidth = round(94/$nbPeriodes);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('absences4day', $absences4day);
$smarty->assign('listeStatuts', $listeStatuts);
$smarty->assign('listeNomsProfs', $listeNomsProfs);
$smarty->assign('listeInfos1', $listeInfos1);
$smarty->assign('listeInfos2', $listeInfos2);
$smarty->assign('listeRetards', $listeRetards);

$smarty->assign('periodes', $periodes);
$smarty->assign('nbPeriodes', $nbPeriodes);
$smarty->assign('periodeWidth', $periodeWidth);
$smarty->assign('laDate', $laDate);

$abs4PDF =  $smarty->fetch('ABScalendarPDF.tpl');


require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('L', 'A4', 'fr');

$html2pdf->WriteHTML($abs4PDF);

$f_date = str_replace('/', '-', $date);
$nomFichier = sprintf('abs_%s.pdf', $f_date);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;

if (!(file_exists($chemin)))
    mkdir ($chemin, 0700, true);

$html2pdf->Output($chemin.$nomFichier, 'F');

echo sprintf("inc/download.php?type=pfN&amp;f=/%s/%s", $module, $nomFichier);
