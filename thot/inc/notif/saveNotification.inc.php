<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$listeEleves = Null;

// si c'est une édition (le $id est déjà défini)
// il suffit de récupérer ce $id, les dates de début et de fin, l'objet et le texte du formulaire
// et déposer le tout dans la notification originale en remplacement des infos qui y figurent
if ($form['id'] != '') {
    $notification = $Thot->getNotification($form['id'], $acronyme);  // $acronyme pour la sécurité
    $notification['objet'] = $form['objet'];
    $notification['dateDebut'] = $form['dateDebut'] ;
    $notification['dateFin'] = $form['dateFin'];
    $notification['texte'] = $form['texte'];
    }
else {
    // toutes les informations viennent du formulaire
    $notification = $form;
    // établir la liste des élèves concernés
    switch ($form['type']) {
        case 'classes':
            // si TOUS est sélectionné, la liste de tous les élèves de la classe, sinon seulement les élèves sélectionnés
            $listeEleves = isset($form['TOUS']) ? $Ecole->listeElevesClasse($form['destinataire']) : array_flip($form['membres']);
            break;
        case 'coursGrp':
            // si TOUS est sélectionné, la liste de tous les élèves du cours, sinon seulement les élèves sélectionnés
            $listeEleves = isset($form['TOUS']) ? $Ecole->listeElevesCours($form['destinataire']) : array_flip($form['membres']);
            break;
        case 'groupe':
            // prévoir ici la recherche des élèves membres d'un "groupe"
            // prévoir ici la recherche des élèves membres d'un "groupe"
            $listeEleves = Null;
            // prévoir ici la recherche des élèves membres d'un "groupe"
            // prévoir ici la recherche des élèves membres d'un "groupe"
            break;
    }
}

// ----------- enregistrement effectif de la notification
// $listeNotifId parce que la fonction peut renvoyer les $notifId pour plusieurs élèves
$listeNotifId = $Thot->enregistrerNotification($notification, $acronyme);
$texte[] = sprintf('%d annonce(s) enregistrée(s)', count($listeNotifId));

// ------------------------------------------------------------------------------
// ok pour la notification en BD, passons éventuellement à l'envoi de mail
// si c'est une édition, le champ 'mail' est désactivé => !(isset)
if (isset($form['mail']) && $form['mail'] == 1) {
    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    $listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
    $smarty->assign('THOTELEVE', THOTELEVE);
    $smarty->assign('ECOLE', ECOLE);
    $smarty->assign('VILLE', VILLE);
    $smarty->assign('ADRESSE', ADRESSE);
    $smarty->assign('objet', $form['objet']);
    $objetMail = $smarty->fetch('notification/objetMail.tpl');
    $texteMail = $smarty->fetch('notification/texteMail.tpl');
    $signatureMail = $smarty->fetch('notification/signatureMail.tpl');
    // la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
    $listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
    $texte[] = sprintf('%d mail(s) envoyé(s)', count($listeEnvois));
}
// Application::afficher($form);

// ------------------------------------------------------------------------------
// voyons si un accusé de lecture est souhaité
// si c'est une édition, le champ 'accuse' est désactivé => !(isset)
if (isset($form['accuse']) && $form['accuse'] == 1) {
    if (isset($form['TOUS'])) {
        // la même annonce $id pour tous
        $notifId = current($listeNotifId);
        $nbAccuses = $Thot->setAccuse($notifId, array_keys($listeEleves));
        }
        else {
            // la liste des élèves qui doivent accuser lecture est dans $listeNotifId
            $nbAccuses = $Thot->setAccuse($listeNotifId);
        }
    $texte[] = sprintf("%d demande(s) d'accusé de lecture envoyée(s)", $nbAccuses);
    }

// ------------------------------------------------------------------------------
// enregistrement et suppression éventuelles des PJ
require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();
if (isset($form['files']) && count($form['files']) > 0) {
    // liaison des PJ existantes et suppression des PJ supprimées
    $nb = $Files->linkFilesNotifications($listeNotifId, $form, $acronyme);
    $texte[] .= sprintf('%d pièce(s) jointe(s)', count($form['files']));
    }
    else {
        // suppression des PJ encore existantes si plus de PJ à l'annonce
        $nb = $Files->unlinkAllFiles4Notif($listeNotifId);
    }

echo implode('<br>', $texte);
