<?php

$listeProfs = $Ecole->listeProfs(true);
$smarty->assign('listeProfs', $listeProfs);

// quelles sont les mentions d'absences accessibles (en principe pour les profs, NP, ABS, PRES)
$justifications = $Presences->listeJustificationsAbsences(false);
$smarty->assign('justifications', $justifications);

// quelles sont toutes les mentions d'absences possibles
$listeJustifications = $Presences->listeJustificationsAbsences(true);
$smarty->assign('listeJustifications', $listeJustifications);

$statutsAbs = $Presences->listeJustificationsAbsences();
$smarty->assign('statutsAbs', $statutsAbs);

$smarty->assign('corpsPage', 'choixCoursProf');
