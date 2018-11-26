<?php
require_once("../../../config.inc.php");

session_start();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$periode = isset($_POST['periode'])?$_POST['periode']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();

// récupérer la liste d'attente complète
$listeAttente = $thot->getListeAttenteProf($date, $acronyme);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeAttente',$listeAttente);
$smarty->assign('acronyme',$acronyme);
$smarty->assign('date',$date);
$smarty->assign('periode',$periode);
$smarty->display('reunionParents/listeAttenteProf.tpl');
