<?php

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$flashInfo = new flashInfo();

$appli = $Application->repertoireActuel();
$smarty->assign('flashInfos', $flashInfo->listeFlashInfos($appli));
$smarty->assign('corpsPage', 'news');
