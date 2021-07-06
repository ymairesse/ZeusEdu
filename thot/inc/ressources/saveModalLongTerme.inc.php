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

$idRessource = isset($form['idRessource']) ? $form['idRessource'] : Null;
// $ressource = $Reservation->getRessourceById($idRessource);
//
// $idRessource = isset($form['idRessource']) ? $form['idRessource'] : Null;
// $hasCaution = isset($form['hasCaution']) ? $form['hasCaution'] : Null;
// $caution = isset($form['caution']) ? $form['caution'] : Null;
// $indisponible = isset($form['indisponible']) ? $form['indisponible'] : Null;
// $longTermeBy = isset($form['longTermeBy']) ? $form['longTermeBy'] : Null;
// $etat = isset($form['etat']) ? $form['etat'] : Null;

$nb = 0;
if ($idRessource != Null)
    $nb = $Reservation->saveRessource($form);

echo $nb;
