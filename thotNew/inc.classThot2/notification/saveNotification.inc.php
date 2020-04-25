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

require_once INSTALL_DIR.'/inc/classes/classThot2.inc.php';
$Thot = new Thot();

$formEdit = isset($_POST['formEdit']) ? $_POST['formEdit'] : null;
$formSelect = isset($_POST['formSelect']) ? $_POST['formSelect'] : null;
$formEd = array();
$formSel = array();
parse_str($formEdit, $formEd);
parse_str($formSelect, $formSel);

// Application::afficher(array($formEd, $formSel), true);


$formEd['texte'] = isset($_POST['texte']) ? $_POST['texte'] : Null;

// INFORMATIONS PROVENANT DU FORMULAIRE DE SÉLECTION
// le type de destinataire (classe, coursGrp, groupe, "tous", 'niveau', "matiere") est la cible
$notification['type'] = $formSel['type'];
// le groupe destinataire (Ex: 3A)
$notification['destinataire'] = $formSel['destinataire'];
// la notification est-elle destinée à tous les membres du groupe?
// Cela pourrait aussi être seulement quelques élèves
$notification['TOUS'] = isset($formSel['TOUS']) ? $formSel['TOUS'] : Null;
// est-ce une notification par élève dans le groupe?
$notification['eleve'] = ($formSel['TOUS'] != '') ? 0 : 1;
// le matricule de chacun des destinataires du message
// tous les élèves du groupe si TOUS ou quelques élèves
$notification['matricules'] = isset($formSel['matricules']) ? $formSel['matricules']: Null;

// INFORMATIONS PROVENANT DU FORMULAIRE D'ÉDITION
$notification['notifId'] = isset($formEd['notifId']) ? $formEd['notifId'] : Null;

$notification['objet'] = $formEd['objet'];
$notification['dateDebut'] = $formEd['dateDebut'] ;
$notification['dateFin'] = $formEd['dateFin'];
$notification['texte'] = $formEd['texte'];

// si les cases sont cochées, les champs suivants sont définis à la valeur 1
$notification['mail'] = isset($formEd['mail']) ? $formEd['mail'] : Null;
$notification['freeze'] = isset($formEd['freeze']) ? $formEd['freeze'] : Null;
$notification['accuse'] = isset($formEd['accuse']) ? $formEd['accuse'] : Null;
$notification['parent'] = isset($formEd['parent']) ? $formEd['parent'] : Null;
// les PJ, y compris répertoires et nom des fichiers
// Ex: 0 => '-1|//|/Informatique/info1/|//|autoevaluation.odt',
$notification['files'] = isset($formEd['files']) ? $formEd['files'] : Null;

// ----------- enregistrement effectif de la notification
// $listeNotifId[] parce que la fonction peut renvoyer les $notifId pour plusieurs élèves
$listeNotifId = $Thot->enregistrerNotification($notification, $acronyme);

// forme de ce tableau [ matricule => notifId ]
// Exemple:
// array (
//   7942 => '16248',
//   7938 => '16249',
// )

$texteAlert[] = sprintf('%d annonce(s) enregistrée(s)', count($listeNotifId));

// ------------------------------------------------------------------------------
// ok pour la notification en BD, passons éventuellement à l'envoi de mail
// si c'est une édition, le champ 'mail' est désactivé => !(isset)
// ------------------------------------------------------------------------------
if (isset($notification['mail']) && $notification['mail'] == 1) {
    // ------------------------------------------------------------------------------
    // recherche de la liste des élèves concernés (cas où un sous-ensemble est permis)
    // classe, coursGrp, groupe, niveau ou pour tous les élèves de l'ensemble
    // ------------------------------------------------------------------------------
    if ($notification['TOUS'] == 'TOUS') {
        // tous les élèves de l'entité ont été sélectionnés
        $destinataire = $notification['destinataire'];
        switch ($notification['type']) {
            // pour éviter la surcharge de la BD, pas d'accusé de lecture pour l'école entière
            case 'ecole':
                // wtf
                break;
            case 'niveau':
                $listeEleves = $Ecole->listeElevesNiveaux($destinataire);
                break;
            case 'classes':
                $listeEleves = $Ecole->listeElevesClasse($destinataire);
                break;
            case 'coursGrp':
                $listeEleves = $Ecole->listeElevesCours($destinataire);
                break;
            case 'groupe':
                $listeEleves = array_keys($Thot->getListeMembresGroupe($destinataire, $acronyme));
                break;
            }
        }
        else {
            // on ne prend que ceux dont les cases ont été cochées
            $listeEleves = array_flip($notification['matricules']);
        }

    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    // $listeMailing contient les informations détaillées sur tous les élèves de $listeEleves
    // y compris leur adresse mail
    $listeMailing = $Ecole->detailsDeListeEleves($listeEleves);

    $smarty->assign('THOTELEVE', THOTELEVE);
    $smarty->assign('ECOLE', ECOLE);
    $smarty->assign('VILLE', VILLE);
    $smarty->assign('ADRESSE', ADRESSE);
    $smarty->assign('objet', $notification['objet']);
    $objetMail = $smarty->fetch('notification/mail/objetMail.tpl');
    $texteMail = $smarty->fetch('notification/mail/texteMail.tpl');
    $signatureMail = $smarty->fetch('notification/mail/signatureMail.tpl');
    // la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
    $listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
    $texteAlert[] = sprintf('%d mail(s) envoyé(s)', count($listeEnvois));
}

