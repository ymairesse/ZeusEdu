<?php

/**
* class Retenue
**/

class Retenue {
	
	private $caracteristiques = array();
	
	/**
	 * constructeur de l'objet; si $idretenue est passé, on relit la BD, sinon on produit un nouvel objet de type Retenue
	 * @param $idRetenue
	 * @return
	 */
	function __construct ($idretenue=Null) {
		if (isset($idretenue))
		$this->lireRetenue($idretenue);
		else {
			$this->set('idretenue',Null);
			$this->set('type',0);
			$this->set('occupation',0);
			$this->set('date','');
			$this->set('heure','13h00');
			$this->set('local','');
			$this->set('places','');
			$this->set('duree','1h');
			$this->set('affiche','O');
			}
	}
	
	function set($key, $value) {
		$this->caracteristiques[$key] = $value;
		}

	function get($key){
		return $this->caracteristiques[$key];
		}		
		
	
	/**
	 * relecture des caractéristiques d'une retenue dans la BD
	 * @param $idRetenue : l'identifiant de la retenue
	 * @return
	 */
	public function lireRetenue($idretenue) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."adesRetenues WHERE idretenue='$idretenue'";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			$this->caracteristiques = $resultat->fetch();
			$this->set('dateRetenue', Application::datePHP($this->get('dateRetenue')));
			}
		Application::DeconnexionPDO($connexion);
		}
		
	/**
	 * Enregistrement des caractéristiques d'une retenue depuis un formulaire
	 * @param $post
	 * @return integer : idretenue (connu au départ ou nouvellement enregistré dans la BD)
	 */
	public function saveRetenue($post) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$idretenue = isset($post['idretenue'])?$post['idretenue']:Null;
		$type = $post['typeRetenue'];
		$date = Application::dateMysql($post['date']);
		
		$heure = $post['heure'];
		$duree = $post['duree'];
		$local = addslashes(htmlspecialchars($post['local']));
		$places = $post['places'];
		$occupation = $post['occupation'];
		$affiche = isset($post['affiche'])?'O':'N';
		if (isset($idretenue)) {
			$sql = "UPDATE ".PFX."adesRetenues ";
			$sql .= "SET type='$type', dateRetenue='$date', heure='$heure', duree='$duree', local='$local', places='$places', occupation='$occupation', affiche='$affiche' ";
			$sql .= "WHERE idretenue = '$idretenue' ";
			}
			else {
				$sql = "INSERT INTO ".PFX."adesRetenues ";
				$sql .= "SET type='$type', dateRetenue='$date', heure='$heure', duree='$duree', local='$local', places='$places', occupation='$occupation', affiche='$affiche' ";
			}

		$resultat = $connexion->exec($sql);
		if (!(isset($idretenue)))
			$idretenue = $connexion->lastInsertId();
		Application::DeconnexionPDO($connexion);
		return $idretenue;
		}
		
	/**
	 * Suppression d'une retenue dont on fournit le $idretenue
	 * @param $idretenue
	 * @result integer : nombre de retenues supprimées 1 si OK, 0 si KO
	 */
	public function delRetenue() {
		$idretenue = $this->get('idretenue');
		$type = $this->get('type');
		$occupation = $this->get('occupation');
		if ($occupation == 0) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = "DELETE FROM ".PFX."adesRetenues ";
			$sql .= "WHERE idretenue = '$idretenue' ";
			$resultat = $connexion->exec($sql);
			Application::DeconnexionPDO($connexion);
			return 1;
			}
		else return 0;
		}

	
}




