<?php

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new FlashInfo();

$listeFlashInfos = $FlashInfo->listeFlashInfos($module);

$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('listeFlashInfos', $listeFlashInfos);

$smarty->assign('corpsPage', 'news');
