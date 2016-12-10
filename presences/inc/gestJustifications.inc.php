<?php

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$listeJustifications = $Presences->listeJustificationsAbsences();

$smarty->assign('listeJustifications', $listeJustifications);
$smarty->assign('corpsPage', 'justifications');
