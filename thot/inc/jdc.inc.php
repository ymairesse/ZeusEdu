<?php

require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$jdc = new Jdc();

// type de JDC par classe ou par cours?
$type = isset($_POST['type']) ? $_POST['type'] : null;
// pour le jdc par élève
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
// pour le jdc par classe (titulaire)
$classe = $Application->postOrCookie('classe', $unAn);
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
// pour le jdc par cours
$coursGrp = $Application->postOrCookie('coursGrp', $unAn);
// $coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;

$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : null;

$listeCours = $user->listeCoursProf();

switch ($mode) {
   case 'delete':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        $verifId = $jdc->verifIdProprio($id, $acronyme);
        if ($id == $verifId) {
            $nb = $jdc->deleteJdc($id);
        } else {
            die('Ce journal de classe ne vous appartient pas');
        }
        $message = array(
            'title' => DELETE,
            'texte' => sprintf('%d enregistrement supprimé', $nb),
            'urgence' => $nb = 1 ? 'success' : 'warning',
            );
        switch ($type) {
            case 'classe':
                $smarty->assign('mode', 'classe');
                $smarty->assign('editable', true);
                $smarty->assign('classe', $classe);
                $listeClasses = $user->listeTitulariats();
                $smarty->assign('listeClasses', $listeClasses);
                $smarty->assign('selecteur', 'selecteurs/selectClassePOST');
                break;
            case 'cours':
                $smarty->assign('mode', 'cours');
                $smarty->assign('coursGrp', $coursGrp);  // pour le sélecteur
                $smarty->assign('editable', true);
                $smarty->assign('selecteur', 'selecteurs/selectCoursPOST');
                break;
            case 'eleves':
                $smarty->assign('mode', 'eleves');
                $smarty->assign('classe', $classe);
                $smarty->assign('matricule', $matricule);
                $smarty->assign('listeEleves', $listeEleves);
                $smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');
                break;
            }
        $smarty->assign('message', $message);
        $smarty->assign('type', $type);
        $smarty->assign('corpsPage', 'jdc');
        break;

    case 'save':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        // est-ce une mise à jour d'un enregistrement existant?
        if ($id != null) {
            $verifId = $jdc->verifIdProprio($id, $acronyme);
            if ($id == $verifId) {
                $nb = $jdc->saveJdc($_POST, $acronyme);
            } else {
                die('Ce journal de classe ne vous appartient pas');
            }
        }
            // ou est-ce une nouvelle notification? // alors, on n'a pas encore d'id
            else {
                // on récupère l'id de l'enregistrement qui est renvoyé par la procédure
                $id = $jdc->saveJdc($_POST, $acronyme);
                $nb = ($id != null) ? 1 : 0;
            }

        $message = array(
            'title' => SAVE,
            'texte' => sprintf('%d enregistrement effectué', $nb),
            'urgence' => $nb = 1 ? 'success' : 'warning',
            );
        $smarty->assign('message', $message);

        if ($id != null) {
            $smarty->assign('acronyme', $acronyme);
            $smarty->assign('action', 'jdc');
            $travail = $jdc->getTravail($id);

            $smarty->assign('travail', $travail);

            $startDate = $travail['startDate'].' 00:00';
            $smarty->assign('startDate', $startDate);
            if ($travail['type'] == 'cours') {
                $smarty->assign('type', 'coursGrp');
                $coursGrp = $travail['destinataire'];
                $smarty->assign('coursGrp', $coursGrp);

                $smarty->assign('mode', 'cours');
                $smarty->assign('editable', true);

                $smarty->assign('selecteur', 'selecteurs/selectCoursPOST');
                $lblDestinataire = $jdc->denomination($listeCours, $travail['type'], $coursGrp);
                if ($lblDestinataire != Null) {
                    $smarty->assign('lblDestinataire', $lblDestinataire);
                    $smarty->assign('corpsPage', 'jdc');
                    }
            } elseif ($travail['type'] == 'classe') {
                $smarty->assign('type', 'classe');
                $classe = $travail['destinataire'];

                $listeClasses = $user->listeTitulariats();
                $smarty->assign('listeClasses', $listeClasses);
                $smarty->assign('classe', $classe);
                $smarty->assign('mode', 'classe');
                $smarty->assign('selecteur', 'selecteurs/selectClassePOST');
                $lblDestinataire = $jdc->denomination(null, $travail['type'], $classe);
                if ($lblDestinataire != Null)
                    $smarty->assign('lblDestinataire', $lblDestinataire);
                    $smarty->assign('corpsPage', 'jdc');
                    }
            }
        break;

    case 'cours':
        $smarty->assign('type', 'cours');
        $smarty->assign('coursGrp', $coursGrp);  // pour le sélecteur
        $smarty->assign('editable', true);
        $smarty->assign('selecteur', 'selecteurs/selectCoursPOST');
        $lblDestinataire =  $jdc->denomination($listeCours, $mode, $coursGrp);
        if ($lblDestinataire != Null) {
          $smarty->assign('lblDestinataire', $lblDestinataire);
          $smarty->assign('corpsPage', 'jdc');
        }
        break;

    case 'classe':
        $smarty->assign('type', 'classe');
        $listeClasses = $user->listeTitulariats();
        // le contenu du Cookie doit correspondre à une classe dont le prof est titulaire
        // sinon, on annule la classe
        if (!in_array($classe, $listeClasses))
          $classe = Null;
        setcookie('classe', $classe, $unAn, '/', null, false, true);
        $smarty->assign('classe', $classe);  // pour le sélecteur
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('editable', true);
        $smarty->assign('selecteur', 'selecteurs/selectClassePOST');

        $lblDestinataire =  $jdc->denomination($listeCours, $mode, $classe);
        if ($lblDestinataire != Null) {
          $smarty->assign('lblDestinataire', $lblDestinataire);
          $smarty->assign('corpsPage', 'jdc');
          }
        break;

    case 'eleves':
        // **consulter** le jdc d'un élève en particulier
        $smarty->assign('type', 'eleves');
        if (in_array($userStatus, array('educ', 'admin', 'direction'))) {
            $listeClasses = $Ecole->listeClasses();
        } else {
            $listeClasses = $Ecole->listeClassesProf($acronyme);
        }
        $smarty->assign('listeClasses', $listeClasses);

        $listeEleves = ($classe != null) ? $Ecole->listeEleves($classe, 'groupe') : null;

        if (isset($matricule) && in_array($matricule, array_keys($listeEleves))) {
            $eleve = $listeEleves[$matricule];
            $classeNomPrenom = sprintf('%s %s de %s', $eleve['prenom'], $eleve['nom'], $eleve['classe']);
        } else {
            $classeNomPrenom = null;
            $matricule = Null;
        }

        $smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');

        if ($classeNomPrenom != Null) {
            $smarty->assign('lblDestinataire', $classeNomPrenom);
            $smarty->assign('corpsPage', 'jdc');
            }
        break;

    default:
        // wtf
        break;
    }

$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);
$smarty->assign('legendeCouleurs', $jdc->categoriesTravaux());
$smarty->assign('startDate', $startDate);
