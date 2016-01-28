<?php
require_once("../../config.inc.php");

// définition de la class USER utilisée en variable de SESSION
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

session_start();
$User = $_SESSION[APPLICATION];

$identite = $User->identite();
$acronyme = $identite['acronyme'];

$start = $_GET['start'];
$end = $_GET['end'];

$type = isset($_COOKIE['type'])?$_COOKIE['type']:Null;
$coursGrp = isset($_COOKIE['coursGrp'])?$_COOKIE['coursGrp']:Null;
$classe = isset($_COOKIE['classe'])?$_COOKIE['classe']:Null;
$matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;

$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

if ($type == 'eleves') {
	require_once(INSTALL_DIR.'/inc/classes/classEleve.inc.php');
	$Eleve = new Eleve($matricule);

	$listeCours = "'".implode("','", $Eleve->listeCoursGrp())."'";
	$sql = "SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ";
	$sql .= "FROM ".PFX."thotJdc ";
	$sql .= "WHERE startDate BETWEEN '$start' AND '$end' ";
	$sql .= "AND destinataire IN ($listeCours) OR destinataire = '$classe' OR destinataire = 'ecole' ";
	}
	else {
		$sql = "SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ";
		$sql .= "FROM ".PFX."thotJdc ";
		$sql .= "WHERE startDate BETWEEN '$start' AND '$end' ";
		$sql .= "AND proprietaire = '$acronyme' ";
		if (($type == 'coursGrp') && ($coursGrp != ''))
			$sql .= "AND destinataire='$coursGrp' ";
			else if (($type == 'classe') && ($classe != ''))
					$sql .= "AND destinataire='$classe' ";
		}

$resultat = $connexion->query($sql);
$liste = array();
if ($resultat) {
	$resultat->setFetchMode(PDO::FETCH_ASSOC);
	while ($ligne = $resultat->fetch()){
		$liste[] = array(
			'id'=>$ligne['id'],
			'title'=>$ligne['title'],
			'url'=>$ligne['url'],
			'className'=>'cat_'.$ligne['idCategorie'],
			'start'=> $ligne['startDate'],
			'end' => $ligne['endDate'],
			'allDay' => ($ligne['allDay']!=0),
			'editable' => ($ligne['proprietaire'] == $acronyme)
			);
		}
	}
Application::DeconnexionPDO($connexion);
echo json_encode($liste);
