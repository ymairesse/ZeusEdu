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

$id = isset($_POST['id']) ? $_POST['id'] : Null;

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$Thot = new Thot();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$notification = $Thot->getNotification($id, $acronyme);

switch ($notification['type']) {
    case 'ecole':
        // pas d'accusé de lecture pour l'ensemble de l'école
        $listeEleves = Null;
        break;
    case 'niveau':
        $niveau = $notification['destinataire'];
        $listeEleves = $Ecole->listeElevesNiveaux($niveau);
        break;
    case 'cours':
        $matiere = $notification['destinataire'];
        $listeEleves = $Ecole->listeElevesMatiere($matiere);
        break;
    case 'coursGrp':
        $destinataire = $notification['destinataire'];
        $listeEleves = $Ecole->listeElevesCours($destinataire);
        break;
    case 'classes':
        $classe = $notification['destinataire'];
        $listeEleves = $Ecole->listeElevesClasse($classe);
        break;
    case 'eleves':
        $matricule = $notification['destinataire'];
        $listeEleves = $Ecole->detailsDeListeEleves($matricule);
        break;
}

$listeAccuses = $Thot->getAccuses4id($id, $acronyme);
$mode = count($listeEleves) < 30 ? 'portrait' : 'liste';

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('mode', $mode);
echo $smarty->fetch('notification/modal/listeAccuses.tpl');
