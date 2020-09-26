<?php

// établissement des rapports de compétences

$date = isset($_POST['date']) ? $_POST['date'] : null;
$signature = isset($_POST['signature']) ? $_POST['signature'] : null;
$classes = isset($_POST['classes']) ? $_POST['classes'] : null;
$typeDoc = isset($_POST['typeDoc']) ? $_POST['typeDoc'] : null;

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classes', $classes);
$smarty->assign('date', $date);
$smarty->assign('signature', $signature);
$smarty->assign('DIRECTION', DIRECTION);
$smarty->assign('typeDoc', $typeDoc);

$smarty->assign('corpsPage', 'direction/competences');
