<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : Null;
$endDate = isset($_POST['endDate']) ? $_POST['endDate'] : Null;

// les dates au format YYYY-MM-JJ
$dateStart = Application::dateMySQL($startDate);
$dateEnd = Application::dateMySQL($endDate);

$date1 = strtotime($dateStart);
$date2 = strtotime($dateEnd);

// liste des jours (hors WE) et des jours de la semaine pour les absences
$arrayDates = array();
for ($currentDate = $date1; $currentDate <= $date2; $currentDate += (86400)) {
    $jour = date('w', $currentDate);
    // ni dimanche ni samedi
    if ($jour > 0 && $jour < 6) {
        $date = date('Y-m-d', $currentDate);
        $arrayDates[] = array('date' => $date, 'jour' => $jour);
        }
    }

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$nb = $Edt->transfertListeAbsences($abreviation, $arrayDates);

echo $nb;
