<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
// la fonction verifProprietaireTravail renvoie l'id du travail s'il est bien attribué à $acronyme
$id = $Files->verifProprietaireTravail($acronyme, $idTravail);
if ($id == $idTravail) {
    $dateSave = $Files->saveEvaluation($_POST);
    // le temps de voir l'ajaxLoader
    sleep(1);
    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('dateSave', $dateSave);
    echo $smarty->fetch('alertDateHeure.tpl');
} else {
    die('Ce travail ne vous appartient pas');
}
