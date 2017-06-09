<?php

    $idfait = isset($_REQUEST['idfait']) ? $_REQUEST['idfait'] : null;
    $type = isset($_REQUEST['type']) ? $_REQUEST['type'] : null;
    switch ($mode) {
    case 'delete':
        if ($idfait != null) {
            $nb = $ficheDisc->supprFait($idfait);
            $smarty->assign('message', array(
            'title' => DELETE,
            'texte' => sprintf("Effacement de: %d fait(s)",$nb),
            'urgence' => 'danger', ));
            $ficheDisc->relireFaitsDisciplinaires($matricule);
            $afficherEleve = true;
        }
        break;

    case 'edit':
        // if (isset($idfait)) {
        //     // on ne vient pas du case 'new', il faut assigner le $fait et le $type
        //     $fait = $ficheDisc->lireUnFait($idfait);
        //     $smarty->assign('fait', $fait);
        //     $type = $fait['type'];
        //     $smarty->assign('type', $type);
        // }
        //
        // // liste nécessaire pour obtenir une liste des profs à l'origine du signalement du fait
        // $smarty->assign('listeProfs', $Ecole->listeProfs(false));
        // // acronyme de l'utilisateur pour indiquer qui a pris note du fait
        // $smarty->assign('acronyme', $user->acronyme());
        //
        // $prototype = $Ades->prototypeFait($type);
        // $smarty->assign('prototype', $prototype);
        // $listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);
        // $smarty->assign('listeRetenues', $listeRetenues);
        // $smarty->assign('listeMemos', $Ades->listeMemos($user->acronyme()));
        //
        // $smarty->assign('action', $action);
        // $smarty->assign('mode', 'enregistrer');
        // $smarty->assign('classe', $classe);
        // $smarty->assign('matricule', $matricule);
        // $smarty->assign('corpsPage', 'editFaitDisciplinaire');
        break;
    case 'enregistrer':
        $type = isset($_POST['type']) ? $_POST['type'] : null;

        $oldIdretenue = isset($_POST['oldIdretenue']) ? $_POST['oldIdretenue'] : null;
        // quand c'est une retenue et qu'il s'agit d'une édition, un problème peut se poser.
        // si la date de retenue n'est plus disponible (elle est cachée), on ne peut plus la sélectionner
        // la valeur de "oldIdretenue" est l'identifiant de la retenue avant édition.
        // si la date n'est pas modifiée, on remet gentiment "oldIdretenue" à la place de "idretenue"
        $idretenue = (isset($_POST['idretenue']) && $_POST['idretenue'] != '') ? $_POST['idretenue'] : $oldIdretenue;
        $prototype = $Ades->prototypeFait($type);

        // si c'est une retenue, on retrouve les détails (date, local,...) de celle-ci dans la BD
        $retenue = ($prototype['structure']['typeRetenue'] != 0) ? $Ades->detailsRetenue($idretenue) : null;
        $nb = $ficheDisc->enregistrerFaitDisc($_POST, $prototype, $retenue, $acronyme);
        $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => sprintf('Enregistrement de: %d fait',$nb),
            'urgence' => 'success' ));
		$smarty->assign('matricule',$matricule);
		$smarty->assign('classe',$classe);
		$smarty->assign('action','');

        $ficheDisc->relireFaitsDisciplinaires($matricule);
		$smarty->assign('selecteur','selecteurs/selectClasseEleve');
        $afficherEleve = true;
        break;
    }
