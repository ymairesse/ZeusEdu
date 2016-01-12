<?php

$unAn = time() + 365 * 24 * 3600;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

if (isset($_POST['classe'])) {
    $classe = $_POST['classe'];
    setcookie('classe', $classe, $unAn, null, null, false, true);
} else {
        $classe = isset($_COOKIE['classe']) ? $_COOKIE['classe'] : null;
    }
$smarty->assign('classe', $classe);

if (isset($_POST['matricule'])) {
    $matricule = $_POST['matricule'];
    setcookie('matricule', $matricule, $unAn, null, null, false, true);
} else {
        $matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : null;
    }
$smarty->assign('matricule', $matricule);

$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$annee = ($classe != null) ? SUBSTR($classe, 0, 1) : null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$listeClasses = $Ecole->listeGroupes($sections = array('G', 'TT', 'S'));

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
    }
