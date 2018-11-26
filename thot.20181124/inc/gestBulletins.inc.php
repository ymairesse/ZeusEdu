<?php

if ($etape == 'enregistrer') {
    $nb = $Thot->saveLimiteBulletins($_POST);
    $smarty->assign('message', array(
                'title' => SAVE,
                'texte' => sprintf('%d enregistrement(s) effectué(s)', $nb),
                'urgence' => SUCCES, )
                );
}

$smarty->assign('classe', $classe);
$listeEleves = $Ecole->listeEleves($classe, 'groupe');
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('selecteur', 'selecteurs/selectClassePOST');

if ($classe != null) {
    $smarty->assign('listeBulletinsEleves', $Thot->listeBulletinsEleves($classe));
    $smarty->assign('NBPERIODES', NBPERIODES);
    $smarty->assign('listeBulletins', range(0, NBPERIODES));
    $smarty->assign('PERIODEENCOURS', PERIODEENCOURS);
    $smarty->assign('corpsPage', 'gestBulletins');
} else {
        $smarty->assign('corpsPages', null);
    }
