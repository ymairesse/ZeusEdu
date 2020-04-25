<?php

// messages aux valves (reçus et envoyés)
$allValves = $Hermes->getAllValves($acronyme);
$smarty->assign('allValves', $allValves);

// archives des mails envoyés, y compris les PJ
$listeArchives = $Hermes->listeArchives($acronyme);
$smarty->assign('listeArchives', $listeArchives);

$smarty->assign('acronyme', $acronyme);
$smarty->assign('corpsPage', 'notifications');
