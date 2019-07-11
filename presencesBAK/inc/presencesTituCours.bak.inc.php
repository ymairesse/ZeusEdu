<?php

if (isset($_GET['coursGrp'])) {
    $coursGrp = $_GET['coursGrp'];
    }
    else if (isset($_POST['coursGrp'])) {
        $coursGrp = $_POST['coursGrp'];
        }
        else $coursGrp = Null;

$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('acronyme', $acronyme);

if ($etape == 'enregistrer') {
    if ($coursGrp != Null) {
        $listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
        $nb = $Presences->savePresences($_POST, $acronyme);
        $smarty->assign('message', array(
                'title' => SAVE,
                'texte' => sprintf(NBSAVE, $nb),
                'urgence' => 'success',
                ));
    }
}

// un coursGrp a été sélectionné
if (isset($coursGrp)) {
    if (!(isset($listeEleves))) {
        // si on a enregistré, $listeEleves est déjà connu
        $listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
    }

	// quelles sont les mentions d'absences accessibles (en principe, NP, ABS, PRES)
	$justifications = $Presences->listeJustificationsAbsences(false);
	$smarty->assign('justifications', $justifications);

    $listeJustifications = $Presences->listeJustificationsAbsences(true);
    $smarty->assign('listeJustifications', $listeJustifications);

    $listePresences = $Presences->listePresencesElevesDate($date, $listeEleves);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('nbEleves', count($listeEleves));

    $listePresences = isset($listePresences) ? $listePresences : null;
    $smarty->assign('listePresences', $listePresences);
    $smarty->assign('action', $action);
    $smarty->assign('mode', $mode);
    $smarty->assign('corpsPage', 'feuillePresencesCours');
} else {
        on présente la liste de choix des coursGrp
        $smarty->assign('corpsPage', 'choixCoursProf');
    }
