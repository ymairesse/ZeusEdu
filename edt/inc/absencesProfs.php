<?php

$laDate = isset($_COOKIE['laDate']) ? $_COOKIE['laDate'] : strftime("%d/%m/%Y");

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeProfs = $Ecole->listeProfs(true);

require_once 'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// si date du week-end, on passe au lundi suivant
$dateSQL = Application::dateMySQL($laDate);
$dayofweek = date('w', strtotime($dateSQL));
// dimanche ou samedi?
if (in_array($dayofweek, [0,6])) {
    $dateWE = new DateTime($dateSQL);
    $dateWE->modify('next monday');
    $dateSQL = $dateWE->format('Y-m-d');
    $laDate = $dateWE->format('d/m/Y');
}

// la liste des périodes de cours avec début et fin des cours
$periodes = $Edt->getPeriodesCours(true, true);
$absences4day = $Edt->getAbsences4date($dateSQL, $periodes);

$listeNomsProfs = array();
foreach ($absences4day as $abreaviation => $data) {
    $listeNomsProfs[$abreaviation] = $Ecole->abr2name($abreaviation);
    }

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

// infos complémentaires en haut de page
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

$smarty->assign('listeInfos1', $listeInfos1);
$smarty->assign('listeInfos2', $listeInfos2);
$smarty->assign('listeRetards', $listeRetards);

// l'ensemble des profs pour le sélecteur
$smarty->assign('listeProfs', $listeProfs);
// la liste des profs avec absences
$smarty->assign('listeNomsProfs', $listeNomsProfs);
$smarty->assign('absences4day', $absences4day);
$smarty->assign('listeStatuts', $listeStatuts);
$smarty->assign('periodes', $periodes);
$smarty->assign('dateSQL', $dateSQL);
$smarty->assign('laDate', $laDate);

$smarty->assign('corpsPage', 'absencesProfs');
