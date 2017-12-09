<?php

class Jdc
{
    /**
     * constructeur de l'objet jdc.
     */
    public function __construct()
    {
    }

    /**
     * renvoie la liste d'événements entres deux dates start et end pour une liste de cours donnée
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param string $listeCoursGrpString : les noms des cours séparés par des virgules et entourés de guillemets
     *
     * @return array
     */
    public function getEvents4Cours($dateFrom, $dateTo, $listeCoursGrp, $acronyme)
    {
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
    	$sql .= 'FROM '.PFX.'thotJdc ';
    	$sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
    	$sql .= "AND destinataire IN ($listeCoursGrpString) ";
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
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

        return $liste;
    }

    /**
     * renvoie la liste des événements entre deux dates start et end pour un niveau d'étude $niveaudonné
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param int $niveau : niveau d'étude
     * @param string $acronyme : identifiant du propriétaire (sécurité)
     *
     * @return array
     */
     public function getEvents4Niveau($dateFrom, $dateTo, $niveau, $acronyme){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
         $sql .= 'FROM '.PFX.'thotJdc ';
         $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
         $sql .= 'AND destinataire = :niveau ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
         $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
         $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
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

         return $liste;
     }

     /**
      * renvoie la liste des événements entre deux dates start et end pour un niveau d'étude $niveaudonné
      *
      * @param string $dateFrom : date de début
      * @param string $dateTo   : date de fin
      * @param int $niveau : niveau d'étude
      * @param string $acronyme : identifiant du propriétaire (sécurité)
      *
      * @return array
      */
      public function getEvents4Ecole($dateFrom, $dateTo, $acronyme){
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
          $sql .= 'FROM '.PFX.'thotJdc ';
          $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
          $sql .= "AND destinataire = 'all' ";
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
          $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);

