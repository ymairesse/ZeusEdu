<?php

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

switch ($etape) {

    case 'save':
        $nb = $thot->saveEditedRv($_POST, $acronyme);
        $message = array(
            'title' => SAVE,
            'texte' => sprintf('%d rendez-vous enregistré ', $nb),
            'urgence' => $nb = 1 ? 'success' : 'warning',
            );
        $smarty->assign('message', $message);
        break;
    case 'delete':
        $nb = $thot->eraseRv($_POST, $acronyme);
        $message = array(
            'title' => SAVE,
            'texte' => sprintf('%d rendez-vous supprimé ', $nb),
            'urgence' => $nb = 1 ? 'success' : 'warning',
            );
        $smarty->assign('message', $message);
        break;
}

$listeRv = $thot->listeChoixRV($acronyme);
$smarty->assign('listeRv', $listeRv);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('corpsPage', 'rdv/listeRv');
