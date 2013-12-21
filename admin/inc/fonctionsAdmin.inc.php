<?php
require_once(INSTALL_DIR."/inc/classes/classUser.inc.php");

///*
// * function checkFileType
// * @param $file
// */
//function checkFileType($fileName) {
//	$finfo = finfo_open(FILEINFO_MIME);
//	return (finfo_file($finfo, $fileName));
//}

///*
// * function csv2array
// * @param $fileName
// * transforme un fichier .csv uploadé en un array()
// */
//function csv2array ($fileName) {
//	$handle = fopen($fileName.".csv","r");
//	if (!($handle)) die("file not open");
//	$tableau = array();
//	while (($data = fgetcsv($handle,10000,',','"')) !== FALSE) {
//		$tableau[] = $data;
//		}
//	fclose($handle);
//	return $tableau;
//	}

/*
// * function SQLtableFields2array
// * @param $table
// * renvoie un tableau indiquant les noms des champs de la table MySQL indiquée
// */
//function SQLtableFields2array ($table) {
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	// recherche des noms des champs dans la table visée
//	$sql = "SHOW FULL COLUMNS FROM ".PFX."$table";
//	$resultat = $connexion->query($sql);
//	$champs = array();
//	if ($resultat) {
//		$resultat->setFetchMode(PDO::FETCH_ASSOC);
//		$champs = $resultat->fetchall();
//		}
//	Application::DeconnexionPDO ($connexion);
//	return $champs;
//	}
///*
// * function nomsChampsBD
// * @param $table
// * retourne le nom des différents champs d'une table dont on fournit le nom
// */
//function nomsChampsBD($champs) {
//	$nomChamps = array();
//	foreach ($champs as $unChamp) {
//		$nomChamps[] = $unChamp['Field'];
//	}
//	return $nomChamps;
//}
//
///*
// * function tablePrimKeys
// * retourne les noms des champs qui sont Primary keys
// * @param $table
// */
//function tablePrimKeys ($table) {
// 	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	$sql = "SHOW KEYS FROM ".PFX."$table WHERE Key_name = 'PRIMARY' ";
//	$resultat = $connexion->query($sql);
//	$resultat->setFetchMode(PDO::FETCH_ASSOC);
//	// la colonne 4 contient les noms des champs "PRIMARY"
//	$keys = $resultat->fetchall(PDO::FETCH_COLUMN, 4);
//	Application::DeconnexionPDO($connexion);
//	return $keys;
//	}

///*
// * function listeTables
// * @param $base, $application
// * fournit la liste des tables pour l'application donnée
// * si pas d'application précisée, donne la liste de toutes les tables
// * cette liste des tables doit, elle-même, figurer dans une table
// * de l'application 'admin'
//  */
//function listeTables($base, $application=Null) {
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	$sql = "SELECT application, nomTable FROM ".PFX."appliTables ";
//	if ($application) $sql .= "WHERE application = '$application'";
//	try {
//		$resultat = $connexion->query($sql);
//		}
//		catch(PDOException $e){
//			die ($e->getMessage());
//		}
//	$listeTables = array();
//	if ($resultat) {
//		$resultat->setFetchMode(PDO::FETCH_ASSOC);
//		$listeTables = array();
//		while ($ligne = $resultat->fetch()) {
//			$application = $ligne['application'];
//			$listeTables[$application][] = $ligne['nomTable'];
//			}
//		}
//	Application::DeconnexionPDO ($connexion);
//	return $listeTables;
//}
	
## ---------------------------------------------------------------##
//function SQLtable2array ($table) {
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	$sql = "SELECT * FROM ".PFX."$table";
//	$resultat = $connexion->query($sql);
//	$tableau = array();
//	if ($resultat) {
//		$resultat->setFetchMode(PDO::FETCH_ASSOC);
//		$tableau = $resultat->fetchall();
//		}
//	Application::DeconnexionPDO ($connexion);
//	return $tableau;
//}

	
## ---------------------------------------------------------------##
//function hiatus ($entete, $champs) {
//	// y a-t-il des éléments de l'entete du fichier CSV qui ne figurent pas
//	// dans la table de la BD et inversement
//	$hiatus1 = array_diff($entete, $champs);
//	$hiatus2 = array_diff($champs,$entete);
//	$lesProblemes = array();
//	if ($hiatus1 || $hiatus2) {
//		foreach ($hiatus1 as $unProbleme)
//			$lesProblemes[0][] = $unProbleme;
//		foreach ($hiatus2 as $unProbleme)
//			$lesProblemes[1][] = $unProbleme;
//		}
//	return $lesProblemes;
//}

