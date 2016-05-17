<?php

session_start();
require_once '../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(2);

$idretenue = isset($_POST['idretenue'])?$_POST['idretenue']:Null;

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

// caractéristiques de la retenue à cloner
$laRetenue = $Ades->detailsRetenue($idretenue);
$date = $laRetenue['dateRetenue'];

$timestamp = strtotime($date);
$datePlus7 = date('Y-m-d', strtotime('+1 week', $timestamp));

require_once INSTALL_DIR.'/ades/inc/classes/classRetenue.inc.php';
$Retenue = new Retenue();

$dataRetenue = array(
        'typeRetenue' => $laRetenue['type'],
        'dateRetenue' => $datePlus7,
        'heure' => $laRetenue['heure'],
        'duree' => $laRetenue['duree'],
        'local' => $laRetenue['local'],
        'places' => $laRetenue['places'],
        'occupation' => 0,
        'affiche' => 'O',
		'jourSemaine' => Application::jourSemaineMySQL($datePlus7)
        );

$newId = $Retenue->saveRetenue($dataRetenue);
$dataRetenue['idretenue'] = $newId;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('uneRetenue', $dataRetenue);
echo $smarty->fetch('../templates/retenues/retenueDeListe.tpl');

// uniquement php 5.4
// echo json_encode($res, JSON_UNESCAPED_SLASHES);
