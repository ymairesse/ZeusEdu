<?php

$unAn = time() + 365 * 24 * 3600;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

if (isset($_POST['coursGrp'])) {
    $coursGrp = $_POST['coursGrp'];
    setcookie('coursGrp', $coursGrp, $unAn, null, null, false, true);
} else {
    $coursGrp = isset($_COOKIE['coursGrp']) ? $_COOKIE['coursGrp'] : null;
}
$smarty->assign('coursGrp', $coursGrp);

if (isset($_POST['matricule'])) {
    $matricule = $_POST['matricule'];
    setcookie('matricule', $matricule, $unAn, null, null, false, true);
} else {
    $matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : null;
}
$smarty->assign('matricule', $matricule);

$listeCours = $user->listeCoursProf("'G','S','TT'");
$smarty->assign('listeCours', $listeCours);

$smarty->assign('action', $action);
// on présente toujours le sélecteur de cours
$smarty->assign('coursGrp', $coursGrp);
// quelles sont les classes des élèves qui fréquentent le cours?
if (isset($coursGrp)) {
    $classesDansCours = implode(', ', $Bulletin->classesDansCours($coursGrp));
    $smarty->assign('listeClasses', $classesDansCours);
}

$smarty->assign('bulletin', PERIODEENCOURS);
$smarty->assign('nbPeriodes', NBPERIODES);
$smarty->assign('periodes', explode(',', NOMSPERIODES));

switch ($mode) {
    case 'modifBareme':
        // un cours est-il défini et le cours appartient-il à l'utilisateur actif?
        if (isset($coursGrp)  && ($Bulletin->legitimeModifBareme($coursGrp, $listeCours, $matricule))) {
            $nbInsert = $Bulletin->enregistrementPonderations($_POST);
            $ponderations = $Bulletin->getPonderations($coursGrp);
            $intituleCours = $Bulletin->intituleCours($coursGrp);
            $listeEleves = $Ecole->listeElevesCours($coursGrp);

            $smarty->assign('listeEleves', $listeEleves);
            $smarty->assign('ponderations', $ponderations);
            $smarty->assign('intituleCours', $intituleCours);
            $smarty->assign('mode', 'voir');
            $smarty->assign('message', array(
                            'title' => SAVE,
                            'texte' => sprintf('%d pondération(s) modifiée(s)', $nbInsert),
                            'urgence' => 'success', )
                            );
            $smarty->assign('selecteur', 'selecteurs/selectCours');
            $smarty->assign('corpsPage', 'ponderation/showPonderations');
        } else {
            die("Vous ne donnez pas ce cours ou l'&eacute;l&egrave;ve ne suit pas ce cours...");
        }
        break;

    case 'delPonderation':
        if (isset($coursGrp)  && ($Bulletin->legitimeModifBareme($coursGrp, $listeCours, $matricule))) {
            $nb = $Bulletin->suppressionPonderation($coursGrp, $matricule);
            $smarty->assign('message', array(
                'title' => 'Suppression',
                'texte' => sprintf('%d pondérations supprimées', $nb),
                'urgence' => 'success',
                )
            );
        }
        else die("Vous ne donnez pas ce cours ou l'&eacute;l&egrave;ve ne suit pas ce cours...");
        // break;  no break

    default:
        $smarty->assign('selecteur', 'selecteurs/selectCours');
        // on revient avec un cours à traiter...
        if ($coursGrp != null) {
            $ponderations = $Bulletin->getPonderations($coursGrp);
            if ($ponderations == null) {
                $ponderations = $Bulletin->ponderationsVides(NBPERIODES, $coursGrp);
            }
            $listeEleves = $Ecole->listeElevesCours($coursGrp);
            $intituleCours = $Bulletin->intituleCours($coursGrp);

            $smarty->assign('mode', 'voir');
            $smarty->assign('ponderations', $ponderations);
            $smarty->assign('intituleCours', $intituleCours);
            $smarty->assign('listeEleves', $listeEleves);
            $smarty->assign('selecteur', 'selecteurs/selectCours');
            $smarty->assign('corpsPage', 'ponderation/showPonderations');
        }
        break;

    }
