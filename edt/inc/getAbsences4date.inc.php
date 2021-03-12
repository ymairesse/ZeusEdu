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

$laDate = isset($_POST['laDate']) ? $_POST['laDate'] : strftime("%d/%m/%Y");
$dateSQL = Application::dateMySQL($laDate);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

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
foreach ($absences4day as $acronyme => $data) {
    $listeNomsProfs[$acronyme] = $Ecole->abr2name($acronyme);
    }

// infos complémentaires en haut de page
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

// la listes des infos est répartie sur deux colonnes plus ou moins équilibrées
$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

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
$smarty->assign('laDate', $laDate);

$smarty->display('ABScalendar.tpl');
