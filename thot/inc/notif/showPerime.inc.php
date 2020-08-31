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

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$annoncesPerimees = $Thot->getAnnoncesPerimees($acronyme);
foreach ($annoncesPerimees AS $notifId => $data) {
    $annoncesPerimees[$notifId]['trueDestinataire'] = $Thot->getTrueDestinataire($data['type'], $data['destinataire']);
    $annoncesPerimees[$notifId]['HRtype'] = $Thot->getHumanReadableType($data['type']);
}

// ------------------------------------------------------------------------------
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('annoncesPerimees', $annoncesPerimees);
$smarty->display('notification/modal/modalPerimees.tpl');
