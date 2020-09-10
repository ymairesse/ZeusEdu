<?php

$listeArchives = $hermes->listeArchives($acronyme);

if (count($listeArchives) > 0) {
    $firstKey = current($listeArchives)['id'];
    // l'archive la plus récente
    $recentArchive = $listeArchives[$firstKey];
}
else $recentArchive = Null;

$smarty->assign('acronyme',$acronyme);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('listeArchives',$listeArchives);
$smarty->assign('recentArchive', $recentArchive);

$smarty->assign('corpsPage','archives');
