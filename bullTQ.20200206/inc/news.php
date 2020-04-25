<?php

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$flashInfo = new flashInfo();

$smarty->assign('flashInfos', $flashInfo->listeFlashInfos($module));
$smarty->assign('corpsPage', 'news');
