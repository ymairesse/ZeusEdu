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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$idRessource = isset($_POST['idRessource']) ? $_POST['idRessource'] : Null;

$infoRessource = $Reservation->getRessourceById($idRessource);
$idType = $infoRessource['idType'];

// suppression de toutes les réservations
$nbReservations = $Reservation->delReservations4ressource($idRessource);
// suppression de la ressource
$nbRessources = $Reservation->delRessource($idRessource);

$listeRessources = $Reservation->getRessourceByType($idType);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('idRessource', Null);
$smarty->assign('listeRessources', $listeRessources);
$html = $smarty->fetch('ressources/selectRessource.tpl');

echo json_encode(array('nbReservations' => $nbReservations, 'nbRessources' => $nbRessources, 'html' => $html));
