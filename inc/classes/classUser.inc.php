<?php

class user {
	private $acronyme;
	private $identite;			// données personnelles
	private $identification;  	// données réseau IP,...
	private $applicationName;
	private $applications;		// les applications accessibles par l'utilisateur
	private $listeCours;		// les cours de ce prof
	private $titulaire;			// la ou les classes dont il/elle est titulaire
	private $aliase;

	// --------------------------------------------
	// fonction constructeur
	function __construct($acronyme=Null) {
	if (isset($acronyme)) {
		$this->acronyme = $acronyme;
		$this->applicationName = APPLICATION;
		$this->identite = $this->identite();
		$this->identification = $this->identification();
		$this->applications = $this->applications($acronyme);
		$this->listeCours = $this->listeCoursProf();
		$this->titulaire = $this->listeTitulariats($acronyme);
		// variable de session de l'administrateur qui a pris un alias
		$this->alias = Null;
		}
	}
	/**
	 * retourne toutes les informations de la table des profs pour l'utilisateur actif
	 * @param
	 * @return array
	 */
	public function identite ($refresh=false){
		if (!(isset($this->identite)) || $refresh) {
			if (is_array($this->acronyme))
				$acronyme = (string)$this->acronyme[0];
				else $acronyme = $this->acronyme;
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = "SELECT * FROM ".PFX."profs ";
			$sql .= "WHERE acronyme = '$acronyme' LIMIT 1 ";
			$resultat = $connexion->query($sql);
			if ($resultat) {
				$resultat->setFetchMode(PDO::FETCH_ASSOC);
				$this->identite = $resultat->fetch();
				}
			Application::DeconnexionPDO($connexion);
			}
		return $this->identite;
		}

	/**
	 * une fonction qui retourne l'acronyme de l'utilisateur
	 * @param
	 * @return string
	 */
	public function acronyme(){
		return $this->acronyme;
		}

	/**
	 * retourne le nom de l'application; permet de ne pas confondre deux applications
	 * différentes qui utiliseraient la variable de SESSION pour retenir MDP et USERNAME
	 * de la même façon.
	 * @param
	 * @return string
	 */
	function applicationName() {
		return $this->applicationName;
	}

