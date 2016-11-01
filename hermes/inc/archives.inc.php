<?php

$listeArchives = $hermes->listeArchives($acronyme);
if (count($listeArchives) > 0) {
    $firstKey = array_keys($listeArchives)[0];
    // l'archive la plus récente²
    $lastArchive = $listeArchives[$firstKey];
} else {
    $lastArchive = null;
}

$smarty->assign('acronyme', $acronyme);
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('listeArchives', $listeArchives);
$smarty->assign('mail', $lastArchive);
$smarty->assign('corpsPage', 'archives');
