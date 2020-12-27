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

// Application::afficher(array($form, $type), true);

// le "type" est soit le groupe (envoi à tout le groupe),
// soit "eleves" pour l'envoi au détail
// le "type" passé en paramètre hors formulaire est toujours correctement ciblé
// alors que le "type" déclaré dans le formulaire est toujours le groupe (classe, coursGrp,...)
// les deux informations sont nécessaires
$type = isset($_POST['type']) ? $_POST['type'] : null;

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
    // toutes les informations viennent du formulaire et c'est une nouvelle notification
    $notification = $form;
    }

// ----------- enregistrement effectif de la notification
// $listeNotifId parce que la fonction peut renvoyer les $notifId pour plusieurs élèves
// la liste des $notifIds revient avec un tableau des  $destinataire => $notifId
// ------------------------------------------------------------------------------
$listeNotifId = $Thot->saveNotification($notification, $type, $acronyme);

$texte[] = sprintf('%d annonce(s) enregistrée(s)', count($listeNotifId));


// **************** détermination du détail de la liste des élèves concernés par l'annonce
// en vue d'envoi de mail ou d'accusé de lecture
// rappel: les annonces à école, niveau et matière ne permettent pas l'envoi de mail
// les éditions ne permettent pas non plus mail ou accusés de lecture
// et de demande d'accusé de lecture => wtf
$listeEleves = Null;

// $form['leType'] == 'eleves' si l'envoi est élève par élève, même si
// form['type'] == 'classes', par exemple
switch ($form['leType']) {  // ici, il faut prendre le type "global" corrigé pour éleves isolés
    case 'eleves':
        $membres = $form['membres'];
        $listeEleves = array_flip(array_values($membres));
        break;
    case 'classes':
        $listeEleves = $Ecole->listeElevesClasse($form['destinataire']);
        break;
    case 'coursGrp':
        $listeEleves = $Ecole->listeElevesCours($form['destinataire']);
        break;
    case 'cours':
        $listeEleves = $Ecole->listeElevesMatiere ($form['destinataire']);
        break;
    case 'groupe':
        $listeEleves = Null;  // prévoir la procédure pour les groupes arbitraires
        break;
    case 'profsCours':
        $listeEleves = $Ecole->listeElevesCours($form['destinataire']);
        break;
    default:
        // wtf
        // pas de liste particulière pour les autres types
        break;
    }

// ------------------------------------------------------------------------------
// ok pour la notification en BD, passons éventuellement à l'envoi de mail aux élèves
// si c'est une édition, le champ 'mail' est désactivé => !(isset)
// ------------------------------------------------------------------------------

// identification de l'expéditeur
$identite = $User->identiteProf($acronyme);
$formule = ($identite['sexe'] == 'M') ? 'Monsieur' : 'Madame';
$initiale = mb_substr($identite['prenom'], 0, 1);
$nomProf = sprintf('%s %s. %s', $formule, $initiale, $identite['nom']);

if (isset($form['mail']) && $form['mail'] == 1) {
    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    $listeMailing = $Ecole->detailsDeListeEleves($listeEleves);

    // la "key" de la liste $listeMailing contient les matricules
    if ($form['parent'] == 1){
        $listeMailing = $Thot->addParentMailing($listeMailing);
    }

    $smarty->assign('THOTELEVE', THOTELEVE);
    $smarty->assign('ECOLE', ECOLE);
    $smarty->assign('VILLE', VILLE);
    $smarty->assign('ADRESSE', ADRESSE);
    $smarty->assign('objet', $form['objet']);
    $smarty->assign('nomProf', $nomProf);
    $objetMail = $smarty->fetch('notification/objetMail.tpl');
    $texteMail = $smarty->fetch('notification/texteMail.tpl');
    $signatureMail = $smarty->fetch('notification/signatureMail.tpl');
    // la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
    $listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
    $texte[] = sprintf('%d mail(s) envoyé(s)', count($listeEnvois));
}

// ------------------------------------------------------------------------------
// voyons si un accusé de lecture est souhaité
// si c'est une édition, le champ 'accuse' est désactivé => !(isset)
// ------------------------------------------------------------------------------
if (isset($form['accuse']) && $form['accuse'] == 1) {
    // pour les élèves contactés séparément, chacun a une $notifId
    if ($type == 'eleves') {
        // la liste des élèves qui doivent accuser lecture est dans $listeNotifId
        $nbAccuses = $Thot->setAccuse($listeNotifId);
        }
        else {
            // sinon, la même annonce $notifId pour tous
            $notifId = current($listeNotifId);
            $nbAccuses = $Thot->setAccuse($notifId, array_keys($listeEleves));
        }
    $texte[] = sprintf("%d demande(s) d'accusé de lecture envoyée(s)", $nbAccuses);
    }

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// ------------------------------------------------------------------------------
// enregistrement et suppression éventuelles des PJ
// ------------------------------------------------------------------------------
if (isset($form['files']) && count($form['files']) > 0) {
    // liaison des PJ existantes et suppression des PJ supprimées
    $nb = $Files->linkFilesNotifications($listeNotifId, $form, $acronyme);
    $texte[] = sprintf('%d pièce(s) jointe(s)', count($form['files']));
    }
    else {
        // toutes les pièces jointes ont été enlevées
        // suppression en BD des PJ encore existantes si plus de PJ à l'annonce
        // inversion key => value du tableau des $listeNotifId (on a besoin des $notifId seulement)
        $listeNotifId = array_flip($listeNotifId);
        $nb = $Files->unlinkAllFiles4Notif($listeNotifId, $acronyme);
        if ($nb > 0)
            $texte[] = sprintf('%d pièce(s) jointe(s) supprimées', $nb);
    }

$texte = implode('<br>', $texte);

echo json_encode(array('texte' => $texte, 'listeNotifId' => $listeNotifId));
