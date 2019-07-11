<?php

session_start();

require_once '../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(2);

require_once INSTALL_DIR."/$module/inc/classes/classPresences.inc.php";
$Presences = new Presences();

$post = isset($_POST['post']) ? $_POST['post'] : null;

$form = array();
parse_str($post, $form);

echo $Presences->saveJustification($form);
