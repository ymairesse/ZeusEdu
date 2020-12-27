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

require_once INSTALL_DIR."/inc/classes/classThot.inc.php";
$Thot = new Thot();
$notification = $Thot->getNotification($id, $acronyme);

// Application::afficher($notification, true);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$module = $Application->getModule(3);

// s'il s'agit d'une notification à une classe, un cours ou un élève isole (!), on cherche la liste des élèves
$type = $notification['type'];

$listeTypes = $Thot->getTypes();
// tous les types de destinataires sauf les élèves isolés
$selectTypes = $Thot->getTypes();

$listeNiveaux = $Ecole->listeNiveaux();
$listeClasses = $Ecole->listeClasses();
$listeCours = $User->getListeCours();

$userStatus = $User->userStatus($module);

// liste des élèves, pour mémoire...
$listeEleves = Null;

// est-ce une notification destinée à l'élève dont le matricule est le destinataire?

if (isset($notification['matricule']) && ($notification['matricule'] != '')) {
    $listeEleves = $Ecole->detailsDeListeEleves($notification['matricule']);
    }
    else {
        // pour les entités 'coursGrp', 'classes', 'groupe' et 'profsCours', on a besoin des élèves qui figurent dans ces groupes
        if (in_array($type, array('coursGrp', 'classes', 'groupe', 'profsCours'))) {
            require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
            $Ecole = new Ecole();
            switch ($type) {
                case 'coursGrp':
                    $listeEleves = $Ecole->listeElevesCours($notification['destinataire']);
                    break;
                case 'classes':
                    $listeEleves = $Ecole->listeElevesClasse($notification['destinataire']);
                    break;
                case 'groupe':
                    // prévoir la liste des élèves du groupe
                    break;
                case 'profsCours':
                    $listeEleves = $Ecole->listeElevesCours($notification['destinataire']);
                    break;
            }
        }
    }

// initialisation de ce qui pourrait être utilisé
$niveau = Null;
$listeClasses = Null;
$listeMatieres = Null;
$stringDestinataire = Null;
$prof4cours = Null;
$listeCours4prof = Null;
// liste de tous les profs
$listeProfs = $Ecole->listeProfs(true);

switch ($type) {
    case 'ecole':
        $stringDestinataire = 'Tous';
        break;
    case 'niveau':
        $stringDestinataire = sprintf('%de année', $notification['destinataire']);
        $niveau = $notification['destinataire'];
        break;
    case 'cours':
        $stringDestinataire = $notification['destinataire'];
        $niveau = SUBSTR($notification['destinataire'], 0, 1);
        $listeMatieres = $Ecole->listeMatieresNiveau($niveau);
        break;
    case 'profsCours':
        $coursGrp = $notification['destinataire'];
        $stringDestinataire = $coursGrp;
        $prof4cours = $Ecole->getProf4coursGrp($coursGrp);
        $listeCours4prof = $Ecole->listeCoursProf($prof4cours, true);
        break;
    case 'coursGrp':
        $stringDestinataire = $notification['destinataire'];
        $niveau = SUBSTR($notification['destinataire'], 0, 1);
        break;
    case 'groupe':
        $stringDestinataire = $notification['destinataire'];
        $niveau = SUBSTR($notification['destinataire'], 0, 1);
        break;
    case 'classes':
        $stringDestinataire = $notification['destinataire'];
        $niveau = SUBSTR($notification['destinataire'], 0, 1);
        $listeClasses = $Ecole->listeClassesNiveau($niveau);
        break;
    case 'eleves':
        $stringDestinataire = 'Un·e élève';
        break;
    default:
        $stringDestinataire = 'wtf';
        break;
    }

// pièces jointes à la notification $id
$pjFiles = $Thot->getPj4Notifs($id, $acronyme);

// il suffit de prendre les PJ de la première notification (les autres sont les mêmes)
if ($pjFiles != Null)
    $pjFiles = current($pjFiles);

$selectedFiles = array();
foreach ($pjFiles as $oneFile) {
    $selectedFiles[] = $oneFile['path'].$oneFile['fileName'];
}

// ------------------------------------------------------------------------------
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('type', $type);
$smarty->assign('edition', true);
$smarty->assign('destinataire', $notification['destinataire']);
$smarty->assign('stringDestinataire', $stringDestinataire);
$smarty->assign('notification', $notification);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('prof4Cours', $prof4cours);
$smarty->assign('listeCours4prof', $listeCours4prof);

$smarty->assign('id', $id);
// à destination du widget fileTree
$smarty->assign('pjFiles', $pjFiles);

$smarty->assign('selectedFiles', $selectedFiles);
$smarty->assign('selectTypes', $selectTypes);
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('$listeMatieres', $listeMatieres);
$smarty->assign('niveau', $niveau);
$smarty->assign('listeCours', $listeCours);
$smarty->assign('userStatus', $userStatus);

echo $smarty->display('notification/edit/tabEdit.tpl');
