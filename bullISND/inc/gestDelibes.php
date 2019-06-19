<?php

$unAn = time() + 365 * 24 * 3600;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
// $classe = Application::postOrCookie('classe', $unAn);
$smarty->assign('classe', $classe);

$matricule = Application::postOrCookie('matricule', $unAn);
$smarty->assign('matricule', $matricule);

$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$annee = ($classe != null) ? SUBSTR($classe, 0, 1) : null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$sections = SECTIONS;
$sections = explode(',', SECTIONS);
$listeClasses = $Ecole->listeGroupes($sections);

$smarty->assign('listeTitus', $listeTitus);
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('annee', $annee);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('action', 'delibes');

switch ($mode) {
    case 'individuel':
        include 'delibe/delibeIndividuel.inc.php';
        break;
    case 'synthese':
        include 'delibe/synthese.inc.php';
        break;
    case 'parClasse':
        include 'delibe/parClasse.inc.php';
        break;
    case 'notifications':
        include 'delibe/notifications.inc.php';
        break;
    case 'eprExternes':
        include 'delibe/eprExternes.inc.php';
        break;
    case 'viewNotifs':
        include 'delibe/notifsAdmin.inc.php';
        break;
    }
