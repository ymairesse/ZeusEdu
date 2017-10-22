<?php

$unAn = time() + 365 * 24 * 3600;
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

$bulletin = isset($_REQUEST['bulletin']) ? $_REQUEST['bulletin'] : PERIODEENCOURS;

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;

$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('niveau', $niveau);
$smarty->assign('onglet', $onglet);
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

switch ($mode) {
    case 'competences':
        require_once 'direction/competences.inc.php';
        break;

    case 'eprExternes':
        require_once 'direction/eprExternes.inc.php';
        break;

    case 'resultatsExternes':
        require_once 'direction/resultatsExternes.inc.php';
        break;

    case 'padEleve':
        require_once 'direction/padEleve.inc.php';
        break;

    case 'pia':
        require_once 'direction/pia.inc.php';
        break;

    case 'recapDegre':
		require_once 'direction/gestFinDegre.inc.php';
		break;
    }
