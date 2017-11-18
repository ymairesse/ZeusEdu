<?php

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;

$listeNotifId = $Thot->enregistrerNotification($_POST);

// enregistrement et suppression éventuels des PJ
require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();
if (isset($_POST['files']) && count($_POST['files']) > 0) {
    // liaison des PJ existantes et suppression des PJ supprimées
    $nb = $Files->linkFilesNotifications($listeNotifId, $_POST, $acronyme);
    }
    else {
        // suppression des PJ encore existantes même si plus de PJ à l'annonce
        $nb = $Files->unlinkAllFiles4Notif($listeNotifId);
    }

// si des notifications ont été enregistrées
if (count($listeNotifId) > 0) {
    switch ($mode) {
        case 'coursGrp':
            $coursGrp = $_POST['destinataire'];
            $listeEleves = $Ecole->listeElevesCours($coursGrp);
            $destinataire = $coursGrp;
            break;
        case 'classes':
            $classe = $_POST['destinataire'];
            $listeEleves = $Ecole->listeElevesClasse($classe);
            $destinataire = $classe;
            break;
        case 'niveau':
            $niveau = $_POST['destinataire'];
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
}

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
        $nbAccuses = $Thot->setAccuse($listeNotifId, $matriculesSelect, 'eleves');
    } else {
        $nbAccuses = $Thot->setAccuse($listeNotifId, $matriculesTous,'groupe');
    }
    $texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s)", $nbAccuses);
    }

$smarty->assign('message', array(
        'title' => SAVE,
        'texte' => $texte,
        'urgence' => SUCCES, )
        );

require_once 'inc/notif/historique.inc.php';
