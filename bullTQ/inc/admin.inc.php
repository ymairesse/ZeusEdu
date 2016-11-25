<?php

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$cours = isset($_POST['cours']) ? $_POST['cours'] : null;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;

switch ($mode) {
    case 'imagesCours':
        $listeImages = $BullTQ->imagesPngBranches(200);
        $smarty->assign('listeImages', $listeImages);
        $smarty->assign('corpsPage', 'imagesCours');
        break;

    case 'initialiser':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        if ($etape == 'confirmer') {
            $init = $BullTQ->init('CommentProfs');
            $init += $BullTQ->init('CotesCompetences');
            $init += $BullTQ->init('CotesGlobales');
            $init += $BullTQ->init('Mentions');
            $smarty->assign('message', array(
                'title' => 'Enregistrement',
                'texte' => "$init tables(s) vidée(s)",
                'urgence' => 'danger', )
                );
        } else {
                $smarty->assign('action', $action);
                $smarty->assign('mode', $mode);
                $smarty->assign('etape', 'confirmer');
                $smarty->assign('corpsPage', 'confirmInit');
            }
        break;

    case 'competences':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $listeNiveaux = array('5', '6');
        $smarty->assign('listeNiveaux', $listeNiveaux);
        if ($niveau) {
            $smarty->assign('niveau', $niveau);
            $listeCoursComp = $BullTQ->listeCoursNiveaux($niveau);
            $smarty->assign('listeCoursComp', $listeCoursComp);
        }
        if ($etape == 'enregistrer') {
            $nbResultats = $BullTQ->enregistrerCompetences($_POST);
            $smarty->assign('message', array(
                        'title' => 'Enregistrement',
                        'texte' => "$nbResultats compétence(s) modifiée(s)", ));
        }
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('cours', $cours);
        $listeCompetences = $BullTQ->listeCompetencesListeCours($cours);
        $smarty->assign('listeCompetences', $listeCompetences);
        $smarty->assign('corpsPage', 'adminCompetences');
        $smarty->assign('selecteur', 'selecteurs/selectNiveauCours');
        break;

    case 'typologie':
        if ($niveau != null) {
            if ($etape == 'enregistrer') {
                $nbResultats = $BullTQ->enregistrerTypes($_POST);
                $smarty->assign('message', array(
                        'title' => 'Enregistrement',
                        'texte' => "$nbResultats types(s) modifié(s)",
                        'urgence' => 'warning', ));
            }
            $listeCours = $BullTQ->listeCoursNiveaux($niveau);
            $listeCoursTypes = $BullTQ->listeTypes($listeCours);
            $smarty->assign('etape', 'enregistrer');
            $smarty->assign('listeCoursTypes', $listeCoursTypes);
            $smarty->assign('corpsPage', 'editTypesCours');
        }
        $smarty->assign('listeNiveaux', array('5', '6'));
        $smarty->assign('niveau', $niveau);
        $smarty->assign('selecteur', 'selecteurs/selectNiveau');
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        break;

    case 'titulaires':
        if (isset($niveau)) {
            $smarty->assign('listeProfs', $Ecole->listeProfs());
            $listeAcronymes = isset($_POST['listeAcronymes']) ? $_POST['listeAcronymes'] : null;
            switch ($etape) {
                case 'supprimer':
                    $nb = $Ecole->supprTitulariat($niveau, $listeAcronymes);
                    $smarty->assign('message', array(
                                'title' => 'Suppression',
                                'texte' => "$nb modification(s) enregistrée(s).", )
                                );
                    break;
                case 'ajouter':
                    $nb = $Ecole->addTitulariat($niveau, $listeAcronymes, 'TQ');
                    $smarty->assign('message', array(
                                'title' => 'Ajouts',
                                'texte' => "$nb modification(s) enregistrée(s).", )
                                );
                    break;
                }
            $listeTitus = $Ecole->titusDeGroupe($niveau);
            $smarty->assign('listeTitus', $listeTitus);
        }

        $smarty->assign('listeNiveaux', $Ecole->listeGroupes(array('TQ')));
        $smarty->assign('selecteur', 'selecteurs/selectNiveau');
        $smarty->assign('corpsPage', 'choixTitu');
        $smarty->assign('niveau', $niveau);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        break;
		
    case 'stages':
        require_once 'inc/stages.inc.php';
        break;

        break;
    default:
        break;
    }
