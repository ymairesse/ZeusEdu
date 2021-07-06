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

$userStatus = $User->userStatus($module);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

// Le formulaire arrive avec la liste des ressources souhaitées et les dates projetées d'emprunt
// array (
//   'dateStart' => '01/05/2021',
//   'startTime' => '08:15',
//   'dateEnd' => '01/05/2021',
//   'endTime' => '09:05',
//   'selectRessource' =>
//   array (
//     0 => '1',
//     1 => '2',
//   ),
// )

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$dateStart = $form['dateStart'];
$dateStartSQL = Application::dateMysql($dateStart);

$dateEnd = $form['dateEnd'];
$dateEndSQL = Application::dateMysql($dateEnd);

$listeRessources = $form['ressources'];

$dateDebut = sprintf('%s %s', Application::dateMysql($form['dateStart']), $form['startTime']);
$dateFin = sprintf('%s %s', Application::dateMysql($form['dateEnd']), $form['endTime']);

$listePeriodesWanted = $Reservation->getListePeriodes2dates($dateDebut, $dateFin);
$planOccupation = $Reservation->getPlanOccupation($listePeriodesWanted, $listeRessources);

$ressources = array();
foreach ($listeRessources as $idRessource) {
    $ressources[$idRessource] = $Reservation->getRessourceById($idRessource);
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeHeuresCours = $Ecole->lirePeriodesCours();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('planOccupation', $planOccupation);
$smarty->assign('listeRessources', $ressources);
$smarty->assign('listeHeuresCours', $listeHeuresCours);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('acronyme', $acronyme);

$smarty->display('ressources/pageReservation.tpl');
