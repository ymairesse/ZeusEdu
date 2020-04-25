<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
$User = $_SESSION[APPLICATION];

$identite = $User->identite();
$acronyme = $identite['acronyme'];

$start = $_GET['start'];
$end = $_GET['end'];

$matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$classe = $Eleve->getDetailsEleve()['classe'];

$listeCours = "'".implode("','", $Eleve->listeCoursGrp())."'";

$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
$sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
$sql .= 'FROM '.PFX.'thotJdc ';
$sql .= "WHERE startDate BETWEEN '$start' AND '$end' ";
$sql .= "AND destinataire IN ($listeCours) OR destinataire = '$classe' OR destinataire = 'ecole' ";

$resultat = $connexion->query($sql);
$liste = array();
if ($resultat) {
    $resultat->setFetchMode(PDO::FETCH_ASSOC);
    while ($ligne = $resultat->fetch()) {
        $liste[] = array(
            'id' => $ligne['id'],
            'title' => $ligne['title'],
            'url' => $ligne['url'],
            'className' => 'cat_'.$ligne['idCategorie'],
            'start' => $ligne['startDate'],
            'end' => $ligne['endDate'],
            'allDay' => ($ligne['allDay'] != 0)
            );
    }
}
Application::DeconnexionPDO($connexion);
echo json_encode($liste);
