<?php

// lecture de toutes les notifications en vrac pour l'utilisateur courant
$listeNotifications = $Thot->listeUserNotification($acronyme);
$smarty->assign('listeNotifications', $listeNotifications);

// traitement particuler pour les élèves dont on ne connaît, sinon, que le matricule
$listeEleves = array();
$notificationsEleves = isset($listeNotifications['eleves']) ? $listeNotifications['eleves'] : null;
foreach ($notificationsEleves as $id => $item) {
    // les matricules sont numériques
    if (is_numeric($item['destinataire'])) {
        $matricule = $item['destinataire'];
        $listeEleves[$matricule] = $matricule;
    }
}

// liste des demandes d'accusés de lecture (lu ou non lu)
$listeAccuses = $Thot->listeAccuses($acronyme);

// liste des résultats des accusés: nombre d'accusés par notification demandant un accusé de lecture
$statsAccuses = $Thot->statsAccuses($Thot->listeIdNotif4User($acronyme));
$smarty->assign('statsAccuses', $statsAccuses);

$smarty->assign('detailsEleves', $Ecole->detailsDeListeEleves($listeEleves));
$smarty->assign('corpsPage', 'notification/historique');
