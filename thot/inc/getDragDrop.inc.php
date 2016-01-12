<?php
require_once("../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classUser.inc.php');
session_start();

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php');
$jdc = new Jdc();

$user = @$_SESSION[APPLICATION];
if ($user == Null)
    die();

$acronyme = $user->getAcronyme();

$id = isset($_POST['id'])?$_POST['id']:Null;
$startDate = isset($_POST['startDate'])?$_POST['startDate']:Null;
$endDate = isset($_POST['endDate'])?$_POST['endDate']:Null;

// si l'événement démarre à zéro heure et que la fin est indéterminée, on le met en allDay
$startTime = explode(' ',$startDate)[1];
 if (($endDate == '0000-00-00 00:00') && ($startTime == '00:00'))
    $allDay = 1;
    else $allDay = 0;
// si l'événement ne commence pas à zéro heure, il n'est pas pour toute la journée
if ($startTime != '00:00')
    $allDay = 0;

if ($id != Null) {
    if ($jdc->verifIdProprio($id, $acronyme)) {
        if (substr($startDate,0,10) == substr($endDate,0,10))
            $resultat = $jdc->modifEvent($id, $startDate, $endDate, $allDay);
            else $resultat = Null;
            }
        if ($resultat != Null) {
            $travail = $jdc->getTravail($id);
            require_once(INSTALL_DIR."/smarty/Smarty.class.php");
            $smarty = new Smarty();
            $smarty->template_dir = "../templates";
            $smarty->compile_dir = "../templates_c";
            $smarty->assign('legendeCouleurs',$jdc->categoriesTravaux());
            $smarty->assign('acronyme',$acronyme);
            $smarty->assign('travail',$travail);
            $smarty->display('jdc/unTravail.tpl');
        }
    }
