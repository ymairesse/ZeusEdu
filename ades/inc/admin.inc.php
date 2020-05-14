<?php

switch ($mode) {
    case 'editBilletRetenue':
        require_once 'inc/retenues/editBilletRetenue.inc.php';
        break;

    case 'editMailRetenue':
        require_once 'inc/retenues/editMailRetenue.inc.php';
        break;

    case 'editSignature':
        require_once 'inc/signature.inc.php';
        break;

    case 'editTypesFaits':
        require_once 'inc/faits/editeTypesFaits.inc.php';
        break;

    // sélection des faits disciplinaires imprimés et publiés
    case 'printPublish':
        require_once 'inc/faits/printPublish.inc.php';
        break;

    case 'users':
        if ($userStatus == 'admin') {
            $module = $Application->getModule(1);
            $listeProfs = $Ecole->listeProfs();
            $adesUsersList = $Ades->adesUsersList();
            $listeStatuts = $Application->listeStatuts();
            $smarty->assign('listeStatuts', $listeStatuts);
            $smarty->assign('usersList', $adesUsersList);
            $smarty->assign('listeProfs', $listeProfs);
            $smarty->assign('corpsPage', 'admin/usersList');
            break;
        }

    case 'remAuto':
        $smarty->assign('listeMemos', $Ades->listeMemos($user->acronyme()));
        $smarty->assign('acronyme', $acronyme);
        $smarty->assign('corpsPage', 'gestionMemos');
        break;
}