// ------------------------------------------------------------------------------
// enregistrement et suppression éventuelles des PJ
// ------------------------------------------------------------------------------
require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// ------------------------------------------------------------------------------
// en cas d'édition, liste des PJ figurant dans cette notification, ventilée par $notifId
// pour une nouvelle notification, $listeOldShared revient comme un array vide
$listeOldShared = $Thot->getPj4Notifs(array_flip($listeNotifId), $acronyme);

// ------------------------------------------------------------------------------
// $notification['files'] est du type
// array (
//   0 => '4709|//|/trombiEleves/|//|1C7.PDF',
//   1 => '4711|//|/thot/|//|jdc_MAI_5 GT:INFO1-01.pdf',
// )
// et $listeOldShared est du type
// array (
//   16703 =>
//   array (
//     4709 =>
//     array (
//       'shareId' => '4709',
//       'path' => '/trombiEleves/',
//       'fileName' => '1C7.PDF',
//     ),
//     4711 =>
//     array (
//       'shareId' => '4711',
//       'path' => '/thot/',
//       'fileName' => 'jdc_MAI_5 GT:INFO1-01.pdf',
//     ),
//     4713 =>
//     array (
//       'shareId' => '4713',
//       'path' => '/thot/',
//       'fileName' => 'jdc_MAI_5 GT:INFO1-02.pdf',
//     ),
//   ),
// )
// ------------------------------------------------------------------------------

// Suppression des liens vers les fichiers *qui ne sont plus* liés
// par comparaison entre la situation avant édition ($listeOldShared)
// et la situation après ($notification['files'])
// ceci n'a lieu qu'en cas d'édition de la notification
if ($listeOldShared != Null) {
    // si c'est une édition, il n'y a qu'un seul $notifId dans $listeNotifId
    $notifId = reset($listeNotifId);
    $Files->unlinkNotShared($notification['files'], $listeOldShared, $notifId, $acronyme);
}


if ($notification['files'] != Null) {
    // rechercher les fileIds (éventuellement déjà existants) pour les PJ
    // si nécessaire, créer les enregistrements dans la table didac_thotFiles
    // à partir de ce moment, chaque fichier est connu par son fileId
    $listeFileIds = array_flip($Files->findFileId4FileList($notification['files'], $acronyme));

    $destinataires = ($notification['TOUS'] == 'TOUS') ? array('all') : $notification['matricules'];

    // recherche des fichiers déjà partagés dans la liste des fileId's de la notification
    // le partage doit concerner les mêmes destinataires, sinon le fichier est partagé une nouvelle fois
    // le array obtenu est du type suivant: $liste[$fileId][] = $shareId
    $listeAlreadyShared = $Files->getAlreadySharedFiles($listeFileIds, $notification['type'], $notification['destinataire'], $destinataires);

    $commentaire = sprintf('Document lié à une annonce du %s', $notification['dateDebut']);

    // attribuer des shareIds aux fileIds encore dépourvus
    $listeAllShared = $Files->addUnshared($listeAlreadyShared, $notification['type'], $notification['destinataire'], $destinataires, $commentaire);

    // liaison des PJ existantes avec redistribution aux destinataires
    foreach ($listeNotifId AS $matricule => $notifId) {
        foreach ($listeAllShared AS $fileId => $listeDestinatairesShares) {
            foreach($listeDestinatairesShares AS $destinataire => $shareId){
                // on attribue le fichier $shareId à un élève (par son matricule) ou à tout le groupe ('all')
                if (($destinataire == $matricule) || ($destinataire == 'all'))
                    $Files->linkNotifPJ($notifId, $shareId);
                }
            }
        }

    $texteAlert[] .= sprintf('%d pièce(s) jointe(s)', count($notification['files']));
    }

echo implode('<br>', $texteAlert);
