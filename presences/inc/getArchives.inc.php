<?php

$module = $Application->repertoireActuel();
require_once INSTALL_DIR.'/'.$module.'/inc/classes/classPresences.inc.php';
$Presences = new presences();

$history = $Presences->getHistory();
$smarty->assign('history', $history);

$smarty->assign('corpsPage', 'history');
