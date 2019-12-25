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

$module = $Application::getmodule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$dateFrom = isset($_POST['dateFrom']) ? $_POST['dateFrom'] : null;
$dateTo = isset($_POST['dateTo']) ? $_POST['dateTo'] : null;
$periodeFrom = isset($_POST['periodeFrom']) ? $_POST['periodeFrom'] : null;
$periodeTo = isset($_POST['periodeTo']) ? $_POST['periodeTo'] : null;

$justification = isset($_POST['justification']) ? $_POST['justification'] : null;

if ($justification != Null) {
    $dateFrom = Application::dateMysql($dateFrom);
    $dateTo = Application::dateMysql($dateTo);

    // ne conserver que les jours ouvrés de la période considérée
    $listeJours = $Presences->listBusinessDays($dateFrom, $dateTo);
    $nbJours = count($listeJours);
    // le nombre de périodes prévues dans la journée
    $listePeriodes = $Presences->lirePeriodesCours();
    $nbPeriodes = count($listePeriodes);

    $grille = array();

    $journee = array_fill(1, $nbPeriodes, 0);

    foreach ($listeJours as $n => $unJour) {
        // initialisation de la grille du jour
        $grille[$unJour] = $journee;
        foreach (range(1, $nbPeriodes) as $periode) {
            // est-ce le premier jour?
            if ($n == 0) {
                // sommes-nous après la période de début?
                if ($periode >= $periodeFrom)  {
                    // y a-t-il un seul jour à traiter?
                    if ($nbJours == 1) {
                        if ($periode <= $periodeTo)
                            $grille[$unJour][$periode] = 1;
                            }
                        // sinon, on met la période à 1
                        else $grille[$unJour][$periode] = 1;
                }
            }
            else {
                // sommes-nous avant le dernier jour?
                if ($n < $nbJours-1){
                    // dans ce cas, on peut bourrer avec des 1 partout
                    $grille[$unJour][$periode] = 1;
                    }
                else {
                    // on met la période à 1 si on est avant la fin de l'intervalle
                    if ($periode <= $periodeTo) {
                        $grille[$unJour][$periode] = 1;
                    }
                }
            }
        }
    }

    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
    $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

    $smarty->assign('grille', $grille);

    // tous les modes de justifications existants
    $listeJustifications = $Presences->listeJustificationsAbsences();
    $smarty->assign('listeJustifications', $listeJustifications);

    $listePeriodes = $Presences->lirePeriodesCours();
    $smarty->assign('listePeriodes', $listePeriodes);
    $smarty->assign('justification', $justification);

    $smarty->display('absences/tableauAbsences.tpl');
}
