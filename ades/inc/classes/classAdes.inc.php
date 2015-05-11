<?php

require(INSTALL_DIR."/fpdf17/fpdf.php");
require(INSTALL_DIR."/inc/classes/class.pdfrotate.php");
require(INSTALL_DIR."/inc/classes/class.pdf.php");

/*
 * class Ades
 */
class Ades {

	private $listeTypesFaits;
	private $listeChamps;
	private $typesRetenues;
    /*
     * __construct
     * @param
     */
    function __construct() {
		$this->listeTypesFaits = $this->getListeTypesFaits();
		$this->listeChamps = $this->lireDescriptionChamps();
		$this->typesRetenues = $this->getTypesRetenues();
        }

	/***
	 * liste des utilisateurs du module ADES
	 * @param
	 * @return array
	 */
	public function adesUsersList($module){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT ".PFX."profs.acronyme, CONCAT(prenom,' ',nom) as nomPrenom, userStatus ";
		$sql .= "FROM ".PFX."profs ";
		$sql .= "JOIN ".PFX."profsApplications ON (".PFX."profsApplications.acronyme = ".PFX."profs.acronyme) ";
		$sql .= "WHERE ".PFX."profsApplications.application = '$module' AND userStatus != 'none' ";
		$sql .= "ORDER BY userStatus, nom, prenom ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$acronyme = $ligne['acronyme'];
				$nomPrenom = $ligne['nomPrenom'];
				$status = $ligne['userStatus'];
				$liste[$acronyme] = array('nomPrenom'=>$nomPrenom, 'status'=>$status);
				}
			}
		Application::deconnexionPDO($connexion);
		return $liste;
		}

	/***
	 * return liste de tous les types de faits avec leur description (champs nécessaires)
	 * @param
	 * @return array
	 */
	 private function getListeTypesFaits () {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."adesTypesFaits ";
		$sql .= "ORDER BY ordre";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$type = $ligne['type'];
				$ligne['listeChamps'] = explode(',',$ligne['listeChamps']);
				$ligne['listeChamps'] = str_replace(' ','', $ligne['listeChamps']);
				$liste[$type] = $ligne;
				}
			}
		Application::deconnexionPDO($connexion);
		return $liste;
		}

	/***
	 * renvoie la liste des types de faits existants
	 * @param
	 * @return array
	 */
	public function getTypesFaits() {
		return $this->listeTypesFaits;
	}
	/**
	 * retrouve les différents types de retenues disponibles depuis la liste des types de faits
	 * @param
	 * @return array
	 */
	public function getTypesRetenues(){
		$typesFaits = $this->listeTypesFaits();
		$liste = array(); $liste2 = array();
		foreach ($typesFaits as $type=>$data) {
			$typeRetenue = $data['typeRetenue'];
			if ($typeRetenue != '0') {
				$liste[$typeRetenue]=$data;
			}
		}
		return $liste;
	}

	/**
	 * Lecture de la description des champs dans la BD
	 * @param
	 * @return array
	 */
	private function lireDescriptionChamps(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."adesChamps ";
		$sql .= "ORDER BY champ ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$champ = $ligne['champ'];
				$ligne['contextes'] = explode(',',$ligne['contextes']);
				$liste[$champ] = $ligne;
			}
		}
		Application::deconnexionPDO($connexion);
		return $liste;
		}

	/**
	 * renvoie la liste des types de faits de l'objet
	 * @param
	 * @return array;
	 */
	public function listeTypesFaits(){
		return $this->listeTypesFaits;
		}

	/**
	 * renvoie la description des champs de la BD
	 * @param
	 * @return array
	 */
	public function listeChamps(){
		return $this->listeChamps;;
	}

	/**
	 * renvoie la description des différents types de retenues existantes
	 * @param
	 * @return array
	 */
	public function listeTypesRetenues () {
		return $this->$typesRetenues;
	}

	/**
	 * renvoie la liste des champs pour décrire un fait disciplinaire
	 * @param integer $type
	 * #return array
	 */
	public function structureFait($type) {
		if (!isset($type)) die('no type');
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT type, titreFait, couleurFond, couleurTexte, typeRetenue, listeChamps ";
		$sql .= "FROM ".PFX."adesTypesFaits ";
		$sql .= "WHERE type='$type' ";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$ligne['listeChamps'] = str_replace(' ', '', $ligne['listeChamps']);
			$ligne['listeChamps'] = explode(',', $ligne['listeChamps']);
			}
			else $ligne = Null;
		Application::DeconnexionPDO($connexion);
		return $ligne;
		}

	/**
	 * renvoie la structure nécessaire à l'établissment du formulaire d'édition d'un fait disciplinaire
	 * sans les données
	 * @param integer $type
	 * @return array
	 */
	public function prototypeFait($type) {
		if (!isset($type)) die('no type');
		$structure = $this->structureFait($type);
		$listeChamps = "'".implode("','",$structure['listeChamps'])."'";

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT champ, label, contextes, typeDate, typeDateRetenue, typeChamp, size, maxlength, colonnes,lignes, classCSS, autocomplete ";
		$sql .= "FROM ".PFX."adesChamps ";
		$sql .= "WHERE champ IN ($listeChamps) ";
		$resultat = $connexion->query($sql);
		$prototype = array('structure'=>$structure, 'champs'=>array());
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$champ = $ligne['champ'];
				$prototype['champs'][$champ] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $prototype;
	}

	/**
	 * retourne la liste des retenues disponibles du type spécifié
	 * @param integer $type
	 * @return array
	 */
	public function listeRetenues ($typeRetenue, $affiche=true) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT type, idretenue, dateRetenue, heure, duree, local, places, affiche ";
		$sql .= "FROM ".PFX."adesRetenues ";
		$sql .= "WHERE type='$typeRetenue' ";
		if ($affiche == true)
			$sql .= "AND affiche = 'O' ";
		$sql .= "ORDER BY dateRetenue, heure ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$idretenue = $ligne['idretenue'];
				$ligne['jourSemaine'] = Application::jourSemaineMySQL($ligne['dateRetenue']);
				$ligne['dateRetenue'] = Application::datePHP($ligne['dateRetenue']);
				$ligne['occupation'] = 0;
				$liste[$idretenue] = $ligne;
				}
			}
		$listeIdRetenue = implode(',',array_keys($liste));

		$sql = "SELECT idretenue, COUNT(*) as occupation ";
		$sql .= "FROM ".PFX."adesFaits ";
		$sql .= "WHERE idretenue IN ($listeIdRetenue) ";
		$sql .= "GROUP BY idretenue ";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$listeOccupation = $resultat->fetchall();
			foreach ($listeOccupation as $wtf=>$data) {
				$idretenue = $data['idretenue'];
				$liste[$idretenue]['occupation']=$data['occupation'];
				}
			}
		Application::DeconnexionPDO($connexion);
		return $liste;
		}

	/**
	 * retourne les caractéristiques de la retenue $idretenue: date, heure, durée, local
	 * @param $idretenue
	 * @return array : caractéristiques de la retenue
	 */
	public function detailsRetenue ($idretenue) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT dateRetenue, heure, duree, local ";
		$sql .= "FROM ".PFX."adesRetenues ";
		$sql .= "WHERE idretenue = '$idretenue' ";
		$resultat = $connexion->query($sql);
		$retenue = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$retenue = $resultat->fetch();
			$retenue['dateRetenue'] = Application::datePHP($retenue['dateRetenue']);
		}
		Application::DeconnexionPDO($connexion);
		return $retenue;
	}

	/**
	 * enregistre un élément de la banque de textes de ADES
	 * @param integer $idTexte : id éventuel du texte dans la table
	 * @param string $user : propriétaire éventuel du texte
	 * @param boolean $free : texte partage (1) ou pas (0)
	 * @param string $texte : texte à enregistrer
	 */
	public function saveTexte ($idTexte, $user, $free, $texte, $champ) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "INSERT INTO ".PFX."adesTextes ";
		$sql .= "SET idTexte = '$idTexte', user='$user', free='$free', texte='$texte', champ='$champ' ";
		$sql .= "ON DUPLICATE KEY UPDATE user='$user', free='$free', texte='$texte', champ='$champ' ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		return $resultat;
	}

	/**
	 * suppression d'un texte de la banque de textes de ADES
	 * @param $id
	 * @return $nb : nombre de modifications dans la BD (normalement 1)
	 */
	public function delTexte ($id) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."adesTextes ";
		$sql .= "WHERE idTexte='$id' ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		return $resultat;
	}

	/**
	 * retourne la liste des mémos de l'utilisateur et des mémos libres
	 * @param string $acronyme : abréviation de l'utilisateur
	 * @return array
	 */
	function listeMemos ($acronyme) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT idTexte, user, champ, free, texte ";
		$sql .= "FROM ".PFX."adesTextes ";
		$sql .= "WHERE user = '$acronyme' OR free='1' ";
		$sql .= "ORDER BY champ, texte ";

		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$champ = $ligne['champ'];
				$id = $ligne['idTexte'];
				$liste[$champ][$id] = $ligne;
			}
		}
		Application::DeconnexionPDO($connexion);
		return $liste;
	}

	/**
	 * liste des élèves inscrits à une retenue dont on indique l'identifiant
	 * @param $idretenue
	 * @return array
	 */
	public function listeElevesRetenue ($idretenue) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT travail, materiel, nom, prenom, groupe, professeur,".PFX."adesFaits.matricule ";
		$sql .= "FROM ".PFX."adesFaits ";
		$sql .= "JOIN ".PFX."eleves ON (".PFX."eleves.matricule = ".PFX."adesFaits.matricule) ";
		$sql .= "WHERE idretenue = '$idretenue' ";
		$sql .= "ORDER BY nom, prenom, groupe ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$ligne['photo'] = Ecole::photo($matricule);
				$liste[$matricule] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $liste;
	}

	/**
	 * recherche les caractéristiques d'un fait disciplinaire dont on fournit le $idfait
	 * @param $idfait
	 * @return array
	 */
	public function infosFait($idfait) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT ".PFX."adesFaits.type, matricule, ladate, motif, professeur, idretenue, travail, materiel, ";
		$sql .= "sanction, nopv, qui, typeRetenue, titreFait ";
		$sql .= "FROM ".PFX."adesFaits ";
		$sql .= "JOIN ".PFX."adesTypesFaits	ON (".PFX."adesTypesFaits.type = ".PFX."adesFaits.type) ";
		$sql .= "WHERE idfait = '$idfait' ";
		$resultat = $connexion->query($sql);
		$infoFaits = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$infosFait = $resultat->fetchAll();
		}
		Application::DeconnexionPDO($connexion);
		return $infosFait[0];
	}

	/**
	 * caractéristiques de la retenue dont on fournit le idretenue
	 * @param $idretenue
	 * @return array
	 */
	public function infosRetenue ($idretenue) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT ".PFX."adesRetenues.type, idretenue, dateRetenue, heure, duree, local, places, titrefait, ";
		$sql .= "(SELECT COUNT(*) FROM ".PFX."adesFaits WHERE idretenue='$idretenue') AS occupation ";
		$sql .= "FROM ".PFX."adesRetenues ";
		$sql .= "JOIN ".PFX."adesTypesFaits ON (".PFX."adesTypesFaits.typeRetenue = ".PFX."adesRetenues.type) ";
		$sql .= "WHERE idretenue = '$idretenue' ";

		$resultat = $connexion->query($sql);
		$info = Null;
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$infos = $resultat->fetch();
			$infos['jourSemaine'] = Application::jourSemaineMySQL($infos['dateRetenue']);
			$infos['dateRetenue'] = Application::datePHP($infos['dateRetenue']);
			}
		Application::DeconnexionPDO($connexion);
		return $infos;
	}

	/**
	 * caractéristiques d'une retenue dont on fournit le type
	 * informations venant de adesTypesFaits
	 * @param $type : le type de fait disciplinaire
	 * @return array
	 */
	public function infosRetenueType($type) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT type, titreFait, couleurFond, couleurTexte, typeRetenue, ordre, listeChamps ";
		$sql .= "FROM ".PFX."adesTypesFaits ";
		$sql .= "WHERE typeRetenue = '$type' ";
		$info = Null;
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$infos = $resultat->fetch();
			}
		Application::DeconnexionPDO($connexion);
		return $infos;
	}

	function utf8($argument) {
		return utf8_decode($argument);
		}

	/**
	 * Impression d'un billet de retenue
	 * @param $data : array toutes les informations qui figurent sur le billet de retenue
	 * @param $acronyme : identifiant de l'utilisateur
	 * @return
	 *
	 */
	public function printRetenue ($data,$acronyme) {
		// Rédaction du billet de retenue: choisir l'un des deux modes d'impression
		// *********************************************************
		// Impression en mode "Paysage" = "Landscape" sur pages A5
		$pdf=new FPDF('L','mm','A5');
		// impression en mode "Portrait" = "Portrait" sur page A4
		// $pdf=new FPDF('P','mm','A4');
		// *********************************************************
		$pdf->AddPage();

		$pdf->Image(INSTALL_DIR.'/images/logoEcole.png', 15, 10, 40,40, 'png');
		$pdf->SetFont('Arial','',14);
		$pdf->SetXY(90,10);
		$pdf->Cell(100,5,$this->utf8(ECOLE), 0, 2, 'C', 0);
		$pdf->SetXY(90,15);
		$pdf->Cell(100,5,$this->utf8(ADRESSE), 0, 2, 'C', 0);
		$pdf->SetXY(90,20);
		$pdf->Cell(100,5, $this->utf8('Téléphone: '.TELEPHONE), 0, 2, 'C', 0);

		$pdf->SetFont('Arial','',12);
		$dt = date("d/m/Y");
		$pdf->SetXY(140,35);
		$pdf->Cell(50,5,$this->utf8(COMMUNE).', le '.$dt, 0, 2, 'R');

		$pdf->SetFont('','B',24);
		$pdf->SetXY(70,45);
		$pdf->Cell(110,10, $this->utf8($data['fait']['titreFait']), 1, 0, 'C');

		$pdf->SetXY(10,65);
		$pdf->SetFont('', 'B',10);
		$chaine = "M. ".$this->utf8($data['eleve']['prenom'])." ".$this->utf8($data['eleve']['nom'])." en classe de ".$this->utf8($data['eleve']['classe'])."\n";
		$pdf->Cell(200,5, $chaine, 0,0,'L');

		$pdf->SetXY(10,70);
		$pdf->SetFont('');
		$chaine = $this->utf8("a mérité une retenue de ".$data['retenue']['duree']." h ce ".$data['retenue']['dateRetenue']." à ".$data['retenue']['heure']);
		$chaine .= "(local ".$this->utf8($data['retenue']['local']).") pour le motif suivant\n";
		$pdf->Cell(200,5, $chaine, 0,0,'L');

		$pdf->SetXY(10,75);
		$pdf->SetFont('','',12);

		$pdf->Write(5, $this->utf8($data['fait']['motif']));
		$pdf->SetFont('', '', 10);
		$pdf->SetXY(10,90);

		$chaine = $this->utf8("Matériel à apporter: Jcl, de quoi écrire - ".$data['fait']['materiel']).".\n";
		$chaine .= $this->utf8("Travail à effectuer: ".$data['fait']['travail']."\n");

		$pdf->Write(5, $chaine);

		$pdf->SetXY(10,110);
		$pdf->Cell(30,5,"Le professeur", 0, 0, 'L', 0);
		$pdf->SetXY(80,110);
		$pdf->Cell(30,5,"Le CPE", 0, 0, 'L', 0);
		$pdf->SetXY(150,110);
		$pdf->Cell(30,5,"Les parents", 0, 0, 'L', 0);

		$pdf->SetXY(30,120);
		$pdf->Cell(30,5,$this->utf8($data['fait']['professeur']), 0, 0, 'L', 0);

		// création du répertoire correspondant à l'utilisateur en cours
		if (!(file_exists("pdf/$acronyme")))
			mkdir ("pdf/$acronyme");

		$pdf->Output("pdf/$acronyme/".$data['eleve']['matricule'].".pdf",'D');
	}

	/**
	 * renvoie la liste des champs qui doivent apparaître dans un "contexte" donné pour chaque élément d'un fait disciplinaire
	 * @param $contexte : string
	 * @return array
	 */
	public function champsInContexte($contexte) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// recherche la liste de tous les types de faits existants avec les champs qui les décrivent
		$sql = "SELECT type, listeChamps ";
		$sql .= "FROM ".PFX."adesTypesFaits ";
		$resultat = $connexion->query($sql);
		$listeFaits = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$type = $ligne['type'];
				$ligne['listeChamps'] = str_replace(' ','', $ligne['listeChamps']);
				$listeFaits[$type] = explode(',',$ligne['listeChamps']);
				}
			}
		// recherche de tous les champs à exposer dans le contexte d'apparition
		$sql = "SELECT champ ";
		$sql .= "FROM ".PFX."adesChamps ";
		$sql .= "WHERE LOCATE('$contexte', contextes) > 0 ";
		$resultat = $connexion->query($sql);
		$listeChamps = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch())
				$listeChamps[] = $ligne['champ'];
			}
		// parcours de la liste des faits existants et de leur description
		foreach ($listeFaits as $type=>$lesChamps) {
			// pour chaque fait, on ne conserve que les champs qui figurent dans la "liste des champs à exposer"
			$listeFaits[$type] = array_intersect($listeFaits[$type], $listeChamps);
			}
		Application::DeconnexionPDO($connexion);
		return $listeFaits;
	}

	/**
	 * renvoie une table de correspondance entre les noms et les titres des champs à exposer
	 * @param
	 * @return array
	 */
	public function titreChamps (){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT champ, label ";
		$sql .= "FROM ".PFX."adesChamps ";
		$resultat = $connexion->query($sql);
		$listeChamps = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$champ = $ligne['champ'];
				$listeChamps[$champ] = $ligne['label'];
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listeChamps;
	}

	/**
	 * renvoie les statistiques sur les différents types de faits entre les dates précisées
	 * pour les élèves demandés (la liste des élèves est fabriquée ailleurs)
	 * @param $listeEleves : liste des élèves concernés
	 * @param $debut : date de début
	 * @param $fin : date de fin
	 * @return array
	 */
	public function statistiques ($listeEleves, $debut, $fin) {
		if (is_array($listeEleves))
			$listeElevesString = implode(",",array_keys($listeEleves));
			else $listeElevesString = $listeEleves;
		$debut = Application::dateMysql($debut);
		$fin = Application::dateMysql($fin);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT COUNT(*) AS nbFaits, af.type, titreFait, couleurFond, couleurTexte ";
		$sql .= "FROM ".PFX."adesFaits AS af ";
		$sql .= "JOIN ".PFX."adesTypesFaits AS tf ON (tf.type = af.type) ";
		$sql .= "WHERE matricule IN ($listeElevesString) AND af.ladate > '$debut' AND af.ladate < '$fin' ";
		$sql .= "GROUP BY type ORDER BY type";
		$resultat = $connexion->query($sql);
		$statistiques = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$type = $ligne['type'];
				$statistiques[$type] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $statistiques;
		}

	/**
	 * renvoie Les fiches disciplinaires de la liste d'élèves indiquée avec uniquement les champs demandés
	 * @param $listeEleves : liste des élèves concernés
	 * @param $debut : date de début
	 * @param $fin : date de fin
	 * @return array
	 */
	public function fichesDisciplinaires ($listeEleves, $debut, $fin) {
		if (is_array($listeEleves))
			$listeElevesString = implode(",",array_keys($listeEleves));
			else $listeElevesString = $listeEleves;
		$debut = Application::dateMysql($debut);
		$fin = Application::dateMysql($fin);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT af.idFait, af.type, af.*, titreFait, ae.groupe AS classe, ";
		$sql .= "dateRetenue, local, heure, duree, ap.nom, ap.prenom, ap.sexe ";
		$sql .= "FROM ".PFX."adesFaits AS af ";
		$sql .= "JOIN ".PFX."eleves AS ae ON (ae.matricule = af.matricule ) ";
		$sql .= "JOIN ".PFX."adesTypesFaits AS atf ON (atf.type = af.type) ";
		$sql .= "LEFT JOIN ".PFX."adesRetenues AS ar ON (ar.idretenue = af.idretenue) ";
		$sql .= "LEFT JOIN ".PFX."profs AS ap ON (ap.acronyme = af.professeur) ";
		$sql .= "WHERE af.matricule IN ($listeElevesString) AND af.ladate >= '$debut' AND af.ladate <= '$fin' ";
		$sql .= "ORDER BY classe, REPLACE(REPLACE(REPLACE(ae.nom, ' ', ''),'''',''),'-',''), ae.prenom, type, ladate ";

		$resultat = $connexion->query($sql);
		$listeFiches = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$ligne['ladate'] = Application::datePHP($ligne['ladate']);
				if ($ligne['nom'] != Null) {
					if ($ligne['sexe'] == 'M')
						$ligne['professeur'] = 'Mr '.$ligne['nom'];
						else $ligne['professeur'] = 'Mme '.$ligne['nom'];
					}
				if (isset($ligne['dateRetenue']))
					$ligne['dateRetenue'] = Application::datePHP($ligne['dateRetenue']);
				$classe = $ligne['classe'];
				$matricule = $ligne['matricule'];
				$type = $ligne['type'];
				$idFait = $ligne['idFait'];
				$listeFiches[$classe][$matricule][$type][$idFait] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listeFiches;
	}

	/**
	 * inverse le mode d'affichage des retenues dans leur liste; une retenue affichée devient cachée et inversement
	 * renvoie un string indiquant le mode d'affichage ("O" ou "N")
	 * @param $idRetenue
	 * @return
	 */
	public function toggleAffichageRetenue($id, $texte) {
		// on ne retient que la deuxième partie de la chaîne passée, du type id_xxx; xxx indique le "id" dans la BD
		$id = explode('_',$id);
		$id = $id[1];
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "UPDATE ".PFX."adesRetenues ";
		$sql .= "SET affiche = IF(affiche='O', 'N', 'O') ";
		$sql .= "WHERE idRetenue = '$id' ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		$texte = ($texte == 'O')?'N':'O';
		return $texte;
		}

}

?>
