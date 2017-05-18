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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;

$form = array();
parse_str($formulaire, $form);

$idTravail = $form['idTravail'];
$bulletin = $form['bulletin'];

// informations générales concernant le travail
$dataTravail = $Files->getDataTravail($idTravail, $acronyme);

$listeCompetences = isset($form['listeCompetences']) ? $form['listeCompetences'] : null;
$libelleCompetences = $Files->getCompetencesTravail($idTravail);

if ($listeCompetences != null) {
    foreach ($listeCompetences as $key => $idCompetence) {
        $idCarnet = $Files->creerEnteteCarnetCotes($dataTravail, $form, $idCompetence);
        // récupérer les cotes dans le casier virtuel
        $listeCotes = $Files->getCotes($idTravail, $idCompetence, $idCarnet);
        // et les envoyer vers le carnet de cotes
        $n = $Files->saveCarnetCotes($listeCotes);
        $libelle = $libelleCompetences[$idCompetence]['libelle'];
        echo sprintf('<strong>%s</strong>: <strong>%d</strong> cote(s) enregistrée(s)<br>', $libelle, $n);
    }
} else {
    echo 'Rien à enregistrer';
}