///*
// * function CSV2MySQL
// * @param $table
// * Enregistrement d'un fichier CSV dans la table MySQL correspondante
// * Le contenu du fichier CSV a été préalablement vérifié et validé à l'écran
// */
//function CSV2MySQL ($table) {
//	$tableauCSV = csv2array($table);
//	// isolement de la première ligne du tableau qui contient les noms des champs
//	// pour la requête INSERT
//	$champsInsert = array_shift($tableauCSV);
//	// détermination des clefs primaires de la table
//	$primKeys = tablePrimKeys($table);
//	// détermination des champs pour la requête UPDATE
//	$champsUpdate = array_diff($champsInsert, $primKeys);
//
//	$sql = "INSERT INTO ".PFX."$table (".implode(',', $champsInsert).") VALUES (";
//	$valuesInsert=array();
//	foreach ($champsInsert as $unChamp) {
//		$valuesInsert[] = ":".$unChamp;
//		}
//	$sql .= implode(',',$valuesInsert).") ";
//	$valuesUpdate = array();
//	foreach ($champsUpdate as $unChamp) {
//		 $valuesUpdate[]= "$unChamp=:$unChamp";
//		}
//	// si tous les champs sont des clés primaires, il n'y a pas d'Update possible
//	if ($valuesUpdate) $sql .= "ON DUPLICATE KEY UPDATE ".implode(',',$valuesUpdate);
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
// 	$connexion->beginTransaction();
//	$requete = $connexion->prepare($sql);
//	$ajouts = 0; $erreurs = 0;
//	foreach ($tableauCSV as $uneLigne) {
//		$insert = array_combine($champsInsert,$uneLigne);
//		if ($requete->execute($insert))
//			$ajouts++;
//			else $erreurs++;
//		}
// 	$connexion->commit();
//	Application::DeconnexionPDO($connexion);
//	return array("erreurs"=>$erreurs,"ajouts"=>$ajouts);
//}
//
//// --------------------------------------------------------------------
//// fonction pour fixer les mots de passe des élèves qui n'en sont pas encore pourvus
//function newPasswdAssign ($table) {
//	$tableauCSV = csv2array($table);
//	$entete = array_shift($tableauCSV);
//	$erreurs = 0; $ajouts = 0;
//	$tousEleves = listeTousEleves();
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	foreach ($tableauCSV as $unEleve) {
//		$matricule = $unEleve[0];
//		$passwd = $unEleve[2];
//		$eleve = $tousEleves[$matricule];
//		$nom = $tousEleves[$matricule]['nom'];
//		$prenom = $tousEleves[$matricule]['prenom'];
//		$username = username($matricule, $nom, $prenom);
//		$sql = "INSERT INTO ".PFX."passwd ";
//		$sql .= "SET matricule='$matricule',passwd='$passwd', user='$username' ";
//		// en cas de doublon, seul le "mot de passe" est modifié
//		$sql .= "ON DUPLICATE KEY UPDATE passwd='$passwd' ";
//		$resultat = $connexion->exec($sql);
//		if ($resultat === false)
//			$erreurs++;
//			else $ajouts++;
//		}
//	Application::DeconnexionPDO($connexion);
//	return array("erreurs"=>$erreurs, "ajouts"=>$ajouts);
//	}
	
// fonction pour supprimer les anciens élèves dont on fournit une liste dans une $table
//function suppressionAnciens ($table) {
//	APPLICATION::afficher($table, true);
//	$tableauCSV = csv2array($table);
//	$entete = array_shift($tableauCSV);
//
//	$suppressions = 0;
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	$sql = "SELECT DISTINCT TABLE_NAME, COLUMN_NAME ";
//	$sql .= "FROM INFORMATION_SCHEMA.COLUMNS ";
//	$sql .= "WHERE column_name LIKE 'matricule' AND TABLE_NAME LIKE ".PFX."%";
//
//	$resultat = $connexion->query($sql);
//	if ($resultat) {
//		$listeTables = $resultat->fetchAll();
//	}
//	
//	$sql = "DELETE FROM ".PFX."eleves ";
//	$sql .= "WHERE matricule = :matricule";
//	$connexion->prepare($sql);
//	foreach ($tableauCSV as $unEleve) {
//		$matricule = $unEleve[0];
//		$resultat = $connexion->execute($matricules);
//		if ($resultat === true)
//			$suppressions++;
//		}
//	Application::DeconnexionPDO($connexion);
//	return $suppressions;
//}

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
// liste des applications existantes, 
//function listeApplisSERTAQUOI($actives='') {
//	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
//	$sql = "SELECT nom, nomLong, active FROM ".PFX."applications ";
//	if ($actives)
//		$sql .= "WHERE active ";
//	$sql .= "ORDER BY ordre, LOWER(nom)";
//	$resultat = $connexion->query($sql);
//	$liste = array();
//	while ($ligne = $resultat->fetch()) {
//		$nom = $ligne['nom'];
//		$nomLong = $ligne['nomLong'];
//		$liste[$nom] = $nomLong;
//		}
//	Application::DeconnexionPDO($connexion);
//	return $liste;
//}

## ---------------------------------------------------------------##
// retourne toutes les applis accessibles à un utilisateur
// et le statut de l'utilisateur dans chacune d'elles
/* function applisUser ($acronyme) {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT application as nom, nomLong, userStatus ";
	$sql .= "FROM ".PFX."profsApplications AS pa ";
	$sql .= "JOIN ".PFX."applications AS a ON (a.nom = pa.application) ";
	$sql .= "WHERE acronyme='$acronyme' AND active";
	$resultat = $connexion->query($sql);

	$tableauApplisUser = array();
	while ($ligne = $resultat->fetch()) {
		$nom = $ligne['nom'];
		$nomLong = $ligne['nomLong'];
		$userStatus = $ligne['userStatus'];
		$tableauApplisUser[$nom]= array('userStatus'=>$userStatus, 'nomLong'=>$nomLong);
		}
	Application::DeconnexionPDO ($connexion);
	return $tableauApplisUser;	
} */

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
## ---------------------------------------------------------------##
/* function identiteProf ($acronyme) {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT * FROM ".PFX."profs WHERE acronyme = '$acronyme'";
	$resultat = $connexion->query($sql);
	$ligne = $resultat->fetch();
	Application::DeconnexionPDO($connexion);
	return $ligne;
} */
## ---------------------------------------------------------------##
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


## ---------------------------------------------------------------##
/* function oldUser ($acronyme) {
	// liste de toutes les applications actives
	$user = identiteProf($acronyme);
	$applis = Application::listeApplis(true);
	$applisUser = applisUser($acronyme);
	$appliDroits = array();
	foreach ($applis as $nom=>$nomLong) {
		if (isset($applisUser[$nom]))
			$appliDroits[$nom]=array('nomLong'=>$nomLong, 'droits'=>$applisUser[$nom]['userStatus']);
			else $appliDroits[$nom]=array('nomLong'=>$nomLong, 'droits'=>'none');
		}
	$user['droits'] = $appliDroits;
	return $user;
	}
*/


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



	

//function stripAccents($string){
//	return strtr($string,'àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ',
//'aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY');
//}
//
//function stripIndesirables ($string) {
//	$indesirables = array(" ", "-", "'");
//	$string = str_replace($indesirables,"",$string);
//	return $string;
//}


/*
 * function userName
 * @param $matricules,$nom, $prenom
 * attribue un nom d'utilisateur à un élèves
 * première lettre du prénom, 7 lettres du nom + matricule
 */
//function userName ($matricule, $nom, $prenom) {
//	$nom = strtolower(stripIndesirables(stripAccents($nom)));
//	$prenom = strtolower(stripIndesirables(stripAccents($prenom)));
//	$username = substr($prenom,0,1).substr($nom,0, 7).$matricule;
//	return $username;
//	}

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
