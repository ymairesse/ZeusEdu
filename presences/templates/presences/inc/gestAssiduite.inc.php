<?php

$debut = Application::postOrCookie('debut', $unAn);
if ($debut == Null)
	$debut = date('d/m/Y');

$fin = Application::postOrCookie('fin', $unAn);
if ($fin == Null)
	$fin = date('d/m/Y');

$listeProfs = $Ecole->listeProfs();

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);
$smarty->assign('corpsPage', 'assiduite');
