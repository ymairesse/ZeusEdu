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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : null;
$endDate = isset($_POST['endDate']) ? $_POST['endDate'] : null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : null;
$locked = isset($_POST['locked']) ? $_POST['locked'] : null;
$allDay = isset($_POST['allDay']) ? $_POST['allDay'] : false;


// après un retour de position 'allDay', la date de fin est invalide
if ($endDate == 'Invalid date')
    $endDate = $startDate;

$startTime = explode(' ', $startDate)[1];
$startTime = $Jdc->heureLaPlusProche($startTime);

//  if (($endDate == '0000-00-00 00:00') && ($startTime == '00:00')) {
//      $allDay = 1;
//  } else {
//         $allDay = 0;
//     }
// // si l'événement ne commence pas à zéro heure, il n'est pas pour toute la journée
// if ($startTime != '00:00') {
//     $allDay = 0;
// }

if ($id != null) {
    if ($id != $Jdc->verifIdProprio($id, $acronyme))
            die('Cette note au JDC ne vous appartient pas');

    $resultat = $Jdc->modifEvent($id, $startDate, $endDate, $allDay);

    if ($resultat != 0) {
        $travail = $Jdc->getTravail($id);
        $listePJ = $Jdc->getPJ($id);
        // $travail['listePJ'] = $Jdc->getPJ($id);
        $categories = $Jdc->categoriesTravaux();

        require_once INSTALL_DIR.'/smarty/Smarty.class.php';
        $smarty = new Smarty();
        $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
        $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

        $smarty->assign('id', $id);
        $smarty->assign('listePJ', $listePJ);
        $smarty->assign('travail', $travail);
        $smarty->assign('editable', $editable);
        $smarty->assign('locked', $locked);
        $smarty->assign('acronyme', $acronyme);
        $smarty->display('jdc/unTravail.tpl');
    }
}
