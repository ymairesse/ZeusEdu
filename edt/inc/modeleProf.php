<?php

$acronyme = isset($_COOKIE['acronyme']) ? $_COOKIE['acronyme'] : Null;
$dateEDT = isset($_COOKIE['dateEDT']) ? $_COOKIE['dateEDT'] : date('d/m/Y');


require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeProfs = $Ecole->listeProfs(true);

require_once 'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// si date du week-end, on passe au lundi suivant
$dateSQL = Application::dateMySQL($dateEDT);
$dayofweek = date('w', strtotime($dateSQL));
// dimanche ou samedi?
if (in_array($dayofweek, [0,6])) {
    $laDate = new DateTime($dateSQL);
    $laDate->modify('next monday');
    $dateSQL = $laDate->format('Y-m-d');
    $dateEDT = $laDate->format('d/m/Y');
}

$periodes = $Edt->getPeriodesCours(true, false);
$absences4day = $Edt->getAbsences4date($dateSQL, $periodes);

$listeNomsProfs = array();
foreach ($absences4day as $acronyme => $data) {
        $listeNomsProfs[$acronyme] = $Ecole->abr2name($acronyme);
    }

// l'ensemble des profs pour le sélecteur
$smarty->assign('listeProfs', $listeProfs);
// la liste des profs avec absences
$smarty->assign('listeNomsProfs', $listeNomsProfs);
$smarty->assign('absences4day', $absences4day);
$smarty->assign('periodes', $periodes);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('dateEDT', $dateEDT);

$smarty->assign('corpsPage', 'modeleProf');
