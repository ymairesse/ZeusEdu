<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);
// Application::afficher($module);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$selection = isset($form['types']) ? array_values($form['types']) : Null;

$listeTypes = $Jdc->getListeTypes();

$types = array();
foreach ($listeTypes as $type => $libelle) {
    $types[$type] = ($selection == Null) ? 0 : in_array($type, $selection) ? 1 : 0;
    }

$unAn = time() + 365 * 24 * 3600;
setcookie('typesJDC', json_encode($types), $unAn, '/');
