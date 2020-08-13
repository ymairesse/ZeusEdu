<?php

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/widgets/flashInfo/inc/classes/class.FlashInfo.php';
$FlashInfo = new FlashInfo();

$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);

$listeFlashInfos = $FlashInfo->listeFlashInfos($module);

$smarty->assign('listeFlashInfos', $listeFlashInfos);

$smarty->assign('corpsPage', 'news/news');
