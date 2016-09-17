<?php

if (isset($matricule)) {
    // suppression d'une visite à l'infirmerie
    if ($consultID) {
        $nbResultats = $infirmerie->deleteVisite($consultID);
        $smarty->assign('message', array(
            'title' => 'Suppression',
            'texte' => "Effacement de: $nbResultats visite",
            'urgence' => 'warning',
            )
            );
    }
}
$smarty->assign('medicEleve', $infirmerie->getMedicEleve($matricule));
$smarty->assign('consultEleve', $infirmerie->getVisitesEleve($matricule));
$smarty->assign('classe', $classe);
$action = 'ficheEleve';
$mode = 'wtf';
$smarty->assign('corpsPage', 'ficheEleve');
