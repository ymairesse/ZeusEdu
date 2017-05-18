<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$competences = $Files->getCompetencesTravail($idTravail);

if (count($competences) == 0) {
    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);
    $smarty->assign('listeCompetences', $listeCompetences);
    echo $smarty->fetch('casier/listeCompetences.tpl');
}
else echo "";
