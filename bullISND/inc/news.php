<?php
require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
$application = Application::repertoireActuel();
$smarty->assign('application',$application);
$smarty->assign('flashInfos', flashInfo::listeFlashInfos ($application));
$smarty->assign('corpsPage', 'news');
?>