<?php

$mode = isset($_GET['mode']) ? $_GET['mode'] : Null;
if ($mode == Null)
    $mode = isset($_POST['mode']) ? $_POST['mode'] : Null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : Null;

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('etape', $etape);

// préparation des sélecteurs
switch ($mode) {
    case 'coursGrp':
        $coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
        $smarty->assign('listeCours', $user->listeCoursProf());
        $smarty->assign('coursGrp', $coursGrp);
        $smarty->assign('selecteur', 'selecteurs/selectCoursPOST');
        break;
    case 'classes':
        $classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
        $smarty->assign('listeClasses', $Ecole->listeGroupes());
        $smarty->assign('classe', $classe);
        $smarty->assign('selecteur', 'selecteurs/selectClassePOST');
        break;
    case 'niveau':
        $niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
        $smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
        $smarty->assign('niveau', $niveau);
        $smarty->assign('selecteur', 'selecteurs/selectNiveau');
        break;
    case 'ecole':
        // on passe de suite à l'étape suivante
        break;
    }

switch ($etape) {
    case 'enregistrer':
        // enregistrement de la notification avec retour de la liste des identifiants correspondants
        // il peut y avoir plusieurs identifiants quand plusieurs destinataires "élèves" dans le cours ou la classe

        $listeId = $Thot->enregistrerNotification($_POST);
        // enregistrement éventuel des PJ
        if (isset($_POST['files']) && count($_POST['files']) > 0) {
            require_once INSTALL_DIR.'/inc/classes/class.Files.php';
            $Files = new Files();
            $nb = $Files->linkFilesNotifications($listeId, $_POST);
            }

        // si des notifications ont été enregistrées
        if (count($listeId) > 0) {
            switch ($mode) {
                case 'coursGrp':
                    $listeEleves = $Ecole->listeElevesCours($coursGrp);
                    $destinataire = $coursGrp;
                    break;
                case 'classes':
                    $listeEleves = $Ecole->listeElevesClasse($classe);
                    $destinataire = $classe;
                    break;
                case 'niveau':
                    $listeEleves = $Ecole->listeElevesNiveaux($niveau);
                    $destinataire = $niveau;
                    break;
                case 'ecole':
                    $listeEleves = $Ecole->listeElevesEcole();
                    $destinataire = 'ecole';
                    break;
                }
            $smarty->assign('listeEleves', $listeEleves);

            // seulement certains élèves ont été sélectionnés dans le groupe ou la classe?
            $matriculesSelect = isset($_POST['membres']) ? array_flip($_POST['membres']) : null;
            $smarty->assign('listeMatricules', $matriculesSelect);

            $matriculesTous = array_keys($listeEleves);
            $nbEleves = ($mode == 'eleves') ? count($matriculesSelect) : count($matriculesTous);
            $texte = sprintf('Notification aux %d élèves enregistrée', $nbEleves);

            // si seulement certains élèves ont été sélectionnés, on change le $mode => eleves
            $memory = $mode;
            $mode = (count($matriculesSelect) != 0) ? 'eleves' : $mode;

            // ok pour la notification en BD, passons éventuellement à l'envoi de mail
            if (isset($_POST['mail']) && $_POST['mail'] == 1) {
                if (!(isset($_POST['TOUS']))) {
                    // quelques élèves
                    // retrouver les détails pour les élèves sélectionnés
                    $listeElevesSelect = $Ecole->detailsDeListeEleves($matriculesSelect);
                    $listeMailing = $Ecole->detailsDeListeEleves($listeElevesSelect);
                } else {
                    // tous les élèves du coursGrp
                    // $listeEleves contient les données principales élèves indexées sur le matricule
                    $listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
                }

                $smarty->assign('THOTELEVE', THOTELEVE);
                $smarty->assign('ECOLE', ECOLE);
                $smarty->assign('VILLE', VILLE);
                $smarty->assign('ADRESSE', ADRESSE);
                $objetMail = $smarty->fetch('templates/notification/objetMail.tpl');
                $texteMail = $smarty->fetch('templates/notification/texteMail.tpl');
                $signatureMail = $smarty->fetch('templates/notification/signatureMail.tpl');
                // la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
                $listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
                $nbMails = count($listeEnvois);
                $texte .= sprintf('<br> %d mails envoyés', $nbMails);
            }

            // voyons si un accusé de lecture est souhaité
            if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
                if ($_POST['type'] == 'eleves') {
                    $nbAccuses = $Thot->setAccuse($listeId, $matriculesSelect, 'eleves');
                } else {
                    $nbAccuses = $Thot->setAccuse($listeId, $matriculesTous,'groupe');
                }
                $texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s)", $nbAccuses);
            }

            $smarty->assign('message', array(
                    'title' => SAVE,
                    'texte' => $texte,
                    'urgence' => SUCCES, )
                    );

            $notification = $_POST;
            // remise en état de "$notification" si des élèves particuliers avaient été sélectionnés
            $notification['type'] = $memory;
            $notification['destinataire'] = $destinataire;
            $smarty->assign('type', $memory);

            $smarty->assign('notification', $notification);
            $smarty->assign('corpsPage', 'notification/syntheseNotification');
            }
            break;

        default:
            switch ($mode) {
                case 'coursGrp':
                    $listeEleves = $Ecole->listeElevesCours($coursGrp);
                    $notification = $Thot->newNotification('coursGrp', $user->acronyme(), $coursGrp);
                    break;
                case 'classes':
                    $listeEleves = $Ecole->listeElevesClasse($classe);
                    $notification = $Thot->newNotification('classes', $user->acronyme(), $classe);
                    break;
                case 'niveau':
                    $listeEleves = Null; // pas de sélection d'élève possible
                    $notification = $Thot->newNotification('niveau', $user->acronyme(), $niveau);
                    break;
                case 'ecole':
                    $listeEleves = Null; // pas de sélection d'élève possible
                    $notification = $Thot->newNotification('ecole', $user->acronyme(), 'ecole');
                    break;
                }
            $smarty->assign('listeEleves', $listeEleves);
            $smarty->assign('notification', $notification);
            $smarty->assign('corpsPage', 'notification/formNotification');
            break;
        }