	/**
	 *r echerche de la liste des classes dont le professeur est titulaire (prof principal)
	 * @param $sections: les sections éventuelles dans lesquelles chercher
	 * @return array : tableau des classes dont l'utilisateur est titulaire
	 */
	public function listeTitulariats ($sections=Null) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$acronyme = $this->getAcronyme();
		$sql = "SELECT classe ";
		$sql .= "FROM ".PFX."titus ";
		$sql .= "WHERE acronyme='$acronyme' ";
		if ($sections != Null)
			$sql .= "AND section IN ($sections) ";
		$sql .= "ORDER BY classe ";
		$resultat = $connexion->query($sql);
		$titulariats = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$classe = $ligne['classe'];
				$titulariats[$classe]=$ligne['classe'];
				}
			}
		Application::DeconnexionPDO($connexion);
		return $titulariats;
		}

	/**
	 * vérifie que l'utilisateur dont on fournit l'acronyme existe dans la table des profs
	 * @param $acronyme
	 * @return array : l'acronyme effectivement trouvé dans la BD ou rien si pas trouvé
	 */
	public static function userExists($acronyme) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT acronyme FROM ".PFX."profs ";
		$sql .= "WHERE acronyme = '$acronyme'";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			}
		Application::DeconnexionPDO($connexion);
		return ($ligne['acronyme']);
		}

	/**
	 * fixe la valeur de l'alias éventuel en mémorisant la $_SESSION de l'admin
	 * @param $session : la session de l'amdin
	 * @return
	 */
	public function setAlias($session){
		$this->alias = $session;
		}

	/**
	 * retourne l'acronyme éventuel de l'admin qui utilise un alias
	 * @param void()
	 * @return string
	 */
	public function getAlias(){
		return $this->alias;
		}

	/**
	 * détermine les applications autorisées (en excluant éventuellement les application inactives) pour l'utilisateur courant
	 * @param $active : boolean true si l'on souhaite ne sélectionner que les applications non désactivées par l'administrateur
	 * @return array
	 */
	private function applications($actives=false) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$acronyme = $this->getAcronyme();
		$sql = "SELECT a.*, pa.userStatus ";
		$sql .= "FROM ".PFX."applications AS a ";
		$sql .= "JOIN ".PFX."profsApplications AS pa ON ";
		$sql .= "(a.nom = pa.application) ";
		$sql .= "WHERE acronyme = '$acronyme' AND userStatus != 'none' ";
		if ($actives) $sql .= "AND active = 1 ";
		$sql .= "ORDER BY ordre, lower(nom), userStatus ";
		$resultat = $connexion->query($sql);
		$applis = array();
		if ($resultat) {
			while ($uneApplication = $resultat->fetch()) {
				$nom = $uneApplication['nom'];
				$applis[$nom]['nomLong'] = $uneApplication['nomLong'];
				$applis[$nom]['URL'] = $uneApplication['URL'];
				$applis[$nom]['icone'] = $uneApplication['icone'];
				$applis[$nom]['userStatus'] = $uneApplication['userStatus'];
				}
			}
		Application::DeconnexionPDO($connexion);
		return $applis;
	}

	/**
	 * renvoie la liste des applications accessibles à l'utilisateur actif
	 * @param
	 */
	public function getApplications() {
		return $this->applications;
	}

	/**
	 * rend l'utilisateur actif "admin" de toutes les applications pour lesquelles il a des droits
	 * @param
	 * @return void()
	 */
	public function setApplicationsAdmin() {
		//foreach ($this->applications as $nomAppli=>&$detailsAppli) {
			//$detailsAppli['userStatus'] = 'admin';
			// }
		}

	/**
	 * on ajoute une application disponible à la liste des applications de l'utilistateur
	 * typiquement, l'application 'admin' lorsque l'on prend un alias
	 * @param array $appli
	 * @return void()
	 */
	function addAppli($appli) {
		$key = current(array_keys($appli));
		$module = current($appli);
		$this->applications[$key] = $module;
	}

	/**
	 * vérifie que l'on dispose d'un nom d'utilisateur et d'un mot de passe pour l'application
	 * le nom de l'application est vérifié au cas où deux applications différentes utiliseraient
	 * les sessions de la même façon
	 * @param $nomApplication
	 * @return boolean
	 */
	function accesApplication ($nomApplication) {
		// vérifier que l'utilisateur est identifié pour l'application active
		$identite = $this->identite();
		return (($this->applicationName() == $nomApplication) && isset($identite['acronyme']) && isset($identite['mdp']));
	}

	/**
	 * Vérification que l'utilisateur actuel a les droits pour accéder à un module de l'application
	 * @param $BASEDIR
	 * @return boolean
	 */
	public function accesModule($BASEDIR) {
		$appliAutorisees = array_keys($this->applications);
		$dir = array_reverse(explode("/",getcwd()));
		$repertoireActuel = $dir[0];
		if (!(in_array($repertoireActuel, $appliAutorisees)))
			header("Location: ".BASEDIR."index.php");
			else return true;
	}

	/**
	 * renvoie la liste des cours donnés par l'utilisateur courant; possibilité de demander les cours par section (GT, TQ, ...)
	 * @param string sections : liste des sections, chacune étant entourée de guillemets simples
	 * @return array : liste de tous les cours données par le prof utilisateur actuel
	 */
	public function listeCoursProf ($sections=Null) {
		$acronyme = $this->getAcronyme();
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT DISTINCT nbheures, SUBSTR(pc.coursGrp,1,LOCATE(':',pc.coursGrp)-1) as annee, ";
		$sql .= "pc.coursGrp, nomCours, libelle, statut ";
		$sql .= "FROM ".PFX."profsCours AS pc ";
		$sql .= "JOIN ".PFX."elevesCours AS ec ON (ec.coursGrp = pc.coursGrp) ";
		$sql .= "JOIN ".PFX."eleves AS e ON (e.matricule = ec.matricule) ";
		$sql .= "JOIN ".PFX."cours AS c ON (SUBSTR(pc.coursGrp,1,LOCATE('-', pc.coursGrp)-1) = c.cours) ";
		$sql .= "JOIN ".PFX."statutCours ON (".PFX."statutCours.cadre = c.cadre) ";
		$sql .= "WHERE acronyme = '$acronyme' ";
		if ($sections) {
			$sql .= "AND c.section IN ($sections) ";
			}
		$sql .= "ORDER BY annee, libelle, nbheures, pc.coursGrp";
		$resultat = $connexion->query($sql);
		$listeCours = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$coursGrp = $ligne['coursGrp'];
				$listeCours[$coursGrp] = array(
						'libelle'=>$ligne['libelle'],
						'nomCours'=>$ligne['nomCours'],
						'annee'=>$ligne['annee'],
						'coursGrp'=>$coursGrp,
						'statut'=>$ligne['statut'],
						'nbheures'=>$ligne['nbheures']
						);
				}
			}
		Application::DeconnexionPDO($connexion);
		$this->listeCours = $listeCours;
		return $this->listeCours;
	}

	### --------------------------------------------------------------------###
	function toArray () {
		return (array) $this;
		}

	/**
	 * ajout de l'utilisateur dans le journal des logs
	 * @param $acronyme	: acronyme de l'utilisateur
	 * @return integer
	 */
	public function logger ($acronyme) {
		$ip = $_SERVER['REMOTE_ADDR'];
		$hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
		$date = date("Y-m-d");
		$heure = date("H:i");
		$user = $acronyme;

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "INSERT INTO ".PFX."logins ";
		$sql .= "SET user='$user', date='$date', heure='$heure', ip='$ip', host='$hostname'";
		$n = $connexion->exec($sql);

		$sql = "INSERT INTO ".PFX."sessions ";
		$sql .= "SET user='$user', ip='$ip' ";
		$sql .= "ON DUPLICATE KEY UPDATE ip='$ip' ";

		$n = $connexion->exec($sql);
		Application::DeconnexionPDO ($connexion);
		return $n;
	}

	/**
	 * délogger l'utilisateur indiqué de la base de données (table des sessions actives)
	 * @param $acronyme : acronyme de l'utilisateur
	 * @return integer : nombre d'effacement dans la BD
	 */
	public function delogger() {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$acronyme = $this->acronyme();
		$sql = "DELETE FROM ".PFX."sessions ";
		$sql .= "WHERE user='$acronyme' ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO ($connexion);
		return $resultat;
		}

	/**
	 * vérifier que l'utilisateur dont on fournit l'acronyme est signalé comme loggé depuis l'adresse ip dans la BD
	 * @param $acronyme : string
	 * @param $ip : string
	 */
	public function islogged($acronyme,$ip) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT user, ip ";
		$sql .= "FROM ".PFX."sessions ";
		$sql .= "WHERE user='$acronyme' AND ip='$ip' ";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$verif = $resultat->fetchAll();
			}
		Application::DeconnexionPDO ($connexion);
		return (count($verif) > 0);
		}

	/**
	 * enregistrement des données personnelles de l'utilisateur, provenant d'un formulaire
	 * @param $post
	 * @return integer : nombre de modifications dans la BD
	 */
	public function saveDataPerso ($post) {
		$data = array();

		// nom, prenom, sexe et statut ne peuvent être modifiés que par l'administrateur
		// si les infos proviennent d'un formulaire 'utilisateur', il n'a pas pu
		// les modifier: ces infos ne figurent pas dans le formulaire "utlisateur"
		$data['acronyme'] = (isset($post['acronyme']))?$post['acronyme']:Null;
		$data['nom'] = (isset($post['nom']))?$post['nom']:Null;
		$data['prenom'] = (isset($post['prenom']))?$post['prenom']:Null;
		$data['sexe'] = (isset($post['sexe']))?$post['sexe']:Null;
		// le changement de statut n'est possible que pour l'administrateur
		// le champ "statut" n'est pas disponible dans le formulaire de modification du profil de l'utilisateur
		if (isset($post['statut']))
			$data['statut'] = $post['statut'];
		// ----------------------------------------------------------------

		$data['mail'] = $post['mail'];
		$data['telephone'] = $post['telephone'];
		$data['GSM'] = $post['GSM'];
		// s'il s'agit de l'enregistrement personnel des données (l'adresse figure dans ce formulaire)
		if (isset($post['adresse'])) {
			$data['adresse'] = $post['adresse'];
			$data['commune'] = $post['commune'];
			$data['codePostal'] = $post['codePostal'];
			$data['pays'] = $post['pays'];
			}
		// si le mot de passe est indiqué, il est présent deux fois dans le formulaire "utilisateur"
		// dans ce cas, il faut vérifier la correspondance
		if (isset($post['mdp']) && isset($post['mdp2']))
			if ($post['mdp'] != $post['mdp2']) die(PASSWDNOTMATCH);
		// s'il y a un mot de passe, alors on en tient compte
		if (isset($post['mdp']) && ($post['mdp'] != ''))
			$data['mdp'] = md5($post['mdp']);

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

		$tableauSqlInsert = $tableauSqlUpdate = array();
		foreach ($data as $key=>$value) {
			// échappement des caractères spéciaux avec PDO
			$value = $connexion->quote($value);
			$tableauSqlInsert[] = "$key = $value";
			}
		unset($data['acronyme']);
		foreach ($data as $key=>$value) {
			// échappement des caractères spéciaux avec PDO
			$value = $connexion->quote($value);
			$tableauSqlUpdate[] = "$key = $value";
			}
		$nb = 0;
		$sql = "INSERT INTO ".PFX."profs SET ";
		$sql .= implode(",",$tableauSqlInsert);
		$sql .= " ON DUPLICATE KEY UPDATE ";
		$sql .= implode(",",$tableauSqlUpdate);

		$resultat = $connexion->exec($sql);
		if ($resultat > 0)
			$nb++;  // en cas de "update", le nombre figurant dans $resultat = 2!!!
		Application::DeconnexionPDO ($connexion);
		return $nb;
	}

	/**
	* enregistrement des droits sur les différentes applications; données
	* issues du formulaire de modification des données personnelles
	* @param $post
	* @param $listeApplis
	* @return integer : nombre de modifications dans la BD
	*/
   public function saveDataApplis($post, $listeApplis) {
	   $acronyme = $post['acronyme'];
	   // liste des applications actives (true) existantes
	   $tableauApplisDroits = array();
	   // on passe toutes les applications en revue et on sort ce qui se trouvait dans $_POST
	   foreach ($listeApplis as $nomAppli=>$nomLong) {
		   $droit = $post[$nomAppli];
		   if ($droit == '') $droit = 'none';
		   $tableauApplisDroits[$nomAppli] = $droit;
		   }
	   $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	   $sql = "INSERT INTO ".PFX."profsApplications ";
	   $sql .= "SET application=:application,userStatus=:userStatus,acronyme=:acronyme ";
	   // en cas de doublon, seul le userStatus est modifié
	   $sql .= "ON DUPLICATE KEY UPDATE userStatus=:userStatus ";
	   $requete = $connexion->prepare($sql);
	   $nbResultats = 0;
	   foreach ($tableauApplisDroits as $application=>$userStatus) {
		   $data = array('application'=>$application, 'userStatus'=>$userStatus, 'acronyme'=>$acronyme);
			$nbResultats += $requete->execute($data);
		   }
	   Application::DeconnexionPDO($connexion);
	   return $nbResultats;
	   }

	/**
	 * Enregistrement du mot de passe dans la BD à partir des informations provenant d'un formulaire
	 * function savePwd
	 * @param $post
	 */
	public function savePwd ($post) {
		$acronyme = $this->identite['acronyme'];
		$mdp = isset($post['mdp'])?$post['mdp']:Null;
		$mdp2 = isset($post['mdp2'])?$post['mdp2']:Null;
		if (strlen($mdp) >= 6)
			if ($mdp == $mdp2) {
					$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
				$mdp = md5($mdp);
				$sql = "UPDATE ".PFX."profs ";
				$sql .= "SET mdp = '$mdp' ";
				$sql .= "WHERE acronyme = '$acronyme' ";
				$nbModif = $connexion->exec($sql);
				Application::DeconnexionPDO($connexion);
				return $nbModif;
				}
		return $nbModif;
	}

	/**
	 * fournit le mot de passe MD5 de l'utilisateur
	 * @param
	 * @return string
	 */
	public function getPasswd() {
		return $this->identite['mdp'];
	}

	/**
	 * renvoie l'acronyme (userName) de l'utilisateur courant
	 * @param
	 */
	public function getAcronyme() {
		return $this->identite['acronyme'];
	}

	/**
	 * renvoie le statut global de l'utlilisateur
	 * @param
	 * @return string
	 */
	public function getStatut() {
		return $this->identite['statut'];
	}

	/**
	 * fixer le statut global de l'application à un niveau donné
	 * @param $statut
	 * @return void()
	 */
	public function setStatut($statut) {
		$this->identite['statut'] = $statut;
		}

	/**
	 * renvoie l'adresse mail de l'utilisateur courant
	 */
	public function getMail() {
		return $this->identite['mail'];
		}

	/**
	* renvoie le nom et le prénom de l'utilisateur
	* @param void()
	* @return array : 'nom'=>$nom, 'prenom'=>$prenom
	*/
	private function getNom(){
		$nom = $this->identite['nom'];
		$prenom = $this->identite['prenom'];
		return array('nom'=>$nom, 'prenom'=>$prenom);
	}

	/**
	 * renvoie les informations d'identification réseau de l'utilisateur courant
	 * @param
	 * @return array ip, hostname, date, heure
	 */
	public static function identification () {
		$data = array();
		$data['ip'] = $_SERVER['REMOTE_ADDR'];
		$data['hostname'] = gethostbyaddr($_SERVER['REMOTE_ADDR']);
		$data['date'] = date("d/m/Y");
		$data['heure'] = date("H:i");
		return $data;
	}

	/**
	 * renvoie l'adresse IP de connexion de l'utilisateur actuel
	 * @param
	 * @return string
	 */
	 public function getIP(){
		$data = $this->identification();
		return $data['ip'];
		 }

	/**
	 * renvoie le nom de l'hôte correspondant à l'IP de l'utilisateur en cours
	 * @param
	 * @return string
	 */
	public function getHostname() {
		$data = $this->identification();
		return $data['hostname'];
		}

	/**
	 * si une photo est présente, retourne l'acronyme du prof; sinon, retourne Null
	 * @param $acronyme
	 */
	public function photoExiste () {
		if (file_exists(INSTALL_DIR."/photosProfs/".$this->getAcronyme().".jpg"))
			return $this->acronyme;
			else return Null;
	}

	/**
	 * renvoie la liste des logs de l'utilisateur en cours
	 * @param $acronyme
	 * @return array
	 */
	public function getLogins () {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."logins WHERE user='".$this->getAcronyme()."' ORDER BY date,heure ASC";
		$resultat = $connexion->query($sql);
		$logins = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$logins = $resultat->fetchall();
			}
		return $logins;
		}

	/**
	* renvoie la liste des cours de l'utilisateur actif
	* @param void()
	* @return array
	*/
	public function getListeCours(){
		return $this->listeCours;
	}

	/**
	* vérification que les données passées dans le formulaire de modification des données personnelles sont admissibles
	* @param $post
	* @return string
	*/
   public function verifFormulairePerso ($post) {
	   foreach ($post as $key=>$value)
		   $$key = $value;
	   $erreur = "";
	   if ($acronyme == Null) $erreur = MISSINGUSERNAME;
	   if ($nom == Null) $erreur .= MISSINGNAME;
	   if ($prenom == Null) $erreur .= MISSINGLASTNAME;
	   if ($mail == Null) $erreur .= MISSINGMAIL;
	   // un mot de passe est indispensable pour un premier enregistrement
	   if ($oldUser == false)
		   if ($mdp == Null) $erreur .= MISSINGPASSWD;
	   if ($erreur != "") {
		   $erreur = FORMERRORS.$erreur;
		   }
	   return $erreur;
	   }

	/**
	 * retourne le statut de l'utilisateur dans l'application donnée
	 * @param $appli
	 * @return string
	 */
	public function userStatus ($appli) {
		$applications = $_SESSION[APPLICATION]->applications;
		if (isset($applications[$appli]))
			$resultat = isset($applications[$appli])?$applications[$appli]['userStatus']:Null;
	return $resultat;
	}

	/**
	 * retourne toutes les informations d'identité d'un utilisateur "prof" dont on fournit l'acronyme
	 * @param $acronyme
	 * @return array
	 */
	public static function identiteProf ($acronyme) {
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT * FROM ".PFX."profs WHERE acronyme = '$acronyme' ";
	$ligne = array();
	$resultat = $connexion->query($sql);
	if ($resultat) {
		$ligne = $resultat->fetch();
		}
	Application::DeconnexionPDO($connexion);
	return $ligne;
}

	/**
	 * @param $acronyme
	 * @param $Application : objet Application
	 */
	public static function oldUser ($acronyme) {
		$user = self::identiteProf($acronyme);
		return $user;
		}

	// /**
	//  * retourne toutes les applis accessibles à un utilisateur et le statut de l'utilisateur dans chacune d'elles
	//  * @param void()
	//  * @return array
	//  */
	// public function applisUser () {
	// 	$acronyme = $this->getAcronyme();
	// 	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	// 	$sql = "SELECT application as nom, nomLong, userStatus ";
	// 	$sql .= "FROM ".PFX."profsApplications AS pa ";
	// 	$sql .= "JOIN ".PFX."applications AS a ON (a.nom = pa.application) ";
	// 	$sql .= "WHERE acronyme='$acronyme' AND active ";
	// 	$resultat = $connexion->query($sql);
	// 	$tableauApplisUser = array();
	// 	while ($ligne = $resultat->fetch()) {
	// 		$nom = $ligne['nom'];
	// 		$nomLong = $ligne['nomLong'];
	// 		$userStatus = $ligne['userStatus'];
	// 		$tableauApplisUser[$nom]= array('userStatus'=>$userStatus, 'nomLong'=>$nomLong);
	// 		}
	// 	Application::DeconnexionPDO ($connexion);
	// 	return $tableauApplisUser;
	// 	}

	/**
	 * renvoie le statut de l'utilisateur actuel pour le module $module
	 * @param string $module : le module concerné
	 * @return string : le statut de l'utilsateur
	 */
	public function getUserStatus($module) {
		return $this->applications[$module]['userStatus'];
	}

	/**
	* rechercher ou deviner l'adresse mail de l'utilisateur (si nouvel utilisateur)
	* @param $guessDomaine : domaine probable
	* @return string : l'adresse mail @ecole.org
	*/
	public function guessUserMail($guessDomaine){
		$mail = $this->getMail();
		$user = explode('@',$mail)[0];
		$domaine = explode('@',$mail)[1];
		if ($domaine == $guessDomaine)
			return($user);
			else {
				$fullName = $this->getNom();
				$p = substr(strtolower(Application::stripAccents($fullName['prenom'])),0,1);
				$indesirables = array(" ", "-", "'");
				$n = str_replace($indesirables,'',strtolower(Application::stripAccents($fullName['nom'])));
				return $p.$n;
				}
		}

}
?>
