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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;

$form = array();
parse_str($formulaire, $form);

$idTravail = $form['idTravail'];
$bulletin = $form['bulletin'];

// informations générales concernant le travail tel qu'enregistré dans la BD,
// y compris les compétences et les points pour chacune d'elles
$dataTravail = $Files->getDataTravail($idTravail, $acronyme);

// Array
// (
//     [idTravail] => 195
//     [coursGrp] => 2C:INFO2-01
//     [titre] => SpaceX
//     [consigne] =>  Dépose ici le .....
//     [dateDebut] => 26/03/2017
//     [dateFin] => 09/04/2017
//     [statut] => readwrite
//     [max] => 15
//     [competences] => Array
//         (
//             [1116] => Array
//                 (
//                     [max] => 5
//                     [formCert] => form
//                     [idCarnet] => 5043
//                 )
//
//             [1117] => Array
//                 (
//                     [max] => 10
//                     [formCert] => form
//                     [idCarnet] => 5042
//                 )
//
//         )
//
// )


$detailsCompetences = $Files->getCompetencesTravail($idTravail);

$texte = '';
if ($detailsCompetences != null) {
    foreach ($detailsCompetences as $idCompetence => $laCompetence) {

        // s'il n'y a pas encore de $idCarnet, on le crée; sinon, on récupère celui qui existe
        $idCarnet = $Files->creerEnteteCarnetCotes($dataTravail, $bulletin, $idCompetence);

        // récupérer les cotes dans le casier virtuel
        $listeCotes = $Files->getCotes($idTravail, $idCompetence, $idCarnet);

        // // et les envoyer vers le carnet de cotes
        $n = $Files->saveCarnetCotes($listeCotes);
        $libelle = $laCompetence['libelle'];
        $texte .= sprintf('<strong>%s</strong>: <strong>%d</strong> cote(s) enregistrée(s)<br>', $libelle, $n);
    }
    echo $texte;
} else {
    echo 'Rien à enregistrer';
}
