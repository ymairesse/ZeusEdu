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

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : Null;

require_once (INSTALL_DIR."/inc/classes/classThot2.inc.php");
$Thot = new Thot();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$notification = $Thot->getNotification($notifId, $acronyme);

$destinataire = $notification['destinataire'];
switch ($notification['type']) {
    case 'ecole':
        // pas d'accusé de lecture pour l'ensemble de l'école
        $listeEleves = Null;
        break;
    case 'niveau':
        $listeEleves = $Ecole->listeElevesNiveaux($destinataire);
        break;
    case 'cours':
        $listeEleves = $Ecole->listeElevesMatiere($destinataire);
        break;
    case 'coursGrp':
        $listeEleves = $Ecole->listeElevesCours($destinataire);
        break;
    case 'classes':
        $listeEleves = $Ecole->listeElevesClasse($destinataire);
        break;
    case 'groupe':

        break;
    case 'eleves':
        $listeEleves = $Ecole->detailsDeListeEleves($destinataire);
        break;
}

$listeAccuses = $Thot->getAccuses4id($notifId, $acronyme);
$mode = count($listeEleves) < 30 ? 'portrait' : 'liste';

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('mode', $mode);

$smarty->display('notification/modal/listeAccuses.tpl');
