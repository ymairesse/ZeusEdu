<?php

$listeAccuses = $Thot->listeAccuses($acronyme);
$statsAccuses = $Thot->statsAccuses($Thot->listeIdNotif4User($acronyme));

$smarty->assign('statsAccuses', $statsAccuses);
$smarty->assign('listeAccuses', $listeAccuses);

$smarty->assign('corpsPage', 'notification/listeAccuses');
