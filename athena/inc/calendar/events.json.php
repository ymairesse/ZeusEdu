<?php
require_once("../../../config.inc.php");

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

$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

$sql = "SELECT id, proprietaire, da.matricule, motif, startDate, endDate, absent, groupe, nom, prenom ";
$sql .= "FROM ".PFX."athena AS da ";
$sql .= "JOIN ".PFX."eleves AS de ON de.matricule = da.matricule ";
$sql .= "WHERE date BETWEEN '$start' AND '$end' ";
$sql .= "AND proprietaire = '$acronyme' ";


$resultat = $connexion->query($sql);
$liste = array();
if ($resultat) {
	$resultat->setFetchMode(PDO::FETCH_ASSOC);
	while ($ligne = $resultat->fetch()){
		$liste[] = array(
			'id'=>$ligne['id'],
			'title'=>sprintf('%s %s [%s]',$ligne['prenom'], $ligne['nom'], $ligne['groupe']),
			'url'=>'',
			'className'=>'cat_'.$ligne['absent'],
			'start'=> $ligne['startDate'],
			'end' => $ligne['endDate'],
			'allDay' => 0,
			'editable' => true
			);
		}
	}
Application::DeconnexionPDO($connexion);
echo json_encode($liste);
