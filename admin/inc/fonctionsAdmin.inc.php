<?php
require_once(INSTALL_DIR."/inc/classes/classUser.inc.php");


## ---------------------------------------------------------------##
function clearTable ($table) {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "TRUNCATE ".PFX."$table";
	$resultat = $connexion->exec($sql);
	Application::DeconnexionPDO ($connexion);
	return true;
}
/*
 * function usersList
 * @param
 * établit une liste de tous les utilisateurs "profs" du logiciel
 */
function usersList () {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT acronyme, CONCAT(nom,' ', prenom) AS nom FROM ".PFX."profs ";
	$sql .= "ORDER BY nom ";
	$resultat = $connexion->query($sql);
	$resultat->setFetchMode(PDO::FETCH_ASSOC);
	$usersList = array();
	if ($resultat) {
		while ($ligne = $resultat->fetch()) {
			$acronyme = $ligne['acronyme'];
			$usersList[$acronyme] = $ligne['nom'];;
			}
		}
	Application::DeconnexionPDO($connexion);
	return $usersList;
}
## ---------------------------------------------------------------##
/**
 * function usersTable
 * @param
 * renvoie un tableau de tous les utilisateurs reprenant
 * - l'identité des utilisateurs (acronyme + nom)
 * - la liste des applications et le statut des utilisateurs pour chacune d'elles
 */
function usersTable () {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT pa.acronyme, application, pa.userStatus, p.nom, p.prenom ";
	$sql .= "FROM ".PFX."profsApplications AS pa ";
	$sql .= "JOIN ".PFX."profs AS p ON (pa.acronyme = p.acronyme) ";
	$sql .= "JOIN ".PFX."applications AS a ON (a.nom = pa.application) ";
	$sql .= "WHERE active = '1' ";
	$sql .= "ORDER BY REPLACE(REPLACE(REPLACE(p.nom, ' ', ''),'''',''),'-',''), p.prenom, lower(application)";
	$resultat = $connexion->query($sql);
	$liste = array();
	if ($resultat) {
		$resultat->setFetchMode(PDO::FETCH_ASSOC);
		$liste = $resultat->fetchall();
		}
	Application::DeconnexionPDO ($connexion);

	$listeAcronymes = array();
	$n=0;
	$tableau = array();
	foreach ($liste as $unElement) {
		$acronyme = $unElement['acronyme'];
		if (!(in_array($acronyme, $listeAcronymes))) {
			$n++;
			$nom = $unElement['nom'];
			$prenom = $unElement['prenom'];
			$listeAcronymes[] = $acronyme;
			$tableau[$n]['identite']['acronyme'] = $acronyme;
			$tableau[$n]['identite']['nom'] = "$nom $prenom";
			}
		$application = $unElement['application'];
		$userStatus = $unElement['userStatus'];
		$tableau[$n]['applications'][$application] = $userStatus;
		}
	return $tableau;
}

## ---------------------------------------------------------------##
// liste de tous les droits existants dans la BD pour les différentes applications
// educ, prof, admin, direction,... et tous les autres statuts éventuels existants
// ou à venir définis dans les applis
function listeDroits () {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT userStatus FROM ".PFX."userStatus ORDER BY ordre";
	$resultat = $connexion->query($sql);
	$liste = array();
	if ($resultat) {
		$resultat->setFetchMode(PDO::FETCH_ASSOC);
		$liste = array();
		while ($ligne = $resultat->fetch())
			array_push($liste, $ligne['userStatus']);
		Application::DeconnexionPDO($connexion);
		}
	return $liste;
}

## ---------------------------------------------------------------##
// liste des applications avec leur "activité"
function listeApplisActif () {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT nom, nomLong, active FROM ".PFX."applications ";
	$sql .= "ORDER BY ordre, LOWER(nom)";
	$resultat = $connexion->query($sql);
	$liste = array();
	if ($resultat) {
		while ($ligne = $resultat->fetch()) {
			$nom = $ligne['nom'];
			$nomLong = $ligne['nomLong'];
			$active = $ligne['active'];
			$liste[$nom] = array("nom"=>$nom, "nomLong"=>$nomLong, "active"=>$active);
			}
		}
	Application::DeconnexionPDO($connexion);
	return $liste;
	}


