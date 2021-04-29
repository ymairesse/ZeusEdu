<?php

$laDate = isset($_COOKIE['laDate']) ? $_COOKIE['laDate'] : strftime("%d/%m/%Y");

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeProfs = $Ecole->listeProfs(true);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
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

// infos complémentaires en haut de page
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

// détermination des statuts pour chaque absence
$listeStatuts = array();
foreach ($absences4day as $abreviation => $dataJour){
    foreach ($dataJour as $heure => $dataHeure){
        // on retient le statut d'absence de la période de cours pour statut global
        // pour cette absence du jour (ABS ou indisponible)
        $absences4day[$abreviation]['statutAbs'] = $dataHeure['statutAbs'];
        // $statuts élèves: licencie,...
        $statuts = $Edt->getStatuts4periode($abreviation, $dateSQL, $heure);
        // réorganisation des statuts 'move' et "normal"
        foreach ($statuts AS $unStatut) {
            if (($unStatut == 'movedFrom') || ($unStatut == 'movedTo'))
                $listeStatuts[$abreviation][$heure]['move'] = $unStatut;
                else $listeStatuts[$abreviation][$heure]['normal'][] = $unStatut;
            }
        }
    }

$smarty->assign('listeInfos1', $listeInfos1);
$smarty->assign('listeInfos2', $listeInfos2);
$smarty->assign('listeRetards', $listeRetards);

$listeEducs = $Edt->getEducs4date($dateSQL);
$smarty->assign('listeEducs', $listeEducs);

$nbPeriodes = count($periodes);
// 6% de la page pour les acronymes, 94% de la page pour les périodes
$periodeWidth = round(94/$nbPeriodes);
$smarty->assign('periodeWidth', $periodeWidth);

// l'ensemble des profs pour le sélecteur
$smarty->assign('listeProfs', $listeProfs);
// la liste des profs avec absences
$smarty->assign('listeNomsProfs', $listeNomsProfs);
$smarty->assign('absences4day', $absences4day);
$smarty->assign('listeStatuts', $listeStatuts);
$smarty->assign('periodes', $periodes);
$smarty->assign('laDate', $laDate);

$smarty->assign('corpsPage', 'absencesProfs');
