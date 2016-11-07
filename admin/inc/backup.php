<?php

switch ($mode) {
    case 'tables':
        if ($etape == 'Enregistrer') {
            $nb = $Application->saveLinkApplisTables($_POST);
            $smarty->assign('message', array(
                    'title' => SAVE,
                    'texte' => sprintf('%i enregistrements(s)', $nb),
                    'urgence' => 'success', )
                    );
        }
        $listeTablesEtApplis = $Application->listeTablesEtApplis();
        $listeToutesTables = $Application->listeTablesAvecChamp();
        $listeApplis = $Application->listeApplis();
        $listeApplis['all'] = array('nom' => 'all', 'nomLong' => 'Toutes', 'active' => 0);
        $listeApplis[''] = array('nom' => '', 'nomLong' => 'Aucune', 'active' => 0);

        $smarty->assign('listeToutesTables', $listeToutesTables);
        $smarty->assign('listeApplis', $listeApplis);
        $smarty->assign('listeAssocTablesEtApplis', $Application->listeAssocTablesApplis($listeToutesTables, $listeTablesEtApplis));
        $smarty->assign('mode', $mode);
        $smarty->assign('action', $action);
        $smarty->assign('etape', 'Enregistrer');
        $smarty->assign('corpsPage', 'dispatchTables');
        break;
    case 'save':
        $fileName = $Application->backupTables($_POST);
        $listeFichiers = $Application->scanDirectories('./save');
        $smarty->assign('listeFichiers', $listeFichiers);
        $smarty->assign('fileName', $fileName);
        $listeFichiers = $Application->scanDirectories('./save');
        $smarty->assign('listeFichiers', $listeFichiers);
        $smarty->assign('derniersConnectes', $Application->derniersConnectes(60));
        $smarty->assign('corpsPage', 'bilan');
        break;
    case 'choose':
        $listeToutesTables = $Application->listeTablesAvecChamp();
        $listeTables = $Application->listeTablesParAppli($listeToutesTables);
        $smarty->assign('listeTables', $Application->listeTablesParAppli($listeToutesTables));
        $smarty->assign('action', 'backup');
        $smarty->assign('mode', 'save');
        $smarty->assign('corpsPage', 'choixTables');
        break;
    case 'delete':
        $fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;
        $listeNomsFichiers = $Application->listeFichiers('./save');
        if (!(in_array($fileName, $listeNomsFichiers))) {
            die('invalid file name');
        }
        unlink('./save/'.$fileName);
        $smarty->assign('message', array(
            'title' => DELETE,
            'texte' => sprintf('Le fichier %s a été effacé', $fileName),
            'urgence' => 'warning', )
            );
        $smarty->assign('fileName', $fileName);
        $smarty->assign('confirmDeleteBU', 'confirmDelete');
        $listeFichiers = $Application->scanDirectories('./save');
        $smarty->assign('listeFichiers', $listeFichiers);
        $smarty->assign('derniersConnectes', $Application->derniersConnectes(60));
        $smarty->assign('corpsPage', 'bilan');
        break;
    default:
        // wtf
        break;
}
