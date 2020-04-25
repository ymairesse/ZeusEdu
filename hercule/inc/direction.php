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

$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;

$smarty->assign('onglet', $onglet);
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

require_once 'direction/padEleve.php';
