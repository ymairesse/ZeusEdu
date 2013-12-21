<?php
$URL = isset($_GET['adresseForm'])?$_GET['adresseForm']:Null;
$table = isset($_GET['table'])?$_GET['table']:Null;

if ($URL == Null) die("URL missing");
if ($table == Null) die("no table");

$texte = file_get_contents("html/confirmerVider.inc.html");
// adresse du formulaire
$texte = str_replace("##SELF##", $URL, $texte);
// on importe quelle table?
$texte = str_replace("##table##", $table, $texte);
echo $texte;
?>
