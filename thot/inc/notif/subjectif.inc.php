<?php

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('type', 'subjectif');
$smarty->assign('action', $action);
$smarty->assign('etape', $etape);
$smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');

if ($classe != Null) {
    $listeEleves = $Ecole->listeEleves($classe,'groupe');
    $smarty->assign('listeEleves', $listeEleves);
    }

if ($matricule != Null) {
    $smarty->assign('matricule', $matricule);
    $smarty->assign('classe', $classe);
    $niveau = substr($classe, 0, 1);

    // liste des coursGrp
    $listeCoursGrp = array_keys($Ecole->listeRealCoursGrpEleves($matricule));
	// liste des matières correspondant à ces coursGrp (on supprime l'extension du numéro du groupe)
    $listeMatieres = $Ecole->getListeMatieresEleve($listeCoursGrp);

    $eleve = Eleve::staticGetDetailsEleve($matricule);

    $listeAnnonces = $Thot->listeLesAnnonces($matricule, $classe, $listeMatieres, $listeCoursGrp, sprintf('%s %s', $eleve[prenom], $eleve['nom']));

    $listePJ = $Thot->getPJ4eleve($listeAnnonces, $matricule);

    $listeFlags = $Thot->listeFlagsAnnonces(array_keys($listeAnnonces), $matricule);

    $smarty->assign('eleve', $eleve);
    $smarty->assign('listeAnnonces', $listeAnnonces);
    $smarty->assign('listeCours', $listeCoursEleve);
    $smarty->assign('listePJ', $listePJ);
    $smarty->assign('listeFlags', $listeFlags);

    $smarty->assign('corpsPage', 'notification/subjectifAnnonces');
}
