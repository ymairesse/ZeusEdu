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

$unAn = time() + 365 * 24 * 3600;
$idTravail = Application::postOrCookie('idTravail', $unAn);
$matricule = Application::postOrCookie('matricule', $unAn);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

// informations générales sur le travail (dates, consigne,...)
$infoTravail = $Files->getDataTravail($idTravail, $acronyme);
$listeTravauxRemis = $Files->listeTravauxRemis($idTravail, $acronyme);
$photo = Ecole::photo($matricule);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('infoTravail', $infoTravail);
$smarty->assign('listeTravauxRemis', $listeTravauxRemis);
$smarty->assign('matricule', $matricule);

echo $smarty->fetch('casier/evalTravaux.tpl');
