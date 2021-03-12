<?php

// répertoire des fichiers .ics
$dir = getcwd();
$ics = $dir.'/ical/*.ics';

$files = glob($ics);

$smarty->assign('numFiles', count($files));
$smarty->assign('corpsPage', 'sendICal');
