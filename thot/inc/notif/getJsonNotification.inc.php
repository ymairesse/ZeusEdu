<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    // echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    echo json_encode(array('erreur' => true));
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : Null;

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$Thot = new Thot();
$notification = $Thot->getNotification($notifId, $acronyme);

// s'il s'agit d'une notification à une classe, un cours ou un élève isole (!), on cherche la liste des élèves
$type = $notification['type'];
// liste des élèves, pour mémoire...
$listeEleves = Null;

// pour les entités 'coursGrp', 'classes' et 'eleves', on a besoin des élèves qui figurent dans ces groupes
if (in_array($type, array('coursGrp', 'classes', 'eleves'))) {
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();
    switch ($type) {
        case 'coursGrp':
            $listeEleves = $Ecole->listeElevesCours($notification['destinataire']);
            break;
        case 'classes':
            $listeEleves = $Ecole->listeElevesClasse($notification['destinataire']);
            break;
        case 'eleves':
            $listeEleves = $Ecole->detailsDeListeEleves($notification['destinataire']);
            break;
    }
}

// liste des PJ liées à cette annonce
$pjFiles = $Thot->getPj4Notifs($notifId, $acronyme);
if ($pjFiles != Null)
    $pjFiles = $pjFiles[$notifId];

echo json_encode(array(
    'notification' => $notification,
    'listeEleves' => $listeEleves,
    'pjFiles' => $pjFiles)
);
