<?php

$mode = isset($_GET['mode']) ? $_GET['mode'] : Null;
if ($mode == Null)
    $mode = isset($_POST['mode']) ? $_POST['mode'] : Null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : Null;

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('etape', $etape);

// préparation des sélecteurs
switch ($mode) {
    case 'coursGrp':
        $coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
        $smarty->assign('listeCours', $user->listeCoursProf());
        $smarty->assign('coursGrp', $coursGrp);
        $smarty->assign('selecteur', 'selecteurs/selectCoursPOST');
        break;
    case 'classes':
        $classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
        $smarty->assign('listeClasses', $Ecole->listeGroupes());
        $smarty->assign('classe', $classe);
        $smarty->assign('selecteur', 'selecteurs/selectClassePOST');
        break;
    case 'niveau':
        $niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
        $smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
        $smarty->assign('niveau', $niveau);
        $smarty->assign('selecteur', 'selecteurs/selectNiveau');
        break;
    case 'ecole':
        // on passe de suite à l'étape suivante
        break;
    }

if ($etape == 'show' || $mode == 'ecole') {
    switch ($mode) {
        case 'coursGrp':
            $listeEleves = $Ecole->listeElevesCours($coursGrp);
            $notification = $Thot->newNotification('coursGrp', $user->acronyme(), $coursGrp);
            break;
        case 'classes':
            $listeEleves = $Ecole->listeElevesClasse($classe);
            $notification = $Thot->newNotification('classes', $user->acronyme(), $classe);
            break;
        case 'niveau':
            $listeEleves = Null; // pas de sélection d'élève possible
            $notification = $Thot->newNotification('niveau', $user->acronyme(), $niveau);
            break;
        case 'ecole':
            $listeEleves = Null; // pas de sélection d'élève possible
            $notification = $Thot->newNotification('ecole', $user->acronyme(), 'ecole');
            break;
        }
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
    $tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme);

    $smarty->assign('tree', $tree->getTree());
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('notification', $notification);
    $smarty->assign('corpsPage', 'notification/formNotification');
}
