<?php

// répertoire des fichiers .ics
$dir = getcwd();
$ics = $dir.'/../ical/*.ics';

$files = glob($ics);

// var_dump($files);

echo count($files);
