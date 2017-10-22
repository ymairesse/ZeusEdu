<?php

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;

switch ($etape) {
    case 'showClasse':
        // la classe a été choisie dans le sélecteur; on prépare un formulaire pour la classe "$classe"
        if ($classe != null) {
            $listeEleves = $Ecole->listeElevesClasse($classe);
            $smarty->assign('listeEleves', $listeEleves);
            $notification = $Thot->newNotification('classes', $user->acronyme(), $classe);
            $smarty->assign('notification', $notification);

            $smarty->assign('corpsPage', 'notification/formNotification');
        }
        break;

    case 'enregistrer':
        // enregistrement de la notification avec retour de la liste des identifiants correspondants
        // il peut y avoir plusieurs identifiants quand plusieurs destinataires "élèves" dans la classe
        $listeId = $Thot->enregistrerNotification($_POST);
        // enregistrement éventuel des PJ
        if (isset($_POST['files']) && count($_POST['files']) > 0) {
            require_once INSTALL_DIR.'/inc/classes/class.Files.php';
            $Files = new Files();
            $nbPJ = $Files->linkFilesNotifications($listeId, $_POST);
            }

        // si des notifications ont été enregistrées
        if (count($listeId) > 0) {
            // liste de tous les élèves de la classe indexée sur le matricule
            $listeEleves = $Ecole->listeElevesClasse($classe);
            $smarty->assign('listeEleves', $listeEleves);

            // liste des matricules de tous les élèves de la classe
            $matriculesTous = array_keys($listeEleves);
            // $matriculesSelect = liste de tous les élèves *sélectionnés* dans la classe (array_flip pour prendre les matricules)
            $matriculesSelect = isset($_POST['membres']) ? array_flip($_POST['membres']) : null;
            $smarty->assign('listeMatricules', $matriculesSelect);

            // si pas d'élèves sélectionnés séparément, la notification concerne l'ensemble de la classe.
            // sinon, on change le type
            $type = (count($matriculesSelect) != 0) ? 'eleves' : 'classes';

            $nbEleves = ($type == 'eleves') ? count($matriculesSelect) : count($matriculesTous);
            $texte = sprintf('%d notification(s) aux élèves de la classe %s enregistrée(s)', $nbEleves, $classe);

            // ok pour la notification en BD, passons éventuellement à l'envoi de mail
            if (isset($_POST['mail']) && $_POST['mail'] == 1) {
                if ($_POST['type'] == 'eleves') {
                    // quelques élèves
                    // retrouver les détails pour les élèves sélectionnés
                    $listeElevesSelect = $Ecole->detailsDeListeEleves($matriculesSelect);
                    $listeMailing = $Ecole->detailsDeListeEleves($listeElevesSelect);
                } else {
                    // toute la classe
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
                // la demande d'accusé de lecture a été postée pour l'ensemble d'un groupe?
                if (($_POST['type'] == 'ecole') || ($_POST['type'] == 'niveau') || (isset($_POST['TOUS']))) {
                    $nbAccuses = $Thot->setAccuse($listeId, $matriculesTous, 'groupe');
                } else {
                    // ou pour des élèves isolés
                    $nbAccuses = $Thot->setAccuse($listeId, $matriculesSelect, 'eleves');
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
            $notification['type'] = 'classes';
            $notification['destinataire'] = $classe;
            $smarty->assign('type', 'classes');

            $smarty->assign('notification', $notification);
            $smarty->assign('corpsPage', 'notification/syntheseNotification');
        }
            break;
        default:
            $notification = null;
            break;
        }

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

// informations pour le sélecteur 'selectClasse'
$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('classe', $classe);
$smarty->assign('selecteur', 'selecteurs/selectClassePOST');