          $resultat = $requete->execute();
          $liste = array();
          if ($resultat) {
              $requete->setFetchMode(PDO::FETCH_ASSOC);
              while ($ligne = $requete->fetch()) {
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

          return $liste;
      }

    /**
     * renvoie la liste des événements entre deux dates start et end pour un élève de $matricule donné
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param int $matricule : matricule de l'élève
     * @param string $acronyme : identifiant du propriétaire (sécurité)
     *
     * @return array
     */
    public function getEvents4Eleve($dateFrom, $dateTo, $matricule, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
        $sql .= 'FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
        $sql .= 'AND destinataire = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
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

        return $liste;
    }

    /**
     * renvoie la liste d'événements entres deux dates start et end pour une classe donnée
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param string $classe : la classe concernée
     *
     * @return array
     */
    public function getEvents4Classe($dateFrom, $dateTo, $classe, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, url, class, allDay, startDate, endDate, allDay ';
    	$sql .= 'FROM '.PFX.'thotJdc ';
    	$sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
    	$sql .= 'AND destinataire= :classe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 5);

        $resulat = $requete->execute();
        $liste = array();
        if ($resulat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
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

        return $liste;
    }

    /**
     * retourne le niveau d'étude d'un élève dont on fournit le matricule
     *
     * @param int $matricule
     *
     * @return int : le niveau d'étude
     */
    public function getNiveauEleve ($matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT groupe FROM '.PFX.'eleves ';
        $sql .= 'WHERE matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $niveau = Null;
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
            $groupe = $ligne['groupe'];
            $niveau = substr($groupe, 0, 1);
        }

        Application::DeconnexionPDO($connexion);

        return $niveau;
    }

    /**
     * retourne la liste des cours effectivement suivis par chacun des élèves d'une classe.
     *
     * @param $classe string: la classe de ces élèves
     *
     * @return array
     */
    public function listeCoursClasse($groupe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT coursGrp, SUBSTR(coursGrp,1, LOCATE('-',coursGrp)-1) as cours, ec.matricule ";
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON (de.matricule = ec.matricule) ';
        $sql .= 'WHERE groupe = :groupe ';
        $sql .= 'ORDER BY matricule, cours ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 5);
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste de tous les coursGrp d'un élève dont on fournit le matricule
     *
     * @param array|string $listeEleves liste des matricules des élèves
     *
     * @return array
     */
     public function listeCoursGrpEleves($listeEleves)
     {
         if (is_array($listeEleves)) {
             $listeElevesString = implode(',', array_keys($listeEleves));
         } else {
             $listeElevesString = $listeEleves;
         }
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT coursGrp ';
         $sql .= 'FROM '.PFX.'elevesCours ';
         $sql .= "WHERE matricule IN ($listeElevesString) ";
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $liste = array();
         $resultat = $requete->execute();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $coursGrp = $ligne['coursGrp'];
                 $liste[$coursGrp] = $coursGrp;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

    /**
     * retrouve une notification dont on fournit l'identifiant.
     *
     * @param $id : l'identifiant dans la BD
     *
     * @return array
     */
    public function getTravail($item_id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT destinataire, type, proprietaire, title, enonce, url, class, jdc.idCategorie, id, DATE(startDate) AS startDate, ';
        $sql .= 'TIME(startDate) AS heure, endDate, TIMEDIFF(endDate, startDate) AS duree, allDay, ';
        $sql .= 'jdc.idCategorie, categorie, sexe, nom, prenom, libelle, nbheures, nomCours ';
        $sql .= 'FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = jdc.proprietaire ';
        $sql .= 'JOIN '.PFX.'thotJdcCategories AS cat ON cat.idCategorie = jdc.idCategorie ';
        $sql .= 'LEFT JOIN '.PFX."cours AS dc ON cours = SUBSTR(jdc.destinataire,1,LOCATE('-',jdc.destinataire)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS dpc ON dpc.coursGrp = destinataire ';
        $sql .= "WHERE id='$item_id' ";

        $travail = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $travail = $resultat->fetch();
            if ($travail['sexe'] == 'F') {
                $nom = 'Mme ';
            } else {
                $nom = 'M. ';
            }
            if ($travail['prenom'] != '') {
                $nom .= mb_substr($travail['prenom'], 0, 1, 'UTF-8').'.';
            }

            $travail['nom'] = $nom.' '.$travail['nom'];
            // $travail['startDate'] = date('d/m/Y', strtotime($travail['startDate']));

            $travail['heure'] = date('H:i', strtotime($travail['heure']));
            $travail['duree'] = date('H:i', strtotime($travail['duree']));
            if ($travail['allDay'] == 0) {
                unset($travail['allDay']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $travail;
    }

    /**
     * modifie les dates de début et de fin d'un évenement dont on fournit aussi l'id
     * fonction nécessaveJdcire après un drag/drop;.
     *
     * @param $id : l'identifiant de l'inscription dans le JDC
     * @param $startDate : date et heure de début de l'événement
     * @param $endDate : date et heure de fin de l'événement
     */
    public function modifEvent($id, $startDate, $endDate, $allDay)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotJdc ';
        $sql .= "SET startDate = '$startDate', endDate = '$endDate', allDay = $allDay ";
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * vérifie si l'élément dont l'identifiant est passé appartient bien au propriétaire utlisateur actuel.
     *
     * @param $id : l'identifiant de l'inscription dans le JDC
     * @param $user : l'acronyme de l'utilisateur
     *
     * @return bool : true si ok
     */
    public function verifIdProprio($id, $proprio)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id FROM '.PFX.'thotJdc ';
        $sql .= "WHERE id ='$id' AND proprietaire = '$proprio' ";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $ligne = $resultat->fetch();
            $id = $ligne['id'];
        } else {
            $id = null;
        }
        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * suppression d'une notification au journal de classe.
     *
     * @param $id : l'identifiant de l'enregistrement
     *
     * @return int : le nombre de suppression (0 -si échec- ou 1)
     */
    public function deleteJdc($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdc ';
        $sql .= "WHERE id = '$id' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * enregistre une notification au JDC.
     *
     * @param $post : tout le contenu du formulaire
     *
     * @return integer: nombre d'enreigstrements résussis (0 ou 1)
     */
    public function saveJdc($post, $acronyme)
    {
        $id = isset($post['id']) ? $post['id'] : null;
        $destinataire = isset($post['destinataire']) ? $post['destinataire'] : null;
        $type = isset($post['type']) ? $post['type'] : null;
        $date = Application::dateMysql($post['date']);
        $duree = isset($post['duree']) ? $post['duree'] : null;
        $allDay = isset($post['journee']) ? 1 : 0;

        if ($allDay == 0) {
            $heure = $post['heure'];
            $startDate = $date.' '.$heure;
            // $duree peut être exprimé en minutes ou en format horaire hh:mm
            $duree = $post['duree'];
            if (!is_numeric($duree)) {
                if (strpos($duree,':') > 0) {
                    // c'est sans doute le format hh::mm
                    $duree = explode(':', $duree);
                    $duree = $duree[0] * 60 + $duree[1];
                }
                else $duree = 0;
            }
            // if (($duree <= 20) || ($duree > 400)) {
            //     $duree = 0;
            // }  // 20 minutes en cas d'erreur et pour la lisibilité

            $endDate = new DateTime($startDate);
            $endDate->add(new DateInterval('PT'.$duree.'M'));
            $endDate = $endDate->format('Y-m-d H:i');
        } else {
            $duree = null;
            $endDate = '0000-00-00 00:00';
            $startDate = $date.' '.'00:00';
        }

        $titre = $post['titre'];
        $categorie = $post['categorie'];
        $class = $categorie;
        $enonce = $post['enonce'];

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($id == null) {
            // nouvel enregistrement
            $sql = 'INSERT INTO '.PFX.'thotJdc ';
            $sql .= 'SET destinataire=:destinataire, type=:type, proprietaire=:proprietaire, idCategorie=:categorie, ';
            $sql .= 'title=:titre, enonce=:enonce, startDate=:startDate, endDate=:endDate, allDay=:allDay ';
        } else {
            // simple mise à jour
            $sql = 'UPDATE '.PFX.'thotJdc ';
            $sql .= 'SET destinataire=:destinataire, type=:type, proprietaire=:proprietaire, idCategorie=:categorie, ';
            $sql .= 'title=:titre, enonce=:enonce, startDate=:startDate, endDate=:endDate, allDay=:allDay ';
            $sql .= "WHERE id='$id' ";
        }
        $requete = $connexion->prepare($sql);

        $data = array(
            ':destinataire' => $destinataire,
            ':type' => $type,
            ':proprietaire' => $acronyme,
            ':categorie' => $categorie,
            ':titre' => $titre,
            ':enonce' => $enonce,
            // ':class' => $class,
            ':startDate' => $startDate,
            ':endDate' => $endDate,
            ':allDay' => $allDay,
            );

        $resultat = $requete->execute($data);
        if ($id == null) {
            $lastId = $connexion->lastInsertId();
        }
        Application::DeconnexionPDO($connexion);

        if ($id == null) {
            return $lastId;
        } elseif ($resultat > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * retourne les différentes catégories de travaux disponibles (interro, devoir,...).
     *
     * @param void
     *
     * @return array
     */
    public function categoriesTravaux()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCategorie, categorie ';
        $sql .= 'FROM '.PFX.'thotJdcCategories ';
        $sql .= 'ORDER BY ordre ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['idCategorie'];
                $liste[$id] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie le label utilisable pour le destinataire en fonction du type
     *
     * @param string $type : type de destinataire (ecole, niveau, classe, groupe, eleve)
     * @param string $destinataire : le nom du destinataire
     *
     * @return string
     */
    public function getLabel ($type, $destinataire, $infos=Null) {
        $lblDestinataire = Null;
        switch ($type) {
            case 'eleve':
                // $infos est un tableau avec les détails de l'élève
                $lblDestinataire = $this->getLblEleve($infos);
                break;
            case 'cours':
                // $infos est la liste des cours du prof
                $lblDestinataire =  $this->getLblCours($destinataire, $infos);
                break;
            case 'classe':
                $lblDestinataire = $this->getLblClasse($destinataire);
                break;
            case 'niveau':
                $lblDestinataire = $this->getLblNiveau($destinataire);
                break;
            case 'ecole':
                $lblDestinataire = $this->getLblEcole();
                break;
        }

        return $lblDestinataire;
    }

    	/**
    	 * renvoie le label utilisable pour un cours si on fournit $coursGrp et $listeCours (avec détails de dénomination) de l'utilisateur
    	 *
    	 * @param string $coursGrp
    	 * @param array $listeCours
    	 *
    	 * @return string
    	 */
    	public function getLblCours ($coursGrp, $listeCours) {
			$detailsCours = $listeCours[$coursGrp];
			if ($detailsCours['nomCours'] != '') {
				$lbl = sprintf('-> %s %dh | %s',$detailsCours['libelle'], $detailsCours['nbheures'], $detailsCours['nomCours']);
                }
			else {
				$lbl = sprintf('%s %s %s %dh [%s]', $detailsCours['annee'], $detailsCours['statut'], $detailsCours['libelle'], $detailsCours['nbheures'], $detailsCours['coursGrp']);
			}

    		return $lbl;
    	}

    	/**
    	 * renvoie le label utilisable pour une classe si on fournit $classe
    	 *
    	 * @param string $classe
    	 *
    	 * @return string
    	 */
    	public function getLblClasse ($classe) {
    		return sprintf('la classe de %s', $classe);
    	}

    	/**
    	 * renvoie le label utilisable pour un élève dont on fournit les détails
    	 * @param array $detailsEleve
    	 *
    	 * @return string
    	 */
    	public function getLblEleve ($detailsEleve) {
    		return sprintf('%s %s [%s]', $detailsEleve['nom'], $detailsEleve['prenom'], $detailsEleve['groupe']);
    	}

    	/**
    	 * renvoie le label utilisable pour le niveau d'étude précisé
    	 *
    	 * @param int $niveau
    	 *
    	 * @return string
    	 */
    	public function getLblNiveau ($niveau) {
    		$suffixe = ($niveau == 1) ? 'ères' : 'èmes';
    		return sprintf('les élèves de %d%s', $niveau, $suffixe);
    	}

    	/**
    	 * renvoie le label utilisable pour tous les élèves de l'école
    	 *
    	 * @param void()
    	 *
    	 * @return string
    	 */
    	public function getLblEcole () {
    		return 'tous les élèves';
    	}

    /**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void()
     *
     * @return array $listeHeures
     */
    public function lirePeriodesCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin';

        $resultat = $connexion->query($sql);
        $listePeriodes = array();
        $periode = 1;
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $debut = $ligne['debut'];
                $fin = $ligne['fin'];
                $listePeriodes[$periode++] = array('debut' => $debut, 'fin' => $fin);
            }
        }
        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

    /**
     * renvoie l'heure de la période de cours la plus proche de l'heure passée en argument
     *
     * @param string $heure
     *
     * @return string
     */
    public function heureLaPlusProche($heure){
        $listePeriodes = $this->lirePeriodesCours();
        $time = explode(':', $heure);
        $time = mktime($heure[0], $heure[1]);

        $n = 1;
        while (($listePeriodes[$n]['fin'] < $heure) && ($n < count($listePeriodes))) {
            $n++;
        }
        $timeDebut = explode(':', $listePeriodes[$n]['debut']);
        $timeFin = explode(':', $listePeriodes[$n]['fin']);

        if (((float) $time - (float) $timeDebut) > ((float) $timeFin - (float) $time))
            return $listePeriodes[$n]['debut'];
            else return $listePeriodes[$n]['fin'];
    }

}
