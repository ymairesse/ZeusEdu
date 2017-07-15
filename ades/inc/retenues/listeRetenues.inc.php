<?php

/**
 * récupérer et formater la liste des retenues disponibles
 * Cette liste est utilisée dans le sélecteur type/date de retenue
 */

 require_once '../../../config.inc.php';

 // définition de la class Application
 require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
 $Application = new Application();

 session_start();
 if (!(isset($_SESSION[APPLICATION]))) {
     echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
     exit;
 }

// définition de la class Ades
require_once INSTALL_DIR.'/ades/inc/classes/classAdes.inc.php';
$Ades = new Ades();

$type = isset($_POST['type']) ? $_POST['type'] : null;
if ($type == null) {
    die();
}

$listeRetenues = $Ades->listeRetenues($type, true);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeRetenues', $listeRetenues);
$smarty->display('selecteurs/selectListesRetenues.tpl');
