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

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

$type = isset($_POST['type']) ? $_POST['type'] : null;
// la liste $listeNotifId arrive avec un ou pluisuers couples
// destinataire -> notifId
$listeNotifId = isset($_POST['listeNotifId']) ? $_POST['listeNotifId'] : Null;
// inversion key => value et on ne conserve que les keys
$listeNotifId = array_keys(array_flip($listeNotifId));

// lecture de toutes les notifications pour l'utilisateur courant
// mais seulement pour le type qui doit être rafraîchit
$listeNotifications = $Thot->listeUserNotification($acronyme, $type);

// liste des pièces jointes liées à toutes les notifications
$listePJ = $Thot->getPJ4ListeNotifications(array_keys($listeNotifications));

// liste des accusés de lecture demandés par l'utilisateur courant pour le type de destinataire
$listeAccuses = $Thot->getAccuses4user($acronyme, $type);

// liste des accusés de réception éventuellement attendus (liste d'élèves d'une classe, par exemple)
$listeAttendus = array();

foreach ($listeNotifications as $notifId => $uneNotification) {
    // les accusés de lecture
    if ($uneNotification['accuse'] == 1) {
        $destinataire = $uneNotification['destinataire'];
        switch ($type) {
            case 'ecole':
                // wtf : il n'y a pas d'accusé de lecture possible pour toute l'école
                break;
            case 'niveau':
                $listeAttendus[$type][$notifId] = $Ecole->nbEleves($destinataire);
                break;
            case 'cours':
                $nb = count($Ecole->listeElevesMatiere($destinataire));
                $listeAttendus[$type][$notifId] = $nb;
                break;
            case 'coursGrp':
                $nb = count($Ecole->listeElevesCours($destinataire));
                $listeAttendus[$type][$notifId] = $nb;
                break;
            case 'classes':
                $nb = count($Ecole->listeElevesClasse($destinataire));
                $listeAttendus[$type][$notifId] = $nb;
                break;
            case 'groupe':
                // À prévoir...
                // $listeAttentdus[$type][$notifId] = ...;
                break;
            case 'eleves':
                $nb = 1;
                $listeAttendus[$type][$notifId] = $nb;
                break;
            }
        }
    }

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('liste', $listeNotifications);
$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('listeAttendus', $listeAttendus);
$smarty->assign('listePJ', $listePJ);
$smarty->assign('type', $type);
$smarty->assign('listeNotifId', $listeNotifId);

$smarty->display('notification/edit/notification4Type.tpl');
