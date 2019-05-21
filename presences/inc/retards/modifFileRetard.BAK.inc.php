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

$module = $Application::getmodule(3);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$idTraitement = $form['idTraitement'];
$matricule = $form['matricule'];

// mise à jour des dates de retard (on supprime celles qui n'existent plus)
$datesRetardsOrg = $Presences->getDatesRetards4idTraitement($idTraitement);
foreach (array_keys($datesRetardsOrg) as $idRetard) {
    if (!in_array($idRetard, $form['idRetards']))
        $Presences->delTraitementLogs($idTraitement, $idRetard, $matricule);
    }

$dateRetour = isset($form['dateRetour']) ? $form['dateRetour'] : Null;
$nbImpression = Null;
$Presences->updatePresencesTraitement($idTraitement, $acronyme, $dateRetour, $nbImpression);

// mise à jour des dates de sanctions (on supprime celles qui ne sont pas dans la liste)
$datesSanction = $form['datesSanction'];
$nb = $Presences->delDatesSanction($idTraitement, $datesSanction);

echo $nb;
