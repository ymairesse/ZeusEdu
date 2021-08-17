<?php

class Infirmerie {

    /**
     * recherche les informations médicales générales sur l'élève dans la BD
     *
     * @param int $matricule
     * @return array
     */
    public function getMedicEleve ($matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT de.matricule, medecin, telMedecin, sitFamiliale, anamnese, medical, psy, traitement, info ";
		$sql .= "FROM ".PFX."eleves AS de ";
		$sql .= "LEFT JOIN ".PFX."infirmerie AS inf ON inf.matricule = de.matricule ";
		$sql .= "LEFT JOIN ".PFX."infirmInfos AS infInfo ON infInfo.matricule = de.matricule ";
		$sql .= "WHERE de.matricule = '$matricule' ";

        $resultat = $connexion->query($sql);
		$ligne = array();
        if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			}

        Application::DeconnexionPDO($connexion);

		return $ligne;
        }


	/**
	 * retourne la liste des visites de l'élève à l'infirmerie et issue de la BD
	 *
     * @param int $matricule : matricule de l'élève concerné
     * @param int $consultID : identifiant de la visite concernée (sinon, toutes les visites)
     *
     * @return array
     */
    public function getVisitesEleve($matricule, $consultID=Null) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT consultID, consult.matricule, acronyme, date, heure, motif, traitement, aSuivre, ';
        $sql .= 'groupe, nom, prenom ';
        $sql .= 'FROM '.PFX.'infirmConsult AS consult ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS el ON el.matricule = consult.matricule ';
        $sql .= 'WHERE consult.matricule = :matricule ';
		if ($consultID != Null)
			$sql .= 'AND consultID = :consultID ';
		$sql .= 'ORDER BY date';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if ($consultID != Null)
            $requete->bindParam(':consultID', $consultID, PDO::PARAM_INT);

        $resultat = $requete->execute();

		$listeVisites = array();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()) {
				$consultID = $ligne['consultID'];
				$ligne['date'] = Application::datePHP($ligne['date']);
				$listeVisites[$consultID] = $ligne;
				}
			}

        Application::DeconnexionPDO($connexion);

		return $listeVisites;
        }

	/**
	 * retourne les informations médicales importantes pour un élève donné
	 *
	 * @param int $matricule
	 *
	 * @return string
	 */
	public function getInfoMedic($matricule) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT info ";
		$sql .= "FROM ".PFX."infirmInfos ";
		$sql .= "WHERE matricule = :matricule ";
		$requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

		$info = '';
        $resultat = $requete->execute();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch())
				$info = $ligne['info'];
			}

		Application::DeconnexionPDO($connexion);

		return $info;
		}

	/**
	 * Enregistrement des données médicales d'un élève
	 *
	 * @param array $data données $_POST provenant d'un formulaire
	 *
	 * @return integer : nombre de modifications dans la BD
	 */
    public function enregistrerMedical($data) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'infirmerie ';
        $sql .= 'SET matricule = :matricule, medecin = :medecin, ';
        $sql .= 'telMedecin = :telMedecin, sitFamiliale = :sitFamiliale, anamnese = :anamnese, psy = :psy, ';
        $sql .= 'traitement = :traitement, medical = :medical ';
        $sql .= 'ON DUPLICATE KEY UPDATE medecin = :medecin, telMedecin = :telMedecin, sitFamiliale = :sitFamiliale, ';
        $sql .= 'anamnese = :anamnese, medical = :medical, psy = :psy, traitement = :traitement ';
        $requete = $connexion->prepare($sql);

        $medecin = $data['medecin'];
        $requete->bindParam(':medecin', $medecin, PDO::PARAM_STR, 30);
        $telMedecin = $data['telMedecin'];
        $requete->bindParam(':telMedecin', $telMedecin, PDO::PARAM_STR, 20);
        $sitFamiliale = $data['sitFamiliale'];
        $requete->bindParam(':sitFamiliale', $sitFamiliale, PDO::PARAM_STR, 180);
        $anamnese = $data['anamnese'];
        $requete->bindParam(':anamnese', $anamnese, PDO::PARAM_STR, 180);
        $medical = $data['medical'];
        $requete->bindParam(':medical', $medical, PDO::PARAM_STR, 180);
        $psy = $data['psy'];
        $requete->bindParam(':psy', $psy, PDO::PARAM_STR, 60);
        $traitement = $data['traitement'];
        $requete->bindParam(':traitement', $traitement, PDO::PARAM_STR, 60);
        $matricule = $data['matricule'];
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        $nb = ($nb == 2) ? 1 : $nb;

        return $nb;
        }

	/**
	 * Enregistrement de l'information médicale primordiale d'un élève (en exergue sur sa fiche)
	 *
	 * @param int $matricule
	 * @param string $infoMedic
	 *
	 * @return int nb d'enregistrements
	 */
	public function saveInfoMedic ($matricule, $infoMedic) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

		$sql = 'INSERT INTO '.PFX.'infirmInfos ';
		$sql .= 'SET matricule = :matricule, info = :infoMedic ';
		$sql .= 'ON DUPLICATE KEY UPDATE ';
		$sql .= 'info = :infoMedic ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':infoMedic', $infoMedic, PDO::PARAM_STR, 200);

		$resultat = $requete->execute();

        $nb = $requete->rowCount();
        // pour éviter de compter deux fois en cas de UPDATE
        $nb = ($nb == 2) ? 1 : $nb;

		Application::DeconnexionPDO($connexion);

        return $nb; // nombre de lignes modifiées dans la BD
	}

    /**
     * Enregistrement des informations concernant une visite à l'infirmerie
     *
     * @param array $post données $_POST provenant d'un formulaire
     *
     * @return integer : nombre de lignes modifiées dans la BD
     */
    public function saveVisite($post) {
        $consultID = isset($post['consultID']) ? $post['consultID'] : Null;
        $acronyme = isset($post['acronyme']) ? $post['acronyme'] : Null;
        $matricule = isset($post['matricule']) ? $post['matricule'] : Null;
        $date = isset($post['date']) ? Application::dateMySql($post['date']) : Null;
        $heure = isset($post['heure']) ? $post['heure'] : Null;
        $motif = isset($post['motif']) ? $post['motif'] : Null;
        $traitement = isset($post['traitement']) ? $post['traitement'] : Null;
        $aSuivre = isset($post['aSuivre']) ? $post['aSuivre'] : Null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($consultID != Null) {
			// c'est une mise à jour d'une visite précédente
			$sql = 'UPDATE '.PFX.'infirmConsult ';
			$sql .= 'SET matricule = :matricule, acronyme = :acronyme, date = :date, heure = :heure, ';
			$sql .= 'motif = :motif, traitement = :traitement, aSuivre = :aSuivre ';
			$sql .= 'WHERE consultID = :consultID ';
			$requete = $connexion->prepare($sql);
			$requete->bindParam(':consultID', $consultID, PDO::PARAM_INT);
			}
			else {
				// c'est une nouvelle visite
				$sql = 'INSERT INTO '.PFX.'infirmConsult SET matricule = :matricule, date = :date, heure = :heure, ';
				$sql .= 'acronyme = :acronyme, motif = :motif, traitement = :traitement, aSuivre = :aSuivre ';
				$requete = $connexion->prepare($sql);
				}

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':motif', $motif, PDO::PARAM_STR, 250);
        $requete->bindParam(':traitement', $traitement, PDO::PARAM_STR, 250);
        $requete->bindParam(':aSuivre', $aSuivre, PDO::PARAM_STR, 50);

        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb; // nombre de lignes modifiées dans la BD
        }

    /**
	 * Suppression des infos concernant une visite à l'infirmerie
	 *
	 * @param int $consultID : identifiant de la visite
	 *
	 * @return int : nombre de suppression effectivement réalisées
	 */
    function deleteVisite($consultID) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'infirmConsult ';
        $sql .= 'WHERE consultID = :consultID ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':consultID', $consultID, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
        }

    /**
     * recherche toutes les visites à l'infirmerie entre deux dates
     *
     * @param string $dateDebut
     * @param string  $dateFin
     *
     * @return array
     *
     * */
     public function listeVisitesParDate ($dateDebut, $dateFin) {
        $liste = array();
        if ($dateDebut && $dateFin) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT consultID, consult.matricule, date, heure, nom, prenom, classe, motif, traitement, aSuivre ';
            $sql .= 'FROM '.PFX.'infirmConsult AS consult ';
            $sql .= 'JOIN '.PFX.'eleves AS eleves ON eleves.matricule = consult.matricule ';
            $sql .= 'WHERE date BETWEEN :dateDebut AND :dateFin ';
            $sql .= 'ORDER BY date, classe, heure, nom ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 10);
            $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);

            $liste = array();

            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $date = $ligne['date'];
                    $matricule = $ligne['matricule'];
                    $consultID = $ligne['consultID'];
                    $liste[$date][$matricule][$consultID] = $ligne;
                }
                }
            Application::DeconnexionPDO($connexion);
            }

        return $liste;
         }

     /**
      * vérifie que l'utilisateur dont on fournit l'acronyme existe dans la table des profs.
      *
      * @param $acronyme
      *
      * @return array : l'acronyme effectivement trouvé dans la BD ou rien si pas trouvé
      */
     public static function userExists($acronyme)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT acronyme FROM '.PFX.'profs ';
         $sql .= "WHERE acronyme LIKE :acronyme ";
         $requete = $connexion->prepare($sql);

         $acronyme = $acronyme.'%';
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 8);

        $liste = array();
        $resultat = $requete->execute();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $acronyme = $ligne['acronyme'];
                 $liste[] = $acronyme;
             }
         }
         Application::DeconnexionPDO($connexion);

         if (count($liste) == 1)
            return $liste[0];
     }
}
