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

$type = isset($_POST['type'])?$_POST['type']:Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

// tous les types de destinataires
// array avec, pour chaque type de destinataire "eleves", "classe", "coursGrp", "niveau", "cours", "ecole"
// le texte correspondant et les droits nécessaires pour accéder à ce type
// Exemple:
// 'ecole' =>
  // array (
  //   'droits' =>
  //   array (
  //     0 => 'admin',
  //     1 => 'direction',
  //   ),
  //   'texte' => 'Tous les élèves',
  // ),
$listeTypes = $Thot->getTypes();

// liste des accusés de lecture demandés par l'utilisateur courant
$listeAccuses = $Thot->getAccuses4user($acronyme, $type);
// Application::afficher($listeAccuses, true);

// lecture de toutes les notifications pour l'utilisateur courant
// ecole => ... niveau => ... classes => ... cours => ... eleves => ...
$listeNotifications = $Thot->listeUserNotification($acronyme, $type);


if ($listeNotifications != Null) {
    foreach ($listeNotifications as $type => $data){
        foreach ($data as $idNotif => $uneNotification){
            $destinataire = $uneNotification['destinataire'];
            $trueDestinataire = $Thot->getTrueDestinataire($type, $destinataire);
            $listeNotifications[$type][$idNotif]['trueDest'] = $trueDestinataire;
            }
        }
    }

// ------------------------------------------------------------------------------
// TRAITEMENT DES ACCUSÉS DE LECTURE
// la liste de toutes les notifications est ventilée par groupe destinataire
// recherche des détails par type de notification
$listeAttendus = Null;

foreach ($listeNotifications as $type => $lesNotifications) {
    // pour chaque notification du type actuel
    foreach ($lesNotifications as $notifId => $uneNotification) {
        // on voit si un accusé de lecture est demandé
        if ($uneNotification['accuse'] == 1) {
            $destinataire = $uneNotification['destinataire'];
            switch ($type) {
                case 'ecole':
                    // wtf : il n'y a pas d'accusé de lecture possible pour toute l'école
                    $listeAttendus[$notifId] = Null;
                    break;
                case 'niveau':
                    $listeAttendus[$notifId] = $Ecole->nbElevesNiveau($destinataire);
                    break;
                case 'cours':
                    $nb = count($Ecole->listeElevesMatiere($destinataire));
                    $listeAttendus[$notifId] = $nb;
                    break;
                case 'coursGrp':
                    // y compris les élèves "PARTI"s qui ont, peut-être, confirmé la lecture
                    $nb = count($Ecole->listeElevesCours($destinataire, Null, true));
                    $listeAttendus[$notifId] = $nb;
                    break;
                case 'classes':
                    $nb = count($Ecole->listeElevesClasse($destinataire));
                    $listeAttendus[$notifId] = $nb;
                    break;
                case 'groupe':
                    // À prévoir...
                    // $listeAttentdus[$type][$notifId] = ...;
                    break;
                case 'eleves':
                    $nb = 1;
                    $listeAttendus[$notifId] = $nb;
                    break;
                }
            }
        }
    }

// liste des accusés de lecture **reçus** pour le type donné
// array trié sur l'id de l'annonce contenant:
//  matricule de chaque élève pour une annonce
//  la date à laquelle l'annonce a été lue
$listeRecus = $Thot->getAccuses4user($acronyme, $type);

// liste des PJ liées aux notification du type donné (avec l'acronyme pour la sécurité)
if (isset($listeNotifications[$type]))
    $listePJ4type = $Thot->getPj4Notifs($listeNotifications[$type], $acronyme);
    else $listePJ4type = Null;

$HRtype = $Thot->getHRtitle4type($type);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('HRtype', $HRtype);
$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('listeAttendus', $listeAttendus);
$smarty->assign('listeRecus', $listeRecus);
$smarty->assign('listeNotifications', $listeNotifications);
$smarty->assign('listePJ', $listePJ4type);
$smarty->assign('listeTypes', $listeTypes);

$smarty->display('notification/details4type.tpl');
