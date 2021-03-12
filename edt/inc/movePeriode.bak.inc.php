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


$oldHeure = isset($_POST['oldHeure']) ? $_POST['oldHeure'] : Null;
$newHeure = isset($_POST['newHeure']) ? $_POST['newHeure'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;
$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// recherche des informations de la période qui a été déplacée
$startTime = sprintf('%s %s', $date, $oldHeure);
$infoOrigine = $Edt->getAbsence4periode($abreviation, $oldHeure);
$statuts = $Edt->getStatuts4periode($abreviation, $oldHeure);

// enregistrement de la période déplacée (NOUVELLE)
$Edt->setAbsence4periode($abreviation, $newHeure, $infoOrigine);
$Edt->setStatuts4periode4prof($abreviation, $newHeure, $statuts);

// enregistrement de la période d'absence d'origine "moved"
$statuts[] = 'moved';
$Edt->setStatuts4periode4prof($abreviation, $odlHeure, $statuts);

// retour de la liste des absences de ce jour

$periodes = $Edt->getPeriodesCours(true, false);
$absences4day = $Edt->getAbsences4date($date);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new ecole();

$listeNomsProfs = array();
foreach ($absences4day as $acronyme => $data) {
        $listeNomsProfs[$acronyme] = $Ecole->abr2name($acronyme);
    }


$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('absences4day', $absences4day);
$smarty->assign('dateEDT', $date);
$smarty->assign('listeNomsProfs', $listeNomsProfs);
$smarty->assign('periodes', $periodes);


$smarty->display('ABScalendar.tpl');
