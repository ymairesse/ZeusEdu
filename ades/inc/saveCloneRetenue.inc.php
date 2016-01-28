<?php

session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
$ligne = $_POST['ligne'];

$date = $_POST['date'];
$timestamp = $Application->dateFR2Time($date);
$datePlus7 = date('d/m/Y', strtotime('+1 week', $timestamp));

require_once (INSTALL_DIR."/ades/inc/classes/classRetenue.inc.php");
$Retenue = new Retenue();
$data = array(
		'typeRetenue'=>$_POST['typeRetenue'],
		'date'=>$datePlus7,
		'heure'=>$_POST['heure'],
		'duree'=>$_POST['duree'],
		'local'=>$_POST['local'],
		'places'=>$_POST['places'],
		'occupation'=>0,
		'affiche'=>'O'
		);

$newId = $Retenue->saveRetenue($data);
$res = array('id'=>$newId, 'date'=>$datePlus7);

echo json_encode($res);

// uniquement php 5.4
// echo json_encode($res, JSON_UNESCAPED_SLASHES);

?>
