<?php

require_once 'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$listeCategories = $Forum->getListeCategories();
$smarty->assign('listeCategories', $listeCategories);

switch ($mode) {
    case 'categories':

        $sujetsAbonnes = $Forum->getSubjects4Abonne($acronyme);
        $smarty->assign('sujetsAbonnes', $sujetsAbonnes);

        $sujetsAmoi = $Forum->getSubject4proprio($acronyme);
        $smarty->assign('sujetsAmoi', $sujetsAmoi);

        $smarty->assign('corpsPage', 'forum/index');
        break;

    case 'gestion':
        $listeAbonnements = $Forum->getListeAbonnements($acronyme);
        $listeCategories = array();
        foreach ($listeAbonnements as $idCategorie => $data) {
            $listeCategories[$idCategorie] = $Forum->getInfoCategorie($idCategorie);
        }

        $smarty->assign('listeAbonnements', $listeAbonnements);
        $smarty->assign('listeCategories', $listeCategories);
        $smarty->assign('corpsPage', 'forum/gestAbonnements');
        break;

}
