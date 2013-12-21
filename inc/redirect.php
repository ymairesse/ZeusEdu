<?php
require ("fonctions.inc.php");
require ("classes/classAffichage.inc.php");
// ne fait... rien pendant le nombre de secondes demandées
$time = (isset($_GET['time'])?$_GET['time']:1);
$url  = (isset($_GET['redir'])?$_GET['redir']:Null);
sleep($time);
echo affichage::redirJavascript($url);
?>