## ---------------------------------------------------------------##
function selectUserApplications ($acronyme="") {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	// il s'agit d'un nouvel utlisateur
	if ($acronyme == "") {
		$sql = "SELECT nom, nomLong FROM ".PFX."applications WHERE active ";
		$sql .= "ORDER BY ordre";
		$resultat = $connexion->query($sql);
		$applications=array();
		while ($ligne = $resultat->fetch()) {
			$nom = $ligne['nom'];
			$nomLong = $ligne['nomLong'];
			$applications[$nom] = array ('nomLong'=>$nomLong, 'userStatus'=>'none');
			}
		}
		else {
			$sql = "SELECT nom, acronyme, userStatus, nomLong ";
			$sql .= "FROM ".PFX."profsApplications AS pa";
			$sql .= "JOIN ".PFX."applications AS a ON ";
			$sql .= "(a.nom = pa.application) ";
			$sql .= "WHERE acronyme='$acronyme' AND active ";
			$sql .= "ORDER BY ordre ";
			$resultat = $connexion->query($sql);
			$applications=array();
			while ($ligne = $resultat->fetch()) {
				$data['nom'] = $ligne['nom'];
				$data['nomLong'] = $ligne['nomLong'];
				$data['userStatus'] = $ligne['userStatus'];
				array_push($applications, $data);
				}
			}
	Application::DeconnexionPDO ($connexion);
	return $applications;
}

function newUser () {
$newUser = array (
		"acronyme"=>"", "nom"=>"", "prenom"=>"", "sexe"=>"", "titulaire"=>"",
		"mail"=>"", "telephone"=>"", "GSM"=>"", "mdp"=>"", "droits"=>array());
$appliDroits = array();
// liste de toutes les applications actives
$applis = listeApplis(true);
foreach ($applis as $nom=>$nomLong) {
	$appliDroits[$nom]=array('nomLong'=>$nomLong, 'droits'=>'none');
	}
$newUser['droits']=$appliDroits;
return $newUser;
}



/*
 * function listOrphanEleves
 * @param
 * Recherche de tous les élèves qui n'ont pas de cours
 */
function listOrphanEleves () {
	$eleves = array();
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT codeInfo, CONCAT(nom,' ', prenom) AS nom, groupe ";
	$sql .= "FROM ".PFX."eleves ";
	$sql .= "WHERE codeInfo NOT IN (SELECT codeInfo FROM ".PFX."elevesCours)";
	$sql .= "ORDER BY groupe, nom;";
	$resultat = $connexion->query($sql);
	while ($ligne = $resultat->fetch()) {
		$codeInfo = $ligne['codeInfo'];
		$eleves[$codeInfo] = $ligne['groupe'].": ".$ligne['nom'];
		}
	Application::DeconnexionPDO($connexion);
	return $eleves;
	}



// --------------------------------------------------------------------
// changement d'utilisateur en gardant les droits admins
function changeUserAdminDansApplication ($acronyme) {
	$listeApplications = $_SESSION[APPLICATION]->getApplications();
	// conserver l'appli 'admin'
	$appliAdmin = array('admin'=>$listeApplications['admin']);

	// préparer un nouvel utilisateur avec l'acronyme souhaité
	// $utilisateur = new user($acronyme);
	$_SESSION[APPLICATION] = new user($acronyme);

    // forcer le statut à celui de l'utilisateur "admin"
    $_SESSION[APPLICATION]->setStatut('admin');
	// on force la valeur "admin" pour chacune des applications de l'utilisateur
	$_SESSION[APPLICATION]->setApplicationsAdmin();
	// ajoute l'application "admin" pour cet utilisateur lambda
	$_SESSION[APPLICATION]->addAppli($appliAdmin);
	$qui = $_SESSION[APPLICATION]->identite();
	return $qui['prenom']." ".$qui['nom'].": ".$qui['acronyme'];
	}

/**
 * function backupTables
 * @param $listeTables
 * On fournit une liste de tables; la procédure fabrique un fichiers .sql
 * permettant la restauration des tables désignées
 */
function backupTables($post) {
	$listeTables = array();
	// seuls les inputs dont le nom commence par "check" sont à considérer
	foreach ($post as $unItem=>$value) {
		if (strstr($unItem, "check")) {
			$data = explode("_",$unItem);
			$listeTables[] = "didac_".$data[1];
			}
		}
	$listeTables = implode(" ",$listeTables);
	$fileName = date("Y-m-d:Hms").".sql";
	$output = exec("mysqldump -u ".NOM." --host=".SERVEUR." --password=".MDP." ".BASE." --tables $listeTables > save/$fileName") ;
	return $fileName;
}
	
?>
