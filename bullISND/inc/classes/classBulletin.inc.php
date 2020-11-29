<?php

require INSTALL_DIR.'/fpdf181/fpdf.php';
require INSTALL_DIR.'/inc/classes/class.pdfrotate.php';
require INSTALL_DIR.'/inc/classes/class.pdf.php';
require INSTALL_DIR.'/inc/classes/class.pdfHTML.php';

class Bulletin
{
    protected $sections;

    public function __construct()
    {
        // quelles sont les sections concernées par cette formule de bulletin
        $this->sections = explode(',', SECTIONS);
    }

    /**
     * retourne un array contenant une liste des périodes de l'année scolaire.
     *
     * @param $nbBulletins
     *
     * @return array
     */
    public function listePeriodes($nbBulletins, $debut = 1)
    {
        return range($debut, $nbBulletins);
    }

    /**
     * retourne un array contenant la liste des périodes pour une année scolaire donnée
     *
     * @param string $anscol : l'année scolaire sous la forme 'XXXX-YYYY'
     *
     * @return array de 1 à nbPpériodes
     */
    public function listePeriodes4anScol ($anscol){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nbPeriodes ';
        $sql .= 'FROM '.PFX.'bullPeriodes4anscol ';
        $sql .= 'WHERE anscol = :anscol ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anscol', $anscol, PDO::PARAM_STR, 9);

        $resultat = $requete->execute();

        $nb = 0;
        if ($resultat){
            $ligne = $requete->fetch();
            $nb = $ligne['nbPeriodes'];
        }
        $listePeriodes = range(1, $nb);

        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

    /**
     * fonction booleenne: détermine si une valeur est numérique et non Null.
     *
     * @param $data : valeur à tester
     *
     * @return bool
     */
    public function isNumericNotNull($data)
    {
        return ($data != null) && (is_numeric($data)) && ($data != '');
    }

    /**
     * retourne les pondérations pour le cours (groupe) donné et le bulletin donné
     * si le numéro du bulletin n'est pas précisé, retourne toutes les pondérations pour le cours (groupe)
     * si la pondération contient un matricule, c'est qu'il y a un cas particulier
     * pour l'élève dont le matricule est renvoyé; sinon, c'est 'all'.
     *
     * @param $coursGrp
     * @param $bulletin
     *
     * @return array
     */
    public function getPonderations($listeCoursGrp, $bulletin = null)
    {
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp, periode, matricule, form, cert ';
        $sql .= 'FROM '.PFX.'bullPonderations ';
        $sql .= "WHERE coursGrp IN ($listeCoursGrpString) ";
        if ($bulletin != null) {
            $sql .= "AND periode = '$bulletin' ";
        }
        $sql .= 'ORDER BY matricule, periode ASC ';

        $resultat = $connexion->query($sql);
        $listePonderations = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $periode = $ligne['periode'];
            $coursGrp = $ligne['coursGrp'];
            $listePonderations[$coursGrp][$matricule][$periode] = array('form' => $ligne['form'], 'cert' => $ligne['cert']);
        }
        Application::DeconnexionPDO($connexion);

        return $listePonderations;
    }

    /**
     * retourne les sommes des pondérations [all] et par matricule pour un cours donné
     * fonction artificielle pour déterminer s'il faut ouvrir ou non les cases de poids de bulletin dans le carnet de cotes
     * si les sommes des pondérations pour une périoe ([all] et par matricule) sont 0, alors c'est que personne n'a de pondération pour la période
     * et il ne faut pas ouvrir la possibilité de mettre un poids pour la compétence correspondante.
     *
     * @param string $coursGrp : la dénomination du cours
     *
     * @return array : tableau des pondérations prévues pour chaque période, respectivement en formatif et en certificatif
     */
	public function sommesPonderations($coursGrp)
		{
			$listePonderations = current(self::getPonderations($coursGrp));
			$liste = array();
			if ($listePonderations != null) {
				foreach ($listePonderations as $key => $lesPonderations) {
					foreach ($lesPonderations as $periode => $ponderation) {
						if (!(isset($liste[$periode]))) {
							$liste[$periode] = array('form' => 0, 'cert' => 0);
						}

						if (is_numeric($this->sansVirg($ponderation['form'])))
							$liste[$periode]['form'] += $ponderation['form'];
						if (is_numeric($this->sansVirg($ponderation['cert'])))
							$liste[$periode]['cert'] += $ponderation['cert'];
					}
				}
			}

			return $liste;
		}

    /**
     * introduction d'une pondération vide lors du premier accès
     * la procédure retourne un tableau contenant une pondération vide.
     *
     * @param $nbPeriodes
     * @param $coursGrp
     *
     * @return array
     */
    public function ponderationsVides($nbPeriodes, $coursGrp)
    {
        $periodes = array();
        for ($n = 1; $n <= $nbPeriodes; ++$n) {
            $periodes[$n] = array('form' => '', 'cert' => '');
        }
        $listePonderations[$coursGrp]['all'] = $periodes;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        foreach ($periodes as $bulletin => $poids) {
            $sql = 'INSERT INTO '.PFX.'bullPonderations ';
            $sql .= "SET matricule='all', periode='$bulletin', coursGrp='$coursGrp', ";
            $sql .= "form='".$poids['form']."', cert='".$poids['cert']."'";
            $resultat = $connexion->exec($sql);
        }
        Application::DeconnexionPDO($connexion);

        return $listePonderations;
    }

    /**
     * recherche les pondérations applicables aux cours de la liste fournie
     * pour le bulletin numéro $bulletin.
     *
     * @param $listeCours
     * @param $bulletin
     *
     * @return array
     */
    public function getPonderationsBulletin($listeCours, $bulletin)
    {
        if (is_array($listeCours)) {
            $listeCoursString = "'".implode("','", array_keys($listeCours))."'";
        } else {
            $listeCoursString = "'".$listeCours."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT form, cert, matricule, coursGrp ';
        $sql .= 'FROM '.PFX.'bullPonderations ';
        $sql .= "WHERE coursGrp IN ($listeCoursString) AND periode = '$bulletin'";

        $resultat = $connexion->query($sql);
        $listePonderations = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $matricule = $ligne['matricule'];
                $listePonderations[$coursGrp][$matricule] = array('form' => $ligne['form'], 'cert' => $ligne['cert']);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $listePonderations;
    }

    /**
     * retourne les pondérations de chaque période pour les cours d'un niveau d'étude
     *
     * @param int $niveau
     *
     * @return array
     */
    public function getPonderationsNiveau($niveau){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT  DISTINCT SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1) AS cours, libelle, coursGrp, periode, form, cert ";
        $sql .= 'FROM '.PFX.'bullPonderations AS dbp ';
        $sql .= 'JOIN '.PFX."cours AS dc ON SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1) = dc.cours ";
        $sql .= 'WHERE SUBSTR(coursGrp,1,1) = :niveau ';
        $sql .= 'ORDER BY cours, periode ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $cours = $ligne['cours'];
                $periode = $ligne['periode'];
                if (!(isset($liste[$cours])))
                    $liste[$cours]['titres'] = array('cours' => $ligne['cours'], 'libelle' => $ligne['libelle']);
                $liste[$cours]['ponderations'][$periode] = array('form' => $ligne['form'], 'cert' => $ligne['cert']);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

        /**
         * liste structurée des profs liés à une liste de coursGrp (liste indexée par coursGrp).
         *
         * @param $listeCoursGrp : array
         * @param string | array : $listeCoursGrp
         *
         * @return array
         */
        public function listeProfsListeCoursGrp($listeCoursGrp, $type = 'string')
        {
            if (is_array($listeCoursGrp)) {
                $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
            } else {
                $listeCoursGrpString = "'".$listeCoursGrp."'";
            }
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT coursGrp, nom, prenom, sexe, '.PFX.'profsCours.acronyme ';
            $sql .= 'FROM '.PFX.'profsCours ';
            $sql .= 'JOIN '.PFX.'profs ON ('.PFX.'profsCours.acronyme = '.PFX.'profs.acronyme) ';
            $sql .= "WHERE coursGrp IN ($listeCoursGrpString) ";
            $sql .= 'ORDER BY nom';

            $resultat = $connexion->query($sql);
            $liste = array();
            if ($resultat) {
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $resultat->fetch()) {
                    $coursGrp = $ligne['coursGrp'];
                    $acronyme = $ligne['acronyme'];
                    $sexe = $ligne['sexe'];
                    $formule = ($sexe == 'M') ? 'M. ' : 'Mme';
                    if ($type == 'string') {
                        if (isset($liste[$coursGrp])) {
                            $liste[$coursGrp] .= ', '.$formule.' '.$ligne['prenom'].' '.$ligne['nom'];
                        } else {
                            $liste[$coursGrp] = $formule.' '.$ligne['prenom'].' '.$ligne['nom'];
                        }
                    } else {
                        $liste[$coursGrp][$acronyme] = $ligne;
                    }
                    // on supprime le cours dont le prof a été trouvé
                    unset($listeCoursGrp[$coursGrp]);
                }
            }
            Application::DeconnexionPDO($connexion);
                // on rajoute tous les cours dont les affectations de profs sont inconnues
                if ($listeCoursGrp != null) {
                    foreach ($listeCoursGrp as $coursGrp => $wtf) {
                        $liste[$coursGrp] = PROFNONDESIGNE;
                    }
                }

            return $liste;
        }

    /**
     * retourne une liste des élèves d'un groupe classe, ordonnée sur les matricules ,
     * reprenant tous les cours de chacun de ces élèves.
     *
     * @param $classe
     *
     * @return array
     */
    public function listeElevesCoursDeGroupe($classe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $listeElevesCours = array();
        $sql = 'SELECT '.PFX.'elevesCours.matricule, coursGrp ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'JOIN '.PFX.'eleves ON ('.PFX.'eleves.matricule = '.PFX.'elevesCours.matricule) ';
        $sql .= "WHERE groupe = '$classe' ";
        $resultat = $connexion->query($sql);
        $listeElevesCours = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            if (!(isset($listeElevesCours[$matricule]))) {
                $listeElevesCours[$matricule] = array();
            }
            $listeElevesCours[$matricule][] = $ligne['coursGrp'];
        }
        Application::DeconnexionPDO($connexion);

        return $listeElevesCours;
    }

    /**
     * retourne la liste des classes représentées parmi les élèves d'un coursGrp.
     *
     * @param $coursGrp
     *
     * @return array
     */
    public function classesDansCours($coursGrp)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT groupe ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'JOIN '.PFX.'eleves ON ('.PFX.'eleves.matricule = '.PFX.'elevesCours.matricule) ';
        $sql .= 'WHERE '.PFX."elevesCours.coursGrp = '$coursGrp'";
        $resultat = $connexion->query($sql);
        $listeClasses = array();
        while ($ligne = $resultat->fetch()) {
            $listeClasses[] = $ligne['groupe'];
        }
        Application::DeconnexionPDO($connexion);

        return $listeClasses;
    }

    /**
     * retourne toutes les informations (libelle, heures, statut,...)
     * d'un coursGrp passé en argument.
     *
     * @param $cours
     *
     * @return array
     */
    public function intituleCours($coursGrp)
    {
        $cours = self::coursDeCoursGrp($coursGrp);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT cours, coursGrp, nomCours, libelle, nbheures, statut, SUBSTR(coursGrp,1,LOCATE(':',coursGrp)-1) as annee ";
        $sql .= 'FROM '.PFX.'profsCours ';
        $sql .= 'JOIN '.PFX.'cours ON ('.PFX."cours.cours = '$cours') ";
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE coursGrp = '$coursGrp'";
        $resultat = $connexion->query($sql);
        $intitule = null;
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $intitule = $resultat->fetchall();
        }
        Application::DeconnexionPDO($connexion);

        return $intitule[0];
    }

    /**
     * vérification du fait qu'une pondération particulière à un élèves peut être supprimée
     * il faut que la pondération pour cet élève soit strictement équivalent à la pondération
     * pour l'ensemble des élèves du cours.
     *
     * @param $cours, $matricule
     *
     * @return bool : selon que la suppression est possible ou non
     */
    public function verifSupprPonderationPossible($coursGrp, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, periode, cert, form ';
        $sql .= 'FROM '.PFX.'bullPonderations ';
        $sql .= "WHERE coursGrp = '$coursGrp'";
        $ponderationEleve = array();
        $ponderationGeneral = array();
        $resultat = $connexion->query($sql);
        while ($ligne = $resultat->fetch()) {
            $periode = $ligne['periode'];
            $form = trim($ligne['form']);
            $cert = trim($ligne['cert']);
            if ($ligne['matricule'] == $matricule) {
                // cette ligne concerne l'élève visé
                $ponderationEleve[$periode] = array('form' => $form, 'cert' => $cert);
            }
                // sinon, c'est le barème général pour le cours
                else {
                    $ponderationGeneral[$periode] = array('form' => $form, 'cert' => $cert);
                }
        }
        Application::DeconnexionPDO($connexion);

        return $ponderationEleve == $ponderationGeneral;
    }

    /**
     * vérification que la modification du barème du cours demandé
     * fait partie de la liste des cours du prof qui fait la demande.
     *
     * @param string $coursGrp
     * @param array  $listeCours
     * @param string $matricule
     *
     * @return bool
     */
    public function legitimeModifBareme($coursGrp, $listeCours, $matricule)
    {
        $okProf = in_array($coursGrp, array_keys($listeCours));
        if ($matricule != 'all') {
            $Ecole = new Ecole();
            $listeEleves = $Ecole->listeElevesCours($coursGrp);
            $okEleve = in_array($matricule, array_keys($listeEleves));
        } else {
            $okEleve = true;
        }

        return $okProf && $okEleve;
    }

    /**
     * enregistrement de la pondération provenant du formulaire ad-hoc.
     *
     * @param $post
     *
     * @return int : nombre de modifications dans la BD
     */
    public function enregistrementPonderations($post)
    {
        $matricule = isset($post['matricule']) ? $post['matricule'] : null;
        $coursGrp = isset($post['coursGrp']) ? $post['coursGrp'] : null;
        if (($coursGrp == null) || ($matricule == null)) {
            die('missing cours or matricule');
        }
        $nbInsertions = 0;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        foreach ($post as $unChamp => $value) {
            $champ = explode('_', $unChamp);
            if (($champ[0] == 'formatif') || ($champ[0] == 'certif')) {
                // les autres champs issus du formulaire sont omis
                if ($champ[0] == 'formatif') {
                    $nom = 'form';
                }
                if ($champ[0] == 'certif') {
                    $nom = 'cert';
                }
                $periode = $champ[1];
                if ($value == '' || (is_numeric($value) && ($value >= 0))) {
                    $sql = 'INSERT INTO '.PFX.'bullPonderations ';
                    $sql .= "SET matricule='$matricule', periode='$periode', $nom='$value', coursGrp='$coursGrp' ";
                    $sql .= "ON DUPLICATE KEY UPDATE $nom='$value' ";

                    $resultat = $connexion->exec($sql);
                    if ($resultat > 0) {
                        // comptage pour éviter le doublement par DUPLICATE
                        ++$nbInsertions;
                    }
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nbInsertions;
    }

    /**
     * Suppression d'un barème particulier pour un élève et un cours.
     *
     * @param $cours
     * @param $matricule
     *
     * @return int : nombre de modifications dans la BD
     */
    public function suppressionPonderation($cours, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullPonderations ';
        $sql .= "WHERE coursGrp = '$cours' AND matricule = '$matricule'";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * ajouter une ligne dans la table des pondérations
     * la ligne est identique à celle du barème général du cours
     * mais sera marquée pour l'élève sélectionné.
     *
     * @param $coursGrp
     * @param $matricules
     *
     * @return bool
     */
    public function ajouterPonderation($coursGrp, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche de toutes les pondérations, y compris les cas particulier, pour ce cours
        $sql = 'SELECT matricule, periode, form, cert FROM '.PFX.'bullPonderations ';
        $sql .= "WHERE coursGrp = '$coursGrp'";
        $resultat = $connexion->query($sql);
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        $ponderations = array();
        while ($ligne = $resultat->fetch()) {
            $leMatricule = $ligne['matricule'];
            $periode = $ligne['periode'];
            $ponderations[$leMatricule][$periode] = array('form' => $ligne['form'], 'cert' => $ligne['cert']);
        }
        if ($ponderations == null) {
            // il n'y a pas encore de pondération pour ce cours
            $ponderations = self::ponderationsVides(NBPERIODES);
        }
        // on vérifie que la pondération n'existe pas déjà
        if (!in_array($matricule, array_keys($ponderations))) {
            // si c'est OK, on attribue la pondération de base (matricule = 'all') à cet élève
            $ponderation = $ponderations['all'];
            foreach ($ponderation as $periode => $poids) {
                $form = $poids['form'];
                $cert = $poids['cert'];
                $sql = 'INSERT INTO '.PFX.'bullPonderations ';
                $sql .= "SET matricule='$matricule', periode='$periode', form='$form', cert='$cert', coursGrp='$coursGrp'";
                $resultat = $connexion->exec($sql);
            }
            $retour = true;
        } else {
            $retour = false;
        }
        Application::DeconnexionPDO($connexion);

        return $retour;
    }

    /**
     * liste des compétences appliquées à un cours dont on fournit le "coursGrp"; il suffit donc de supprimer le groupe.
     *
     * @param $coursGrp
     *
     * @return array
     */
    public function listeCompetences($coursGrp)
    {
        $cours = self::coursDeCoursGrp($coursGrp);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, cours, ordre, libelle ';
        $sql .= 'FROM '.PFX.'bullCompetences ';
        $sql .= "WHERE cours='$cours' ";
        $sql .= 'ORDER BY ordre, libelle';
        $resultat = $connexion->query($sql);
        $listeCompetences = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $idComp = $ligne['id'];
                $cours = $ligne['cours'];
                $listeCompetences[$cours][$idComp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCompetences;
    }

    /**
     * retire le groupe d'un cours dont on passe le coursGroupe.
     *
     * @param sting $coursGrp
     *
     * @return string
     */
    private function coursSansGrp($coursGrp)
    {
        return substr($coursGrp, 0, strpos($coursGrp, '-', 0));
    }

    /**
     * retourne la liste ordonnées de toutes les compétences pour tous les cours passé en argument.
     *
     * @param $listeCours
     *
     * @return array
     */
    public function listeCompetencesListeCours($listeCours)
    {
        if (is_array($listeCours)) {
            $listeCoursString = "'".implode("','", array_keys($listeCours))."'";
        } else {
            $listeCoursString = "'".$listeCours."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, cours, ordre, libelle ';
        $sql .= 'FROM '.PFX.'bullCompetences ';
        $sql .= "WHERE cours IN ($listeCoursString)";
        $sql .= 'ORDER BY ordre';
        $resultat = $connexion->query($sql);
        $listeCompetences = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $idComp = $ligne['id'];
                $listeCompetences[$cours][$idComp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCompetences;
    }

    public function listeCompetencesListeCoursGrp($listeCoursGrp)
    {
        $listeCours = array();
        foreach ($listeCoursGrp as $coursGrp => $data) {
            $cours = self::coursSansGrp($coursGrp);
            $listeCours[$cours] = $data;
        }

        return self::listeCompetencesListeCours($listeCours);
    }

    /**
     * retourne la liste des compétences liées à un cours.
     *
     * @param $cours
     *
     * @return array
     */
    public function listeCompetencesCours($cours)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, ordre, libelle ';
        $sql .= 'FROM '.PFX.'bullCompetences ';
        $sql .= "WHERE cours = '$cours' ";
        $sql .= 'ORDER BY ordre, libelle';
        $resultat = $connexion->query($sql);
        $listeCompetences = array();
        while ($ligne = $resultat->fetch()) {
            $id = $ligne['id'];
            $ordre = $ligne['ordre'];
            $libelle = $ligne['libelle'];
            $listeCompetences[$id] = $libelle;
        }
        Application::DeconnexionPDO($connexion);

        return $listeCompetences;
    }

     /**
      * retourne la liste de toutes les compétences pour tous les cours passés en argument.
      *
      * @param $listeCoursGrp
      *
      * @return array : liste ordonnée sur le idComp
      */
     public function listeCompetencesTousEleves($listeCoursGrpEleves)
     {
         $listeCours = array();
         foreach ($listeCoursGrpEleves as $matricule => $coursGrpEleve) {
             foreach ($coursGrpEleve as $coursGrp) {
                 $cours = $this->coursSansGrp($coursGrp['coursGrp']);
                 // évitons les doublons
                 $listeCours[$cours] = $cours;
             }
         }
         $listeCoursString = "'".implode("','", array_keys($listeCours))."'";
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT id, cours, libelle ';
         $sql .= 'FROM '.PFX.'bullCompetences ';
         $sql .= "WHERE cours IN ($listeCoursString)";
         $resultat = $connexion->query($sql);
         $listeCompetences = array();
         while ($ligne = $resultat->fetch()) {
             $idComp = $ligne['id'];
             $listeCompetences[$idComp] = $ligne['libelle'];
         }
         Application::DeconnexionPDO($connexion);

         return $listeCompetences;
     }

    /**
     * retourne la liste des fiches d'élèves bloquées pour la page d'encodage du bulletin
     * la liste d'élèves arrive sous la forme d'un tableau.
     *
     * @param $listeEleves
     * @param $coursGrp
     * @param $periode
     */
    public function listeLocksBulletin($listeEleves, $listeCoursGrp, $periode)
    {
        $listeElevesString = implode(',', array_keys($listeEleves));
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coursGrp, locked FROM '.PFX.'bullLockElevesCours ';
        $sql .= "WHERE matricule IN ($listeElevesString) AND coursGrp IN ($listeCoursGrpString) AND periode='$periode' ";

        $resultat = $connexion->query($sql);
        $listeLocks = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $listeLocks[$matricule][$coursGrp] = $ligne['locked'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeLocks;
    }

    /**
     * retourne une liste des élèves et de leurs cours à un niveau donné.
     *
     * @param $niveau
     */
    public function listeElevesCoursGrpNiveau($niveau)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX."elevesCours.matricule, coursGrp, classe, CONCAT(nom,' ',prenom) AS nomPrenom ";
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'JOIN '.PFX.'eleves ON ('.PFX.'eleves.matricule = '.PFX.'elevesCours.matricule) ';
        $sql .= 'WHERE SUBSTR('.PFX."eleves.groupe,1,1) = '$niveau' ";
        $sql .= 'ORDER BY classe';
        $resultat = $connexion->query($sql);
        $listeElevesCoursGrp = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $classe = $ligne['classe'];
                $nomPrenom = $ligne['nomPrenom'];
                $listeElevesCoursGrp[$classe][$matricule][$coursGrp] = $nomPrenom;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeElevesCoursGrp;
    }

    /**
     * retourne la liste de tous les cours suivis par chaque élève.
     *
     * @param void
     *
     * @return array()
     */
    public function listeElevesCoursGrp($niveau = null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT dc.matricule, coursGrp, classe, CONCAT(nom,' ',prenom) AS nomPrenom ";
        $sql .= 'FROM '.PFX.'elevesCours AS dc ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON (de.matricule = dc.matricule) ';
        if ($niveau != null) {
            $sql .= "WHERE SUBSTR(classe,1,1) = '$niveau' ";
        }
        $sql .= 'ORDER BY classe ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $liste = $resultat->fetchAll();
        }
        Application::DeconnexionPDO($connexion);
        $listeElevesCours = array();
        while ($liste != null) {
            $data = array_pop($liste);
            $matricule = $data['matricule'];
            $coursGrp = $data['coursGrp'];
            $listeElevesCours[$matricule][$coursGrp] = array('classe' => $data['classe'], 'nomPrenom' => $data['nomPrenom']);
        }

        return $listeElevesCours;
    }

    /**
     * retourne la liste des verrous ouverts/fermés selon la valeur du paramètre $etatVerrou
     * pour la période donnée
     * pour un niveau donné
     * résultat par classe puis par cours.
     *
     * @param $periode
     * @param $niveau
     * @param $etatVerrou
     *
     * @return array : liste des verrous pour la période
     */
    public function listeLocksPeriode($periode, $niveau, $etatVerrou)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX."eleves.matricule, coursGrp, classe, CONCAT(nom,' ',prenom) AS nomPrenom ";
        $sql .= 'FROM '.PFX.'bullLockElevesCours ';
        $sql .= 'JOIN '.PFX.'eleves ON ('.PFX.'eleves.matricule = '.PFX.'bullLockElevesCours.matricule) ';
        $sql .= "WHERE periode = '$periode' AND locked != '$etatVerrou' AND SUBSTR(classe,1,1) = $niveau ";
        $sql .= 'ORDER BY classe, coursGrp, nomPrenom ';

        $resultat = $connexion->query($sql);
        $listeLocks = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $classe = $ligne['classe'];
                $niveau = substr($classe, 0, 1);
                $coursGrp = $ligne['coursGrp'];
                $nomPrenom = $ligne['nomPrenom'];
                $matricule = $ligne['matricule'];
                $listeLocks[$niveau][$classe][$coursGrp][$matricule] = $nomPrenom;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeLocks;
    }

    /**
     * Vidage de la table des verrous.
     *
     * @param void
     *
     * @return bool : true si l'opération s'est bien passée
     */
    private function resetLocks()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // suppression de tous les verrous existants par vidage de la table
        $sql = 'TRUNCATE TABLE '.PFX.'bullLockElevesCours ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Vidage de la table des notifications de décisions par Thot.
     *
     * @param void
     *
     * @return bool : true si l'opération s'est bien passée
     */
    public function resetDecisions()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullDecisions ';

        $resultat = $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Réinitialisation de tous les verrous à l'état "ouvert" à faire en début d'année scolaire.
     *
     * @param
     *
     * @return int : nombre d'enregistrements modifiés dans la BD
     */
    public function renewAllLocks()
    {
        $this->resetLocks();
        $listePeriodes = $this->listePeriodes(NBPERIODES);
        $listeElevesCours = $this->listeElevesCoursGrp();
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'bullLockElevesCours ';
        $sql .= "SET matricule=:matricule, coursGrp=:coursGrp, periode=:periode, locked='0' ";
        $requete = $connexion->prepare($sql);
        $resultat = 0;
        $liste = array();
        foreach ($listeElevesCours as $matricule => $listeCoursGrp) {
            foreach ($listeCoursGrp as $coursGrp => $wtf) {
                foreach ($listePeriodes as $periode) {
                    $data = array(':matricule' => $matricule, ':coursGrp' => $coursGrp, ':periode' => $periode);
                    $resultat += $requete->execute($data);
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * vide la table des accès aux bulletins depuis thot.
     *
     * @param void()
     */
    public function initialiserThot()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE '.PFX.'thotBulletin ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
    }

    /**
     * Enregistrement des positions des verrous depuis le formulaire.
     *
     * @param array $listeEleves : liste des matricules des élèves concernés
     * @param array $listeCours : liste des coursGrp concernés
     * @param string $type : coursGrp, eleve, eleveCours ou classe
     * @param int $action : 0 = déverouiller, 1 = verrou cours, 2 = verrou cours + commentaires
     * @param int $periode : période à (dé-)verrouiller
     *
     * @return int nombre d'enregistrements réalisés
     */
    public function saveLocksBulletin($listeEleves, $listeCours, $type, $action, $periode) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullLockElevesCours SET ';
        $sql .= 'matricule= :matricule, coursGrp = :coursGrp, locked = :action, periode = :periode ';
        $sql .= 'ON DUPLICATE KEY UPDATE locked = :action ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':action', $action, PDO::PARAM_INT);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

        $resultats = 0;
        switch ($type) {
            case 'coursGrp':
                $requete->bindParam(':coursGrp', $listeCours, PDO::PARAM_STR, 15);
                foreach ($listeEleves AS $wtf => $matricule) {
                    $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                    $resultats += $requete->execute();
                }
                break;
            case 'eleve':
                $requete->bindParam(':matricule', $listeEleves, PDO::PARAM_INT);
                foreach ($listeCours AS $key => $coursGrp) {
                    $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
                    $resultats += $requete->execute();
                }
                break;
            case 'eleveCours':
                $requete->bindParam(':matricule', $listeEleves, PDO::PARAM_INT);
                $requete->bindParam(':coursGrp', $listeCours, PDO::PARAM_STR, 15);
                $resultats += $requete->execute();
                break;
            case 'classe':
                foreach ($listeEleves AS $matricule => $wtf) {
                    $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                    foreach ($listeCours[$matricule] AS $coursGrp => $wtf) {
                        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
                        $resultats += $requete->execute();
                    }
                }
        }

        Application::DeconnexionPDO($connexion);

        return $resultats;
    }
    // public function saveLocksBulletin($post, $periode)
    // {
    //     $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    //     $sql = 'INSERT INTO '.PFX.'bullLockElevesCours SET ';
    //     $sql .= 'matricule=:matricule, coursGrp=:coursGrp, locked=:locked, periode=:periode ';
    //     $sql .= 'ON DUPLICATE KEY UPDATE locked=:locked';
    //
    //     $requete = $connexion->prepare($sql);
    //     $nbResultats = 0;
    //     foreach ($post as $unChamp => $value) {
    //         $data = explode('#', $unChamp);
    //         if ($data[0] == 'lock') {
    //             // dans le coursGrp, un espace éventuel avait été remplacé par un "~" dans le template;
    //         // il faut remettre l'espace
    //         $coursGrp = str_replace('~', ' ', $data[1]);
    //             $matricule = $data[2];
    //             $locked = $value;
    //             $verrou = array(
    //             ':matricule' => $matricule,
    //             ':coursGrp' => $coursGrp,
    //             ':locked' => $value,
    //             ':periode' => $periode,
    //             );
    //
    //             $nbResultats += $requete->execute($verrou);
    //         }
    //     }
    //     Application::DeconnexionPDO($connexion);
    //
    //     return $nbResultats;
    // }

    /**
     * pose les verrous sur tous les cours des classes passées dans $post
     * $post provenant du formulaire de l'administrateur du bulletin.
     *
     * @param array $post
     *
     * @return int nombre de verrous enregistrés
     */
    public function saveLocksAdmin($post, $bulletin)
    {
        $verrouiller = isset($post['verrou']) ? $post['verrou'] : null;
        $nbResultats = 0;

        if (($verrouiller == 0) || ($verrouiller == 1) || ($verrouiller == 2)) {
            $listeEleves = array();
            foreach ($post as $key => $value) {
                $data = explode('_', $key);
                if ($data[0] == 'classe') {
                    $classe = $data[1];
                    $listeEleves[$classe] = self::listeElevesCoursDeGroupe($classe);
                }
            }
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'bullLockElevesCours ';
            $sql .= "SET matricule=:matricule, coursGrp=:coursGrp, locked=:verrouiller, periode= :bulletin ";
            $sql .= "ON DUPLICATE KEY UPDATE locked= :verrouiller ";
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':verrouiller', $verrouiller, PDO::PARAM_INT);
            $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);
            foreach ($listeEleves as $classe => $eleves) {
                foreach ($eleves as $matricule => $listeCours) {
                    $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                    foreach ($listeCours as $no => $coursGrp) {
                        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
                        $nbResultats += $requete->execute();
                    }
                }
            }
            Application::DeconnexionPDO($connexion);
        }

        return $nbResultats;
    }

    /**
     * Enregistre le verrouillage / déverrouillage des cotes par classe, par cours et par élève
     * On déverrouille ou on verrouille (voir le contenu de la variable $_POST['verrouiller']) au cas par cas
     * à envisager: un verrouillage pour l'ensemble d'une classe => 1 enregistrement dans la BD / classe
     *  et un verrouillage pour l'ensemble d'un cours => 1 enregistrement dans la BD / cours.
     *
     * @param post
     *
     * @return nombre d'enregistrements
     */
    public function saveLocksClasseCoursEleve($post)
    {
        $verrouiller = isset($_POST['verrouiller']) ? $_POST['verrouiller'] : null;
        if (!(in_array($verrouiller, array('0', '1', '2')))) {
            die('illegal lock');
        }
        $bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : null;
        if (!($bulletin)) {
            die('illegal period');
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullLockElevesCours ';
        $sql .= "SET matricule=:matricule, coursGrp=:coursGrp, locked=:verrouiller, periode='$bulletin' ";
        $sql .= 'ON DUPLICATE KEY UPDATE locked=:verrouiller';
        $requete = $connexion->prepare($sql);
        $nb = 0;
        foreach ($post as $key => $value) {
            // récupérer les champs dont le nom commence par 'eleve' comme 'eleve%4087_coursGrp%4#GT:REL2-01'
            if (preg_match('/^eleve/', $key)) {
                $data = explode('_', $key);
                $eleve = $data[0];
                $dataEleve = explode('%', $eleve);
                $matricule = $dataEleve[1];

                $coursGrp = $data[1];
                $dataCours = explode('%', $coursGrp);

                // remplacement du code '#' utilisé pour remplacer le caractère ' ' dans le nom de champ
                $coursGrp = str_replace('#', ' ', $dataCours[1]);
                $data = array(
                        ':matricule' => $matricule,
                        ':coursGrp' => $coursGrp,
                        ':verrouiller' => $verrouiller,
                        );
                $nb += $requete->execute($data);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * function listeAttitudes.
     *
     * @param $listeEleves
     * @parame $coursGrp
     *
     * @param $bulletin
     *
     * liste des attitudes pour tous les élèves d'une liste donnée pour les cours
     * donnés. Pour un bulletin donné
     */
    public function listeAttitudes($listeEleves, $coursGrp, $bulletin)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        // attribution de l'attitude "Acquis" par défaut pour chacune des attitudes
        // pour chaque élève
        // permet de traiter les élèves qui n'ont pas encore d'attitude dans la BD
        $listeAttitudes = array();
        foreach ($listeEleves as $matricule => $data) {
            $listeAttitudes[$matricule] = array(1 => 'N', 2 => 'N', 3 => 'N', 4 => 'N');
        }

        // recherche et rectifications dans la base de données
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coursGrp, att1, att2, att3, att4 ';
        $sql .= 'FROM '.PFX.'bullAttitudes ';
        $sql .= "WHERE matricule IN ($listeElevesString) and coursGrp = '$coursGrp' ";
        $sql .= "AND bulletin = '$bulletin' ";
        $sql .= 'ORDER BY matricule';

        $resultat = $connexion->query($sql);
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $listeAttitudes[$matricule] = array(1 => $ligne['att1'], 2 => $ligne['att2'], 3 => $ligne['att3'], 4 => $ligne['att4']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeAttitudes;
    }

    /**
     * retourne la liste de tous les commentaires pour un cours donné pour toutes les périodes pour tous les élèves d'une liste donnée.
     *
     * @param $listeEleves
     * @param $coursGrp
     * @result array
     */
    public function listeCommentaires($listeEleves, $coursGrp)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, bulletin, commentaire ';
        $sql .= 'FROM '.PFX.'bullCommentProfs ';
        $sql .= "WHERE matricule IN ($listeElevesString) AND coursGrp = '$coursGrp' ";
        $sql .= 'ORDER BY matricule, coursGrp';
        $resultat = $connexion->query($sql);
        $listeCommentaires = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            // $cours = $ligne['coursgrp'];
            $bulletin = $ligne['bulletin'];
            $listeCommentaires[$matricule][$bulletin] = stripslashes($ligne['commentaire']);
        }
        Application::DeconnexionPDO($connexion);

        return $listeCommentaires;
    }

    /**
     * liste des commentaires pour tous les cours d'une liste d'élèves passée en argument
     * pour un bulletin éventuellement donné
     * si pas de bulletin précisé, renvoie les commentaires de tous les bulletins.
     *
     * Typiquement pour la génération d'un bulletin d'élève
     *
     * @param array|string $listeEleves : liste des matricules ou matricule
     * @param integer $bulletin : numéro du bulletin
     *
     * @return array
     */
    public function listeCommentairesTousCours($listeEleves, $bulletin = null)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($bulletin)) {
            $listeBulletinsString = implode(',', $bulletin);
        } else {
            $listeBulletinsString = $bulletin;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, com.coursGrp, commentaire, bulletin ';
        $sql .= 'FROM '.PFX.'bullCommentProfs AS com ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = com.coursGrp ';
        $sql .= 'WHERE matricule IN ('.$listeElevesString.') ';
        $sql .= 'AND virtuel = 0 ';
        if ($bulletin != null) {
            $sql .= 'AND bulletin IN ('.$listeBulletinsString.') ';
        }
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeCommentaires = array();
        while ($ligne = $requete->fetch()) {
            $commentaire = $ligne['commentaire'];
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            $bulletin = $ligne['bulletin'];
            $listeCommentaires[$matricule][$coursGrp][$bulletin] = stripslashes($commentaire);
        }
        Application::DeconnexionPDO($connexion);

        return $listeCommentaires;
    }

    /**
     * produire un tableau reprenant la somme des cotes de TJ et les sommes des cotes CERT
     * pour une liste d'élèves donnés et pour un bulletin donné
     * la liste est indexée sur les matricules et les cours concernés.
     *
     * @param $listeEleves
     * @param $bulletin
     *
     * @return array
     */
     public function sommesTjCertEleves($listeEleves, $bulletin)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, cotes.coursGrp, idComp, form, maxForm, cert, maxCert ';
        $sql .= 'FROM '.PFX.'bullDetailsCotes AS cotes ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = cotes.coursGrp ';
        $sql .= 'WHERE (matricule IN ('.$listeElevesString.')) ';
        $sql .= 'AND (bulletin = :bulletin) AND (virtuel = 0) ';
        $sql .= 'ORDER BY matricule, coursGrp, idComp';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);

        $cotesVides = array(
                    'form' => array('cote' => Null, 'max' => Null),
                    'cert' => array('cote' => Null, 'max' => Null),
                    );
        $listeCotes = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $idComp = $ligne['idComp'];
                $form = $this->sansVirg($ligne['form']);
                $maxForm = $this->sansVirg($ligne['maxForm']);
                $cert = $this->sansVirg($ligne['cert']);
                $maxCert = $this->sansVirg($ligne['maxCert']);
                if (!(isset($listeCotes[$matricule][$coursGrp]))) {
                    $listeCotes[$matricule][$coursGrp] = $cotesVides;
                }

                // s'il y a du **Formatif** pour cet enregistrement, on l'additionne
                if (($form != '') && ($maxForm != '')) {
                    // si form et maxForm sont des informations numériques, on les additionne
                    if (is_numeric($form) && is_numeric($maxForm)) {
                        $listeCotes[$matricule][$coursGrp]['form']['cote'] += $form;
                        $listeCotes[$matricule][$coursGrp]['form']['max'] += $maxForm;
                    }
                }  // if $form...
                // s'il y a du **Certificatif** pour cet enregistrement, on l'additionne
                if (($cert != '') && ($maxCert != '')) {
                    // si cert et maxCert sont des informations numériques, on les additionne
                    if (is_numeric($cert) && is_numeric($maxCert)) {
                        $listeCotes[$matricule][$coursGrp]['cert']['cote'] += $cert;
                        $listeCotes[$matricule][$coursGrp]['cert']['max'] += $maxCert;
                    }
                }  // if $cert...
            }  // while
        } // if $resultat
        Application::DeconnexionPDO($connexion);

        return $listeCotes;
    }


    /**
     * produire un tableau reprenant les sommes des cotes TJ et les sommes des cotes CERT
     * pour une liste d'élèves, une liste de cours, une liste de compétences et un bulletin donnés.
     *
     * @param $listeEleves: tableau dont les keys sont les $matricule
     * @param $listeCoursGrp: liste des coursGrp pour ces élèves
     * @param $listeCompetences: liste des compétences existantes pour ce cours
     * @param $bulletin: n° du bulletin concerné
     *
     * @return array tableau de la somme des cotes par élève, par cours et par compétence
     */
    public function listeCotes($listeEleves, $listeCoursGrp, $listeCompetences, $bulletin)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coursGrp, idComp, form, maxForm, cert, maxCert ';
        $sql .= 'FROM '.PFX.'bullDetailsCotes ';
        $sql .= "WHERE (matricule IN ($listeElevesString)) AND (coursGrp IN ($listeCoursGrpString)) ";
        $sql .= "AND (bulletin = '$bulletin') ";
        $sql .= 'ORDER BY matricule, idComp ';

        $cotesVides = array(
                            'form' => array('cote' => '', 'maxForm' => '', 'echec' => false),
                            'cert' => array('cote' => '', 'maxCert' => '', 'echec' => false),
                            );
        $listeCotes = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $idComp = $ligne['idComp'];

                // remplir le tableau avec des vides si on n'a pas encore vu
                // de competences pour cet élève (il n'est pas encore passé)
                if (!(isset($listeCotes[$matricule][$coursGrp]))) {
                    // on a besoin du cours pour trouver les compétences
                    $cours = self::coursDeCoursGrp($coursGrp);
                    $competences = $listeCompetences[$cours];
                    foreach ($competences as $id => $data) {
                        $listeCotes[$matricule][$coursGrp][$id] = $cotesVides;
                    }
                }

                // s'il y a du **Formatif** pour la compétence $idComp, on le note pour cet élève et ce cours
                if (($ligne['form'] != '') && ($ligne['maxForm'] != '')) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['cote'] = $this->sansVirg($ligne['form']);
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['maxForm'] = $this->sansVirg($ligne['maxForm']);
                    if (floatval($ligne['maxForm']) > 0) {
                        if ((floatval($ligne['form']) / floatval($ligne['maxForm'])) < 0.5) {
                            $listeCotes[$matricule][$coursGrp][$idComp]['form']['echec'] = 'echec';
                        }
                    }
                }

                // ----------------------------------------------------------------
                // s'il n'y a pas de cote mais seulement un maximum pour cette compétence (cote en attente)
                if (($ligne['maxForm'] != '') && ($ligne['form'] == '')) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['maxForm'] = $this->sansVirg($ligne['maxForm']);
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['echec'] = '';
                }
                // ----------------------------------------------------------------

                // ----------------------------------------------------------------
                // s'il n'y a qu'une mention non numérique (Abs, CM, NR, ...)
                if (!is_numeric($this->sansVirg($ligne['form']))) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['cote'] = $ligne['form'];
                    $listeCotes[$matricule][$coursGrp][$idComp]['form']['maxForm'] = $ligne['maxForm'];
                }
                // ----------------------------------------------------------------

                // s'il y a du **Certificatif** pour la compétence $competence, on le note pour cet élève et ce cours
                if (($ligne['cert'] != '') && ($ligne['maxCert'] != '')) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['cote'] = $this->sansVirg($ligne['cert']);
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['maxCert'] = $this->sansVirg($ligne['maxCert']);
                    if (floatval($ligne['maxCert']) > 0) {
                        if (floatval($ligne['cert']) / floatval($ligne['maxCert']) < 0.5) {
                            $listeCotes[$matricule][$coursGrp][$idComp]['cert']['echec'] = 'echec';
                        }
                    }
                }

                // ----------------------------------------------------------------
                // s'il n'y a pas de cote mais seulement un maximum pour cette compétence (cote en attente)
                if (($ligne['maxCert'] != '') && ($ligne['cert'] == '')) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['maxCert'] = $this->sansVirg($ligne['maxCert']);
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['echec'] = '';
                }
                // ----------------------------------------------------------------

                // ----------------------------------------------------------------
                // s'il n'y a qu'une mention non numérique (Abs, CM, NR, ...)
                if (!is_numeric($this->sansVirg($ligne['cert']))) {
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['cote'] = $ligne['cert'];
                    $listeCotes[$matricule][$coursGrp][$idComp]['cert']['maxCert'] = $ligne['maxCert'];
                }
                // ----------------------------------------------------------------
            }// while
        } // if $resultat
        Application::DeconnexionPDO($connexion);

        return $listeCotes;
    }

    /**
     * calcule les cotes de périodes pondérées pour tous les cours d'un élèves
     * les sommes des TJ et des Cert sont passées dans le tableau $sommesTjCert,
     * les pondérations à appliquer sont passées dans le tableau $ponderations.
     *
     * @param $sommesTjCert array
     * @param $ponderations array
     *
     * @return array
     */
    public function cotesPeriodePonderees($sommesTjCert, $ponderations)
    {
        $listeCotesPonderees = array();
        foreach ($sommesTjCert as $matricule => $lesCours) {
            foreach ($lesCours as $coursGrp => $lesCotes) {
                $laPonderation = $ponderations[$coursGrp];
                if (in_array($matricule, $laPonderation)) {
                    $ponderation = $laPonderation[$matricule];
                } else {
                    $ponderation = $laPonderation['all'];
                }
                if (is_numeric($lesCotes['form']['cote']) && is_numeric($lesCotes['form']['max'])) {
                    $coteForm100 = $lesCotes['form']['cote'] / $lesCotes['form']['max'];
                    $listeCotesPonderees[$matricule][$coursGrp]['form']['cote'] = round($coteForm100 * $ponderation['form'], 1);
                    $listeCotesPonderees[$matricule][$coursGrp]['form']['max'] = $ponderation['form'];
                    $mention = $this->calculeMention($coteForm100 * 100);
                    $listeCotesPonderees[$matricule][$coursGrp]['form']['mention'] = str_replace('+', 'plus', $mention);
                }
                if (is_numeric($lesCotes['cert']['cote']) && is_numeric($lesCotes['cert']['max'])) {
                    $coteCert100 = $lesCotes['cert']['cote'] / $lesCotes['cert']['max'];
                    $listeCotesPonderees[$matricule][$coursGrp]['cert']['cote'] = round($coteCert100 * $ponderation['cert'], 1);
                    $listeCotesPonderees[$matricule][$coursGrp]['cert']['max'] = $ponderation['cert'];
                    $mention = $this->calculeMention($coteCert100 * 100);
                    $listeCotesPonderees[$matricule][$coursGrp]['cert']['mention'] = str_replace('+', 'plus', $mention);
                }
            }
        }

        return $listeCotesPonderees;
    }

    /**
     * retourne les cotesGlobales pondérées, formatives et certificatives
     * à partir des cotes brutes et des pondérations pour la période donnée.
     *
     * @param $listeCotes
     * @param $ponderations
     * @param $periode
     */
    public function listeGlobalPeriodePondere($listeCotes, $ponderations, $periode)
    {
        $listeCotesGlobales = array();
        foreach ($listeCotes as $matricule => $lesCoursGrp) {
            foreach ($lesCoursGrp as $coursGrp => $lesCompetences) {
                $coteForm = 0;
                $maxForm = 0;
                $coteCert = 0;
                $maxCert = 0;
                foreach ($lesCompetences as $idComp => $lesCotes) {
                    $coteForm += $this->sansVirg(floatval($lesCotes['form']['cote']));
                    if (($lesCotes['form']['cote'] != '') && (is_numeric($this->sansVirg($lesCotes['form']['cote'])))) {
                        $maxForm += $this->sansVirg($lesCotes['form']['maxForm']);
                    }

                    $coteCert += $this->sansVirg(floatval($lesCotes['cert']['cote']));
                    if (($lesCotes['cert']['cote'] != '') && (is_numeric($this->sansVirg($lesCotes['cert']['cote'])))) {
                        $maxCert += $this->sansVirg($lesCotes['cert']['maxCert']);
                    }
                }
                $poids = $ponderations[$coursGrp];
                // y a-t-il une pondération spéciale pour l'élève à ce matricule?
                if (in_array($matricule, array_keys($poids))) {
                    $ponderation = $poids[$matricule];
                } else {
                    $ponderation = $poids['all'];
                }
                $cotesPonderees = array('form' => array('cote' => null, 'max' => null, 'echec' => null),
                                        'cert' => array('cote' => null, 'max' => null, 'echec' => null), );

                // s'il y a du formatif
                if ($ponderation[$periode]['form'] && $maxForm > 0) {
                    $cote = $coteForm / $maxForm * $ponderation[$periode]['form'];
                    $cote = ($cote > 50) ? round($cote, 0) : round($cote, 1);
                    $max = $ponderation[$periode]['form'];
                    if ($max > 0) {
                        $echec = ($cote / $max < 0.5) ? 'echec' : '';
                    } else {
                        $echec = '';
                    }
                    $cotesPonderees['form']['cote'] = $cote;
                    $cotesPonderees['form']['max'] = $max;
                    $cotesPonderees['form']['echec'] = $echec;
                }

                // s'il y a du certificatif
                if ($ponderation[$periode]['cert'] && $maxCert > 0) {
                    $cote = $coteCert / $maxCert * $ponderation[$periode]['cert'];
                    $cote = ($cote > 50) ? round($cote, 0) : round($cote, 1);
                    $max = $ponderation[$periode]['cert'];
                    if ($max > 0) {
                        $echec = ($cote / $max < 0.5) ? 'echec' : '';
                    } else {
                        $echec = '';
                    }
                    $cotesPonderees['cert']['cote'] = $cote;
                    $cotesPonderees['cert']['max'] = $max;
                    $cotesPonderees['cert']['echec'] = $echec;
                }

                $listeCotesGlobales[$matricule][$coursGrp] = $cotesPonderees;
            }
        }

        return $listeCotesGlobales;
    }

    /**
     * retourne la liste des situations de délibés pour tous les élèves qui suivent une série de coursGrp et pour un bulletin donné.
     *
     * @param $listeCoursGrp
     * @param $bulletin : le numéro du Bulletin
     *
     * @return array
     */
    public function listeSituationsInternes($listeCoursGrp, $bulletin)
    {
        $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coursGrp, sitDelibe, attributDelibe ';
        $sql .= 'FROM '.PFX.'bullSituations ';
        $sql .= "WHERE coursGrp IN ($listeCoursGrpString) AND bulletin = '$bulletin' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $liste[$matricule][$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le symbole correspondant à un attribut de cote de délibé.
     *
     * @param string $attribut
     *
     * @return char
     */
    public static function attribut2Symbole($attribut)
    {
        $symbolesAttributs = array(
            '' => '',
            'hook' => '',
            'degre' => '²',
            'star' => '<i class="fa fa-star"></i>',
            'magique' => '<i class="fa fa-magic"></i>',
            'externe' => '<i class="fa fa-graduation-cap"></i>',
            );
        $symbole = $symbolesAttributs[$attribut];

        return $symbole;
    }

    /**
     * retourne la liste des situations de délibés provenant des bulletins
     * pour une liste d'élèves données
     * pour une liste de cours donnée et
     * pour un bulletin donné
     * Si le numéro du bulletin n'est pas précisé, la liste revient avec tous les bulletins.
     *
     * @param string|array $listeEleves   : matricule ou liste des matricules des élèves concernés
     * @param string|array $listeCoursGrp : liste des coursGrp concernés
     * @param $bullletin : numéro du bulletin concerné
     *
     * @return array : liste des situations dans la liste de coursGrp indiqué
     */
 public function listeSituationsCours($listeEleves, $listeCoursGrp, $bulletin = null, $isDelibe = true)
    {
        // la liste d'élèves est fournie comme un tableau indexé sur les matricules
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche y compris l'épreuve externe
        $sql = 'SELECT bs.coursGrp, bs.matricule, bulletin, situation, maxSituation, nbheures, libelle, ';
        $sql .= 'choixProf, sitDelibe, cours, statut, dc.cadre, attributProf, attributDelibe ';
        $sql .= 'FROM '.PFX.'bullSituations AS bs ';
        // tous les niveaux n'ont pas d'épreuv externe => LEFT JOIN
        $sql .= 'JOIN '.PFX."cours AS dc ON (dc.cours = SUBSTR(bs.coursGrp,1,LOCATE('-',bs.coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON dc.cadre = dsc.cadre ';
        $sql .= "WHERE bs.matricule in ($listeElevesString) AND (bs.coursGrp IN ($listeCoursGrpString)) ";
        if ($bulletin) {
            $sql .= "AND bulletin='$bulletin' ";
        }
        $sql .= 'ORDER BY bulletin, bs.matricule ';

        $resultat = $connexion->query($sql);
        $listeSituationsCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
        }
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $bulletin = $ligne['bulletin'];
            $coursGrp = $ligne['coursGrp'];
            $statut = $ligne['statut'];
            $cadre = $ligne['cadre'];
            $cours = $ligne['cours'];
            $nbheures = $ligne['nbheures'];
            $libelle = $ligne['libelle'];
            $choixProf = $ligne['choixProf'];
            $attributProf = $ligne['attributProf'];
            $sitDelibe = $ligne['sitDelibe'];
            $attributDelibe = $ligne['attributDelibe'];
            $maxSituation = $this->sansVirg($ligne['maxSituation']);
            $situation = $this->sansVirg($ligne['situation']);

            // à partir du pivot 50/100, on arrondit à l'unité s'il y a une cote de situation
            if ($situation != '') {
                $situation = ($situation > 50) ? round($situation, 0) : round($situation, 1);
            }
            $situationPourCent = (!is_numeric($maxSituation) || ($situation === '') || ($maxSituation === '')) ? null : round(100 * $situation / $maxSituation, 0);

            // sommes-nous dans une période avec délibé?
            if ($isDelibe) {
                $sitDelibe = $ligne['sitDelibe'];
                $echec = (($sitDelibe < 50) && ($sitDelibe != '') && ($attributDelibe != 'hook')) ? 'echec' : '';
                $choixProf = $ligne['choixProf'];
            } else {
                $sitDelibe = null;
                $choixProf = null;
                $echec = null;
            }

            $listeSituationsCours[$matricule][$coursGrp][$bulletin] = array(
                    'sit' => $situation,
                    'max' => $maxSituation,
                    'pourcent' => $situationPourCent,
                    'echec' => $echec,
                    'choixProf' => $choixProf,
                    'attributProf' => $attributProf,
                    'sitDelibe' => $sitDelibe,
                    'attributDelibe' => $attributDelibe,
                    'symbole' => self::attribut2Symbole($attributDelibe),
                    'statut' => $statut,
                    'cadre' => $cadre,
                    'cours' => $cours,
                    'nbheures' => $nbheures,
                    'libelle' => $libelle,
                    );
        }
        Application::DeconnexionPDO($connexion);

        return $listeSituationsCours;
    }

    /**
     * retourne la liste de toutes les situations pour un bulletin donné pour un groupe d'élèves donné et pour une série de cours donnés.
     *
     * @param $listeEleves
     * @param $listeCoursGrp
     * @param $bulletin : le numéro du Bulletin
     *
     * @return array
     */
    public function listeSituationsFinales($listeEleves, $listeCoursGrp, $bulletin)
    {
        // la liste d'élèves est fournie comme un tableau indexé sur les matricules
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche y compris l'épreuve externe
        $sql = 'SELECT DISTINCT ext.coursGrp, ext.matricule, coteExterne, situation, maxSituation, ';
        $sql .= 'sitDelibe, attributDelibe, choixProf, attributProf ';
        $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
        $sql .= 'JOIN didac_bullSituations AS sit ON sit.coursGrp = ext.coursGrp AND ext.matricule = sit.matricule';
// WHERE ext.matricule IN ( 5905, 5749, 6009, 5803, 5748, 5737, 5824, 5799, 5757, 5759, 5822, 5830, 5796, 5736, 5790 )
// AND ext.coursGrp IN ('2S:EDM4-04', '2S:FR6-04', '2S:MATH6-04', '2S:NL4-04', '2S:SC3-04')
// AND bulletin = 5
// die($sql);
    }

    /**
     * retourne la liste de cotes de situation et délibé pour une liste de cours fournie et pour un bulletin donné.
     *
     * @param $listeCours : la liste des cours d'un prof, par exemple
     * @param $noBulletin : le numéro du bulletin correspondant
     *
     * @return array
     */
    public function listeSitDelibeVides($listeCoursGrp, $noBulletin)
    {
        $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT sit.matricule, sit.coursGrp, situation, maxSituation, choixProf, attributProf, sitDelibe, attributDelibe, ';
        $sql .= 'de.nom, de.prenom, ';
        $sql .= 'cours, libelle, nbheures, nomCours ';
        $sql .= 'FROM '.PFX.'bullSituations AS sit ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = sit.matricule ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1) ";
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = sit.coursGrp ';
        $sql .= "WHERE bulletin = $noBulletin ";
        $sql .= "AND sit.coursGrp IN ($listeCoursGrpString) ";
        $sql .= "AND (situation != '' AND sitDelibe = '') ";
        $sql .= 'ORDER BY sit.coursGrp ';

        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $matricule = $ligne['matricule'];
                $libelle = $ligne['libelle'];
                $liste[$coursGrp][$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des coursGrp et des matricules des élèves pour lesquels la situation est connue à la période indiquée.
     *
     * @param $listeCoursGrp
     * @param $noBulltin
     *
     * @return array
     */
    public function listeSituationsOK($listeCoursGrp, $noBulletin)
    {
        $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coursGrp ';
        $sql .= 'FROM '.PFX.'bullSituations as sit ';
        $sql .= "WHERE coursGrp IN ($listeCoursGrpString) AND bulletin = '$noBulletin' AND trim(situation) != '' ";
        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $matricule = $ligne['matricule'];
                $liste[$coursGrp][$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des cours pour lesquels existent des cotes en échec sans commentaire.
     *
     * @param $listeCoursGrp : array la liste des cours du prof concerné
     * @param $noBulletin: le numéro du bulletin correspondant
     *
     * @return array
     */
    public function listeEchecNonCommentes($listeCoursGrp, $noBulletin)
    {
        $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT sit.matricule, sit.coursGrp, sitDelibe, libelle, nom, prenom ';
        $sql .= 'FROM '.PFX.'bullSituations AS sit ';
        $sql .= 'JOIN '.PFX.'bullCommentProfs AS com ON com.matricule=sit.matricule AND com.coursGrp=sit.coursGrp AND com.bulletin=sit.bulletin ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = sit.matricule ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(sit.coursGrp,1,LOCATE('-',sit.coursGrp)-1) ";
        $sql .= "WHERE sit.coursGrp IN ($listeCoursGrpString) ";
        $sql .= "AND TRIM(sitDelibe) != '' AND sitDelibe < 50 AND sit.bulletin = '$noBulletin' AND trim(commentaire) = '' ";
        $sql .= 'ORDER BY coursGrp, nom, prenom ';

        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $matricule = $ligne['matricule'];
                $libelle = $ligne['libelle'];
                $liste[$coursGrp][$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * liste des situations de délibés par cours (et non par coursGrp).
     *
     * @param $listeEleves
     * @param $listeCoursGrp
     * @param $bulletin
     *
     * @return array
     */
    public function listeSituationsDelibe($listeEleves, $listeCoursGrp, $bulletin)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", $listeCoursGrp)."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT bs.coursGrp, bs.matricule, nbheures, libelle, sitDelibe, choixProf, situation, maxSituation, cours, statut, dc.cadre, attributProf, attributDelibe ';
        $sql .= 'FROM '.PFX.'bullSituations AS bs ';
        $sql .= 'JOIN '.PFX."cours AS dc ON (cours = SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON (dc.cadre = dsc.cadre) ';
        $sql .= 'WHERE bs.matricule in ('.$listeElevesString.') AND (bs.coursGrp IN ('.$listeCoursGrpString.')) ';
        $sql .= 'AND bulletin = :bulletin ';
        $sql .= 'ORDER BY bulletin, bs.matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $cours = $ligne['cours'];
                $sitDelibe = trim($ligne['sitDelibe']);
                $attributDelibe = $ligne['attributDelibe'];
                $ligne['symbole'] = self::attribut2Symbole($attributDelibe);
                $echec = (($sitDelibe < 50) && ($sitDelibe != '') && ($attributDelibe != 'hook')) ? 'echec' : '';
                $situation = $ligne['situation'];
                $maxSituation = $ligne['maxSituation'];
                if (is_numeric($maxSituation))
                    $situationPourCent = (($situation === '') || ($maxSituation === '')) ? null : round(100 * $situation / $maxSituation, 0);
                    else $situationPourCent = '-';
                $ligne['situationPourcent'] = $situationPourCent;
                $ligne['echec'] = $echec;
                $liste[$matricule][$cours] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche la dernière cotes de situation connue, avant le bulletin $bulletin
     * parmi les situations transmises par $listeSituations
     * cette variable contenant toutes les situations pour toutes les périodes.
     *
     * @param $listeSituations
     * @param $bulletin
     *
     * @return array : liste des situations précédentes
     */
    public function situationsPrecedentes($listeSituations, $bulletin)
    {
        $sitPrecedentes = array();
        foreach ($listeSituations as $matricule => $cotesCoursGrp) {
            foreach ($cotesCoursGrp as $coursGrp => $periodes) {
                $sitPrecedentes[$matricule][$coursGrp] = $this->situationPrecedente($periodes, $bulletin);
            }
        }

        return $sitPrecedentes;
    }

    /**
     * renvoie la dernière situation précédente connue avant le bulletin $bulletin pour le cours $coursGrp
     * la fonction retourne dans les périodes précédentes juqu'à trouver une sitPrec
     * fonction appelée par self:situationsPrecedentes.
     *
     * @param $coursGrp
     * @param $bulletin
     *
     * @return array
     */
    private function situationPrecedente($situations, $bulletin)
    {
        $sitPrec = array('sit' => null, 'maxSit' => null);
        $noBull = $bulletin - 1;
        $found = false;
        // on va, éventuellement, jusqu'au bulletin 0 (correspondant au report de l'année précédente)
        while (($noBull >= 0) && !($found)) {
            if (isset($situations[$noBull]) && isset($situations[$noBull]['max']) && (trim($situations[$noBull]['sit']) != '')) {
                $sitPrec['sit'] = $situations[$noBull]['sit'];
                $sitPrec['maxSit'] = $situations[$noBull]['max'];
                $found = true;
            }
            --$noBull;
        }

        return $sitPrec;
    }

    /**
     * calcule la nouvelle situation à partir de la situation précédente ($listeSituations)
     * et de la cote globale de période actuelle
     * pour le bulletin donné.
     *
     * @param $listeSituations
     * @param $listeGlobalPeriodePondere
     * @param $bulletin
     */
    public function calculeNouvellesSituations($listeSituations, $listeGlobalPeriodePondere, $bulletin)
    {
        foreach ($listeGlobalPeriodePondere as $matricule => $unCours) {
            foreach ($unCours as $coursGrp => $lesCotes) {
                // on recherche la situation précédente dans tous les bulletins précédents
                $sitPrec = $this->situationPrecedente($listeSituations[$matricule][$coursGrp], $bulletin);
                // au cas où, la situation précédente est recopiée dans la liste (cas d'un bulletin très ancien)
                $listeSituations[$matricule][$coursGrp][$bulletin - 1] = $sitPrec;
                $listeSituations[$matricule][$coursGrp][$bulletin]['sit'] =
                    $sitPrec['sit']
                    + $listeGlobalPeriodePondere[$matricule][$coursGrp]['form']['cote']
                    + $listeGlobalPeriodePondere[$matricule][$coursGrp]['cert']['cote'];

                $listeSituations[$matricule][$coursGrp][$bulletin]['max'] =
                    $sitPrec['maxSit']
                    + $listeGlobalPeriodePondere[$matricule][$coursGrp]['form']['max']
                    + $listeGlobalPeriodePondere[$matricule][$coursGrp]['cert']['max'];

                // limiter le nombre de décimales si > PIVOT
                if ($listeSituations[$matricule][$coursGrp][$bulletin]['max'] > 50) {
                    $listeSituations[$matricule][$coursGrp][$bulletin]['sit'] = round($listeSituations[$matricule][$coursGrp][$bulletin]['sit'], 0);
                } else {
                    $listeSituations[$matricule][$coursGrp][$bulletin]['sit'] = round($listeSituations[$matricule][$coursGrp][$bulletin]['sit'], 1);
                }

                // s'il n'y a pas de valeur pour le max, alors il n'y a pas de situation
                if ($listeSituations[$matricule][$coursGrp][$bulletin]['max'] == 0) {
                    $listeSituations[$matricule][$coursGrp][$bulletin]['sit'] = null;
                    $listeSituations[$matricule][$coursGrp][$bulletin]['max'] = null;
                }
                // si le max est > 0, on peut calculer un pourcentage
                if ($listeSituations[$matricule][$coursGrp][$bulletin]['max'] > 0) {
                    $listeSituations[$matricule][$coursGrp][$bulletin]['pourcent'] =
                    round(100 * $listeSituations[$matricule][$coursGrp][$bulletin]['sit'] / $listeSituations[$matricule][$coursGrp][$bulletin]['max'], 0);
                } else {
                    $listeSituations[$matricule][$coursGrp][$bulletin]['pourcent'] = null;
                }
            }
        }

        return $listeSituations;
    }

     /**
      * Enregistrement des cotes de situations recalculées après remplissage du bulletin.
      *
      * @param $listeNouvellesSituations
      * @param $bulletin
      * @result Null
      */
     public function enregistrerSituations($listeSituations, $bulletin)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         foreach ($listeSituations as $matricule => $cours) {
             foreach ($cours as $coursGrp => $lesSituations) {
                 $situation = $lesSituations[$bulletin]['sit'];
                 $maxSituation = $lesSituations[$bulletin]['max'];
                 $sql = 'INSERT INTO '.PFX.'bullSituations ';
                 $sql .= "SET matricule='$matricule', coursGrp='$coursGrp', bulletin='$bulletin', ";
                 $sql .= "situation='$situation', maxSituation = '$maxSituation' ";
                 $sql .= "ON DUPLICATE KEY UPDATE situation='$situation', maxSituation='$maxSituation'";
                 $resultat = $connexion->exec($sql);
             }
         }
         Application::DeconnexionPDO($connexion);
     }

    /**
     * enregistrement des cotes de situations de l'ensemble d'une classe
     * en provenance du formulaire de l'admin.
     *
     * @param array $post
     *
     * @return int : nombre d'enregistrements dans la BD
     */
    public function enregistrerSituationsClasse($post)
    {
        // organisation des cotes dans un tableau avant enregistrement
        $listeSituations = array();
        foreach ($post as $eleveCours => $cote) {
            $eleveCours = explode('#', $eleveCours);
            $type = $eleveCours[0];
            if (in_array($type, array('sit', 'max'))) {
                $matricule = explode('_', $eleveCours[1])[1];
                $coursGrp = explode ('_', $eleveCours[2]);
                $coursGrp = str_replace('!', ' ', $coursGrp[1]);
                if ($type == 'sit')
                    $listeSituations[$matricule][$coursGrp]['situation'] = $cote;
                    else $listeSituations[$matricule][$coursGrp]['maxSituation'] = $cote;
            }
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullSituations ';
        $sql .= 'SET bulletin = :bulletin, matricule = :matricule, coursGrp = :coursGrp, ';
        $sql .= 'situation = :situation, maxSituation = :maxSituation ';
        $sql .= 'ON DUPLICATE KEY UPDATE situation = :situation, maxSituation = :maxSituation ';
        $requete = $connexion->prepare($sql);

        $bulletin = $post['bulletin'];
        $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);

        $resultat = 0;
        foreach ($listeSituations as $matricule => $dataCours) {
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            foreach ($dataCours as $coursGrp => $dataCotes) {
                $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
                $requete->bindParam(':situation', $dataCotes['situation'], PDO::PARAM_STR, 6);
                $requete->bindParam(':maxSituation', $dataCotes['maxSituation'], PDO::PARAM_STR, 6);
                $resultat += $requete->execute();
                }
            }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    public function sommesBrutesFormCert($bulletin, $classe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX.'bullDetailsCotes.matricule, coursGrp, form, maxForm,cert, maxCert ';
        $sql .= 'FROM '.PFX.'bullDetailsCotes ';
        $sql .= 'JOIN '.PFX.'eleves ON ('.PFX.'eleves.matricule = '.PFX.'bullDetailsCotes.matricule) ';
        $sql .= "WHERE classe = '$classe' AND bulletin = '$bulletin'";
        $resultat = $connexion->query($sql);
        $listeSommes = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            if (!(isset($listeSommes[$matricule][$coursGrp]))) {
                $listeSommes[$matricule][$coursGrp] = array('form' => '', 'maxForm' => '', 'cert' => '', 'maxCert' => '');
            }
            if ((is_numeric($ligne['form'])) && (is_numeric($ligne['maxForm']))) {
                $listeSommes[$matricule][$coursGrp]['form'] += $ligne['form'];
                $listeSommes[$matricule][$coursGrp]['maxForm'] += $ligne['maxForm'];
            }
            if ((is_numeric($ligne['cert'])) && (is_numeric($ligne['maxCert']))) {
                $listeSommes[$matricule][$coursGrp]['cert'] += $ligne['cert'];
                $listeSommes[$matricule][$coursGrp]['maxCert'] += $ligne['maxCert'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeSommes;
    }

     /**
      * recalcul des cotes de situation au bulletin après modification manuelle des cotes de situation dans le bulletin n-1.
      *
      * @param $bulletin
      * @param $classe
      *
      * @return  array : cotes recalculées pour la période $bulletin
      */
     public function recalculSituationsClasse($bulletin, $classe)
     {
         $Ecole = new Ecole();
         $listeEleves = $Ecole->listeEleves($classe, 'groupe');
         $listeSitPrec = $this->getSituations($bulletin - 1, $listeEleves);
         $sommesPeriode = $this->sommesBrutesFormCert($bulletin, $classe);
         $listeCoursGrpClasse = $Ecole->listeCoursGrpClasse($classe);
         $ponderations = $this->getPonderations($listeCoursGrpClasse);

         $listeGlobalPeriode = array();
         foreach ($sommesPeriode as $matricule => $listeSommes) {
             foreach ($listeSommes as $coursGrp => $cotes) {
                 $periode = array();
                 $lesPonderations = $ponderations[$coursGrp];
                // recherche de la pondération pour l'élève et pour la période
                // $lesPonderations est vide si l'élève n'a pas ce coursGrp à la période suivante (voir historique)
                // ne pas faire de calculs dans ce cas
                if (isset($lesPonderations)) {
                    if (in_array($matricule, array_keys($lesPonderations))) {
                        $ponderation = $lesPonderations[$matricule][$bulletin];
                    } else {
                        $ponderation = $lesPonderations['all'][$bulletin];
                    }
                    if ((trim($cotes['form']) != '') && (trim($cotes['maxForm']) != '')) {
                        $form = $cotes['form'];
                        $maxForm = $cotes['maxForm'];
                        $periode['form'] = round($form / $maxForm * $ponderation['form'], 1);
                    } else {
                        $periode['form'] = null;
                    }

                    if ((trim($cotes['cert']) != '') && (trim($cotes['maxCert']) != '')) {
                        $cert = $cotes['cert'];
                        $maxCert = $cotes['maxCert'];
                        $periode['cert'] = round($cert / $maxCert * $ponderation['cert'], 1);
                    } else {
                        $periode['cert'] = null;
                    }
                    if ($periode['form'] || $periode['cert']) {
                        $listeGlobalPeriode[$matricule][$coursGrp] = array(
                            'periode' => array_sum($periode), 'maxPeriode' => $ponderation['form'] + $ponderation['cert'],
                            );
                    }
                }    // if ($lesPonderations)
             }
         }

         $listeSitAct = array();
         foreach ($listeSitPrec as $matricule => $listeCours) {
             foreach ($listeCours as $coursGrp => $cotes) {
                 $sitPrec = isset($listeSitPrec[$matricule][$coursGrp]['sit']) ? $listeSitPrec[$matricule][$coursGrp]['sit'] : null;
                 $sitPeriode = isset($listeGlobalPeriode[$matricule][$coursGrp]['periode']) ? $listeGlobalPeriode[$matricule][$coursGrp]['periode'] : null;
                 if (($sitPrec == null) || ($sitPeriode == null)) {
                     $listeSitAct[$matricule][$coursGrp]['sit'] = null;
                 } else {
                     $listeSitAct[$matricule][$coursGrp]['sit'] = $sitPrec + $sitPeriode;
                 }

                 $maxPrec = isset($listeSitPrec[$matricule][$coursGrp]['max']) ? $listeSitPrec[$matricule][$coursGrp]['max'] : null;
                 $maxPeriode = isset($listeGlobalPeriode[$matricule][$coursGrp]['maxPeriode']) ? $listeGlobalPeriode[$matricule][$coursGrp]['maxPeriode'] : null;
                 if (($maxPrec == null) || ($maxPeriode == null)) {
                     $listeSitAct[$matricule][$coursGrp]['max'] = null;
                 } else {
                     $listeSitAct[$matricule][$coursGrp]['max'] = $maxPrec + $maxPeriode;
                 }
             }
         }

         return $listeSitAct;
     }

     /**
      * Enregistrement de situations telles que recalculées après modification des situations.
      *
      * @param $listeSitActuelles
      * @param $bulletin :  période à enregistrer
      *
      * @return $nombre d'enregistrements
      */
     public function enregistrerSituationsRecalc($listeSitActuelles, $bulletin)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT INTO '.PFX.'bullSituations ';
         $sql .= "SET matricule=:matricule, bulletin='$bulletin', coursGrp=:coursGrp, ";
         $sql .= 'situation=:situation, maxSituation=:maxSituation ';
         $sql .= 'ON DUPLICATE KEY UPDATE situation=:situation, maxSituation=:maxSituation ';
         $requete = $connexion->prepare($sql);
         $nbResultats = 0;
         foreach ($listeSitActuelles as $matricule => $listeCoursGrp) {
             foreach ($listeCoursGrp as $coursGrp => $cotes) {
                 $data = array(
                    ':matricule' => $matricule,
                    ':coursGrp' => $coursGrp,
                    ':situation' => $cotes['sit'],
                    ':maxSituation' => $cotes['max'],
                    );
                 $nbResultats += $requete->execute($data);
             }
         }
         Application::DeconnexionPDO($connexion);

         return $nbResultats;
     }

    /**
     * liste des élèves sous forme de tableau avec le suivant et le précédent
     * utile pour des listes chaînées.
     *
     * @param $listeEleves
     */
    public function listeElevesSuivPrec($listeEleves)
    {
        $liste = array();
        $precedent = null;
        foreach ($listeEleves as $matricule => $unEleve) {
            $liste[$matricule]['prev'] = $precedent;
            $precedent = $matricule;
        }
        $listeEleves = array_reverse($listeEleves, true);
        $suivant = null;
        foreach ($listeEleves as $matricule => $unEleve) {
            $liste[$matricule]['next'] = $suivant;
            $suivant = $matricule;
        }

        return $liste;
    }

    /**
     * totaux bruts pour le Formatif et le Certificatif
     * pour la liste des cotes d'une période donnée
     * concerne tous les élèves d'un cours.
     *
     * @param $listeCotes
     *
     * @return array
     */
    public function listeSommesFormCert($listeCotes)
    {
        $sommesFormCert = array();
        foreach ($listeCotes as $matricule => $lesCours) {
            foreach ($lesCours as $coursGrp => $competences) {
                $sommeForm = 0;
                $sommeMaxForm = 0;
                $sommeCert = 0;
                $sommeMaxCert = 0;
                foreach ($competences as $idComp => $lesCotes) {
                    // il n'y a qu'un seul cours, en fait
                    $form = $lesCotes['form']['cote'];
                    $maxForm = $lesCotes['form']['maxForm'];
                    $cert = $lesCotes['cert']['cote'];
                    $maxCert = $lesCotes['cert']['maxCert'];

                    // on n'additionne que si les cotes et les max sont numériques simultanément
                    if (is_numeric($form) && is_numeric($maxForm)) {
                        $sommeForm += $form;
                        $sommeMaxForm += $maxForm;
                    }
                    if (is_numeric($cert) && is_numeric($maxCert)) {
                        $sommeCert += $cert;
                        $sommeMaxCert += $maxCert;
                    }
                }
                // s'il n'y a pas de max, au total, il n'y a pas de cote formative
                $sommeMaxForm = ($sommeMaxForm == 0) ? '' : $sommeMaxForm;
                $sommeForm = ($sommeMaxForm == '') ? '' : $sommeForm;
                $pourcentForm = ($sommeMaxForm > 0) ? round(100 * $sommeForm / $sommeMaxForm) : null;
                // s'il n'y a pas de max, au total, il n'y a pas de cote EX
                $sommeMaxCert = ($sommeMaxCert == 0) ? '' : $sommeMaxCert;
                $sommeCert = ($sommeMaxCert == '') ? '' : $sommeCert;
                $pourcentCert = ($sommeMaxCert > 0) ? round(100 * $sommeCert / $sommeMaxCert) : null;

                $sommesFormCert[$matricule] = array(
                    'totalForm' => $sommeForm,
                    'maxForm' => $sommeMaxForm,
                    'pourcentForm' => $pourcentForm,
                    'totalCert' => $sommeCert,
                    'maxCert' => $sommeMaxCert,
                    'pourcentCert' => $pourcentCert,
                    );
            }
        }

        return $sommesFormCert;
    }

    /**
     * retourne la liste des cotes étoilées (cote certificative > cote globale).
     *
     * @param $listeSommesFormCert
     *
     * @return array : liste des cotes à étoiler; vide si pas étoilé
     */
    public function listeCotesEtoilees($listeSommesFormCert, $listeSituations, $coursGrp, $bulletin)
    {
        $liste = array();
        foreach ($listeSommesFormCert as $matricule => $cotes) {
            $liste[$matricule] = '';
            if (($cotes['pourcentCert'] != null) && (isset($listeSituations[$matricule][$coursGrp][$bulletin]['pourcent']))) {
                if ($cotes['pourcentCert'] > $listeSituations[$matricule][$coursGrp][$bulletin]['pourcent']) {
                    $liste[$matricule] = $cotes['pourcentCert'];
                }
            }
        }

        return $liste;
    }

    /**
     * retourne les cotes de CEB d'un élève dont on fournit le matricule.
     *
     * @param $matricule
     *
     * @return array
     */
    public function getCEB($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT fr, math, sc, hg, l2 ';
        $sql .= 'FROM '.PFX.'bullCE1B ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $CEB = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $CEB = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $CEB;
    }

    /**
     * organisation rationnelle des cotes: une ligne par compétence extraite
     * du formulaire de rédaction du bulletin par cours.
     *
     * @param array $post
     *
     * @return array
     */
    public function organiserData($post)
    {
        $listeCotesParCompetences = array();
        $listeCotesPeriode = array();
        $listeAttitudes = array();
        $listeCommentaires = array();
        $listeChoixProf = array();
        $listeSituations = array();
        $listeAttributs = array();
        $genresPermis = array('form', 'maxForm', 'cert', 'maxCert');

        foreach ($post as $uneInfo => $value) {
            $value = htmlspecialchars($value);
            $data = explode('-', $uneInfo);
            switch ($data[0]) {
                case 'cote' :
                    // on retient les cotes Form et Cert
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $idComp = substr($data[2], strpos($data[2], '_') + 1);
                    $genre = $data[3];
                    if (in_array($genre, $genresPermis)) {
                        $listeCotesParCompetences[$matricule][$idComp][$genre] = $this->sansVirg($value);
                    }
                    // fonction $this->sansVirg pour transformer les "," en "." dans les nombres décimaux
                    // et supprime les espaces
                    break;
                case 'periode' :
                    die();
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $type = substr($data[2], strpos($data[2], '_') + 1);
                    if (!(isset($listeCotesPeriode[$matricule]))) {
                        $listeCotesPeriode[$matricule][$type] = array('sit' => '', 'maxForm' => '');
                    }
                    $listeCotesPeriode[$matricule][$type] = $value;
                    break;
                case 'attitudes' :
                    // on retient les attitudes
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $attitude = $data[2];
                    $listeAttitudes[$matricule][$attitude] = $value;
                    break;
                case 'commentaire' :
                    // on retient les commentaires
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $listeCommentaires[$matricule] = $value;
                    break;
                case 'sitDelibe' :
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $attributDelibe = $post['attributDelibe-matricule_'.$matricule];
                    $listeSituations[$matricule] = array('sitDelibe' => $value, 'attributDelibe' => $attributDelibe);
                    break;
                case 'choixProf' :
                    $matricule = substr($data[1], strpos($data[1], '_') + 1);
                    $attributProf = $post['attributProf-matricule_'.$matricule];
                    $listeChoixProf[$matricule] = array('choixProf' => $value, 'attributProf' => $attributProf);
                    break;
                default :
                    // on passe, ce champ n'est pas significatif
                    break;
            }
        }

        return array('cotes' => $listeCotesParCompetences,
                     'attitudes' => $listeAttitudes,
                     'commentaires' => $listeCommentaires,
                     'choixProf' => $listeChoixProf,
                     'sitDelibe' => $listeSituations,
                );
    }

    /**
     * enregistrement des données provenant de la page d'encodage du bulletin
     * $dataBulletin est un tableau structuré contenant les informations à enregistrer
     * $bulletin est le numéro du bulletin.
     *
     * @param $dataBulletin
     * @parame $bulletin
     *
     * @return array : une table des erreurs dans les encodages des cotes
     */
    public function enregistrerBulletin($dataBulletin, $coursGrp, $bulletin)
    {
        $tableErreurs = array();
        $texteLicite = explode(',', COTEABS);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        foreach ($dataBulletin as $table => $data) {
            switch ($table) {
                case 'cotes' :
                    foreach ($data as $matricule => $competences) {
                        foreach ($competences as $idComp => $lesCotes) {

                            // vérification des données du "formatif"
                            $form = (isset($lesCotes['form'])) ? strtoupper(trim($lesCotes['form'])) : null;
                            $maxForm = (isset($lesCotes['maxForm'])) ? strtoupper(trim($lesCotes['maxForm'])) : null;
                            if (is_numeric($form)) {
                                if (is_numeric($maxForm)) {
                                    $formOK = ($form <= $maxForm) ? true : false;
                                }
                            } elseif ($form == '') {
                                $formOK = true;
                            } else {
                                $formOK = (in_array($form, $texteLicite));
                            }

                            if ($formOK) {
                                $boutSql = "form='$form', maxForm='$maxForm'";
                                $sql = 'INSERT INTO '.PFX.'bullDetailsCotes SET ';
                                $sql .= "matricule='$matricule', coursGrp='$coursGrp', bulletin='$bulletin', ";
                                $sql .= "idComp='$idComp', form='$form', maxForm='$maxForm' ";
                                $sql .= "ON DUPLICATE KEY UPDATE form='$form', maxForm='$maxForm'";
                                $resultat = $connexion->exec($sql);
                            } else {
                                $tableErreurs[$matricule][$idComp] = true;
                            }

                            // vérification des données du Certificatif
                            $cert = (isset($lesCotes['cert'])) ? strtoupper(trim($lesCotes['cert'])) : null;
                            $maxCert = (isset($lesCotes['maxCert'])) ? strtoupper(trim($lesCotes['maxCert'])) : null;
                            if (is_numeric($cert)) {
                                if (is_numeric($maxCert)) {
                                    $certOK = ($cert <= $maxCert);
                                } else {
                                    $certOK = false;
                                }
                            } elseif ($cert == '') {
                                $certOK = true;
                            } else {
                                $certOK = (in_array($cert, $texteLicite));
                            }

                            if ($certOK) {
                                $boutSql = "cert='$cert', maxCert='$maxCert'";
                                $sql = 'INSERT INTO '.PFX.'bullDetailsCotes SET ';
                                $sql .= "matricule='$matricule', coursGrp='$coursGrp', bulletin='$bulletin', ";
                                $sql .= "idComp='$idComp', cert='$cert', maxCert='$maxCert' ";
                                $sql .= "ON DUPLICATE KEY UPDATE cert='$cert', maxCert='$maxCert'";

                                $resultat = $connexion->exec($sql);
                            } else {
                                $tableErreurs[$matricule][$idComp] = true;
                            }
                        }
                    }
                    break;
                case 'attitudes' :
                    $lesAttitudes = array('att1', 'att2', 'att3', 'att4');
                    foreach ($data as $matricule => $attitudes) {
                        foreach ($attitudes as $noAttitude => $value) {
                            // vérifier que l'attitude figure parmi celles qui sont attendues
                            if (in_array($noAttitude, $lesAttitudes)) {
                                $boutSql = "$noAttitude='$value'";
                                $sql = 'INSERT INTO '.PFX.'bullAttitudes ';
                                $sql .= "SET matricule='$matricule', coursGrp='$coursGrp', ";
                                $sql .= "bulletin='$bulletin', ".$boutSql.' ';
                                $sql .= 'ON DUPLICATE KEY UPDATE '.$boutSql;
                                $resultat = $connexion->exec($sql);
                            } else {
                                die("out of range $noAttitude");
                            }
                        }
                    }
                    break;
                case 'commentaires' :
                    // rubrique "commentaire" du prof pour le cours
                    foreach ($data as $matricule => $commentaire) {
                        $commentaire = addslashes($commentaire);
                        $sql = 'INSERT INTO '.PFX.'bullCommentProfs ';
                        $sql .= "SET matricule='$matricule', coursGrp='$coursGrp', ";
                        $sql .= "bulletin='$bulletin', commentaire = '$commentaire' ";
                        $sql .= "ON DUPLICATE KEY UPDATE commentaire = '$commentaire'";
                        $resultat = $connexion->exec($sql);
                    }
                    break;
                case 'choixProf' :
                    // cotes de périodes pondérées choisie par le titulaire du cours
                    foreach ($data as $matricule => $situation) {
                        $sitProf = $this->sansVirg($situation['choixProf']);
                        $attributProf = $situation['attributProf'];

                        $boutSql = "choixProf='$sitProf', attributProf='$attributProf' ";
                        $sql = 'INSERT INTO '.PFX.'bullSituations ';
                        $sql .= "SET matricule='$matricule', coursGrp='$coursGrp', ";
                        $sql .= "bulletin='$bulletin', $boutSql ";
                        $sql .= "ON DUPLICATE KEY UPDATE $boutSql ";
                        $resultat = $connexion->exec($sql);
                    }
                    break;
                case 'sitDelibe':
                    // cote de délibération pour la période
                    foreach ($data as $matricule => $situation) {
                        $sitDelibe = $this->sansVirg($situation['sitDelibe']);
                        $attributDelibe = $situation['attributDelibe'];

                        $boutSql = "sitDelibe='$sitDelibe', attributDelibe='$attributDelibe' ";
                        $sql = 'INSERT INTO '.PFX.'bullSituations ';
                        $sql .= "SET matricule='$matricule', coursGrp='$coursGrp', situation='-', maxSituation='-', choixProf='-', ";
                        $sql .= "bulletin='$bulletin', $boutSql ";
                        $sql .= "ON DUPLICATE KEY UPDATE $boutSql ";

                        $resultat = $connexion->exec($sql);

                        if (($sitDelibe < 0) || ($sitDelibe > 100)) {
                            $tableErreurs[$matricule]['sitDelibe'] = true;
                        }
                    }
                    break;
                default :
                    die('data error');
            }
        }
        Application::DeconnexionPDO($connexion);

        return $tableErreurs;
    }

    /**
     * Récapitulatif des cotes par compétence et des cotes globales
     * pour les élèves de la liste donnée, pour le cours donné et
     * pour un bulletin donné.
     *
     * @param $$listeEleves
     * @param $listeCompetences
     * @param $coursGrp
     * @param $bulletin
     *
     * @return array
     */
    public function recapCotesCours($listeEleves, $listeCompetences, $coursGrp, $bulletin)
    {
        $listeCotes = self::listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
        $ponderation = self::getPonderations($coursGrp, $bulletin);
        $cotesGlobales = self::listeSommesFormCert($listeCotes);
        foreach ($listeEleves as $matricule => $unEleve) {
            // on prend le premier élément de listeCotes qui contient les cotes
            // pour le cours
            $serieCotes = isset($listeCotes[$matricule]) ? $listeCotes[$matricule] : null;
            // s'il y a des cotes, on les traite
            if ($serieCotes) {
                $listeEleves[$matricule]['cotes'] = $serieCotes;
                foreach ($serieCotes as $idComp => $cotes) {
                    $listeEleves[$matricule]['cotes'][$idComp] = $cotes;
                }
            }
            // s'il y a des cotes globales pour la période, on les ajoute
            if (isset($cotesGlobales[$matricule])) {
                $listeEleves[$matricule]['globalPeriode'] = $cotesGlobales[$matricule];
            } else {
                $listeEleves[$matricule]['globalPeriode'] = null;
            }
        }

        return $listeEleves;
    }

    /**
     * liste de tous les cours qui se donnent à une liste d'élèves
     * sans tenir compte des cours-groupes éventuels.
     *
     * @param $listeEleves
     * @highStatus : liste des statuts de cours de haut niveau ('FC','OB') -> permet d'écarter les cours de Rem, AC,... Utile pour les synthèses générales
     *
     * @return array
     */
    public function listeCoursEleves($listeEleves, $highStatus = false)
    {
        if (is_array($listeEleves)) {
            $listeMatricules = implode(',', array_keys($listeEleves));
        } else {
            $listeMatricules = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT coursGrp, SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1) AS cours, matricule, ";
        $sql .= 'libelle, nbheures, statut, section ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'JOIN '.PFX.'cours ON ('.PFX."cours.cours = SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE matricule IN ($listeMatricules) ";
        // si l'on veut négliger les cours moins importants
        if ($highStatus) {
            $sql .= "AND statut IN ('FC','OB') ";
        }
        $sql .= 'ORDER BY nbheures DESC, libelle ';

        $resultat = $connexion->query($sql);
        $listeCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $matricule = $ligne['matricule'];
                $listeCours[$cours][$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

    /**
     * Établissement de la liste des coursGrp à un bulletin donné pour les élèves passés en argument
     * la liste tient compte de l'historique des mouvements
     *
     * @param string|array $listeEleves : liste des élèves concernés
     * @param int          $bulletin    : numéro du bulletin à considérer (important pour l'historique)
     * @param boolean $virtuel : veut-on les cours virtuels aussi?
     *
     * @return array : liste des cours suivis par la liste des élèves à la période $bulletin
     */
	public function listeCoursGrpEleves($listeEleves, $bulletin, $virtuel=false) {
        if (is_array($listeEleves)) {
            $listeMatricules = implode(',', array_keys($listeEleves));
        } else {
            $listeMatricules = $listeEleves;
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT delc.coursGrp, cours, libelle, nbheures, dsc.statut, dc.cadre, section, rang, matricule, nom, prenom, dpc.acronyme, dpc.virtuel  ';
        $sql .= 'FROM '.PFX.'elevesCours AS delc ';
        $sql .= 'JOIN '.PFX."cours AS dc ON (dc.cours = SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON (dsc.cadre = dc.cadre) ';
        // LEFT JOIN pour les cas où un élève aurait été affecté à un cours qui n'existe plus dans la table des profs
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS dpc ON (dpc.coursGrp = delc.coursGrp) ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON (dp.acronyme = dpc.acronyme) ';
        $sql .= "WHERE matricule IN ($listeMatricules) ";
        if ($virtuel == true) {
            $sql .= 'AND virtuel = false ';
            }
        $sql .= 'ORDER BY rang, nbheures DESC, rang, libelle ';

        $resultat = $connexion->query($sql);
        $listeCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $listeCours[$matricule][$coursGrp] = $ligne;
            }
        }
        $sql = 'SELECT matricule, dbhc.coursGrp, mouvement,  bulletin, dsc.statut, cadre, ';
        $sql .= 'cours, libelle, nbheures, rang, section, rang, nom, prenom, dpc.acronyme ';
        $sql .= 'FROM '.PFX.'bullHistoCours AS dbhc ';
        $sql .= 'JOIN '.PFX.'profsCours AS dpc ON (dpc.coursGrp = dbhc.coursGrp) ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(dpc.coursGrp, 1, LOCATE('-', dpc.coursGrp)-1) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON (dsc.cadre = dc.cadre) ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON (dp.acronyme = dpc.acronyme) ';
        $sql .= 'WHERE matricule IN ('.$listeMatricules.') ';
        if ($virtuel == true) {
            $sql .= 'AND virtuel = false ';
            }

        $resultat = $connexion->query($sql);
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $mouvement = $ligne['mouvement'];
                $depuis = $ligne['bulletin'];
                // si le $bulletin est antérieur à la période où a eu lieu le mouvement
                if ($bulletin < $depuis) {
                    // et qu'il s'agit d'un ajout
                    if ($mouvement == 'ajout') {
                        // il faut supprimer le cours qui a donc été ajouté ultérieurement
                        unset($listeCours[$matricule][$coursGrp]);
                    }
                        // sinon, c'est une suppression qui a été effectuée plus tard, et il faut rétablir ce cours à cet élève
                        else {
                            $listeCours[$matricule][$coursGrp] = array(
                            'coursGrp' => $coursGrp,            'cours' => $ligne['cours'],
                            'libelle' => $ligne['libelle'],     'nbheures' => $ligne['nbheures'],
                            'statut' => $ligne['statut'],       'cadre' => $ligne['cadre'],
                            'section' => $ligne['section'],
                            'rang' => $ligne['rang'],           'matricule' => $matricule,
                            'nom' => $ligne['nom'],             'prenom' => $ligne['prenom'],
                            'acronyme' => $ligne['acronyme'],
                            );
                        }
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

    /**
     * liste de tous les coursGrp ayant été affectés à un élève, y compris les cours supprimés dans l'historique
     * cette liste peut servir pour établir une liste cohérente des situations tout au long de l'année
     * une case est prévue pour tous les cours pour toutes les périodes, même si l'élève n'a pas/plus ce cours.
     *
      * @param array|integer $listeEleves : liste des matricules des élèves concernés
     *
     * @return array
     */
    public function listeFullCoursGrpActuel($listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeMatricules = implode(',', array_keys($listeEleves));
        } else {
            $listeMatricules = $listeEleves;
        }
        // liste des cours figurant officiellement dans la liste actuelle des cours des élèves concernés
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT ec.coursGrp, cours, libelle, nbheures, sc.statut, section, rang, matricule, nom, prenom, pc.acronyme ';
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX."cours AS c ON (c.cours = SUBSTR(ec.coursGrp, 1,LOCATE('-',ec.coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours AS sc ON (sc.cadre = c.cadre) ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON (pc.coursGrp = ec.coursGrp) ';
        $sql .= 'JOIN '.PFX.'profs AS p ON (p.acronyme = pc.acronyme) ';
        $sql .= 'WHERE matricule IN ('.$listeMatricules.') AND (virtuel = 0) ';
        $sql .= 'ORDER BY statut DESC, nbheures DESC, rang, libelle ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeCours = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $listeCours[$matricule][$coursGrp] = $ligne;
            }
        }

		// on ajoute tous les cours qui ont été ajoutés un jour... (même s'ils ont été supprimés ensuite)
		$sql = 'SELECT '.PFX.'histo.coursGrp, acronyme, nom, prenom, cours, libelle, nbheures, statut, section, rang ';
        $sql .= 'FROM '.PFX.'bullHistoCours AS histo ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON (pc.coursGrp = histo.coursGrp) ';
        $sql .= 'JOIN '.PFX.'profs AS profs ON (pc.acronyme = profs.acronyme) ';
        $sql .= 'JOIN '.PFX.'cours AS cours ON (cours.cours = SUBSTR(histo.coursGrp, 1, LOCATE("-", histo.coursGrp)-1)) ';
        $sql .= 'JOIN '.PFX.'statutCours AS statut ON (statut.cadre = cours.cadre) ';
        $sql .= 'WHERE matricule IN ('.$listeMatricules.') AND mouvement = "ajout" ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $listeCours[$matricule][$coursGrp] = array(
                            'coursGrp' => $coursGrp,                    'cours' => $ligne['cours'],
                            'libelle' => $ligne['libelle'],            'nbheures' => $ligne['nbheures'],
                            'statut' => $ligne['statut'],                'section' => $ligne['section'],
                            'rang' => $ligne['rang'],                'matricule' => $matricule,
                            'nom' => $ligne['nom'],                    'prenom' => $ligne['prenom'],
                            'acronyme' => $ligne['acronyme'],
                            );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }


    /**
     * recherche de la situation pour le bulletin actuel sur base de la liste de l'ensemble des situations
     * de toutes les périodes de cours ($listeSituations).
     *
     * @param array $listeSituations : liste détaillée des situations de toutes les périodes
     * @param $bulletin : numéro du bulletin pour lequel on souhaite la liste des situations
     *
     * @return array : la liste des situations par élève et par cours
     */
    public function situationsPeriode($listeSituations, $bulletin)
    {
        $situations = array();
        foreach ($listeSituations as $matricule => $dataCours) {
            foreach ($dataCours as $coursGrp => $dataSit) {
                // s'il y a un max, il doit y avoir autre chose; hope so...

                if (isset($dataSit[$bulletin]['max'])) {
                    $cotesPeriode = $dataSit[$bulletin];
                    $sit = $this->sansVirg(trim($cotesPeriode['sit']));
                    // si ce n'est pas une cote vide, on l'arrondit comme il le faut
                    if ($sit != '') {
                        $sit = ($sit > 50) ? round($sit, 0) : round($sit, 1); // l'arrondi qui va bien
                    }
                    $max = $this->sansVirg($cotesPeriode['max']);
                    $pourcent = $cotesPeriode['pourcent'];
                    $sitDelibe = isset($cotesPeriode['sitDelibe']) ? $cotesPeriode['sitDelibe'] : null;
                    $sitDelibe = $this->sansVirg(trim($sitDelibe, '*[]²'));
                    $attributDelibe = $cotesPeriode['attributDelibe'];
                    if ($attributDelibe == 'hook') {
                        $sitDelibe = '['.$sitDelibe.']';
                    }
                    $symbole = self::attribut2Symbole($attributDelibe);
                    $situations[$matricule][$coursGrp] = array(
                        'sit' => $sit,
                        'maxSit' => $max,
                        'pourcent' => $pourcent,
                        'sitDelibe' => $sitDelibe,
                        'symbole' => $symbole,
                        );
                }
            }
        }

        return $situations;
    }


    /***
     * retourne le cours correspondant au coursGrp passé en argument
     * @param $coursGrp
     */
    public function coursDeCoursGrp($coursGrp)
    {
        return substr($coursGrp, 0, strpos($coursGrp, '-'));
    }

    /**
     * retourne la mention accordée par le conseil de classe pour une période donnée
     * à une liste d'élèves donnée.
     *
     * @param $matricule
     * @param $periode // si pas de période, on cherche toutes les périodes
     * @param $annee  // si pas d'année précisée, on chercher pour toutes les années d'étude (pour quoi faire???)
     * @param $anscol // année scolaire pour laquelle on souhaite les mentions
     *
     * @return array
     */
    public function listeMentions($listeEleves, $periode = null, $annee = null, $anscol = null)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, mention, periode, annee, anscol ';
        $sql .= 'FROM '.PFX.'bullMentions ';
        $sql .= "WHERE matricule IN ($listeElevesString) ";
        if ($periode != null) {
            $sql .= "AND periode = '$periode' ";
        }
        if ($annee != null) {
            $sql .= "AND annee = '$annee' ";
        }
        if ($anscol != null) {
            $sql .= "AND anscol='$anscol' ";
        }

        $resultat = $connexion->query($sql);
        $listeMentions = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $annee = $ligne['annee'];
            $anScol = $ligne['anscol'];
            $mention = $ligne['mention'];
            $periode = $ligne['periode'];
            $listeMentions[$matricule][$anScol][$annee][$periode] = $mention;
        }
        Application::DeconnexionPDO($connexion);

        return $listeMentions;
    }

/**
 * renvoie les décisions de délibération pour la liste d'élèves indiqués.
 *
 * @param $matricule / liste de matricules
 *
 * @return array
 */
  public function listeDecisions($listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'SELECT dp.matricule, periode, user, mailDomain, decision, restriction, notification, mail, adresseMail, ';
        $sql .= "DATE_FORMAT(quand, '%d/%m %H:%i') AS quand, prenom, nom ";
        $sql .= 'FROM '.PFX.'passwd AS dp ';
        $sql .= 'LEFT JOIN '.PFX.'bullDecisions AS dbd ON dbd.matricule = dp.matricule ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dp.matricule ';
        $sql .= "WHERE dp.matricule IN ($listeElevesString) ";

        $resultat = $connexion->query($sql);
        $listeDecisions = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
            // vérifier si l'on peut encore envoyer la décision ou si c'est déjà fait
            $ligne['okEnvoi'] = ($ligne['quand'] == '') ? true : false;
            // l'adresse d'envoi est-elle définie (cas où les parents ont demandé le mail à la place de l'enfant)
            // $ligne['adresseMail'] revient avec l'adresse de substitution demandée par les parents (vient de la table bullDecistion)
            // mais s'il n'y en a pas et qu'un mail est demandé, l'adresse d'envoi est celle de l'élève
            if ($ligne['mail'] == '1') {
                $ligne['adresseMail'] = $ligne['user'].'@'.$ligne['mailDomain'];
            }
                $listeDecisions[$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeDecisions;
    }

    /**
     * Ajout du texte de notification pour chaque décision de la liste des décisions.
     *
     * @param $listeDecisions : la liste des élèves avec la décision du Conseil de Classe correspondante
     * @param $listeEleves : liste des élèves par matricule (key) avec leurs caractéristiques (nom, prénom,...)
     * @param $texte : le texte modèle pour la notification
     */
    public function listeDecisionsAvecTexte($listeDecisions, $listeEleves, $texteNotification)
    {
        foreach ($listeDecisions as $matricule => $data) {
            $decision = $data['decision'];
            $restriction = $data['restriction'];
            $nom = $listeEleves[$matricule]['prenom'].' '.$listeEleves[$matricule]['nom'];
            $classe = $listeEleves[$matricule]['classe'];
            $restrictions = ($restriction != '') ? $restriction : 'néant';

            // préparer un nouveau texte modèle contenant les ##motsÀremplacer##
            $leTexte = $texteNotification;
            $leTexte = str_replace('##nom##', $nom, $leTexte);
            $leTexte = str_replace('##classe##', $classe, $leTexte);
            $leTexte = str_replace('##decision##', $decision, $leTexte);
            $leTexte = str_replace('##restrictions##', $restrictions, $leTexte);
            $listeDecisions[$matricule]['texteDecision'] = $leTexte;
        }

        return $listeDecisions;
    }

    /**
     * dater (et donc clôturer) les décisions de C.Cl pour les élèves dont la liste est fournie en paramètre.
     *
     * @param array $listeEleves
     *
     * @return $nb : integer
     */
    public function daterDecisions($listeEleves)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $liste = array();
        foreach ($listeEleves as $matricule) {
            $sql = 'UPDATE '.PFX.'bullDecisions ';
            $sql .= 'SET quand=NOW() ';
            $sql .= "WHERE matricule = '$matricule' ";
            $resultat = $connexion->exec($sql);
            if ($resultat) {
                $liste[$matricule] = $matricule;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * établir la liste de synthèse des décisions prises pour les élèves dont la liste est fournie.
     *
     * @param $listeEleves
     *
     * @return array
     */
    public function listeSynthDecisions($listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT bd.matricule, periode, decision, restriction, mail, notification, adresseMail, DATE_FORMAT(quand, "%d/%m %H:%i") AS quand, ';
        $sql .= 'nom, prenom, user, mailDomain ';
        $sql .= 'FROM '.PFX.'bullDecisions AS bd ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = bd.matricule ';
        $sql .= 'JOIN '.PFX.'passwd AS dpw ON dpw.matricule = bd.matricule ';
        $sql .= "WHERE bd.matricule IN ($listeElevesString) ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $periode = $ligne['periode'];
                $photo = Ecole::photo($matricule);
                $ligne['photo'] = $photo;
                $liste[$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des élèves (et des décisions de C.Cl.) des élèves pour lesquels une notification Thot est souhaitée.
     *
     * @param $listeDecisions : la liste des décisions "brutes"
     * @param array la liste des décisions expurgée des élèves pour lesquels une notification n'est pas souhaitée
     */
    public function listeDecisionsNote($listeDecisions)
    {
        // $liste = array();
        foreach ($listeDecisions as $matricule => $data) {
            if ($data['notification'] == 0) {
                unset($listeDecisions[$matricule]);
            }
        }

        return $listeDecisions;
    }

    /**
     * retourne la liste des élèves (et des décisions de C.Cl.) des élèves pour lesquels une notification par mail est souhaitée.
     *
     * @param $listeDecisions : la liste des décisions "brutes"
     * @param array la liste des décisions expurgée des élèves pour lesquels une notification n'est pas souhaitée
     *
     * @return array : la liste de mailing par matricule
     */
    public function listeDecisionsMail($listeDecisions)
    {
        $liste = array();
        foreach ($listeDecisions as $matricule => $data) {
            if (($data['mail'] == 1) && ($data['adresseMail'] != '')) {
                $liste[$matricule] = array(
                        'matricule' => $matricule,
                        'nom' => $data['nom'],
                        'prenom' => $data['prenom'],
                        'mail' => $data['adresseMail'],
                    );
            }
        }

        return $liste;
    }

    /**
     * retourne la liste des commentaires "educ" par bulletin et par educ
     * pour la liste d'élèves donnée
     *
     * @param  array $listeEleves : liste des élèves concernés
     * @param int $bulletin : numéro du bulletin (éventuellement)
     * @return array liste des commentaires
     */
    public function listeCommentairesEduc($listeEleves, $bulletin = Null) {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, bulletin, fiche, commentaire, dbe.acronyme, nom, prenom, sexe, titre ';
        $sql .= 'FROM '.PFX.'bullEducs AS dbe ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = dbe.acronyme ';
        $sql .= 'WHERE matricule in ('.$listeElevesString.') ';
        if ($bulletin != Null)
            $sql .= 'AND bulletin=:bulletin ';

        $requete = $connexion->prepare($sql);
        if ($bulletin != Null)
            $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $bulletin = $ligne['bulletin'];
                $acronyme = $ligne['acronyme'];
                $commentaire = trim($ligne['commentaire']);
                if ($commentaire != '')
                    $liste[$matricule][$bulletin][$acronyme] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Enregistrement des commentaires Educ provenant du formulaire
     * @param  array $post contenu du formulaire
     * @param string $acronyme : propriétaire de la note
     *
     * @return int nombre d'enregistrements
     */
     public function saveCommentEduc($post, $acronyme) {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT INTO '.PFX.'bullEducs ';
         $sql .= 'SET acronyme=:acronyme, bulletin=:bulletin, matricule=:matricule, commentaire=:commentaire ';
         $sql .= 'ON DUPLICATE KEY UPDATE commentaire=:commentaire ';

         $requete = $connexion->prepare($sql);
         $data = array(
             ':bulletin' => $post['bulletin'],
             ':acronyme' => $acronyme
         );
         $n = 0;
         foreach ($post as $field => $value) {
             if (substr($field, 0,5) == 'note_') {
                 $matricule = explode('_', $field);
                 $matricule = $matricule[1];
                 $data['matricule'] = $matricule;
                 $data['commentaire'] = $value;
                 $n += $requete->execute($data);
             }
         }

        Application::DeconnexionPDO($connexion);

        return $n;
     }


    /**
     * retourne un tableau des 4 attitudes pour tous les élèves de la liste
     * pour tous les cours de l'élève pour le bulletin donné
     * si pas de bulletin passé, on prend tous les bulletins.
     *
     * @param string | array $listeEleves : matricule ou liste de matricules d'élèves concernés
     * @param int            $bulletin    : numéro du bulletin à imprimer
     *
     * @return array
     */
    public function tableauxAttitudes($listeEleves, $bulletin = null)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT bulletin, matricule, coursGrp, att1, att2, att3, att4 ';
        $sql .= 'FROM '.PFX.'bullAttitudes ';
        $sql .= "WHERE matricule IN ($listeElevesString) ";
        if ($bulletin != null) {
            $sql .= "AND bulletin = '$bulletin' ";
        }
        $sql .= 'ORDER BY bulletin';

        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
        }
        $tableauAttitudes = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            $ligne['cours'] = substr($coursGrp, 0, strpos($coursGrp, '-'));
            $bulletin = $ligne['bulletin'];
            $tableauAttitudes[$bulletin][$matricule][$coursGrp] = $ligne;
        }
        Application::DeconnexionPDO($connexion);

        return $tableauAttitudes;
    }

    /**
     * retourne les notes de la direction ou des coordinateurs à indiquer au bulletin donné dans l'année d'étude donnée.
     *
     * @param $bulletin
     * @param $$annee
     *
     * @return array
     */
    public function noteDirection($annee, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT remarque FROM '.PFX.'bullNotesDirection ';
        $sql .= "WHERE annee='$annee' AND bulletin='$bulletin'";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
        }
        $listeNotes = array();
        $ligne = $resultat->fetch();
        $listeNotes = $ligne['remarque'];
        Application::DeconnexionPDO($connexion);

        return $listeNotes;
    }

    /**
     * création d'une image d'un texte sur base des paramètres.
     *
     * @param $largeur
     * @param $hauteur
     * @param $texte
     * @param $taillePolice
     * @param $font
     * @param $nomImage
     */
    public function creeTexteVerticalPng($largeur, $hauteur, $texte, $taillePolice, $font, $nomImage)
    {
        // crée un texte disposé verticalement pour les entêtes des feuilles de cotes
        $im = imagecreate($largeur, $hauteur);

        // couleur de fond de l'image
        $gris = imagecolorallocate($im, 0xdd, 0xdd, 0xdd);
        $white = imagecolorallocate($im, 0xff, 0xff, 0xff);
        $black = imagecolorallocate($im, 0x00, 0x00, 0x00);

        // angle d'écriture = 90
        imagettftext($im, $taillePolice, 90, $taillePolice + 3, $hauteur - 4, $white, $font, $texte);
        imagettftext($im, $taillePolice, 90, $taillePolice + 4, $hauteur - 5, $black, $font, $texte);

        // Sauvegarde l'image
        imagepng($im, "$nomImage");
        imagedestroy($im);
    }

    /**
     * création des étiquettes verticales "images" pour les cours.
     *
     * @param $hauteur
     *
     * @return array : liste des images créées
     */
    public function imagesPngBranches($hauteur)
    {
        $listeBranches = Ecole::listeCours(Ecole::listeNiveaux());
        $largeur = 18;
        $fontSize = 10;
        $font = '../inc/font/LiberationMono-Bold.ttf';
        $liste = array();
        foreach ($listeBranches as $uneBranche => $data) {
            $nomImage = $uneBranche;
            $texte = $data['libelle'];
            $this->creeTexteVerticalPng($largeur, $hauteur, $texte, $fontSize, $font, "imagesCours/$nomImage.png");
            $liste[] = array('nomImage' => $nomImage, 'texte' => $texte);
        }

        return $liste;
    }

    /**
     * enregistrement des informations de pondérations passées depuis le forumlaire.
     *
     * @param $post : formulaire à décoder
     * @param $nbPeriodes : le nombre de périodes de l'année scolaire
     *
     * @return int : nombre de pondérations enregistrées
     */
    public function enregistrerPonderations($post, $nbPeriodes)
    {
        $listeCoursGrp = $post['listeCoursGrp'];
        $nbResultats = 0;
        if (count($listeCoursGrp) > 0) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'bullPonderations ';
            $sql .= "SET coursGrp=:coursGrp, periode=:periode, matricule='all', form=:form, cert=:cert ";
            $sql .= 'ON DUPLICATE KEY UPDATE form=:form, cert=:cert ';
            $requete = $connexion->prepare($sql);
            for ($periode = 1;$periode <= $nbPeriodes; ++$periode) {
                $champForm = "formatif_$periode";
                $form = $post[$champForm];
                $champCertif = "certif_$periode";
                $cert = $post[$champCertif];
                foreach ($listeCoursGrp as $coursGrp) {
                    $resultat = $requete->execute(array(
                                ':coursGrp' => $coursGrp,
                                ':periode' => $periode,
                                ':form' => $form,
                                ':cert' => $cert, )
                                );
                    if ($resultat) {
                        ++$nbResultats;
                    }
                }
            }
            Application::DeconnexionPDO($connexion);
        }

        return $nbResultats;
    }

    /**
     * retourne la liste des cours pour la liste de niveaux donnée.
     *
     * @param $listeNiveaux
     *
     * @return array
     */
    public function listeCoursNiveaux($listeNiveaux)
    {
        if (is_array($listeNiveaux)) {
            $listeNiveauxString = implode(',', $listeNiveaux);
        } else {
            $listeNiveauxString = $listeNiveaux;
        }
        $sections = "'".implode("','", $this->sections)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT cours, libelle, nbheures, section, statut ';
        $sql .= 'FROM '.PFX.'cours ';
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE SUBSTR(cours, 1,1) IN ($listeNiveauxString) ";
        $sql .= "AND section IN ($sections) ";
        $sql .= 'ORDER BY libelle ';

        $listeCours = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $listeCours[$cours] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

     /**
      * retourne la liste des cours réellemnent suivis par des élèves à un certain niveau d'études.
      *
      * @param $niveau
      *
      * @return array
      */
     public function listeCoursSuivisNiveau($niveau)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT DISTINCT coursGrp, libelle, cours, nbheures ';
         $sql .= 'FROM '.PFX.'elevesCours ';
         $sql .= 'JOIN '.PFX."cours AS dc ON (dc.cours = SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1)) ";
         $sql .= "WHERE SUBSTR(coursGrp,1,1) = '$niveau' ";
         $sql .= 'ORDER BY libelle, coursGrp ';
         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $cours = $ligne['cours'];
                 $liste[$cours] = $ligne;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

    /**
     * enregistrement des compétences provenant du formulaire "adminCompetences.tpl".
     *
     * @param $post
     *
     * @return int : nombre de modifications dans la BD
     */
    public function enregistrerCompetences($post)
    {
        // $cours = $post['cours'];
        // $resultat = 0;
        // // mise en ordre des données reçues
        // $dataExiste = array();
        // $dataNew = array();
        // foreach ($post as $field => $value) {
        //     $champ = explode('_', $field);
        //     // mises à jour et suppression des compétences
        //     if ($champ[0] == 'libelle') {
        //         $idComp = $champ[1];
        //         $dataExiste[$idComp]['libelle'] = addslashes($value);
        //     }
        //     if ($champ[0] == 'ordre') {
        //         $idComp = $champ[1];
        //         $dataExiste[$idComp]['ordre'] = addslashes($value);
        //     }
        //
        //     // nouvelles compétences
        //     if ($field == 'newComp') {
        //         $dataNew = $value;
        //     }
        // }
        // $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // foreach ($dataExiste as $idComp => $data) {
        //     if ($data['libelle'] == '') {
        //         $sql = 'DELETE FROM '.PFX.'bullCompetences ';
        //         $sql .= "WHERE id='$idComp'";
        //         $resultat += $connexion->exec($sql);
        //     } else {
        //         $ordre = $data['ordre'];
        //         $libelle = $data['libelle'];
        //         $sql = 'UPDATE '.PFX.'bullCompetences ';
        //         $sql .= "SET ordre='$ordre', libelle='$libelle' ";
        //         $sql .= "WHERE id = '$idComp'";
        //         $resultat += $connexion->exec($sql);
        //     }
        // }
        //
        // foreach ($dataNew as $libelle) {
        //     $libelle = addslashes($libelle);
        //     if ($libelle != '') {
        //         $sql = 'INSERT INTO '.PFX.'bullCompetences ';
        //         $sql .= "SET libelle='$libelle', cours='$cours'";
        //
        //         $resultat += $connexion->exec($sql);
        //     }
        // }
        // Application::DeconnexionPDO($connexion);
        //
        // return $resultat;
    }

    /**
     * enregistre l'ensemble des informations figurant au formulaire de gestion des compétences
     *
     * @param array $post
     *
     * @return int
     */
    public function saveCompetences($post){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'bullCompetences ';
        $sql .= 'SET libelle = :libelle, ordre = :ordre ';
        $sql .= 'WHERE id = :idComp AND cours = :cours ';
        $requete = $connexion->prepare($sql);
        // echo $sql;
        $cours = $post['cours'];
        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);

        // on n'a plus besoin du cours pour l'analyse des autres champs
        unset($post['cours']);

        $liste = array();
        foreach ($post as $field => $value) {
            $champ = explode('_', $field);
            $idComp = $champ[1];
            if ($champ[0] == 'libelle')
                $liste[$idComp]['libelle'] = $value;

            if ($champ[0] == 'ordre')
                $liste[$idComp]['ordre'] = $value;
            }

        $nb = 0;
        foreach ($liste as $idComp => $data) {
            $libelle = $data['libelle'];
            $ordre = $data['ordre'];
            $requete->bindParam(':idComp', $idComp, PDO::PARAM_INT);
            $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 100);
            $requete->bindParam(':ordre', $ordre, PDO::PARAM_INT);
            // Application::afficher(array($cours, $libelle, $ordre, $idComp));
            $resultat = $requete->execute();
            $nb += $requete->rowCount();
        }

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * Enregistrement d'une nouvelle compétence dans la table des compétences
     *
     * @param string $idComp
     *
     * @return int
     */
    public function addCompetence($cours, $libelle){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullCompetences ';
        $sql .= 'SET cours = :cours, ordre = 0, libelle = :libelle ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);
        $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 100);

        $resultat = $requete->execute();

        if($resultat)
            $idComp = $connexion->lastInsertId();
            else $idComp = -1;

        Application::DeconnexionPDO($connexion);

        return $idComp;
    }

    /**
     * Suppression de la compétences $idComp pour le cours $cours
     *
     * @param int $idComp
     * @param string $cours
     *
     * @return int
     */
    public function delCompetence($idComp, $cours){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullCompetences ';
        $sql .= 'WHERE id = :idComp AND cours = :cours ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);
        $requete->bindParam(':idComp', $idComp, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * recherche la liste des compétences utilisées dans la liste des compétences passée en argument
     *
     * @param array $listeCompetences
     *
     * @return array
     */
    public function getUsedCompetences($listeCompetences) {
        $listeString = implode(",", array_keys($listeCompetences));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // compétences utilisées dans le bulletin
        $sql = 'SELECT DISTINCT idComp ';
        $sql .= 'FROM '.PFX.'bullDetailsCotes ';
        $sql .= 'WHERE idComp IN ('.$listeString.') ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idComp = $ligne['idComp'];
                $liste[$idComp] = $idComp;
            }
        }

        $sql = 'SELECT DISTINCT idComp ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'WHERE idComp IN ('.$listeString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idComp = $ligne['idComp'];
                $liste[$idComp] = $idComp;
            }
        }

        APPLICATION::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le code "cadre" qui indique le statut des cours
     * cette fonction permet le lien entre le code "cadre" et les abréviations FC, OC, OB, OG, ...
     *
     * @param void
     *
     * @return array
     */
    public function listeStatutCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT cadre, statut, rang, legende ';
        $sql .= 'FROM '.PFX.'statutCours ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cadre = $ligne['cadre'];
                $liste[$cadre] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des cours sans élève et sans professeur.
     *
     * @param
     *
     * @return array
     */
    public function listOrphanCoursGrp()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // liste des cours associés à des élèves
        $sql = "SELECT DISTINCT SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1) AS cours ";
        $sql .= 'FROM '.PFX.'elevesCours ORDER BY cours';
        $resultat = $connexion->query($sql);
        $listeElevesCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $listeElevesCours[$cours] = $ligne;
            }
        }

        // liste des cours associés à des profs
        $sql = "SELECT DISTINCT SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1) AS cours ";
        $sql .= 'FROM '.PFX.'profsCours ORDER BY cours';
        $resultat = $connexion->query($sql);
        $listeProfsCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $listeProfsCours[$cours] = $ligne;
            }
        }

        // liste de tous les cours existants dans la table des cours
        $sql = 'SELECT cours, libelle, statut, nbheures ';
        $sql .= 'FROM '.PFX.'cours ';
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= 'ORDER BY libelle, cours';
        $resultat = $connexion->query($sql);
        $listeCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $listeCours[$cours] = $ligne;
            }
        }

        // sélection de tous les cours qui ne sont ni dans la liste des élèves ni dans la liste des profs
        $listeOrphanCours = array_diff_key($listeCours, $listeElevesCours, $listeProfsCours);

        return $listeOrphanCours;
    }

    /**
     * vérifie si une matière est sans prof et sans élève
     *
     * @param string $cours
     *
     * @return array
     */
    public function isOrphanMatiere($cours) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // la matière est-elle donnée par un prof?
        $sql = 'SELECT coursGrp ';
        $sql .= 'FROM '.PFX.'profsCours ';
        $sql .= 'WHERE SUBSTR(coursGrp, 1, LOCATE("-", coursGrp)-1) LIKE :cours ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $coursGrp;
            }
        }

        // la matière est-elle suivie par des élèves?
        $sql = 'SELECT DISTINCT coursGrp ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'WHERE SUBSTR(coursGrp, 1, LOCATE("-", coursGrp)-1) LIKE :cours ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);

        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $coursGrp;
            }
        }

        Application::DeconnexionPDO($connexion);

        return count($liste) == 0;
    }

    /**
     * enregistrement d'une nouvelle matière (méta-cours) dans la base de données
     * la fonction retourne le nombre d'enregistrements réalisés (normalement, un seul ou aucun) et le nom du cours enregistrés
     * cette dernière information est utile si le cours a été édité.
     *
     * @param array $post
     *
     * @return array (integer, string)
     */
    public function enregistrerMatiere($post)
    {
        $fullEdition = isset($post['fullEdition']) ? $post['fullEdition'] : null;
        $libelle = $post['libelle'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // s'il s'agit d'une édition d'un cours existant, on ne peut modifier que son libellé
        if ($fullEdition == 0) {
            $cours = $post['cours'];
            $sql = 'UPDATE '.PFX.'cours ';
            $sql .= 'SET libelle = :libelle ';
            $sql .= 'WHERE cours = :cours ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);
            $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 60);
            $resultat = $requete->execute();

            $nb = $requete->rowCount();
        } else {
            $annee = $post['niveau'];
            $section = $post['section'];
            $forme = $post['forme'];
            $code = $post['code'];
            $nbheures = $post['nbheures'];
            $cadre = $post['cadre'];
            $cours = $annee.$forme.':'.$code.$nbheures;
            $sql = 'INSERT INTO '.PFX.'cours ';
            $sql .= 'SET cours = :cours, nbheures = :nbheures, libelle = :libelle, cadre = :cadre, section = :section ';
            $sql .= 'ON DUPLICATE KEY UPDATE libelle= :libelle ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 17);
            $requete->bindParam(':nbheures', $nbheures, PDO::PARAM_INT);
            $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 60);
            $requete->bindParam(':cadre', $cadre, PDO::PARAM_INT);
            $requete->bindParam(':section', $section, PDO::PARAM_STR);

            $resultat = $requete->execute();

            $nb = $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return array('nb' => $nb, 'cours' => $cours);
    }

    /**
     * supprime la liste des cours passés en argument de la table des cours
     * ces cours sont, en principe, orphelins (pas d'élève, pas de prof).
     *
     * @param array/string $listeOrphans
     *
     * @return int : nombre de suppressions de la BD
     */
    public function deleteOrphanCours($listeOrphans)
    {
        if (is_array($listeOrphans)) {
            $listeOrphansString = "'".implode("','", $listeOrphans)."'";
        } else {
            $listeOrphansString = "'".$listeOrphans."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'cours ';
        $sql .= "WHERE cours IN ($listeOrphansString) ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne une synthèse de toutes les cotes de l'élève pour toutes les années d'étude
     * sauf si l'année est précisée.
     *
     * @param $matricule : le matricule de l'élève concerné
     * @param $annee : l'année d'étude (en principe, entre 1 et 6, si nécessaire)
     *
     * @return array
     */
    public function syntheseToutesAnnees($matricule, $annee = null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT annee AS anScolaire, SUBSTR(cours,1,1) as annee, bulletin, statut, '.PFX.'bullSitArchives.coursGrp, situation, maxSituation, ';
        $sql .= 'round(situation*100/maxSituation) as pourcent, sitDelibe, cours, nbheures, libelle, attributDelibe ';
        $sql .= 'FROM '.PFX.'bullSitArchives ';
        $sql .= 'LEFT JOIN '.PFX.'cours ON ('.PFX."cours.cours = SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1)) ";
        $sql .= 'LEFT JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE matricule = '$matricule' ";
        if ($annee != null) {
            $sql .= "AND SUBSTR(cours,1,1)='$annee' ";
        }
        $sql .= 'ORDER BY anScolaire DESC, annee DESC, bulletin, statut DESC, nbheures DESC ';

        $synthese = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $anScolaire = $ligne['anScolaire'];
                $bulletin = $ligne['bulletin'];
                $annee = $ligne['annee'];
                $sitDelibe = $ligne['sitDelibe'];
                if (($sitDelibe != '') && ($sitDelibe < 50)) {
                    $ligne['echec'] = 'echec';
                }
                $pourcent = $ligne['pourcent'];
                $ligne['mention'] = $this->calculeMention($pourcent);
                $pourcent = ($pourcent == null) ? '' : $pourcent.'%';
                $ligne['pourcent'] = $pourcent;
                $attribut = $ligne['attributDelibe'];
                $coursGrp = $ligne['coursGrp'];
                // raccourcissement du nom du cours sans l'année (Ex: "5 GT" est supprimé)
                $coursLong = $ligne['cours'];
                $ligne['cours'] = ($ligne['cours'] != Null) ? explode(':', $coursLong)[1] : '???';
                $synthese[$anScolaire][$annee]['resultats'][$bulletin][$coursGrp] = $ligne;
            }
        }

        // recherche de la liste de tous les cours qui figurent dans la synthèse
        foreach ($synthese as $anScolaire => $dataAnScol) {
            $listeCours = array();
            foreach ($dataAnScol as $annee => $data) {
                foreach ($synthese[$anScolaire][$annee]['resultats'] as $periode => $details) {
                    foreach ($details as $unCoursGrp => $details) {
                        // on ne reprend pas les cours pour lesquels il n'y a pas de cote de situation...
                        // => pas de colonne vide pour les élèves qui ont changé de cours avant le bulletin 1
                        if ($details['situation'] != '') {
                            $coursGrp = $details['coursGrp'];
                            if (!isset($listeCours[$coursGrp])) {
                                $listeCours[$coursGrp] = array(
                                    // 'cours' => $details['cours'],
                                    'cours' => $details['cours'],
                                    'libelle' => $details['libelle'],
                                    'nbheures' => $details['nbheures'],
                                    'statut' => $details['statut'],
                                    );
                            }
                        }
                    }
                }
                $synthese[$anScolaire][$annee]['listeCours'] = $listeCours;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $synthese;
    }

    /**
     * tableau des situations et des délibés pour l'année scolaire en cours
     * ce tableau est établi sur la base de la liste déclarée des cours suivis ou ayant été suivis par l'élève
     * puis par recherche de chacun de ces cours dans la table des bullSituation.
     *
     * @param $listeCoursGrp
     *
     * @return array : liste des situations pour chaque période
     */
    public function syntheseAnneeEnCours($listeCoursActuelle, $matricule)
    {
        $stringListeCoursActuelle = "'".implode("','", array_keys($listeCoursActuelle))."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT coursGrp, bulletin, situation, maxSituation, sitDelibe, attributDelibe, SUBSTR(coursGrp,1,LOCATE('-', coursGrp)-1) as cours, ";
        $sql .= 'SUBSTR(cours,1,1) as annee, statut, situation, maxSituation, sitDelibe, nbheures, libelle ';
        $sql .= 'FROM '.PFX.'bullSituations ';
        $sql .= 'JOIN '.PFX.'cours ON ('.PFX."cours.cours = SUBSTR(coursGrp,1,LOCATE('-', coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= "AND coursGrp IN ($stringListeCoursActuelle) ";
        $sql .= 'ORDER BY bulletin';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $bulletin = $ligne['bulletin'];
                $annee = $ligne['annee'];
                $sitDelibe = $ligne['sitDelibe'];
                $attribut = $ligne['attributDelibe'];
                $situation = $this->sansVirg($ligne['situation']);
                $maxSituation = $this->sansVirg($ligne['maxSituation']);
                $pourcent = ($maxSituation != 0) ? round(100 * $situation / $maxSituation, 0) : null;
                $ligne['mention'] = $this->calculeMention($pourcent);
                $pourcent = ($pourcent == null) ? '' : $pourcent.'%';
                $ligne['pourcent'] = $pourcent;
                if ($sitDelibe != '') {
                    if ($sitDelibe < 50) {
                        $ligne['echec'] = 'echec';
                    }
                }
                $coursGrp = $ligne['coursGrp'];
                $liste[$bulletin][$coursGrp] = $ligne;
            }
            Application::DeconnexionPDO($connexion);

            return $liste;
        }
    }

    /**
     * retourne les remarques du titulaire
     * pour une liste d'élèves donnée et
     * pour un  bulletin donné.
     *
     * @param $listeEleves
     * @param $bulletin
     *
     * @return array
     */
    public function remarqueTitu($listeEleves, $bulletin = null)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, bulletin, remarque ';
        $sql .= 'FROM '.PFX.'bullTitus ';
        $sql .= "WHERE matricule IN ($listeElevesString) ";
        if ($bulletin != null) {
            $sql .= "AND bulletin='$bulletin'";
        }
        $resultat = $connexion->query($sql);
        $listeRemarques = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $bulletin = $ligne['bulletin'];
            $listeRemarques[$matricule][$bulletin] = $ligne['remarque'];
        }
        Application::DeconnexionPDO($connexion);

        return $listeRemarques;
    }

    /**
     * enregistrement de la remarque du titulaire pour l'élève dont le matricule est indiqué, pour le bulletin donné.
     *
     * @param $commentaire
     * @param $matricule
     * @param $bulletin
     *
     * @return $resultat : nombre d'enregistrements réussis (normalement, 1)
     */
    public function enregistrerRemarque($remarque, $matricule, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $remarque = self::corrigeWord($remarque);

        $sql = 'INSERT INTO '.PFX.'bullTitus SET remarque = :remarque, ';
        $sql .= 'matricule = :matricule, bulletin = :bulletin ';
        $sql .= 'ON DUPLICATE KEY UPDATE remarque = :remarque ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);
        $requete->bindParam(':remarque', $remarque, PDO::PARAM_STR);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();
        if ($nb == 2)
            $nb = 1; // pour le cas du Update
        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * renvoie les informations de remarques sur le parcours scolaire pour un élève
     * dont on founit le matricule pour l'année d'étude en cours (si précisé)
     * ou pour toutes les années scolaires
     *
     * @param int $matricule
     * @param int Null | $anScol : année d'étude en cours ou rien
     *
     * @return array : pour chaque année scolaire, la notice "parcours"
     */
    public function getNoticesParcours($matricule, $annee = Null){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT parcours, annee ';
        $sql .= 'FROM '.PFX.'bullParcours ';
        $sql .= 'WHERE matricule = :matricule ';
        if ($annee != Null) {
            $sql .= 'AND annee = :annee ';
            $sql .= 'ORDER BY annee DESC ';
        }
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if ($annee != Null) {
            $requete->bindParam(':annee', $annee, PDO::PARAM_INT);
        }

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $annee = $ligne['annee'];
                $liste[$annee] = $ligne['parcours'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Enregistre la notice de conseil de parcours scolaire $parcours pour l'élève $matricule
     * dans l'année d'étude $annee
     *
     * @param int $matricule
     * @param string $parcours : texte du conseil
     * @param int $annee : année d'étude
     *
     * @return int : nombre d'enregistrements (0 ou 1)
     */
    public function setNoticesParcours($matricule, $annee, $parcours)
        {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $parcours = self::corrigeWord($parcours);

        $sql = 'INSERT INTO '.PFX.'bullParcours ';
        $sql .= 'SET matricule = :matricule, annee = :annee, parcours = :parcours ';
        $sql .= 'ON DUPLICATE KEY update parcours = :parcours ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':annee', $annee, PDO::PARAM_INT);
        $requete->bindParam(':parcours', $parcours, PDO::PARAM_STR);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();
        if ($nb == 2)
            $nb = 1; // pour le cas du UPDATE

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne la liste des classes en détaillant par degré et par année.
     *
     * @param
     *
     * @return array
     */
    public function listeStructClasses()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT groupe ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= 'ORDER BY groupe';
        $resultat = $connexion->query($sql);
        $liste = array();
        while ($ligne = $resultat->fetch()) {
            $classe = $ligne['groupe'];
            $annee = substr($classe, 0, 1);
            if (in_array($annee, range(1, 2))) {
                $degre = 1;
            } elseif (in_array($annee, range(3, 4))) {
                $degre = 2;
            } elseif (in_array($annee, range(5, 6))) {
                $degre = 3;
            }
            $liste[$degre][$annee][] = $classe;
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

     /**
      * retourne la liste des cotes de situation sit/max par cours pour la liste d'élèves indiquée.
      *
      * @param $bulletin : le bulletin concerné
      * @param $listeEleves : liste des matricules des élèves
      *
      * @return array
      */
     public function getSituations($bulletin, $listeEleves)
     {
         if (is_array($listeEleves)) {
             $listeElevesString = implode(',', array_keys($listeEleves));
         } else {
             $listeElevesString = $listeEleves;
         }
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT matricule, coursGrp, cours, situation, maxSituation ';
         $sql .= 'FROM '.PFX.'bullSituations ';
         $sql .= 'JOIN '.PFX."cours ON (SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1) = ".PFX.'cours.cours) ';
         $sql .= "WHERE matricule IN ($listeElevesString) AND bulletin = '$bulletin' ";

         $resultat = $connexion->query($sql);
         $listeSituations = array();
         while ($ligne = $resultat->fetch()) {
             $matricule = $ligne['matricule'];
             $cours = $ligne['cours'];
             $coursGrp = $ligne['coursGrp'];
             $sit = $this->sansVirg($ligne['situation']);
             $max = $this->sansVirg($ligne['maxSituation']);
             $listeSituations[$matricule][$cours] = array('coursGrp' => $coursGrp, 'sit' => $sit, 'max' => $max);
         }
         Application::DeconnexionPDO($connexion);

         return $listeSituations;
     }

     /**
      * Calcule la mention obetnue par un élève selon les règles en vigueur à l'ISND.
      *
      * @param $moyenne exprimée sur 100
      *
      * @return $string : mention obtenue
      */
     public function calculeMention($moyenne)
     {
         if (is_numeric($moyenne)) {
             $moyenneEntiere = intval($moyenne / 10);
             switch ($moyenneEntiere) {
                case 10: $mention = 'E'; break;
                case 9: $mention = 'E'; break;
                case 8: if ($moyenne >= 85) {
                     $mention = 'TB+';
                 } else {
                     $mention = 'TB';
                 } break;
                case 7: if ($moyenne >= 75) {
                     $mention = 'B+';
                 } else {
                     $mention = 'B';
                 } break;
                case 6: if ($moyenne >= 65) {
                     $mention = 'AB';
                 } else {
                     $mention = 'S';
                 } break;
                case 5: $mention = 'F'; break;
                default: $mention = 'I';
                }
         } else {
             $mention = '';
         }

         return $mention;
     }

    /**
     * retourne les situations sur 100 basées sur les cotes de situation calculées
     * pour le bulletin n° $bulletin
     * et pour les élèves dont la liste est fournie.
     *
     * @param $bulletin
     * @param $eleves
     *
     * @return array : coursGrp, sit100, mention
     */
    public function getSituations100($bulletin, $listeEleves)
    {
        $listeSituations = $this->getSituations($bulletin, $listeEleves);
        $listeSituations100 = array();
        foreach ($listeSituations as $matricule => $listeCours) {
            foreach ($listeCours as $cours => $cotes) {
                $coursGrp = $cotes['coursGrp'];
                $sit = $cotes['sit'];
                $max = $cotes['max'];
                if (($max != '') && ($sit != '')) {
                    $sit100 = round(100 * $sit / $max);
                    // suppression des + et -
                    $mention = trim($this->calculeMention($sit100), '+-');
                } else {
                    $sit100 = '';
                    $mention = '';
                }
                $listeSituations100[$matricule][$cours] = array('coursGrp' => $coursGrp, 'sit100' => $sit100, 'mention' => $mention);
            }
        }

        return $listeSituations100;
    }

     /**
     * retourne les moyennes par élèves pour la liste des situations par cours
     * passée en argument (getSituations100 juste au-dessus)
     *
     * @param array $listeSituations100
     *
     * @return array
     */
    public function getMoyennes($listeSituations100){
        $listeMoyennes = array();
        foreach ($listeSituations100 as $matricule => $data){
            $n = 0;
            $somme = 0;
            foreach ($data as $cours => $detailsCours){
                $sit100 = $detailsCours['sit100'];
                if (is_numeric($sit100)) {
                    $somme += $sit100;
                    $n++;
                    }
            }
            $moyenne = ($n > 0) ? round($somme / $n, 1) : '-';
            $listeMoyennes[$matricule]['cote'] = $moyenne;
            $listeMoyennes[$matricule]['mention'] = $this->calculeMention($moyenne);
        }

        return $listeMoyennes;
    }


    /*
     *
     * CARNET DE COTES  CARNET DE COTES
     * CARNET DE COTES  CARNET DE COTES
     * CARNET DE COTES  CARNET DE COTES
     *
     * */

    /**
     * retourne la liste de tous les travaux cotés pour ce cours durant la période précisée.
     *
     * @param $coursGrp : le cours
     * @param $bulletin : numéro du bulletin
     *
     * @return array
     */
    public function listeTravaux($coursGrp, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCarnet, coursGrp, cc.libelle, date, max, idComp, formCert, bulletin, ';
        $sql .= 'remarque, neutralise, ordre, publie ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes as cc ';
        $sql .= 'JOIN '.PFX.'bullCompetences as c ON (c.id = cc.idComp) ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND bulletin = '$bulletin' ";
        $sql .= 'ORDER BY formCert, date, ordre ';
        $listeTravaux = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $idCarnet = $ligne['idCarnet'];
                $ligne['date'] = $this->datePHPglue($ligne['date'], '/');
                $listeTravaux[$idCarnet] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeTravaux;
    }

   /**
     * retroune la liste de toutes les cotes dans le carnet de cotes pour la liste des cours donnée
     * pour l'élève dont on fournit le matricule
     *
     * @param array|string $listeCoursGrp
     * @param int $matricule
     *
     * @return array
     */
    public function getCotes4listeCoursGrp($listeCoursGrp, $matricule) {
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode('\',\'', array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = $listeCoursGrp;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT cote, max, coursGrp, dbcc.libelle, dbcp.libelle AS competence, date, formCert, bulletin, publie ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes AS dbcc ';
        $sql .= 'JOIN '.PFX.'bullCarnetEleves AS dbce ON dbce.idCarnet = dbcc.idCarnet ';
        $sql .= 'JOIN '.PFX.'bullCompetences AS dbcp ON dbcp.id = dbcc.idComp ';
        $sql .= 'WHERE matricule = :matricule AND coursGrp IN ('.$listeCoursGrpString.') AND publie = 1 AND neutralise = 0 ';
        $sql .= 'ORDER BY bulletin, date ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $bulletin = $ligne['bulletin'];
                $ligne['date'] = Application::datePHP($ligne['date']);

                if (in_array($ligne['cote'], explode(',', COTENULLE)))
                    $ligne['echec'] = true;
                    else {
                    if (($ligne['max'] > 0) && ($ligne['cote'] != '') && (!in_array($ligne['cote'], explode(',', COTEABS)))) {
                        $ligne['echec'] = ($ligne['cote'] / $ligne['max']) < 0.5;
                    } else {
                        $ligne['echec'] = false;
                    }
                }

                //if (($ligne['max'] > 0) && ($ligne['cote'] != '') && (!in_array($ligne['cote'], explode(',', COTEABS)))) {
                    //$ligne['echec'] = ($ligne['cote'] / $ligne['max']) < 0.5;
                //} else {
                    //$ligne['echec'] = false;
                //}
                $liste[$coursGrp][$bulletin][] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * conversion d'une date au format MySQL vers un format usuel
     * lors de la conversion, le symbole de séparation des nombres peut être choisi ($glue).
     *
     * @param string $dateMysql
     * @param char   $glue
     *
     * @return string
     */
    public function datePHPglue($dateMysql, $glue)
    {
        $dateArray = explode('-', $dateMysql);
        $phpArray = array_reverse($dateArray);
        $date = implode($glue, $phpArray);

        return $date;
    }

    /**
     * convertit une date contenant le séparateur $glue en date au format MySQL.
     *
     * @param $date : la date à convertir (Exemple: 07/10/2014)
     * @param $glue : le liant utilisé dans la date (dans l'exemple, le caractère "/")
     */
    public function dateMysqlGlue($date, $glue)
    {
        $dateArray = explode($glue, $date);
        $sqlArray = array_reverse($dateArray);
        $date = implode('-', $sqlArray);

        return $date;
    }

    /**
     * retourne les listes de cotes correspondant à la liste des travaux passée en argument.
     *
     * @param array $listeTravaux
     *
     * @return array
     */
    public function listeCotesCarnet($listeTravaux)
    {
        $listeTravauxString = implode(',', array_keys($listeTravaux));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT ccotes.idCarnet, matricule, ';
        $sql .= 'cote, ccotes.remarque, ccotes.neutralise, max ';
        $sql .= 'FROM '.PFX.'bullCarnetEleves AS celeves ';
        $sql .= 'JOIN '.PFX.'bullCarnetCotes AS ccotes ON ccotes.idCarnet = celeves.idCarnet ';
        $sql .= 'WHERE ccotes.idCarnet in ('.$listeTravauxString.') ';
        $sql .= 'ORDER BY ccotes.idCarnet ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeCotes = array();

        $texteLicite = array_merge(explode(',', COTEABS), explode(',', COTENULLE), explode(',', MENTIONSTEXTE));
        $texteNonEchec = array_merge(explode(',', COTEABS), explode(',', MENTIONSTEXTE));

        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $idCarnet = $ligne['idCarnet'];
                $cote = strtoupper($ligne['cote']);
                $trimCote = strtoupper($this->sansVirg(trim($cote, '!')));
                $remarque = $ligne['remarque'];
                $neutralise = $ligne['neutralise'];
                $max = strtoupper(trim($this->sansVirg($ligne['max'])));

                // ------------------------------------------------------------
                // est-ce une erreur d'encodage?
                if (is_numeric($this->sansVirg($trimCote))) {
                    $erreur = (($max < $trimCote) || ($trimCote < 0));
                    } else {
                        if (in_array($trimCote, $texteLicite) || $trimCote == '')
                            $erreur = false;
                            else $erreur = true;
                    }
                // ------------------------------------------------------------
                // est-ce une cote en échec?
                if (is_numeric($this->sansVirg($trimCote)) && is_numeric($this->sansVirg($max))) {
                    if (($max > 0) && ($trimCote != '')){
                        $echec = $this->estCoteNulle($trimCote) || ($trimCote / $max) < 0.5;
                        }
                        else $echec = false;
                    }
                    else {
                        $echec = (!in_array($trimCote, $texteNonEchec) && ($trimCote != ''));
                    }
                // ------------------------------------------------------------

                $listeCotes[$matricule][$idCarnet] = array(
                                    'cote' => $cote,
                                    'remarque' => $remarque,
                                    'neutralise' => $ligne['neutralise'],
                                    'erreurEncodage' => $erreur,
                                    'max' => $max,
                                    'echec' => $echec,
                                    );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $listeCotes;
    }

    /**
     * retourne la liste des erreurs trouvées dans la le carnet de cotes passé en paramètre
     *
     * @param $listeCotes
     *
     * @return array
     */
    public function listeErreursCarnet($listeCotes){
        $listeErreurs = array();
        if (count($listeCotes) > 0)
			foreach ($listeCotes as $idEleve => $dataCotes) {
				foreach ($dataCotes as $idCarnet => $data) {
					if ($data['erreurEncodage'] == true)
						$listeErreurs[] = array('idEleve' => $idEleve, 'idCarnet' => $idCarnet);
				}
			}
        return $listeErreurs;
    }

     /**
      * retourne la liste des moyennes des cotes correspondant à la liste des cotes
      * passée en paramètre.
      *
      * @param array $listeCotesCarnet
      *
      * @return array
      */
     public function listeMoyennesCarnet($listeCotesCarnet)
     {
         $moyennes = array();
         $sommes = array();
         $texteLicite = array_merge(explode(',', COTEABS), explode(',', MENTIONSTEXTE));
         if ($listeCotesCarnet) {
             foreach ($listeCotesCarnet as $matricule => $listeCotes) {
                 foreach ($listeCotes as $noCarnet => $data) {
                     $data['cote'] = strtoupper($data['cote']);
                     // on additionne pour la moyenne
					 // conversion d'une cote nulle en zéro
                     if ($this->estCoteNulle($data['cote']))
                        $data['cote'] = 0;
                    // s'il y a une cote et que ce n'est pas une mention d'absence (COTEABS) ou une (MENTIONTEXTUELLE)
                    if (($data['cote'] != '') && (!in_array($data['cote'], $texteLicite))) {
                        if (isset($sommes[$noCarnet])) {
                            $sommes[$noCarnet]['total'] += $data['cote'];
                            ++$sommes[$noCarnet]['nbCotes'];
                        } else {
                            $sommes[$noCarnet]['total'] = $data['cote'];
                            $sommes[$noCarnet]['nbCotes'] = 1;
                        }
                    }
                 }
             }
             if ($sommes) {
                 foreach ($sommes as $noCarnet => $data) {
                     if ($sommes[$noCarnet]['nbCotes'] > 0) {
                         $moyennes[$noCarnet] = $sommes[$noCarnet]['total'] / $sommes[$noCarnet]['nbCotes'];
                     } else {
                         $moyennes[$noCarnet] = '';
                     }
                 }
             }
         }

         return $moyennes;
     }

     /**
      * retourne les caractéristiques d'une évaluation dont on fournit le $idCarnet
      *
      * @param int $idCarnet
      *
      * @return array
      */
     public function getEnteteCote($idCarnet) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCarnet, coursGrp, dbcc.libelle, date, bulletin, max, dbcc.idComp, dbc.libelle AS competence, formCert, bulletin, remarque, neutralise, publie ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes AS dbcc ';
        $sql .= 'JOIN '.PFX.'bullCompetences AS dbc ON dbc.id = dbcc.idComp ';
        $sql .= 'WHERE idCarnet = :idCarnet ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);

        $entete = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $entete = $requete->fetch();
            $entete['date'] = Application::datePHP($entete['date']);
        }

        Application::deconnexionPDO($connexion);

        return $entete;
     }

     /**
      * crée une nouvelle entête de cote vide pour un cours $coursGrp donné et un $bulletin donné
      *
      * @param string $coursGrp
      * @param int $bulletin: période en coursgrp
      *
      * @return array
      */
     public function getNewEnteteCote($coursGrp, $bulletin) {
         $entete = array(
             'idCarnet' => Null,
             'coursGrp' => $coursGrp,
             'libelle' => Null,
             'date' => Application::dateNow(),
             'bulletin' => $bulletin,
             'max' => Null,
             'idComp' => Null,
             'competence' => Null,
             'formCert' => 'form',
             'remarque' => Null,
             'neutralise' => 0,
             'publie' => 0
         );
         return $entete;
     }

    /**
     * enregistrement des caractéristiques d'un travail dans le carnet de cotes
     * si $idCarnet dans $post est Null, c'est un nouveau travail.
     *
     * @param array $post : le formulaire de création d'une nouvelle évaluation
     *
     * @return int : nombre d'enregistrements
     * */
    public function recordEnteteCote($post)
    {
        $idCarnet = $post['idCarnet'];
        if (!(is_numeric($idCarnet)))
            $idCarnet = Null;
        $idComp = isset($post['idComp']) ? $post['idComp'] : null;
        $coursGrp = isset($post['coursGrp']) ? $post['coursGrp'] : null;
        $bulletin = isset($post['bulletin']) ? $post['bulletin'] : null;
        $date = isset($post['date']) ? Application::dateMysql($post['date']) : null;
        $formCert = isset($post['formCert']) ? $post['formCert'] : null;
        $neutralise = isset($post['neutralise']) ? 1 : 0;
        $remarque = addslashes(htmlspecialchars($post['remarque']));
        $libelle = addslashes(htmlspecialchars($post['libelle']));
        $max = isset($post['max']) ? $post['max'] : null;
        $max = $this->sansVirg($max);
        $publie = isset($post['publie']) ? 1 : 0;

        if (($coursGrp == null) || ($bulletin == null) || ($max == null) || ($idComp == null) || !(is_numeric($max))) {
            die("Erreur d'encodage");
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullCarnetCotes ';
        $sql .= 'SET idCarnet = :idCarnet, ';
        $sql .= 'coursGrp = :coursGrp, bulletin = :bulletin, date = :date, ';
        $sql .= 'idComp = :idComp, formCert = :formCert, neutralise = :neutralise, ';
        $sql .= 'max= :max, libelle = :libelle, remarque = :remarque, publie = :publie ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'coursGrp = :coursGrp, bulletin = :bulletin, date = :date, ';
        $sql .= 'idComp = :idComp, formCert = :formCert, neutralise = :neutralise, ';
        $sql .= 'max= :max, libelle = :libelle, remarque = :remarque, publie = :publie ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 20);
        $requete->bindParam(':bulletin', $bulletin, PDO::PARAM_INT);
        $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
        $requete->bindParam(':idComp', $idComp, PDO::PARAM_INT);
        $requete->bindParam(':formCert', $formCert, PDO::PARAM_STR, 4);
        $requete->bindParam(':neutralise', $neutralise, PDO::PARAM_INT);
        $requete->bindParam(':max', $max, PDO::PARAM_STR, 20);
        $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 50);
        $requete->bindParam(':remarque', $remarque, PDO::PARAM_STR, 50);
        $requete->bindParam(':publie', $publie, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistre les cotes pour toutes les colonnes déverrouillées.
     *
     * @param post
     *
     * @return array liste des erreurs
     */
    public function recordCotes($post)
    {
        $bulletin = isset($post['bulletin']) ? $post['bulletin'] : null;
        $coursGrp = isset($post['coursGrp']) ? $post['coursGrp'] : null;
        if (($bulletin == null) || ($coursGrp == null)) {
            die('missing data');
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullCarnetEleves ';
        $sql .= 'SET idCarnet = :idCarnet, matricule = :matricule, cote = :cote ';
        $sql .= 'ON DUPLICATE KEY UPDATE cote = :cote ';
        $requete = $connexion->prepare($sql);
        $nbResultats = 0;
        $listeErreurs = array();
        $texteLicite = array_merge(explode(',', COTEABS), explode(',', COTENULLE), explode(',', MENTIONSTEXTE));

        foreach ($post as $champ => $value) {
            // on s'intéresse aux champs dont le nom commence par 'cote'
            if (preg_match('/^cote/', $champ)) {
                // supprimer les blancs, la virgule et l'éventuel point d'exclamation
                $value = trim(strtoupper($this->sansVirg(str_replace(' ', '', $value))), '!');

                $data = explode('_', $champ);
                $idCarnet = explode('-', $data[0]);
                $idCarnet = $idCarnet[1];
                $matricule = explode('-', $data[1]);
                $matricule = $matricule[1];
                // vide ou mention licite => pas d'erreur
                if (($value == '') || (in_array($value, $texteLicite))) {
                    $erreur = false;
                }
                    // est-ce numérique?
                    elseif (is_numeric($value)) {
                        // si le max est inférieur à la cote => erreur
                        $erreur = ($post['max'.$idCarnet] < $value);
                        }
                        // si ce n'est pas numérique => erreur
                        else {
                            $erreur = true;
                        }

                if ($erreur) {
                    // ajout d'un point d'exclamation pour signaler une erreur
                    $value = $value.'!';
                    $listeErreurs[$idCarnet][$matricule] = true;
                }

                $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
                $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                $requete->bindParam(':cote', $value, PDO::PARAM_STR, 6);

                $nbResultats += $requete->execute();
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeErreurs;
    }

    /**
     * Vérifie que l'utilisateur actuel est bien détenteur du cours
     * dont on veut provoquer l'effacement d'une cote
     * efface la cote, le cas échéant. Sinon, die().
     *
     * @param int $idCarnet
     * @param array $listeCours
     *
     * @return int: nombre de cotes effacées
     */
    public function effacementLiciteCarnet($idCarnet, $listeCours)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'WHERE idCarnet = :idCarnet ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
            if ($ligne == null) {
                die('invalid note');
            }
        }

        $coursGrp = $ligne['coursGrp'];
        if (!(in_array($coursGrp, array_keys($listeCours)))) {
            die('invalid user');
        }
        $sql = 'DELETE FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'WHERE idCarnet = :idCarnet ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);

        $nbResultats = $requete->execute();
        if ($nbResultats > 0) {
            $sql = 'DELETE FROM '.PFX.'bullCarnetEleves ';
            $sql .= 'WHERE idCarnet = :idCarnet ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
            $nbResultats = $requete->execute();
        }
        Application::DeconnexionPDO($connexion);

        return $nbResultats;
    }

    /**
     * effacement de la cote $idCarnet du carnet de cotes
     *
     * @param int $idCarnet
     *
     * @return int : nombre d'effacements
     */
    public function deleteCote($idCarnet){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'WHERE idCarnet = :idCarnet ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
        $resultat = $requete->execute();

        if ($resultat) {
            $sql = 'DELETE FROM '.PFX.'bullCarnetEleves ';
            $sql .= 'WHERE idCarnet = :idCarnet ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
            $nbResultats = $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $nbResultats;
    }

    /**
     * retourne un tableau de la liste des poids des compétences
     * pour le certificatif et le formatif
     * par période.
     *
     * @param $coursGrp
     * @param $listeCompetences
     *
     * @return array
     */
    public function listePoidsCompetences($coursGrp, $listeCompetences, $nbPeriodes)
    {
        // préparer un tableau complet mais vide
        $listePoids = array();
        foreach ($listeCompetences as $idComp => $data) {
            foreach (range(1, $nbPeriodes) as $periode) {
                $listePoids[$periode][$idComp]['form'] = '';
                $listePoids[$periode][$idComp]['cert'] = '';
            }
        }

        $listeCompetencesString = implode(',', array_keys($listeCompetences));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT bulletin, certForm, poids, idComp ';
        $sql .= 'FROM '.PFX.'bullCarnetPoidsCompetences ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND idComp IN ($listeCompetencesString) ";
        $sql .= 'ORDER BY bulletin, idComp ';
        $resultat = $connexion->query($sql);

        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $bulletin = $ligne['bulletin'];
                $certForm = $ligne['certForm'];
                $idComp = $ligne['idComp'];
                $poids = $ligne['poids'];
                $listePoids[$bulletin][$idComp][$certForm] = $poids;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listePoids;
    }

    /**
     * Enregistre le poids donné à chaque compétence pour chaque période,
     * formatif et certificatif, dans le carnet de cotes.
     *
     * @param $post
     *
     * @return int nombre d'enregistrements
     * */
    public function recordPoidsCompetences($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $coursGrp = $post['coursGrp'];
        $sql = 'INSERT INTO '.PFX.'bullCarnetPoidsCompetences ';
        $sql .= 'SET coursGrp=:coursGrp, idComp=:idComp, bulletin=:bulletin, certForm=:certForm, poids=:poids ';
        $sql .= 'ON DUPLICATE KEY UPDATE poids=:poids';
        $requete = $connexion->prepare($sql);
        $nbResultats = 0;
        foreach ($post as $key => $value) {
            if (preg_match('/^comp/', $key)) {
                $data = explode('-', $key);
                $idComp = explode('_', $data[0]);
                $idComp = $idComp[1];
                $bulletin = explode('_', $data[1]);
                $bulletin = $bulletin[1];
                $certForm = $data[2];

                $data = array(
                        ':coursGrp' => $coursGrp,
                        ':idComp' => $idComp,
                        ':bulletin' => $bulletin,
                        ':certForm' => $certForm,
                        ':poids' => trim($this->sansVirg($value)),
                        );

                $nbResultats += $requete->execute($data);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nbResultats;
    }

    /**
     *	reset complet de tous les carnets de cotes de tous les profs
     *	fonction très dangereuse.
     *
     *	@param
     *
     *	@return
     */
    public function resetCcotes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullCarnetPoidsCompetences';
        $resultat = $connexion->exec($sql);
        $sql = 'TRUNCATE TABLE '.PFX.'bullCarnetEleves';
        $resultat = $connexion->exec($sql);
        $sql = 'TRUNCATE TABLE '.PFX.'bullCarnetCotes';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
    }

    /**
     * Suppression de toutes les mentions dans la table des pondérations
     *	fonction très dangereuse.
     *
     * @param
     *
     * @return bool : true si tout s'est bien passé
     */
    public function resetPonderations()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullPonderations ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Suppression du détail des cotes par compétence, TJ, EX aux bulletins
     * Fonction dangereuse, à n'utiliser qu'en début d'année scolaire.
     *
     * @param
     *
     * @return : true si tout s'est bien passé
     */
    public function resetDetailsCotes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullDetailsCotes ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Suppression de tous les commentaires des profs de branches, aux bulletins
     * Fonction dangereuse à n'utilise qu'en début d'année scolaire.
     *
     * @param
     *
     * @return : true si tout s'est bien passé
     */
    public function resetCommentProfs()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullCommentProfs ';
        $requete = $connexion->prepare($sql);
        $resultat = $requete->execute();

        $sql = 'TRUNCATE TABLE '.PFX.'didac_bullParcours ';
        $requete = $connexion->prepare($sql);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Suppression de tous les commentaires titulaires dans les bulletins.
     *
     * @param
     *
     * @return : true si tout s'est bien passé
     */
    public function resetCommentTitus()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullTitus ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Suppression des notices "coordinateurs".
     *
     * @param
     *
     * @return : true si tout s'est bien passé
     */
    public function resetCoordinateurs()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullNotesDirection ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Suppression de toutes les mentions d'attitudes.
     *
     * @param
     *
     * @return : true si tout s'est bien passé
     */
    public function resetAttitudes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullAttitudes ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

     /**
     * Suppression de toutes les remarques des éducateurs aux bulletins
     *
     * @param void
     *
     * @return boolean : true si tout s'est bien passé
     */
    public function resetEduc(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullEducs ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        if ($resultat) {
            return true;
        }
    }


    /**
     * Archivage des matricules et classes des élèves pour l'année scolaire indiquée.
     *
     * @param $annee
     * @param $listeEleves : array
     *
     * @return int : nombre de références archivées
     */
    public function archiveEleves($anneeScolaire, $listeEleves)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullArchives ';
        $sql .= "SET lematricule=:matricule, nomPrenom=:nomPrenom, classe=:classe, annee='$anneeScolaire' ";
        $sql .= 'ON DUPLICATE KEY UPDATE classe=:classe ';
        $requete = $connexion->prepare($sql);
        $nb = 0;
        foreach ($listeEleves as $matricule => $data) {
            $nomPrenom = $data['nom'].' '.$data['prenom'];
            $classe = $data['groupe'];
            $eleve = array(':matricule' => $matricule, ':nomPrenom' => $nomPrenom, ':classe' => $classe);
            $resultat = $requete->execute($eleve);
            if ($resultat) {
                ++$nb;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * Archivage vers la table bullSitArchives des cotes de situation des élèves pour l'année scolaire indiquée.
     *
     * @param string $anneeScolaire
     *
     * @return true : si l'opération s'est bien passée
     */
    public function archiveSituations($anneeScolaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullSitArchives (annee, matricule, coursGrp, bulletin, situation, maxSituation, sitDelibe, attributDelibe) ';
        $sql .= "SELECT '$anneeScolaire', matricule, coursGrp, bulletin, situation, maxSituation, sitDelibe, attributDelibe ";
        $sql .= 'FROM '.PFX.'bullSituations ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * vide la table des situations après archivage.
     *
     * @param void
     *
     * @return true si tout s'est bien passé
     */
    public function deleteSituations()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullSituations ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * vide les tables profs/cours et eleves/cours en début d'année scolaire.
     *
     * @param void
     *
     * @return true si tout s'est bien passé
     */
    public function delProfsElevesCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'elevesCours ';
        $resultat = $connexion->exec($sql);
        $sql = 'TRUNCATE TABLE '.PFX.'profsCours ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * Archivage vers la table bullExterneArchives des cotes d'épreuves externes de la table bullEprExterne.
     *
     * @param void
     *
     * @return true : si l'opération s'est bien passée
     */
    public function archiveEprExternes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullExterneArchives (matricule, anscol, coursGrp, coteExterne) ';
        $sql .= 'SELECT matricule, anscol,coursGrp,coteExterne ';
        $sql .= 'FROM '.PFX.'bullEprExterne ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat > 0 ? true : false;
    }

    /**
     * vide la table des épreuves externes après archivage.
     *
     * @param void
     *
     * @return true si tout s'est bien passé
     */
    public function deleteEprExternes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE TABLE '.PFX.'bullEprExterne ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * effacement de tous les historiques des mouvements de cours.
     *
     * @param void
     *
     * @return integer: nombre de suppressions
     */
    public function deleteHistoriques()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullHistoCours ';
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des écoles fréquentées anciennement par les élèves du niveau indiqué.
     *
     * @param int $niveau
     *
     * @return array
     */
    public function listeEcoles($niveau)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT '.PFX.'elevesEcoles.ecole, nomEcole, adresse ';
        $sql .= 'FROM '.PFX.'elevesEcoles ';
        $sql .= 'JOIN '.PFX.'ecoles ON ('.PFX.'ecoles.ecole = '.PFX.'elevesEcoles.ecole) ';
        $sql .= 'WHERE matricule IN  (SELECT matricule ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= "WHERE SUBSTR(annee,1,1) = '$niveau') ";
        $sql .= 'ORDER BY nomEcole';
        $resultat = $connexion->query($sql);
        $listeEcoles = array();
        while ($ligne = $resultat->fetch()) {
            $ecole = $ligne['ecole'];
            $nomEcole = $ligne['nomEcole'].' | '.$ligne['adresse'];
            $listeEcoles[$ecole] = $nomEcole;
        }
        Application::DeconnexionPDO($connexion);

        return $listeEcoles;
    }

    /**
     * retourne le nom de l'école dont on fournit l'identifiant
     *
     * @param string $identifiant
     *
     * @return string
     * */
    public function ecole($identifiant)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nomEcole, adresse, cpostal, commune ';
        $sql .= 'FROM '.PFX.'ecoles ';
        $sql .= "WHERE ecole = '$identifiant'";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * liste simple de tous les élèves d'un niveau provenant d'une école.
     *
     * @param int $niveau : niveau d'étude
     * @param string $ecole: identifiant de l'école d'origine de l'élève
     *
     * @return array
     */
    public function listeElevesEcoleNiveau($niveau, $ecole)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX."eleves.matricule, CONCAT(nom, ' ', prenom) AS nomEleve, groupe ";
        $sql .= 'FROM `'.PFX.'eleves` ';
        $sql .= 'JOIN '.PFX.'elevesEcoles ON ('.PFX.'elevesEcoles.matricule = '.PFX.'eleves.matricule) ';
        $sql .= 'JOIN '.PFX.'ecoles ON ('.PFX.'ecoles.ecole = '.PFX.'elevesEcoles.ecole) ';
        $sql .= 'WHERE SUBSTR('.PFX."eleves.annee,1,1) = '$niveau' AND ".PFX."elevesEcoles.ecole = '$ecole' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        $resultat = $connexion->query($sql);
        $listeEleves = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $photo = Ecole::photo($matricule);
                $listeEleves[$matricule] = array('photo' => $photo, 'identite' => $ligne['groupe'].': '.$ligne['nomEleve']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeEleves;
    }

    /**
     * retourne la liste des colonnes de cotes à additionner
     * en séparant par compétence et form ou cert.
     *
     * @param string  $coursGrp
     * @param int $bulletin
     *
     * @return array
     */
    public function colonnesCotesBulletin($coursGrp, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCarnet, idComp, formCert, max, '.PFX.'bullCompetences.libelle ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'JOIN '.PFX.'bullCompetences ON ('.PFX.'bullCompetences.id = '.PFX.'bullCarnetCotes.idComp) ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND bulletin = $bulletin AND neutralise = 0 ";

        $resultat = $connexion->query($sql);
        $listeEvaluations = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $idCarnet = $ligne['idCarnet'];
                $idComp = $ligne['idComp'];
                $formCert = $ligne['formCert'];
                $max = $ligne['max'];
                $libelle = $ligne['libelle'];
                $listeEvaluations[$idCarnet] = array('idComp' => $idComp, 'formCert' => $formCert, 'max' => $max, 'libelle' => $libelle);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeEvaluations;
    }

    /**
     * retourne l'entête de la liste des colonnes de cotes à additionner
     * en séparant par compétence et form ou cert.
     *
     * @param string $coursGrp
     * @param int $bulletin
     *
     * @return array
     */
    public function listeCompetencesBulletin($coursGrp, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCarnet, idComp, formCert, max, '.PFX.'bullCompetences.libelle ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'JOIN '.PFX.'bullCompetences ON ('.PFX.'bullCompetences.id = '.PFX.'bullCarnetCotes.idComp) ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND bulletin = $bulletin AND neutralise = 0 ";
        $sql .= 'ORDER BY formCert, ordre';
        $resultat = $connexion->query($sql);
        $listeEvaluations = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                // $idCarnet = $ligne['idCarnet'];
                $idComp = $ligne['idComp'];
                $formCert = $ligne['formCert'];
                $max = $ligne['max'];
                $libelle = $ligne['libelle'];
                $listeEvaluations[$idComp][$formCert] = array('libelle' => $libelle, 'max' => $max);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeEvaluations;
    }

    /**
     * renvoie un tableau de toutes les cotes dont les entêtes sonf passées
     * dans $listeColonnes.
     *
     * @param array $listeColonnes
     *
     * @return array
     */
    public function listeCotesCompFormCert($listeColonnes)
    {
        $listeIdCarnetString = implode(',', array_keys($listeColonnes));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCarnet, matricule, cote FROM '.PFX.'bullCarnetEleves ';
        $sql .= "WHERE idCarnet IN ($listeIdCarnetString) ";
        $sql .= 'ORDER BY idCarnet ';
        $resultat = $connexion->query($sql);
        $listeCotes = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $idCarnet = $ligne['idCarnet'];
                $matricule = $ligne['matricule'];
                $cote = $ligne['cote'];
                $max = $listeColonnes[$idCarnet]['max'];
                $idComp = $listeColonnes[$idCarnet]['idComp'];
                $formCert = $listeColonnes[$idCarnet]['formCert'];
                $libelle = $listeColonnes[$idCarnet]['libelle'];
                $listeCotes[$matricule][$idComp][$formCert][] = array('cote' => $cote, 'max' => $max, 'libelle' => $libelle);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCotes;
    }

    /**
     * vérifie qu'une cote passée en argument vaut pour "0"
     * la liste des cotes valant pour "0" se trouve dans la constante COTENULLE.
     *
     * @param string $cote
     *
     * @return bool
     */
    private function estCoteNulle($cote)
    {
        return in_array(strtolower($cote), explode(',', COTENULLE));
    }

    /**
     * Vérifie qu'une conte passée en argument est licite
     * il faut qu'elle soit numérique et non vide
     * ou qu'elle soit équivalent à un "0" (cote nulle).
     *
     * @param  string $cote
     *
     * @return bool
     * */
    private function estLicite($cote)
    {
        return (is_numeric($cote) && ($cote != '')) || (self::estCoteNulle($cote));
    }

    /**
     * retourne la somme des cotes figurant dans le carnet de cotes pour les colonnes
     * figurant dans $listeColonnes
     * pour les cotes figurant dans $listeCotesEleves.
     *
     * @param $listeColonnes
     * @param $listeCompetences
     * @param $listeCotesEleves
     *
     * @return array
     */
    public function sommesBruteCotes($listeColonnes, $listeCotesEleves)
    {
        $listeSommes = array();
        foreach ($listeCotesEleves as $matricule => $listeCompetences) {
            foreach ($listeCompetences as $idComp => $listeFormCert) {
                foreach ($listeFormCert as $unType => $lesCotes) {
                    foreach ($lesCotes as $uneCote) {
                        $cote = $this->sansVirg($uneCote['cote']);
                        $max = $this->sansVirg($uneCote['max']);
                        if ($this->estLicite($cote)) {
							if ($this->estCoteNulle($cote))
                                $cote = 0;
                            if (isset($listeSommes[$matricule][$unType][$idComp]['cote'])) {
                                $listeSommes[$matricule][$unType][$idComp]['cote'] += $cote;
                            } else {
                                $listeSommes[$matricule][$unType][$idComp]['cote'] = $cote;
                            }
                            if (isset($listeSommes[$matricule][$unType][$idComp]['max'])) {
                                $listeSommes[$matricule][$unType][$idComp]['max'] += $max;
                            } else {
                                $listeSommes[$matricule][$unType][$idComp]['max'] = $max;
                            }
                        }
                    }
                }
            }
        }

        return $listeSommes;
    }

    /**
     * retourne la liste des poids attribués à chaque compétence, dans le bulletin.
     *
     * @param string $coursGrp
     * @param int $bulletin
     *
     * @return array
     */
    public function poidsCompetencesBulletin($coursGrp, $bulletin)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idComp, poids, certForm ';
        $sql .= 'FROM '.PFX.'bullCarnetPoidsCompetences ';
        $sql .= "WHERE bulletin = '$bulletin' AND coursGrp = '$coursGrp'";

        $resultat = $connexion->query($sql);
        $listePoids = array();
        while ($ligne = $resultat->fetch()) {
            $idComp = $ligne['idComp'];
            $certForm = $ligne['certForm'];
            $poids = $ligne['poids'];
            $listePoids[$idComp][$certForm] = $poids;
        }
        Application::DeconnexionPDO($connexion);

        return $listePoids;
    }

    /**
     * retourne les cotes calculées prêtes pour le bulletin depuis le carnet de cotes.
     *
     * @param $sommesBrutesCotes
     * @param $listePoids
     *
     * @return array
     */
    public function cotesBulletinCalculees($sommesBrutesCotes, $listePoids)
    {
        $listeCotesBulletin = array();
        foreach ($sommesBrutesCotes as $matricule => $listeTypes) {
            foreach ($listeTypes as $formCert => $listeCompetences) {
                foreach ($listeCompetences as $idComp => $uneCote) {
                    $cote = $uneCote['cote'];
                    $max = $uneCote['max'];
                    $poids = isset($listePoids[$idComp]) ? $listePoids[$idComp][$formCert] : '';
                    // on utilise la cote si
                    // - elle est numérique
                    // - ou s'il s'agit d'une cote nulle (Non remis = nr, ou autre éventuel)
                    // - et s'il y a un max et un poids
                    if ((is_numeric($this->sansVirg($cote)) || $this->estCoteNulle($cote)) && ($max > 0) && ($poids != '')) {
                        $listeCotesBulletin[$matricule][$formCert][$idComp] = round($cote * $poids / $max, 1);
                    }
                }
            }
        }

        return $listeCotesBulletin;
    }

    /**
     * renvoie la valeur false ou true selon que des poids ont été
     * attribués à des compétences pour le cours $coursGrp
     * dans le bulletin $bulletin
     * pour chaque compétence, indique son libellé et son statut (OK ou pas OK).
     *
     * @param $coursGrp
     * @param $bulletin
     * @param $listeCompetences
     *
     * @return bool
     */
    public function poidsCompetencesOK($coursGrp, $bulletin, $listeCompetences)
    {
        // chercher la liste des compétences et des types (form/cert) pour lesquels il y a des points
        // pour cette période, dans le carnet de cotes
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT idComp, formCert, coursGrp  ';
        $sql .= 'FROM '.PFX.'bullCarnetCotes ';
        $sql .= 'JOIN '.PFX.'bullCarnetEleves ON ('.PFX.'bullCarnetEleves.idCarnet = '.PFX.'bullCarnetCotes.idCarnet) ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND bulletin = '$bulletin' AND neutralise='0' ";

        $resultat = $connexion->query($sql);
        $competences = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $competences = $resultat->fetchAll();
        }
        // vérifier que toutes ces compétences ont reçu un poids
        $listePoidsOK = array();
        $poidsOKEnsemble = true;

        foreach ($competences as $uneCompetence) {
            $idComp = $uneCompetence['idComp'];
            $formCert = $uneCompetence['formCert'];
            $coursGrp = $uneCompetence['coursGrp'];
            $sql = 'SELECT poids ';
            $sql .= 'FROM '.PFX.'bullCarnetPoidsCompetences ';
            $sql .= "WHERE idComp = '$idComp' AND certForm = '$formCert' AND bulletin = '$bulletin' AND coursGrp ='$coursGrp' ";

            $resultat = $connexion->query($sql);
            // on n'attend qu'un seul résultat de poids pour une compétence dans un type donné
            if ($resultat) {
                $ligne = $resultat->fetch();
                $poids = $ligne['poids'];
                $poidsOK = ($this->sansVirg(trim($poids, ' ')) > 0) ? true : false;
                $cours = self::coursDeCoursGrp($coursGrp);
            }
                // s'il n'y a pas de résultat, c'est qu'il n'y a pas de poids
                else {
                    $poidsOK = false;
                }
            $poidsOKEnsemble = $poidsOKEnsemble && $poidsOK;
            $listePoidsOK[$formCert][$idComp] = array('competence' => $listeCompetences[$cours][$idComp]['libelle'], 'poidsOK' => $poidsOK);
        }

        return array('tutti' => $poidsOKEnsemble, 'details' => $listePoidsOK);
    }

    /**
     * Transfère vers le bulletin tous les points venant du formulaire
     * ad-hoc dans le carnet de cotes.
     *
     * @param $post
     * @param $listeLocks
     *
     * @return array
     */
    public function transfertCarnetCotes($post, $listeLocks)
    {
        $sqlForm = 'INSERT INTO '.PFX.'bullDetailsCotes ';
        $sqlForm .= 'SET matricule=:matricule, coursGrp=:coursGrp, bulletin=:bulletin, ';
        $sqlForm .= 'idComp=:idComp, form=:form, maxForm=:maxForm ';
        $sqlForm .= 'ON DUPLICATE KEY UPDATE ';
        $sqlForm .= 'form=:form, maxForm=:maxForm ';

        $sqlCert = 'INSERT INTO '.PFX.'bullDetailsCotes ';
        $sqlCert .= 'SET matricule=:matricule, coursGrp=:coursGrp, bulletin=:bulletin, ';
        $sqlCert .= 'idComp=:idComp, cert=:cert, maxCert=:maxCert ';
        $sqlCert .= 'ON DUPLICATE KEY UPDATE ';
        $sqlCert .= 'cert=:cert, maxCert=:maxCert';

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $requeteForm = $connexion->prepare($sqlForm);
        $requeteCert = $connexion->prepare($sqlCert);

        // récupération des poids par évaluation
        foreach ($post as $variable => $value) {
            // tous les champs dont le nom commence par "poids"
            if (preg_match('/^poids/', $variable)) {
                $data = explode('-', $variable);
                $coursGrp = explode('_', $data[1]);
                $coursGrp = $coursGrp[1];
                $coursGrp = str_replace('$', ' ', $coursGrp);
                $coursGrp = str_replace('#', '-', $coursGrp);

                $type = explode('_', $data[2]);
                $type = $type[1];
                $idComp = explode('_', $data[3]);
                $idComp = $idComp[1];
                $bulletin = explode('_', $data[4]);
                $bulletin = $bulletin[1];
                $poids[$coursGrp][$idComp][$type][$bulletin] = $this->sansVirg($value);
            }
        }
        $nbResultats = 0;
        $nbRefus = 0;
        foreach ($post as $variable => $value) {
            // tous les champs dont le nom commence par "bull-matr"
            if (preg_match('/^bull-matr/', $variable)) {
                $data = explode('-', $variable);
                $matricule = explode('_', $data[1]);
                $matricule = $matricule[1];
                $coursGrp = explode('_', $data[2]);
                $coursGrp = $coursGrp[1];
                $coursGrp = str_replace('$', ' ', $coursGrp);
                $coursGrp = str_replace('#', '-', $coursGrp);
                $type = explode('_', $data[3]);
                $type = $type[1];
                $idComp = explode('_', $data[4]);
                $idComp = $idComp[1];
                $bulletin = explode('_', $data[5]);
                $bulletin = $bulletin[1];

                // vérifier que le bulletin de cet élève et de ce cours n'est pas verrouillé
                if (isset($listeLocks[$matricule][$coursGrp]) && $listeLocks[$matricule][$coursGrp] == 0) {
                    switch ($type) {
                        case 'form':
                            $data = array(
                                ':matricule' => $matricule,    ':coursGrp' => $coursGrp,
                                ':type' => $type,              ':idComp' => $idComp,
                                ':bulletin' => $bulletin,      ':form' => $this->sansVirg($value),
                                ':maxForm' => $poids[$coursGrp][$idComp][$type][$bulletin],
                                );
                            $nbResultats += $requeteForm->execute($data);
                            break;
                        case 'cert':
                            $data = array(
                                ':matricule' => $matricule,    ':coursGrp' => $coursGrp,
                                ':type' => $type,                ':idComp' => $idComp,
                                ':bulletin' => $bulletin,        ':cert' => $this->sansVirg($value),
                                ':maxCert' => $poids[$coursGrp][$idComp][$type][$bulletin],
                                );
                            $nbResultats += $requeteCert->execute($data);
                            break;
                        } // switch
                } // if $listeLocks
                    else {
                        ++$nbRefus;
                    }
            } // if
        } //foreach
        Application::deconnexionPDO($connexion);

        return array('poidsOK' => true, 'ok' => $nbResultats, 'ko' => $nbRefus);
    } // function

    /**
     * calculs des cotes moyennes, des nombres d'heures d'échec, des nombres d'échecs, de la mention
     * pour chaque élève d'une classe.
     *
     * @param  array $listeSituations
     * @param array $statutsCadres : statuts des cours en fonction de leur cadre
     *
     * @return array
     */
    public function echecMoyennesDecisions($listeSituations, $statutsCadres)
    {
        $texteLicite = explode(',', COTEABS);
        $liste = array();
        foreach ($listeSituations as $matricule => $dataCours) {
            $liste[$matricule] = array();
            $total = 0;
            $nbCours = 0;
            $nbEchecs = 0;
            $listeCoursEchec = 0;
            $nbCoursEchec = 0;
            $nbHeuresEchec = 0;
            $coursEchecs = array();
            $moyenne = '';
            $mention = '';
            foreach ($dataCours as $cours => $infos) {
                $sitDelibe = trim($infos['sitDelibe']);
                $attributDelibe = $infos['attributDelibe'];
                $echec = $infos['echec'];
                $cadre = $infos['cadre'];
                if (($attributDelibe != 'hook') && ($sitDelibe != '') && !(in_array($sitDelibe, $texteLicite))) {
                    if ($statutsCadres[$cadre]['total'] == false) {
                        $total += $sitDelibe;
                        ++$nbCours;
                    }
                    if (($statutsCadres[$cadre]['echec'] == false) && ($echec == 'echec')) {
                        $libelle = $infos['libelle'];
                        $nbHeuresEchec += $infos['nbheures'];
                        ++$nbEchecs;
                        $coursEchecs[] = $libelle;
                    }
                }
            }

            if ($nbCours != 0) {
                $moyenne = round($total / $nbCours, 1);
                $mention = self::calculeMention($moyenne);
            }
            $liste[$matricule] = array(
                        'total' => $total, 'nbCours' => $nbCours, 'moyenne' => $moyenne, 'mention' => $mention,
                        'nbEchecs' => $nbEchecs, 'nbHeuresEchec' => $nbHeuresEchec, 'coursEchec' => implode('<br>', $coursEchecs),
                        );
        }

        return $liste;
    }

    /**
     * calcul des moyennes des situations sur la base d'une liste des situations dans chaque cours.
     *
     * @param array $listeSituations
     * @param array $listePeriodes
     * @param array $statutsCadres : cadre des cours et statut intene à l'école + traitement
     *
     * @return array
     */
 public function moyennesSituations($listeSituations, $listePeriodes, $statutsCadres)
    {
        foreach ($listePeriodes as $periode) {
            $data[$periode] = array('somme' => 0, 'nbCours' => 0, 'nbEchecs' => 0, 'nbHeuresEchec' => 0, 'cours' => array(), 'moyenne' => '', 'attribut' => '');
        }
        // somme des situations
        if ($listeSituations) {
            foreach ($listeSituations as $coursGrp => $lesSituations) {
                foreach ($listePeriodes as $periode) {
                    // si la période existe déjà dans la BD
                    if (isset($lesSituations[$periode])) {
                        $sit = $this->sansVirg(trim($lesSituations[$periode]['sitDelibe']));
                        $attribut = $lesSituations[$periode];

                        // si l'information est numérique, on en tient compte
                        if (is_numeric($sit)) {
                            // les cotes entre crochets sont négligées
                            if ($lesSituations[$periode]['attributDelibe'] != 'hook') {
                                $cadre = $lesSituations[$periode]['cadre'];
                                // certains cours ne doivent pas être totalisés en fonction de leur "cadre"
                                if ($statutsCadres[$cadre]['total'] == false){
                                    $data[$periode]['somme'] += $sit;
                                    ++$data[$periode]['nbCours'];
                                }
                                // certains cours (en fonction de leur cadre) ne comptent pas comme échec
                                if (($sit < 50) && ($statutsCadres[$cadre]['echec'] == false)) {
                                    ++$data[$periode]['nbEchecs'];
                                    $data[$periode]['nbHeuresEchec'] += $lesSituations[$periode]['nbheures'];
                                    $data[$periode]['cours'][] = $lesSituations[$periode]['libelle'];
                                }
                            }
                        }
                    }
                }
            }
            foreach ($listePeriodes as $periode) {
                if (isset($data[$periode])) {
                    if ($data[$periode]['nbCours'] > 0) {
                        $data[$periode]['moyenne'] = round($this->sansVirg($data[$periode]['somme']) / $data[$periode]['nbCours'], 1);
                    } else {
                        $data[$periode]['moyenne'] = '';
                    }
                    $data[$periode]['cours'] = implode(', ', $data[$periode]['cours']);
                }
            }
        }

        return $data;
    }

    /**
     * retourne la liste des mentions correspondant à la liste des moyennes
     * passées en paramètre.
     *
     * @param $lesMoyennes
     *
     * @return array
     */
    public function calculeMentionsDecJuin($lesMoyennes)
    {
        $lesMentions = array();
        foreach ($lesMoyennes as $periode => $data) {
            $lesMentions[$periode] = self::calculeMention($data['moyenne']);
        }

        return $lesMentions;
    }

    /**
     * enregistrement des mentions provenant de la feuille de délibé individuelle.
     *
     * @param $post
     *
     * @return int : nombre d'enregistrements
     */
    public function enregistrerMentions($post)
    {
        $matricule = $post['matricule'];
        $annee = SUBSTR($post['classe'], 0, 1);
        $anScol = ANNEESCOLAIRE;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $resultat = 0;
        // toutes les mentions figurent dans un champ nommé 'mentions_x'
        foreach ($post as $key => $value) {
            $explKey = explode('_', $key);
            if ($explKey[0] == 'mentions') {
                $periode = $explKey[1];
                $sql = 'INSERT INTO '.PFX.'bullMentions ';
                $sql .= "SET periode='$periode', mention='$value', matricule='$matricule', annee='$annee', anscol='$anScol' ";
                $sql .= "ON DUPLICATE KEY UPDATE mention='$value' ";
                $resultat += $connexion->exec($sql);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * enregistrement de la décision du Conseil de Classe provenant de la feuille de délibé individuelle.
     *
     * @param $post
     *
     * @return int : normalement, 1
     */
     public function enregistrerDecision($post)
     {
         $matricule = $post['matricule'];
         $decision = ($post['decision'] == '') ? Null : $post['decision'];

         if ($decision == 'Restriction') {
             $restriction = $post['restriction'];
         } else {
             $restriction = '';
         }
         if ($decision != Null) {
             $mail = isset($post['mail']) && ($post['mail'] == true) ? 1 : 0;
             $notification = isset($post['notification']) && ($post['notification'] == true) ? 1 : 0;
             }
             else {
                 $mail = 0;
                 $notification = 0;
             }

         $mailEleve = $post['mailEleve'];

         $adresseMail = ($post['adresseMail'] != $mailEleve) ? $post['adresseMail'] : '';

         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT INTO '.PFX.'bullDecisions ';
         $sql .= 'SET matricule = :matricule, decision = :decision, restriction = :restriction, ';
         $sql .= 'mail = :mail, notification = :notification, ';
         $sql .= 'adresseMail = :adresseMail ';
         $sql .= 'ON DUPLICATE KEY UPDATE ';
         $sql .= 'decision = :decision, restriction = :restriction, mail = :mail, notification = :notification, ';
         $sql .= 'adresseMail = :adresseMail ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $requete->bindParam(':decision', $decision, PDO::PARAM_STR, 20);
         $requete->bindParam(':restriction', $restriction, PDO::PARAM_STR, 80);
         $requete->bindParam(':mail', $mail, PDO::PARAM_INT);
         $requete->bindParam(':notification', $notification, PDO::PARAM_INT);
         $requete->bindParam(':adresseMail', $adresseMail, PDO::PARAM_STR, 30);

         $resultat = $requete->execute();

         Application::DeconnexionPDO($connexion);

         return $resultat;
     }

    /**
     * retourne la notice "coordinateurs" pour le bulletin donné au niveau donné.
     *
     * @param $bulletin : période de l'année concernée
     * @param $annee : année d'étude concernée
     *
     * @return string
     */
    public function noticeCoordinateurs($bulletin, $annee)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT remarque FROM '.PFX.'bullNotesDirection ';
        $sql .= "WHERE bulletin='$bulletin' AND SUBSTR(annee,1,1) = $annee";
        $notice = '';
        $resultat = $connexion->query($sql);
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $notice = $ligne['remarque'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $notice;
    }

    /**
     * enregistrement de la notice "coordinateurs" pour un bulletin et un niveau donné.
     *
     * @param int $annee
     * @param int $noBulletin
     * @param string $notice
     *
     * @return integer: nombre d'enregistrements 0 ou 1
     */
    public function saveNoticeCoordinateurs($annee, $noBulletin, $remarque)
    {
        if ($noBulletin && $annee) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'bullNotesDirection ';
            $sql .= 'SET bulletin = :noBulletin, annee = :annee, remarque = :remarque ';
            $sql .= 'ON DUPLICATE KEY UPDATE remarque = :remarque ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':annee', $annee, PDO::PARAM_INT);
            $requete->bindParam(':noBulletin', $noBulletin, PDO::PARAM_INT);
            $requete->bindParam(':remarque', $remarque, PDO::PARAM_STR);

            $resultat = $requete->execute();
            // si update => 2 modifications...
            $nb = $requete->rowCount() == 2 ? 1 : 0;

            Application::DeconnexionPDO($connexion);

            return $nb;
        }
    }

    /**
     * retourne la classe d'un ancien élève dont on fournit la matricule
     * pour l'année scolaire indiquée.
     *
     * @param $matricule : matricule de l'élève
     * @param $annee : année scolaire concernée
     *
     * @return array $classes par année scolaire
     */
    public function classeArchiveEleve($matricule, $annee)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT classe ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $sql .= "WHERE lematricule = '$matricule' AND annee = '$annee' ";
        $sql .= 'ORDER BY annee ';
        $resultat = $connexion->query($sql);
        if (isset($resultat)) {
            $ligne = $resultat->fetch();
            $classe = $ligne['classe'];
        }
        Application::DeconnexionPDO($connexion);

        return $classe;
    }

    /**
     * retourne la liste des élèves d'un niveau donné (de la 1e à la 6e) pour une année scolaire indiquée.
     *
     * @param $annee string : annee scolaire passée (Ex: 2012-2013)
     * @param $niveau integer : niveau d'étude
     *
     * @return array : liste des élèves
     */
    public function listeElevesArchives($annee, $niveau)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT lematricule, nomPrenom, classe ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $sql .= 'WHERE annee = :annee AND SUBSTR(classe,1,1) = :niveau ';
        $sql .= 'ORDER BY nomPrenom, classe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':annee', $annee, PDO::PARAM_STR,9);
        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $listeEleves = array();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['lematricule'];
                $nomPrenom = $ligne['nomPrenom'];
                $listeEleves[$matricule] = $nomPrenom;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeEleves;
    }

    /**
     * retourne la liste des années d'archives disponibles dans la table des archives.
     *
     * @param
     *
     * @return array
     */
    public function anneesArchivesDispo()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT annee ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $resultat = $connexion->query($sql);
        $listeAnnees = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $listeAnnees[] = $ligne['annee'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeAnnees;
    }

    public function listeNotesFiches($listeEleves)
    {
        $listeElevesString = implode(', ', array_keys($listeEleves));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, fiche, bulletin ';
        $sql .= 'FROM '.PFX.'bullEducs ';
        $sql .= "WHERE matricule IN ($listeElevesString)";

        $resultat = $connexion->query($sql);
        $liste = array();
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $bulletin = $ligne[$bulletin];
            $liste[$bulletin]['$matricule'] = $ligne['fiche'];
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    public function mergeElevesDiscNotes($listeEleves, $listeFaitsDisc, $listeNotesFiches)
    {
        foreach ($listeEleves as $matricule => $data) {
            $listeEleves[$matricule]['disc'] = isset($listeFaitsDisc[$matricule]['disc']) ? $listeFaitsDisc[$matricule]['disc'] : null;
            $listeEleves[$matricule]['fiche'] = isset($listeNotesFiches[$matricule]) ? $listeNotesFiches[$matricule] : null;
        }

        return $listeEleves;
    }

    public function selectEleveFromPageDisc($classe, $date1, $date2)
    {
        $date1 = $this->dateMysqlGlue($date1, '-');
        $date2 = dateMysqlGlue($date2, '-');
        $listeEleves = Ecole::listeEleves($classe, 'groupe');
        $listeNotesFiches = $this->listeNotesFiches($listeEleves);
        $listeFaitsDisc = $this->listeFaitsDisc($listeEleves, $date1, $date2);
        $listeElevesDisc = $this->mergeElevesDiscNotes($listeEleves, $listeFaitsDisc, $listeNotesFiches);

        return $listeElevesDisc;
    }

    public function enregistrerFichesDisc($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $bulletin = $post['bulletin'];
        $resultat = 0;
        foreach ($post as $champ => $value) {
            if (preg_match('/^fiche/', $champ)) {
                $data = explode('_', $champ);
                $matricule = $data[1];
                $sql = 'INSERT INTO '.PFX.'bullEducs ';
                $sql .= "SET matricule='$matricule', bulletin='$bulletin', fiche='$value' ";
                $sql .= "ON DUPLICATE KEY UPDATE fiche='$value'";
                $resultat += $connexion->exec($sql);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * renvoie un tableau contenant l'élève précédent, l'élève courant et l'élève suivant
     * celui dont le matricule est passé en argument.
     *
     * @param $matricule
     * @param $listeEleves
     *
     * @return array ('prev', 'next')
     **/
    public function prevNext($matricule, $listeEleves)
    {
        $listeEleves = array_keys($listeEleves);
        $pos = array_search($matricule, $listeEleves);
        $prev = ($pos > 0) ? $listeEleves[$pos - 1] : null;
        $next = ($pos < count($listeEleves) - 1) ? $listeEleves[$pos + 1] : null;

        return array('prev' => $prev, 'next' => $next);
    }

     /**
      * retourne les totalisation  des cotes par élèves, per cours et par compétence
      * pour l'ensemble de l'année scolaire.
      *
      * @param $listeEleves: tableau dont les keys sont les $matricule
      * @param $listeCours: tableau de la liste des cours dont les keys sont les abréviations des cours
      * @param $listeCompetences: liste des compétences existantes pour ce cours
      *
      * @return tableau de la somme des cotes par élève, par cours et par compétence
      */
     public function sommeToutesCotes($listeEleves, $listeCours, $listeCompetences)
     {
         $listeElevesString = implode(',', array_keys($listeEleves));
         if (is_array($listeCours)) {
             $listeCoursString = "'".implode('\',\'', array_keys($listeCours))."'";
         } else {
             $listeCoursString = $listeCours;
         }
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = "SELECT matricule, coursGrp, idComp, form, maxForm, cert, maxCert, SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1) AS cours ";
         $sql .= 'FROM '.PFX.'bullDetailsCotes ';
         $sql .= "WHERE (matricule IN ($listeElevesString)) AND (SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1) IN ($listeCoursString)) ";
         $sql .= 'ORDER BY matricule, idComp';

         $resultat = $connexion->query($sql);
         $listeCotes = array();
         while ($ligne = $resultat->fetch()) {
             $matricule = $ligne['matricule'];
             $cours = $ligne['cours'];
             $idComp = $ligne['idComp'];
             $form = isset($ligne['form']) ? $this->sansVirg(trim($ligne['form'])) : null;
             $maxForm = isset($ligne['maxForm']) ? $this->sansVirg(trim($ligne['maxForm'])) : null;
             $cert = isset($ligne['cert']) ? $this->sansVirg(trim($ligne['cert'])) : null;
             $maxCert = isset($ligne['maxCert']) ? $this->sansVirg(trim($ligne['maxCert'])) : null;

             if (($form != Null) && (is_numeric($form))) {
                 if (isset($listeCotes[$matricule][$cours][$idComp]['cote'])) {
                     $listeCotes[$matricule][$cours][$idComp]['cote'] += $form;
                 } else {
                     $listeCotes[$matricule][$cours][$idComp]['cote'] = $form;
                 }
                 if (isset($listeCotes[$matricule][$cours][$idComp]['max'])) {
                     $listeCotes[$matricule][$cours][$idComp]['max'] += $maxForm;
                 } else {
                     $listeCotes[$matricule][$cours][$idComp]['max'] = $maxForm;
                 }
             }

             if (($cert != Null) && (is_numeric($cert))) {
                 if (isset($listeCotes[$matricule][$cours][$idComp]['cote'])) {
                     $listeCotes[$matricule][$cours][$idComp]['cote'] += $cert;
                 } else {
                     $listeCotes[$matricule][$cours][$idComp]['cote'] = $cert;
                 }
                 if (isset($listeCotes[$matricule][$cours][$idComp]['max'])) {
                     $listeCotes[$matricule][$cours][$idComp]['max'] += $maxCert;
                 } else {
                     $listeCotes[$matricule][$cours][$idComp]['max'] = $maxCert;
                 }
             }
         }
         Application::DeconnexionPDO($connexion);

         return $listeCotes;
     }

    public function listeAcquis($listeCotes)
    {
        foreach ($listeCotes as $matricule => $listeCours) {
            foreach ($listeCours as $cours => $listeCompetences) {
                foreach ($listeCompetences as $idComp => $evaluation) {
                    if ($evaluation['max'] > 0) {
                        if ($evaluation['cote'] / $evaluation['max'] >= 0.5) {
                            $listeCotes[$matricule][$cours][$idComp]['acq'] = 'Acquis';
                        } else {
                            $listeCotes[$matricule][$cours][$idComp]['acq'] = 'Non acquis';
                        }
                    } else {
                        unset($listeCotes[$matricule][$cours][$idComp]);
                    }
                }
            }
        }

        return $listeCotes;
    }

    /**
     * vérifie qu'au moins une compétence a reçu un poids avant transfert vers le bulletin.
     *
     * @param $listePoidsCompetences
     *
     * @return bool
     */
    public function poidsCompetencesVide($listePoidsCompetences)
    {
        $vide = true;
        foreach ($listePoidsCompetences as $idComp => $poids) {
            $vide = $vide && (trim($poids['cert']) == '') && (trim($poids['form']) == '');
        }

        return $vide;
    }

    /**
     * retourne la liste de situations des élèves pour la liste des cours passés en argument
     * on soustrait le situation de la période 0 de celle de la période $bulletin.
     *
     * @param string|array $listeEleves    : liste des élèves
     * @param string|array $listeCoursGrp: liste des coursGrp concernés
     * @param int          $bulletin       : numéro du bulletin en cours
     *
     * @return array listeSituationsDeuxiemes
     */
    public function situationsDeuxieme($listeEleves, $listeCoursGrp, $bulletin)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT bulletin, matricule, coursGrp, situation, maxSituation ';
        $sql .= 'FROM '.PFX.'bullSituations ';
        $sql .= "WHERE bulletin BETWEEN 0 AND $bulletin AND coursGrp IN ($listeCoursGrpString) AND matricule IN ($listeElevesString) ";
        $resultat = $connexion->query($sql);
        $listeSituations = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $periode = $ligne['bulletin'];
                $coursGrp = $ligne['coursGrp'];
                $matricule = $ligne['matricule'];
                $listeSituations[$coursGrp][$matricule][$periode] = array(
                    'sit' => $ligne['situation'],
                    'max' => $ligne['maxSituation'],
                    );
            }
        }
        foreach ($listeSituations as $coursGrp => $eleves) {
            foreach ($eleves as $matricule => $cotes) {
                if (isset($cotes[$bulletin]) && $this->isNumericNotNull($cotes[$bulletin]['sit']) && isset($cotes[0]) && $this->isNumericNotNull($cotes[0]['sit'])) {
                    // cote initiale
                $sit0 = $cotes[0]['sit'];
                    $max0 = $cotes[0]['max'];
                // cote jusqu'à la période actuelle $bulletin
                $sitPeriode = $cotes[$bulletin]['sit'];
                    $maxPeriode = $cotes[$bulletin]['max'];
                // on soustrait la période 0 (report de l'année précédente) de la situation totale du degré
                $sit2 = $sitPeriode - $sit0;
                    $max2 = $maxPeriode - $max0;
                    $listeSituations[$coursGrp][$matricule]['sit2'] = array('sit' => $sit2, 'max' => $max2);
                    if ($max2 > 0) { // pas de division par zéro
                    $listeSituations[$coursGrp][$matricule]['sit2']['pourcent'] = round(100 * $sit2 / $max2);
                    }
                } else {
                    $listeSituations[$coursGrp][$matricule]['sit2']['pourcent'] = null;
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeSituations;
    }

    /**
     * rédaction du bulletin d'un élève.
     *
     * @param array  $dataEleve : tableau contenant $matricule, $annee, $degre et noms des titulaires
     * @param int    $bulletin  : numéro du bulletin
     * @param string $acronyme  : identifiant de l'utilisateur en cours
     *
     * @return lien vers le fichier PDF créé
     */
    public function createPDFeleve($dataEleve, $bulletin, $acronyme)
    {
        $matricule = $dataEleve['matricule'];
        $annee = $dataEleve['annee'];
        $degre = $dataEleve['degre'];
        $titulaires = $dataEleve['titulaires'];

        $eleve = new Eleve($matricule);
        $infoPerso = $eleve->getDetailsEleve();
        $Ecole = new Ecole();

        // liste des coursGrp tenant compte de l'historique
        $listeCoursGrp = $this->listeCoursGrpEleves($matricule, $bulletin, true);
        if ($listeCoursGrp) {
            // il n'y a qu'un élève, il n'y aura donc qu'une seule liste de pondérations
            $listeCoursGrp = $listeCoursGrp[$matricule];
            $listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);

            $listeSituations = $this->listeSituationsCours($matricule, array_keys($listeCoursGrp), null, true);
            $sitPrecedentes = $this->situationsPrecedentes($listeSituations, $bulletin);
            $sitActuelles = $this->situationsPeriode($listeSituations, $bulletin);
            $listeCompetences = $this->listeCompetencesListeCoursGrp($listeCoursGrp);
            $listeCotes = $this->listeCotes($matricule, $listeCoursGrp, $listeCompetences, $bulletin);
            $ponderations = $this->getPonderations($listeCoursGrp, $bulletin);
            $cotesPonderees = $this->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
            $commentairesCotes = $this->listeCommentairesTousCours($matricule, $bulletin);
            $mention = $this->listeMentions($matricule, $bulletin, $annee);

            $ficheEduc = $this->listeCommentairesEduc($matricule, $bulletin);

            $remarqueTitulaire = $this->remarqueTitu($matricule, $bulletin);
            $tableauAttitudes = $degre == 1 ? $this->tableauxAttitudes($matricule, $bulletin) : null;
            $noticeDirection = $this->noteDirection($annee, $bulletin);

            $detailsBulletin = array(
                'annee' => $annee,                            'degre' => $degre,
                'titulaires' => $titulaires,                'listeCoursEleve' => $listeCoursGrp,
                'listeProfs' => $listeProfsCoursGrp,        'baremes' => $ponderations,
                'infoPerso' => $infoPerso,                    'sitPrec' => $sitPrecedentes,
                'sitActuelles' => $sitActuelles,            'detailCotes' => $listeCotes,
                'listeCompetences' => $listeCompetences,        'cotesPonderees' => $cotesPonderees,
                'listeProfs' => $listeProfsCoursGrp,        'commentairesCotes' => $commentairesCotes,
                'ficheEduc' => $ficheEduc,                    'attitudes' => $tableauAttitudes,
                'remTitu' => $remarqueTitulaire,            'mention' => $mention,
                'noticeDirection' => $noticeDirection,
                );

            $pdf = new PDF_HTML('P', 'mm', 'A4');
            $pdf->SetFillColor(230);

            $this->createBulletinEleve($pdf, $detailsBulletin, $bulletin);
            $pdf->Output("$matricule.pdf", 'D');
        }
    }

    /**
     * création du document PDF de bulletin pour l'ensemble d'une classe
     * le bulletin d'une classe est formé de la somme des bulletins individuels de chaque élève.
     *
     * @param array  $listeEleves : liste de tous les élèves de la classe
     * @param string $classe:     la classe concernée
     * @param int    $bulletin    : le numéro du bulletin
     * @param string $acronyme    : nom de l'utilisateur pour déterminer le sous-répertoire d'enregistrement du fichier PDF
     * @param bool   $parNiveau   : est-ce un bulletin par niveau (auquel cas, il ne faudra pas faire l'Output)
     *
     * @return fichier PDF à télécharger
     */
    public function createPDFclasse($listeEleves, $classe, $bulletin, $acronyme, $parNiveau = false)
    {
        $pdf = new PDF_HTML('P', 'mm', 'A4');
        // page de garde
        $pdf->AddPage('P');
        $pdf->SetFont('Arial', 'B', 72);
        $pdf->SetFillColor(230);
        $pdf->SetY(100);
        $pdf->Cell(0, 72, $classe, 0, 0, 'C');

        $Ecole = new Ecole();
        $annee = $Ecole->anneeDeClasse($classe);
        $degre = $Ecole->degreDeClasse($classe);
        $titulaires = $Ecole->titusDeGroupe($classe);

        $noticeDirection = $this->noteDirection($annee, $bulletin);

        // tous les cours donnés dans la classe (certains élèves ne suivent pas certains cours; tenir compte de l'historique)
        $listeTousCoursGrp = $this->listeCoursGrpEleves($listeEleves, $bulletin, true);
        $module = Application::getModule(1);

        foreach ($listeEleves as $matricule => $dataEleve) {
            $listeCoursGrpUnEleve = isset($listeTousCoursGrp[$matricule]) ? $listeTousCoursGrp[$matricule] : null;
            // s'il n'y a pas de cours défini pour cet élève, on ne compose pas le bulletin...
            if ($listeCoursGrpUnEleve != null) {
                $eleve = new Eleve($matricule);
                $infoPerso = $eleve->getDetailsEleve();
                $listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrpUnEleve);
                $listeSituations = $this->listeSituationsCours($matricule, array_keys($listeCoursGrpUnEleve), null, true);

                $sitPrecedentes = $this->situationsPrecedentes($listeSituations, $bulletin);
                $sitActuelles = $this->situationsPeriode($listeSituations, $bulletin);
                $listeCompetences = $this->listeCompetencesListeCoursGrp($listeCoursGrpUnEleve);
                $listeCotes = $this->listeCotes($matricule, $listeCoursGrpUnEleve, $listeCompetences, $bulletin);
                $ponderations = $this->getPonderations($listeCoursGrpUnEleve, $bulletin);

                $cotesPonderees = self::listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
                $commentairesCotes = $this->listeCommentairesTousCours($matricule, $bulletin);
                $mention = $this->listeMentions($matricule, $bulletin, $annee);
                $ficheEduc = $this->listeCommentairesEduc($matricule, $bulletin);
                $remarqueTitulaire = $this->remarqueTitu($matricule, $bulletin);
                // tableau des attitudes seulement au premier degré.
                $tableauAttitudes = $degre == 1 ? $this->tableauxAttitudes($matricule, $bulletin) : null;

                $detailsBulletin = array(
                    'annee' => $annee,                            'degre' => $degre,
                    'titulaires' => $titulaires,                'listeCoursEleve' => $listeCoursGrpUnEleve,
                    'listeProfs' => $listeProfsCoursGrp,        'baremes' => $ponderations,
                    'infoPerso' => $infoPerso,                    'sitPrec' => $sitPrecedentes,
                    'sitActuelles' => $sitActuelles,            'detailCotes' => $listeCotes,
                    'listeCompetences' => $listeCompetences,        'cotesPonderees' => $cotesPonderees,
                    'listeProfs' => $listeProfsCoursGrp,        'commentairesCotes' => $commentairesCotes,
                    'ficheEduc' => $ficheEduc,                    'attitudes' => $tableauAttitudes,
                    'remTitu' => $remarqueTitulaire,            'mention' => $mention,
                    'noticeDirection' => $noticeDirection,
                    );
                $this->createBulletinEleve($pdf, $detailsBulletin, $bulletin);
                unset($eleve);
            }
        }
        $ds = DIRECTORY_SEPARATOR;
        // création éventuelle du répertoire au nom de l'utlilisateur
        if (!(file_exists(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds))) {
            mkdir(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module, 0700, true);
        }

        // s'il s'agit d'une classe isolée, envoyer le PDF, sinon (bulletins par niveau)
        $pdf->Output('F', INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds.$classe.'-'.$bulletin.'.pdf');
        if ($parNiveau == false) {
            return $module.$ds.$classe.'-'.$bulletin.'.pdf';
        } else {
            return;
        }
    }

    /**
     * raccourci pour utf8_decode
     * @param  string $argument
     *
     * @return string : la même chaîne décodée de l'UTF8
     */
    private function utf8($argument)
    {
        return utf8_decode($argument);
    }

    // --------------------------------------------------------------------

    private function enteteBulletin($pdf, $infoPerso, $titulaires, $bulletin)
    {
        $classe = $this->utf8($infoPerso['classe']);
        $eleve_nom = $this->utf8($infoPerso['nom']);
        $eleve_prenom = $this->utf8($infoPerso['prenom']);
        $titulaires = $this->utf8($titulaires);
        $x = 10;
        $y = 12;
        $pdf->SetLineWidth(0.2);
        $pdf->Image('../images/logo1.jpg', 12, 8, 25);

        $pdf->SetXY($x + 30, $y - 2);
        $pdf->SetFont('Arial', 'B', 14);
        $pdf->MultiCell(120, 5, $this->utf8(ECOLE), 0, 'L');
        $pdf->SetFont('Arial', '', 11);
        $pdf->SetXY($x + 30, $y + 3);
        $pdf->MultiCell(120, 4, $this->utf8(ADRESSE)."\n".$this->utf8(VILLE)."\n".$this->utf8(TELEPHONE), 0, 'L');
        $pdf->SetXY($x + 30, $y + 14);
        $pdf->SetFont('Arial', 'U', 9);
        $pdf->MultiCell(120, 5, SITEWEB, 0, 'L');

        $pdf->SetFont('Arial', 'B', 11);
        $pdf->SetXY(90, $y - 2);
        $jour = date('d');
        $mois = date('m');
        $annee = date('Y');

        $titreEleve = sprintf($this->utf8("%s %s \n %s \n Titulaire(s): %s \n"), $eleve_prenom, $eleve_nom, $classe, $titulaires);
        $titreEleve .= sprintf($this->utf8('Le %02d-%02d-%04d, période %d'), $jour, $mois, $annee, $bulletin);
        $pdf->MultiCell(110, 5, $titreEleve, 0, 'R');
        $pdf->Ln();
    }

    // -------------------------------------------------------------------
    public function situationPrecedentePDF($pdf, $sitPrec, $bulletin, $degre)
    {
        // la cote de situation précédente n'est indiquée qu'au D1
        $pdf->SetFont('Arial', '', 8);
        // encadrement pour situation précédente
        $pdf->SetLineWidth(0.2);
        // s'il y a une situation précédente
        if (in_array($degre, array(1, 2, 3))) {  // possibilité de choisir le degré; actuellement, pour tous les degrés
            if ($sitPrec['maxSit'] != 0) {
                $pdf->Cell(40, 5, $this->utf8('Situation Précédente'), 0, 0, 'R');
                $sitPrec = $sitPrec['sit'].'/'.$sitPrec['maxSit'];
                $pdf->Cell(17, 5, $sitPrec, 1, 0, 'C', true);
            } else {
                // il n'y a pas de situation précédente
            $pdf->Cell(40, 5, $this->utf8('Situation Précédente'), 0, 0, 'R');
                $pdf->Cell(17, 5, '---', 0, 0, 'C', true);
            }
        } else { // on n'est pas au D1;
            $pdf->Cell(40 + 17, 5, '', 0, 0, 'R');
        }
    }

    // -------------------------------------------------------------------
    public function entetesColonnesPDF($pdf, $cotesPonderees)
    {
        $pdf->SetFont('Arial', '', 7);
        // encadrement pour les entêtes de colonnes TJ et Cert
        $pdf->SetLineWidth(0.2);
        if (isset($cotesPonderees)) {
            $form = $cotesPonderees['form']['cote'];
            $maxForm = $cotesPonderees['form']['max'];

            // Entête de colonne pour le Formatif
            $pdf->SetFontSize(5);
            $pdf->Cell(4, 5, 'TJ', 1, 0, 'C', true);
            $pdf->SetFontSize(7);
            if ($form >= 0) {
                if ($cotesPonderees['form']['echec']) {
                    $this->rouge($pdf);
                } else {
                    $this->noir($pdf);
                }
                $pdf->Cell(10, 5, $form.'/'.$maxForm, 1, 0, 'C', true);
                $this->noir($pdf);
            } else {
                $pdf->Cell(10, 5, '-', 1, 0, 'C', true);
            }

            $cert = $cotesPonderees['cert']['cote'];
            $maxCert = $cotesPonderees['cert']['max'];
            // Entête de colonne pour les Cert
            $pdf->SetFontSize(5);
            $pdf->Cell(4, 5, 'C', 1, 0, 'C', true);
            $pdf->SetFontSize(7);
            if ($cert >= 0) {
                if ($cotesPonderees['cert']['echec']) {
                    $this->rouge($pdf);
                } else {
                    $this->noir($pdf);
                }
                $pdf->Cell(10, 5, $cert.'/'.$maxCert, 1, 0, 'C', true);
                $this->noir($pdf);
            } else {
                $pdf->Cell(10, 5, '-', 1, 0, 'C', true);
            }
        } else {
            $pdf->Cell(14, 5, '', 1, 0, 'C', true);
            $pdf->Cell(14, 5, '', 1, 0, 'C', true);
        }
    }

    /**
     * nom de la branche et titulaire du cours
     * encadrement du nom du cours et du prof.
     *
     * @param $pdf			// objet PDF
     * @param array  $unCours    : description du cours
     * @param string $listeProfs : liste des profs pour ce cours
     */
    public function brancheProfPDF($pdf, $unCours, $listeProfs)
    {
        $pdf->SetLineWidth(0.2);
        $pdf->SetFont('Arial', 'B', 7);
        $nomCours = $this->utf8($unCours['libelle']);
        $nbh = $unCours['nbheures'];

        $prof = $this->utf8($listeProfs);
        $texte = "$nomCours [$nbh h] $prof";
        // $limite = 48;
        $limite = 60;
        if (strlen($texte) > $limite) {
            $texte = substr($texte, 0, $limite).'...';
        }
        $pdf->Cell(83, 5, $texte, 1, 0, 'L', true);
        $y = $pdf->GetY();

        // ligne de séparation entre les cours
        $pdf->SetLineWidth(0.4);
        $pdf->Line(6, $y, 200, $y);
        // ligne descendante pour le bord gauche de l'encadrement
        $pdf->Line(6, $y, 6, $y + 5);
        $pdf->SetLineWidth(0.2);
    }

    /**
     * écriture de la situation actuelle dans le PDF.
     *
     * @param $pdf			// objet PDF
     * @param $sitActuelle
     * @param $bulletin		// période pour le bulletin à imprimer
     * @param $degre   		// la présentation du bulletin varie selon le degré
     */
    public function situationActuellePDF($pdf, $sitActuelle, $bulletin, $degre)
    {
        // tableau des périodes de délibés, sans espaces
        $arrayDelibes = explode(',', str_replace(' ', '', PERIODESDELIBES));
        $pdf->SetFont('Arial', '', 8);
        // encadrement pour situation actuelle
        $pdf->SetLineWidth(0.2);

        if (in_array($bulletin, $arrayDelibes)) {    // sommes nous en période de délibé
            // la situation de délibé est-elle connue?
            $sitDelibe = trim($sitActuelle['sitDelibe']);
            if ($sitDelibe != '') {
                $pdf->Cell(12, 5, 'Situation', 1, 0, 'C', true);
                if ($this->echec(trim($sitDelibe, '*²[]'), 100)) {
                    $this->rouge($pdf);
                } else {
                    $this->noir($pdf);
                }
                $pdf->Cell(14, 5, $this->utf8($sitDelibe.' %'), 1, 1, 'C', true);
                $this->noir($pdf);
            } else {
                $pdf->Cell(12 + 14, 5, '', 1, 1, 'C', true);
            }    // déplacer le pointeur
        }    // on n'est pas en période de délibés
            else {
                if (in_array($degre, array(1, 2, 3))) {  // possibilité de choisir le degré; ici, on les prend tous
                    // la situation est-elle connue?
                    $sit = trim($sitActuelle['sit']);
                    $max = $sitActuelle['maxSit'];
                    if ($max == '') {
                        $sit = '';
                    }
                    if ($sit != '') {
                        $sit = ($sitActuelle['sit'] > 50) ? round($sitActuelle['sit'], 0) : round($sitActuelle['sit'], 1);
                        $pdf->Cell(12, 5, 'Situation', 1, 0, 'C', true);
                        if ($this->echec($sit, $max)) {
                            $this->rouge($pdf);
                        } else {
                            $this->noir($pdf);
                        }
                        $pdf->Cell(14, 5, $sit.'/'.$max, 1, 1, 'C', true);
                        $this->noir($pdf);
                    }
                        // on n'a rien à écrire
                        else {
                            $pdf->Cell(12 + 14, 5, '', 1, 1, 'C', true);
                        }    // déplacer le pointeur
                } else {
                    $pdf->Cell(12 + 14, 5, '', 1, 1, 'C', true);
                }    // déplacer le pointeur
            }
    }

    /**
     * écriture des "attitudes" dans le bulletin PDF.
     *
     * @param $pdf
     * @param $attitudes
     */
    public function attitudesPDF($pdf, $attitudes)
    {
        if ($attitudes != null) {
            $pdf->SetLineWidth(0.2);
            $y = $pdf->GetY();
            $x = 10;
            $pdf->SetXY($x, $y);
            $pdf->SetFont('Arial', 'B', 12);
            // titre de la rubrique
            $pdf->Cell(50, 5, 'Attitudes', 0, 1, 'L');
            // rectangle gris vide
            $pdf->Rect(10, $y + 5, 50, 17, 'DF');
            $pdf->SetY($y + 22);
            // différentes attitudes
            $pdf->SetFont('Arial', '', 9);
            $pdf->SetX(10);
            $pdf->MultiCell(50, 5, $this->utf8('Respect des autres'), 1, 'L', 1);
            $pdf->SetX(10);
            $pdf->MultiCell(50, 5, $this->utf8('Respect des consignes'), 1, 'L', 1);
            $pdf->SetX(10);
            $pdf->MultiCell(50, 5, $this->utf8('Volonté de progresser'), 1, 'L', 1);
            $pdf->SetX(10);
            $pdf->MultiCell(50, 5, $this->utf8('Ordre et soin'), 1, 'L', 1);

            // position X = 10 + 50
            $x = 60;
            $y += 5;
            foreach ($attitudes as $coursGrp => $unCours) {
                // entete du tableau des attitudes indiquant le cours
                $pdf->SetXY($x, $y);
                $pdf->SetFont('Arial', 'B', 9.5);
                $pdf->Rect($x, $y, 8, 17, 'DF');
                // $cours = $unCours['coursGrp'];
                $cours = substr($coursGrp, strpos($coursGrp, ':') + 1);
                $cours = substr($cours, 0, strpos($cours, '-'));

                $pdf->RotatedText($x + 5, $y + 16, $cours, 90);
                // ériture des différentes attitudes A ou N
                $y1 = $y + 17;
                for ($i = 1; $i <= 4; ++$i) {
                    $pdf->SetFont('Arial', 'B', 9.5);
                    $attitude = $unCours['att'.$i];
                    if ($attitude == 'N') {
                        $attitude = 'NA';
                        $this->rouge($pdf);
                    }
                    $pdf->SetXY($x, $y1);
                    $pdf->Cell(8, 5, $attitude, 1, 'C', 0);
                    $this->noir($pdf);
                    $y1 += 5;
                }
                // colonne suivante
                $x += 8;
            }
            $pdf->Ln(10);
        }
    }

        /***
         * corrige certains caractères non standard de Word
         * @param $chaine : string la châine à corriger
         * @return string : la chaîne corrigée
         */
        private function corrigeWord($chaine)
        {
            $chaine = str_replace('…', '...', $chaine);
            $chaine = str_replace('’', "'", $chaine);

            return $chaine;
        }

    // -------------------------------------------------------------------
    public function notaBulletin($pdf, $nota)
    {
        if ($nota) {
            $pdf->SetY($pdf->GetY() + 5);
            $nota = $this->corrigeWord($nota);
            $nota = str_replace('<br />', '', $this->utf8(html_entity_decode($nota)));

            $pdf->SetLineWidth(0.2);
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->SetX(5);
            $pdf->MultiCell(194, 5, 'Informations de la direction et/ou du coordinateur', 1, 'C', true);
            $pdf->SetX(5);
            $pdf->SetFont('Arial', '', 9);
            $yOrg = $pdf->GetY();
            $xOrg = 5;
            $pdf->WriteHTML($nota);
            $pdf->Ln();
            $yFinal = $pdf->GetY();
            $xFinal = $pdf->GetPageWidth()-16;
            $deltaY = $yFinal - $yOrg;
            $pdf->rect($xOrg, $yOrg, $xFinal, $deltaY, 'D');

            // $pdf->MultiCell(194, 4, $nota, 1);

        }
    }

    // -------------------------------------------------------------------
    public function remarqueTituPDF($pdf, $remarqueTitulaire)
    {
        $remarqueTitulaire = $this->corrigeWord($remarqueTitulaire);
        // $remarqueTitulaire = str_replace('<br />','', $this->utf8(html_entity_decode($remarqueTitulaire,ENT_HTML5,'UTF-8')));
        $remarqueTitulaire = str_replace('<br />', '', $this->utf8($remarqueTitulaire));
        $pdf->SetLineWidth(0.2);
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->SetX(6);
        $pdf->MultiCell(194, 6, 'Avis du titulaire ou du Conseil de Classe', 1, 'C', 1);
        $pdf->SetX(6);
        $pdf->SetFont('Arial', '', 9);
        $pdf->MultiCell(194, 4, $remarqueTitulaire, 1);
        $pdf->Ln();
    }

    // -------------------------------------------------------------------
    public function mentionPDF($pdf, $mention)
    {
        $pdf->SetLineWidth(0.2);
        $pdf->SetX(6);
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->MultiCell(194, 8, $this->utf8('Mention: '.$mention), 1, 'C');
        $pdf->Ln();
    }

    // -------------------------------------------------------------------
    public function commentaireProfPDF($pdf, $commentaire, $y)
    {
        $pdf->SetLineWidth(0.2);
        $pdf->SetFont('Arial', '', 8);
        $commentaire = $this->corrigeWord($commentaire);
        $commentaire = $this->utf8(html_entity_decode($commentaire));
        $pdf->setXY(91, $y);
        $pdf->MultiCell(0, 4, $commentaire, 1, 'L', false);
    }

    /**
     * génération de l'emplacement pour les signatures
     * @param  obj $pdf objet PDF en cours
     *
     * @return void
     */
    public function signatures($pdf)
    {
        $pdf->SetLineWidth(0.2);
        $x = 20;
        $y = $pdf->GetY() + 3;
        $pdf->SetXY($x, $y);
        $pdf->SetFont('Arial', 'B', 8.5);
        $pdf->MultiCell(40, 5, 'Le titulaire', 0, 'C');
        $x = 85;
        $pdf->SetXY($x, $y);
        $pdf->MultiCell(40, 5, 'Les parents', 0, 'C');
        $x = 150;
        $pdf->SetXY($x, $y);
        $pdf->MultiCell(40, 5, $this->utf8('L\'élève'), 0, 'C');
        $pdf->Ln();
    }

    /**
     * Génération de la partie "educs" du bulletin -> PDF
     * @param  obj $pdf objet PDF en cours
     * @param  array $remarques remarques des éducs à imprimer
     *
     * @return void
     */
    public function educPDF($pdf, $remarques)
    {
        $pdf->SetLineWidth(0.2);
        $x = 10;
        $y = $pdf->GetY();
        $pdf->SetXY($x, $y);
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->MultiCell(0, 5, $this->utf8('Remarques des éducateurs'), 1, 'C', true);
        $x = 10;
        $y = $pdf->GetY()+3;
        $fiche = false;
        foreach ($remarques AS $acronyme => $dataEduc) {
            $commentaire = $this->corrigeWord($dataEduc['commentaire']);
            $commentaire = $this->utf8(html_entity_decode($commentaire));
            $pdf->SetX($x);
            $pdf->SetFont('Arial', '', 8);
            $pdf->MultiCell(0, 4, $commentaire, 1, 'L');
            $y = $pdf->GetY();
            $nom = $this->utf8($dataEduc['nom']);
            $prenom = $this->utf8($dataEduc['prenom']);
            $initiale = substr($prenom, 0, 1);
            $signature = html_entity_decode(sprintf('%s. %s', $initiale, $nom));

            if ($dataEduc['titre'] != '')
                $signature .= sprintf( ' (%s)', $this->utf8(html_entity_decode($dataEduc['titre'])));
            $pdf->SetFont('Arial', '', 6);
            $pdf->MultiCell(0, 4, $signature, 0, 'R', false);
            $pdf->SetY($y+5);
            // un éduc a-t-il demandé la fiche disciplinaire?
            if (($dataEduc['fiche'] == 1) && ($fiche == false))
                $fiche = true;
        }
        if ($fiche === true) {
            $pdf->SetLineWidth(0.2);
            $pdf->SetX(5);
            $pdf->SetFont('Arial', '', 9);
            $pdf->MultiCell(194, 4, $this->utf8('Feuille de comportements jointe au bulletin; à signer par les parents.'), 1, 'L');
            $pdf->Ln();
        }
    }

    // /**
    //  * Génération de la partie "educs" du bulletin -> écran
    //  * @param  obj $pdf objet PDF en cours
    //  * @param  array $rubriques informations à imprimer
    //  *
    //  * @return void
    //  */
    // public function educEcran ($remarques) {
    //     $fiche = false;
    //     $infos = array();
    //     foreach ($remarques AS $acronyme => $dataEduc) {
    //         $infos[$acronyme]['commentaire'] = $dataEduc['commentaire'];
    //         $nom = $dataEduc['nom'];
    //         $prenom = $dataEduc['prenom'];
    //         $initiale = substr($prenom, 0, 1);
    //         $infos[$acronyme]['signature'] = html_entity_decode(sprintf('%s. %s', $initiale, $nom));
    //         if ($dataEduc['titre'] != '')
    //             $infos[$acronyme]['signature'] .= sprintf( ' (%s)', html_entity_decode($dataEduc['titre']));
    //         // un éduc a-t-il demandé la fiche disciplinaire?
    //         if (($dataEduc['fiche'] == 1) && ($fiche == false))
    //             $fiche = true;
    //     }
    //
    //     return array($infos, $fiche);
    // }

    // -------------------------------------------------------------------
    public function ecrireCotesPDF($pdf, $cotes, $listeCompetences)
    {
        $limite = 57;
        $pdf->SetFont('Arial', '', 8);

        foreach ($cotes as $idComp => $lesCotes) {
            // ligne descendante pour le bord gauche de l'encadrement
            $pdf->SetLineWidth(0.4);
            $y = $pdf->GetY();
            $pdf->Line(6, $y, 6, $y + 6);
            $pdf->SetLineWidth(0.2);
            // S'il y a quelque chose dans la cote, alors on imprime
            if (($lesCotes['form']['cote'] != '') || ($lesCotes['form']['maxForm'] != '')
                || ($lesCotes['cert']['cote'] != '') || ($lesCotes['cert']['maxCert'] != '')) {

                // écriture de la colonne de gauche: nom des compétences et cotes TJ/Cert
                $libelle = $this->utf8($listeCompetences[$idComp]['libelle']);
                if (strlen($libelle) > $limite) {
                    $libelle = substr($libelle, 0, $limite).'...';
                }
                $coteForm = $this->utf8($lesCotes['form']['cote']);
                $maxForm = $this->utf8($lesCotes['form']['maxForm']);
                $coteCert = $this->utf8($lesCotes['cert']['cote']);
                $maxCert = $this->utf8($lesCotes['cert']['maxCert']);
                $pdf->SetFontSize(6);
                $pdf->Cell($limite, 6, $libelle, 1, 0, 'R', false);
                $pdf->SetFontSize(8);
                if ($coteForm != '') {
                    if ($this->echec($coteForm, $maxForm)) {
                        $this->rouge($pdf);
                    } else {
                        $this->noir($pdf);
                    }
                    $pdf->Cell(14, 6, "$coteForm / $maxForm", 1, 0, 'C', false);
                } else {
                    $pdf->Cell(14, 6, '', 1, 0, 'C', false);
                }
                if ($coteCert != '') {
                    if ($this->echec($coteCert, $maxCert)) {
                        $this->rouge($pdf);
                    } else {
                        $this->noir($pdf);
                    }
                    $pdf->Cell(14, 6, "$coteCert / $maxCert", 1, 1, 'C', false);
                } else {
                    $pdf->Cell(14, 6, '', 1, 1, 'C', false);
                }
                $this->noir($pdf);
            }
        }
    }

    /**
     * compression de tous les fichiers bulletin d'un niveau.
     *
     * @param $dir : répertoire où se trouvent les fichiers
     * @param $bulletin : numéro du bulletin concerné
     * @param $listeClasses : liste des classes à ce niveu d'études
     */
    public function zipFilesNiveau($dir, $bulletin, $listeClasses, $module)
    {
        $memDir = getcwd();
        $niveau = substr($listeClasses[0], 0, 1);
        $zip = new ZipArchive();
        chdir ($dir);
        if ($zip->open("niveau_$niveau-Bulletin_$bulletin.zip", ZIPARCHIVE::CREATE) !== true) {
            exit("Impossible d'ouvrir <niveau_$niveau-Bulletin--_$bulletin.zip>\n");
        }

        foreach ($listeClasses as $uneClasse) {
            $zip->addFile("$uneClasse-$bulletin.pdf");
        }
        $zip->close();
        chdir($memDir);
        return "$module/niveau_$niveau-Bulletin_$bulletin.zip";
    }

    /**
     * écrire en noir, dans le PDF
     * @param  obj $pdf Objet PDF en cours
     * @return void()
     */
    public function noir($pdf)
    {
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetFont('Arial');
    }

    /**
     * écrire en rouge, dans le PDF
     * @param  obj $pdf Objet PDF en cours
     * @return void()
     */
    public function rouge($pdf)
    {
        $pdf->SetTextColor(217, 3, 3);
        $pdf->SetFont('Arial', 'BU');
    }

    /**
     * détermine si une cote est un échec (< 50%)
     * @param  floate $cote cote
     * @param  float $max  maximum pour l'évaluation
     *
     * @return bool true si échec
     */
    public function echec($cote, $max)
    {
        if (($max > 0) && (is_numeric($cote))) {
            return ($cote / $max) < 0.5;
        } else {
            return false;
        }
    }

    /**
     * crée la numérotation des pages dans l'objet PDF passé
     * @param  objet PDF $pdf  l'objet PDF existant
     * @param  int $page numéro de la page
     *
     * @return void
     */
    public function piedPage($pdf, $page)
    {
        $pdf->SetXY(180, 270);
        $pdf->SetFont('Arial', '', 8.5);
        $pdf->MultiCell(20, 5, "page $page / 2", 0, 'R', 0);
    }

    /**
     * Créer une nouvelle page en gérant le pied de page
     * @param  object $pdf        Objet PDF courant
     * @param  array $infoPerso   description de l'élève
     * @param  string $titulaires titulaire de l'élève
     * @param  int $bulletin   numéro du bulletin en cours
     * @param  int $page       numéro de la page
     *
     * @return void (la page m)
     */
    public function newPage($pdf, $infoPerso, $titulaires, $bulletin, $page)
    {
        $this->piedPage($pdf, $page);
        $pdf->AddPage('P');
        $pdf->SetLeftMargin(6);
        $x = 10;
        $y = 12;

        $this->enteteBulletin($pdf, $infoPerso, $titulaires, $bulletin);
        $this->noir($pdf);

        return $page + 1;
    }

    /**
     * Création effective du bulletin de l'élève.
     *
     * @param $pdf class fpdf
     * @param array $bulletinEleve : ensemble des informations relatives à l'élève et à son bulletin
     * @param int   $bulletin      : numéro du bulletin à générer
     */
    public function createBulletinEleve($pdf, $bulletinEleve, $bulletin)
    {
        foreach ($bulletinEleve as $key => $data) {
            $$key = $data;
        }
        /* $bulletinEleve
            'annee' => $annee,		'degre' => $degre,			'titulaires' => $titulaires,			'listeCoursEleve' => $listeCoursGrp,
            'listeProfs' => $listeProfsCoursGrp,				'baremes' => $ponderations,				'infoPerso' => $infoPersoEleve,
            'sitPrec' => $sitPrecedentes,						'sitActuelles' => $sitActuelles,		'detailCotes' => $listeCotes,
            'listeCompetences'=>$listeCompetences,				'cotesPonderees' => $cotesPonderees,	'listeProfs' => $listeProfsCoursGrp,
            'commentairesCotes' => $commentairesCotes,			'ficheEduc' => $ficheEduc,				'attitudes' => $tableauAttitudes,
            'remTitu' => $remarqueTitulaire,					'mention' => $mentions,					'noticeDirection' => $noticeDirection
            */
        $matricule = $infoPerso['matricule'];
        $classe = $infoPerso['classe'];
        $titulaires = implode(', ', $titulaires);
        $eleve_nom = $this->utf8($infoPerso['nom']);
        $eleve_prenom = $this->utf8($infoPerso['prenom']);

        $pdf->AddPage('P');
        $pdf->SetLeftMargin(6); // fixe la marge de gauche
        $page = 1;

        $this->enteteBulletin($pdf, $infoPerso, $titulaires, $bulletin);
        $pdf->SetFont('Arial', '', 8);

        // on passe tous les cours en revue
        foreach ($listeCoursEleve as $coursGrp => $dataCours) {
            $debutX = $pdf->GetX();
            $debutY = $pdf->GetY();

            // s'il y a des cotes pour ce cours
            if (isset($detailCotes[$matricule][$coursGrp])) {
                $this->situationPrecedentePDF($pdf, $sitPrec[$matricule][$coursGrp], $bulletin, $degre);
                $this->entetesColonnesPDF($pdf, $cotesPonderees[$matricule][$coursGrp]);
            } else {
                $pdf->setX(91);
            } // il n'y a pas de cotes, déplacer la marge de gauche

            $profs = $listeProfs[$coursGrp];
            $this->brancheProfPDF($pdf, $listeCoursEleve[$coursGrp], $profs);

            // on vérifie qu'il y a une situation actuelle pour ce cours; sinon, Null
            $situationCours = isset($sitActuelles[$matricule][$coursGrp]) ? $sitActuelles[$matricule][$coursGrp] : null;
            $this->situationActuellePDF($pdf, $situationCours, $bulletin, $degre);

            // on retient la position Y du début d'écriture des cotes
            // on en aura  besoin pour positionner le multicell du commentaire du prof
            $yDebutCotes = $pdf->GetY();

            // s'il y a des cotes pour ce cours
            if (isset($detailCotes[$matricule][$coursGrp])) {
                $cours = $this->coursDeCoursGrp($coursGrp);
                $this->ecrireCotesPDF($pdf, $detailCotes[$matricule][$coursGrp], $listeCompetences[$cours]);
            }

            // quand toutes les cotes sont écrites, on récupère la valeur de Y
            $yFinCotes = $pdf->GetY();
            $prof = $listeProfs[$coursGrp];

            $commentaire = isset($commentairesCotes[$matricule][$coursGrp][$bulletin]) ? $commentairesCotes[$matricule][$coursGrp][$bulletin] : '';
            $this->commentaireProfPDF($pdf, $commentaire, $yDebutCotes);

            $yFinCommentaire = $pdf->GetY();
            // se positionner sous le bloc le plus haut: compétences ou commentaires
            $pdf->SetY(max($yFinCotes, $yFinCommentaire));

            // vérifier s'il faut un saut de page préventif
            if ($pdf->GetY() > 235) {
                $page = $this->newPage($pdf, $infoPerso, $titulaires, $bulletin, $page);
            } else {
                $pdf->Ln(1);
            }
        } // foreach $listeCoursEleve

        // Le tableau des attitudes et l'avis du titu sont toujours à la page 2
        if ($page == 1) {
            $page = $this->newPage($pdf, $infoPerso, $titulaires, $bulletin, $page);
        } else {
            $pdf->Ln(1);
        }

        if (isset($attitudes[$bulletin])) {
            $this->attitudesPDF($pdf, $attitudes[$bulletin][$matricule]);
        }

        // *************************************************************************************

        if (isset($mention[$matricule][ANNEESCOLAIRE][$annee][$bulletin])) {
            $this->mentionPDF($pdf, $mention[$matricule][ANNEESCOLAIRE][$annee][$bulletin]);
        }
        if (isset($remTitu[$matricule][$bulletin])) {
            $this->remarqueTituPDF($pdf, $remTitu[$matricule][$bulletin]);
        }

        if (isset($ficheEduc[$matricule][$bulletin])) {
            $this->educPDF($pdf, $ficheEduc[$matricule][$bulletin]);
        }

        if (isset($noticeDirection)) {

            $this->notaBulletin($pdf, $noticeDirection);

        }

        $this->signatures($pdf);
        $this->piedPage($pdf, $page);
    }// fin fonction

    /**
     * /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch!
     * réparation du hiatus entre la table des situations et la table des cours réellement suivis par les élèves.
     *
     * @param
     *
     * @return int : nombre de rectifications
     *             /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch! /!\ patch!
     */
    public function listeErreursCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX.'eleves.matricule, classe, nom, prenom, '.PFX.'elevesCours.coursGrp AS correct, '.PFX.'bullSituations.coursGrp AS incorrect ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= 'JOIN '.PFX.'bullSituations ON ( '.PFX.'bullSituations.matricule = '.PFX.'eleves.matricule ) ';
        $sql .= 'JOIN '.PFX.'elevesCours ON ( '.PFX.'elevesCours.matricule = '.PFX.'bullSituations.matricule ) ';
        $sql .= 'WHERE SUBSTR( '.PFX."bullSituations.coursGrp, 1, LOCATE( '-', ".PFX.'bullSituations.coursGrp ) -1 ) = SUBSTR( '.PFX."elevesCours.coursGrp, 1, LOCATE( '-', ".PFX.'elevesCours.coursGrp ) -1 ) ';
        $sql .= 'AND ('.PFX.'elevesCours.coursGrp != '.PFX.'bullSituations.coursGrp) ';
        $sql .= 'ORDER BY classe, '.PFX.'elevesCours.coursGrp, nom ';
        $resultat = $connexion->query($sql);
        $listeErreurs = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $correct = $ligne['correct'];
                $incorrect = $ligne['incorrect'];
                $listeErreurs[$matricule][$incorrect] = $correct;
            }
            $nb = 0;
            foreach ($listeErreurs as $matricule => $listeCours) {
                foreach ($listeCours as $erreur => $correct) {
                    $sql = 'UPDATE '.PFX.'bullSituations ';
                    $sql .= "SET coursGrp = '$correct' ";
                    $sql .= "WHERE coursGrp = '$erreur' AND matricule = '$matricule' ";
                    $resultat = $connexion->exec($sql);
                    $nb += $resultat;
                }
            }
            Application::DeconnexionPDO($connexion);

            return $nb;
        }
    }

    /**
     * Suppression de la virgule et remplacement par un point dans les nombres + suppression des espaces.
     *
     * @param $nombre string
     *
     * @return string
     */
    private function sansVirg($nombre)
    {
        $nombre = str_replace(',', '.', $nombre);
        $nombre = str_replace(' ', '', $nombre);

        return $nombre;
    }

    /**
     * Ajout d'une "compétence" pour tous les cours.
     *
     * @param
     */
    public function ajouteTV()
    {
        $listeCours = $this->listeCoursNiveaux(ECOLE::listeNiveaux());
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        foreach ($listeCours as $cours => $data) {
            $sql = 'INSERT INTO '.PFX.'bullCompetences ';
            $sql .= "SET cours = '$cours', libelle='Travail de vacances', ordre='99' ";
            $resultat = $connexion->exec($sql);
        }
        Application::DeconnexionPDO($connexion);
    }

    /**
     * recherche de tous les coursGrp correspondant à un $cours donné
     * la fonction retourne des array (matricule, coursGrp).
     *
     * @param string $cours
     *
     * @return array
     */
    public function elevesCoursGrpDeCours($cours)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule,coursGrp FROM '.PFX.'elevesCours ';
        $sql .= "WHERE SUBSTR(coursGrp,1,LOCATE('-',coursGrp)-1)='$cours' ";
        $sql .= 'ORDER BY coursGrp ';
        $resultat = $connexion->query($sql);
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        $elevesCoursGrp = $resultat->fetchall();
        Application::DeconnexionPDO($connexion);

        return $elevesCoursGrp;
    }

    /**
     * retourne le tableau des élèves par cours quand on fournit un tableau des élèves par coursGrp.
     *
     * @param array $listeCoursGrpListeEleves
     *
     * @return array
     */
    public function listeCoursSansGrp($listeCoursGrpListeEleves)
    {
        $liste = array();
        foreach ($listeCoursGrpListeEleves as $matricule => $listeCoursGrp) {
            foreach ($listeCoursGrp as $coursGrp => $wtf) {
                $cours = self::coursDeCoursGrp($coursGrp);
                $liste[$matricule][$cours] = '';
            }
        }

        return $liste;
    }

    /**
     * initialisation de la table des résultats d'épreuves externes
     * les enregistrements déjà existants ne sont pas écrasés!!!
     *
     * @param array $elevesCoursGrp
     *
     * @return int $nb : nombre de nouveaux enregistrements dans la table
     */
    public function initEpreuvesExternes($elevesCoursGrp, $anscol)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullEprExterne ';
        $sql .= "SET matricule=:matricule, coursGrp=:coursGrp, anscol='$anscol' ";
        $requete = $connexion->prepare($sql);
        $nb = 0;
        foreach ($elevesCoursGrp as $wtf => $data) {
            $matricule = $data['matricule'];
            $coursGrp = $data['coursGrp'];
            $nb += $requete->execute($data);
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne la liste des classes concernées par les épreuves externes pour une année scolaire donnée.
     *
     * @param $anneeScolaire
     *
     * @return array
     */
    public function classesEprExterne($anneeScolaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT groupe ';
        $sql .= 'FROM '.PFX.'eleves AS de ';
        $sql .= 'JOIN '.PFX.'bullEprExterne AS ext ON ext.matricule = de.matricule ';
        $sql .= 'WHERE de.matricule IN (SELECT DISTINCT matricule FROM '.PFX.'bullEprExterne) ';
        $sql .= "AND anscol = '$anneeScolaire' ";
        $sql .= 'ORDER BY groupe ';
        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $classe = $ligne['groupe'];
                $liste[$classe] = $classe;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * liste des cours (et des coursGrp correspondants) de la table des épreuves externes.
     *
     * @param int $niveau : le niveau d'étude
     *
     * @return array
     */
    public function listeCoursEpreuveExterne($niveau, $anscol)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT coursGrp, cours, libelle ';
        $sql .= 'FROM '.PFX.'bullEprExterne ';
        $sql .= 'JOIN '.PFX."cours as dc ON (dc.cours = SUBSTR(coursGrp,1, LOCATE('-',coursGrp)-1)) ";
        $sql .= "WHERE SUBSTR(coursGrp,1,1) = '$niveau' AND anscol='$anscol' ";
        $sql .= 'ORDER BY libelle,coursGrp ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $coursGrp = $ligne['coursGrp'];
                $libelle = $ligne['libelle'];
                if (!(isset($liste[$cours]))) {
                    $bloc = array('libelle' => $libelle, 'coursGrp' => array());
                    $liste[$cours] = $bloc;
                }
                $liste[$cours]['coursGrp'][] = $coursGrp;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie le nombre de cotes déjà encondées pour chacun des cours à épreuve externe dans le niveau donné.
     *
     * @param $niveau
     *
     * @return array
     */
    public function nbCotesExtCoursGrp($niveau)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp, count(*) AS nbCotes ';
        $sql .= 'FROM '.PFX.'bullEprExterne ';
        $sql .= "WHERE (TRIM(coteExterne) != '') AND (SUBSTR(coursGrp,1,1) = '$niveau') ";
        $sql .= 'GROUP BY coursGrp ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne['nbCotes'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Suppression d'un coursGrp dans la table des épreuves externes.
     *
     * @param string $coursGrp
     *
     * @return $nb
     */
    public function delEprExterne($coursGrp, $anscol)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullEprExterne ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND anscol='$anscol' ";
        $nb = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * recherche la liste des cotes d'épreuve externe pour un cours-groupe donné.
     *
     * @param string $coursGrp
     *
     * @return array
     */
    public function listeCotesEprExterne($coursGrp, $anscol)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, coteExterne, coursGrp ';
        $sql .= 'FROM '.PFX.'bullEprExterne ';
        $sql .= "WHERE coursGrp = '$coursGrp' AND anscol='$anscol' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des coursGrp en épruve externe dans une classe donnée.
     *
     * @param $classe
     *
     * @return array
     */
    public function listeCoursGrpEprExterne($classe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT coursGrp, nbHeures, libelle, cours ';
        $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1) ";
        $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX."eleves WHERE groupe = '$classe') ";
        $sql .= 'ORDER BY coursGrp ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des cotes des épreuves externes pour les élèves de la liste fournie.
     *
     * @param $listeEleves : array
     * @param $anneeScolaire : l'année scolaire souhaitée
     *
     * @return array
     */
    // public function listeCotesExternesListeEleves($listeEleves, $anneeScolaire)
    // {
    //     $listeElevesString = implode(',', array_keys($listeEleves));
    //     $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    //     $sql = 'SELECT ext.matricule, nom, prenom, groupe, coursGrp, libelle, nbHeures, coteExterne ';
    //     $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
    //     $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1) ";
    //     $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = ext.matricule ';
    //     $sql .= "WHERE matricule IN ($listeElevesString) AND anscol = '$anneeScolaire' ";
    //     $sql .= 'ORDER BY coursGrp ';
    //
    //     $resultat = $connexion->query($sql);
    //     $liste = array();
    //     if ($resultat) {
    //         $resultat->setFetchMode(PDO::FETCH_ASSOC);
    //         while ($ligne = $resultat->fetch()) {
    //             $matricule = $ligne['matricule'];
    //             $coursGrp = $ligne['coursGrp'];
    //             $liste[$matricule][$coursGrp] = $ligne;
    //         }
    //     }
    //     Application::DeconnexionPDO($connexion);
    //
    //     return $liste;
    // }

    /**
     * retourne les résultats des épreuves externes des élèves de la classe donnée pour l'année scolaire donné
     * @param  string $classe        la classe des élèves
     * @param  string $anneeScolaire sous la forme XXXX-YYYY
     * @return array
     */
    public function getResultatsExternes($classe, $anneeScolaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT classe, coursGrp, libelle, nbheures, ext.matricule, coteExterne, nom, prenom ';
        $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = ext.matricule ';
        $sql .= 'JOIN '.PFX."cours AS cours ON cours.cours = SUBSTR(coursGrp,1, LOCATE('-', coursGrp)-1) ";
        $sql .= "WHERE anscol = '$anneeScolaire' ";
        $sql .= 'AND de.matricule IN (SELECT matricule FROM '.PFX."eleves WHERE groupe = '$classe') ";
        $sql .= 'ORDER BY nom, prenom ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $liste[$matricule][$coursGrp] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des cotes des épreuves externes d'un élève donné
     * la liste est triée par année scolaire puis par cours.
     *
     * @param $matricule
     *
     * @return array
     */
    public function cotesExternesPrecedentes($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT anscol, coursGrp, coteExterne ';
        $sql .= 'FROM '.PFX.'bullExterneArchives ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= 'ORDER BY anscol DESC ';

        $resultat = $connexion->query($sql);
        $listeCotes = array();
        while ($ligne = $resultat->fetch()) {
            $anneeScolaire = $ligne['anscol'];
            $cours = $this->coursDeCoursGrp($ligne['coursGrp']);
            $cote = $ligne['coteExterne'];
            $listeCotes[$anneeScolaire][$cours] = $cote;
        }
        Application::DeconnexionPDO($connexion);

        return $listeCotes;
    }

    /**
     * retourne la liste des cours d'un prof qui sont concernés par une épreuve externe.
     *
     * @param array $listeCoursProf
     *
     * @return array
     */
    public function listeCoursEprExterne($listeCoursProf, $anscol)
    {
        $listeCoursProf = "'".implode("','", array_keys($listeCoursProf))."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT ext.coursGrp, statut, libelle, nbheures, cours, nomCours, SUBSTR(ext.coursGrp,1,1) AS annee ';
        $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
        $sql .= 'JOIN '.PFX."cours AS dc ON (dc.cours =  SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours AS sc ON ( sc.cadre = dc.cadre ) ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = ext.coursGrp ';
        $sql .= "WHERE ext.coursGrp IN ($listeCoursProf) AND ext.anscol='$anscol' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des cours avec la situation interne pour la classe donnée et pour la liste de cours donnée.
     *
     * @param $classe
     * @param $listeCours : liste des cours
     * @param $bulletin : le bulletin en cours
     *
     * @return array
     */
    public function listeCoursSitInternes($classe, $listeCours, $bulletin)
    {
        $listeCoursString = "'".implode('\',\'', $listeCours)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT matricule, coursGrp, SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1) AS cours, ";
        $sql .= 'sitDelibe, attributDelibe ';
        $sql .= 'FROM '.PFX.'bullSituations ';
        $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX."eleves WHERE groupe = '$classe') ";
        $sql .= "AND SUBSTR(coursGrp, 1, LOCATE('-',coursGrp)-1) IN ($listeCoursString) ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $liste[$matricule][$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistrement des cotes d'épreuves externes en provenance d'un formulaire POST.
     *
     * @param array post
     *
     * @return int nombre d'enregistrements modifiés
     */
    public function enregistrerEprExternes($post, $anscol)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'bullEprExterne ';
        $sql .= "SET coteExterne=:cote, anscol= :anscol ";
        $sql .= 'WHERE matricule=:matricule AND coursGrp=:coursGrp ';
        $requete = $connexion->prepare($sql);

        $coursGrp = $post['coursGrp'];

        $requete->bindParam(':anscol', $anscol, PDO::PARAM_INT);
        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
        $coteabs = explode(',', COTEABS);
        $nb = 0;
        $tableErreurs = array();

        foreach ($post as $field => $value) {
            $fieldCote = explode('_', $field);

            // le nom du champ contenant la cote de l'épreuve externe commence par "cote" suivi de "_xxxxx" où xxxxx est le matricule
            if ($fieldCote[0] == 'cote') {
				$matricule = $fieldCote[1];
				$value = str_replace(',', '.', $value);
				$cote = ltrim(strtoupper($value), '0');

                $erreur = false;

                // la cote externe doit être numérique et comprise entre 0 et 100
                if (is_numeric($cote) && (($cote > 100) || ($cote < 0))) {
                    $erreur = true;
                }
                // une éventuelle mention textuelle illicite (pas dans les cotes d'absence)
                if ((!(is_numeric($cote))) && (!(in_array($cote, $coteabs))) && (trim($cote) != '')) {
                    $erreur = true;
                }

                if ($erreur == true) {
                    $tableErreurs[$matricule] = $cote;
                } else {
					// Application::afficher(array('coursGrp' => $coursGrp, 'matricule' => $matricule, 'cote' => $cote));
					$requete->bindParam(':cote', $cote, PDO::PARAM_STR, 5);
					$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                    $nb += $requete->execute();
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return array('nb' => $nb, 'erreurs' => $tableErreurs);
    }

    /**
     * retourne les cotes de situation en tenant compte des épreuves externes pour un élève donné
     * soit la cote de l'épreuve externe, soit 50% (cas de la réussite interne), soit la cote de situation
     * => destination: feuille de délibé individuelle par élève.
     *
     * @param array $listeSituations : la liste de situations de délibé pour chaque cours
     * @param int   $matricule       : le matricule de l'élève
     *
     * @return array $listeSituations
     */
    public function eleveSitDelibeExternes($matricule, $listeSituations)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp, coteExterne ';
        $sql .= 'FROM '.PFX.'bullEprExterne ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $coteExterne = $ligne['coteExterne'];
                $choixCote = $ligne['choixCote'];
                if (isset($listeSituations[$coursGrp][NBPERIODES]['sitDelibe']) && (trim($listeSituations[$coursGrp][NBPERIODES]['sitDelibe']) != '')) {
                    switch ($choixCote) {
                        case 'coteExterne':
                            $listeSituations[$coursGrp][NBPERIODES]['sitInterne'] = $listeSituations[$coursGrp][NBPERIODES]['sitDelibe'];
                            $listeSituations[$coursGrp][NBPERIODES]['sitDelibe'] = $coteExterne;
                            $listeSituations[$coursGrp][NBPERIODES]['symbole'] = self::attribut2Symbole('externe');
                            $listeSituations[$coursGrp][NBPERIODES]['echec'] = ($coteExterne < 50) ? 'echec' : null;
                        break;
                        case 'reussite':
                            $listeSituations[$coursGrp][NBPERIODES]['sitInterne'] = $listeSituations[$coursGrp][NBPERIODES]['sitDelibe'];
                            $listeSituations[$coursGrp][NBPERIODES]['sitDelibe'] = '50';
                            $listeSituations[$coursGrp][NBPERIODES]['symbole'] = self::attribut2Symbole('reussite50');
                            $listeSituations[$coursGrp][NBPERIODES]['echec'] = null;
                        break;
                        case 'sitDelibe':
                            // do nothing : la cote est le situation choisie par le titulaire du cours dans le bulletin
                        break;
                        }
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeSituations;
    }

    /**
     * 	retourne la liste des coursGrp pour lesquels une épreuve externe est définie
     * 	dans la table correspondante et pour le niveau donné.
     *
     * 	@param $niveau
     *
     * 	@return array
     */
    public function listeEprExterne($niveau)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT ee.coursGrp, cours, ds.statut, nbheures, libelle, dp.acronyme, nom, prenom ';
        $sql .= 'FROM '.PFX.'bullEprExterne AS ee ';
        $sql .= 'JOIN '.PFX."cours AS dc ON (dc.cours = SUBSTR(coursGrp,1, LOCATE('-',coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'profsCours AS dpc ON (dpc.coursGrp = ee.coursGrp) ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON (dp.acronyme = dpc.acronyme) ';
        $sql .= 'JOIN '.PFX.'statutCours AS ds ON ( ds.cadre = dc.cadre ) ';
        $sql .= "WHERE SUBSTR(ee.coursGrp,1,1) = '$niveau' ";
        $sql .= 'ORDER BY libelle, coursGrp ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $acronyme = $ligne['acronyme'];
                $statut = $ligne['statut'];
                $nbheures = $ligne['nbheures'];
                if (isset($liste[$coursGrp])) {
                    $liste[$coursGrp]['acronyme'] .= ",$acronyme";
                } else {
                    $liste[$coursGrp] = array(
                            'acronyme' => $acronyme,
                            'coursGrp' => $coursGrp,
                            'statut' => $statut,
                            'nbheures' => $nbheures,
                            'libelle' => $ligne['libelle'], );
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

     /**
      * enregistrement des noms attribués aux cours en provenance du formulaire ad hoc pour l'utilisateur actuel $acronyme.
      *
      * @param array : $post
      * @param string : $acronyme
      *
      * @return int : nombre d'enregistrements réalisés
      */
     public function enregistrerNomsCours($post, $acronyme)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $resultat = 0;
         foreach ($post as $champ => $value) {
             if (substr($champ, 0, 6) == 'field_') {
                 $coursGrp = explode('_', $champ);
                // dans le coursGrp, un espace éventuel avait été remplacé par un "~" dans le template;
                // il faut remettre l'espace
                $coursGrp = str_replace('~', ' ', $coursGrp[1]);
                 $nomCours = addslashes($value);
                 $sql = 'INSERT INTO '.PFX.'profsCours ';
                 $sql .= "SET acronyme='$acronyme', coursGrp='$coursGrp', nomCours='$nomCours' ";
                 $sql .= "ON DUPLICATE KEY UPDATE nomCours='$nomCours' ";
                 $resultat += $connexion->exec($sql);
             }
         }
         Application::DeconnexionPDO($connexion);

         return $resultat;
     }

    /**
     * Effacement de toutes les cotes d'un bulletin donné (avant transfert du carnet de cotes).
     *
     * @param $bulletin
     * @param $listeCompetences
     * @param $coursGrp
     */
    public function effaceDetailsBulletin($bulletin, $listeCompetences, $coursGrp, $listeLocks, $listeEleves)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        foreach ($listeCompetences as $idCompetence => $wtf) {
            foreach ($listeEleves as $matricule => $wtf2) {
                // on n'efface que ce qui n'est pas verrouillé
                if (isset($listeLocks[$matricule][$coursGrp]) && $listeLocks[$matricule][$coursGrp] == 0) {
                    $sql = 'UPDATE '.PFX.'bullDetailsCotes ';
                    $sql .= "SET form='', maxForm='', cert='', maxCert='' ";
                    $sql .= "WHERE idComp='$idCompetence' AND coursGrp='$coursGrp' AND matricule='$matricule' AND bulletin='$bulletin' ";
                    $resultat = $connexion->exec($sql);
                }
            }
        }
        Application::DeconnexionPDO($connexion);
    }

    /**
     * Retourne l'ensemble des cadres de cours et des statuts correspondants dans l'école
     * Chaque cours appartient à un cadre officiel (voir dans ProEco)
     * Dans l'application, on attribue un statut correspondant: AC, OB, OG, FC,...
     * Plusieurs "cadres" peuvent correspondre au même "statut".
     * Dans l'application de bulletins, les cours de statut moindre (AC, OC) sont traités différemment des
     * cours à "statut" fort.
     *
     * @param void
     *
     * @return array
     */
    public function getStatutsCadres()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT cadre, statut, rang, echec, total ';
        $sql .= 'FROM '.PFX.'statutCours ';
        $sql .= 'ORDER BY rang, cadre ';
        $requete = $connexion->prepare($sql);
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $cadre = $ligne['cadre'];
                $liste[$cadre] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Enregistrer les combinaisons "cadre" / "statut du cours" provenant du formulaire.
     *
     * @param $post : le contenu du formulaire d'édition
     *
     * @return int : le nombre d'insertion dans la BD
     */
    public function saveStatutsCadres($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'statutCours ';
        $sql .= 'SET cadre = :cadre, statut = :statut, rang = :rang, echec = :echec, total = :total ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'statut = :statut, rang = :rang, echec = :echec, total = :total ';
        $requete = $connexion->prepare($sql);
        $resultat = 0;
        $lesCadres = $post['cadre'];

        foreach ($lesCadres as $cadre) {
            $statut = $post['statut_'.$cadre];
            $rang = $post['rang_'.$cadre];
            $echec = isset($post['echec_'.$cadre]) ? 1 : 0;
            $total = isset($post['total_'.$cadre]) ? 1 : 0;

            $requete->bindParam(':cadre', $cadre, PDO::PARAM_INT);
            $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 6);
            $requete->bindParam(':rang', $rang, PDO::PARAM_INT);
            $requete->bindParam(':echec', $echec, PDO::PARAM_INT);
            $requete->bindParam(':total', $total, PDO::PARAM_INT);

            $requete->execute();
            $resultat ++;
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne les mentions obtenues par une liste d'élèves données à une période donnée
     * pour l'année scoalire donnée
     *
     * @param array $listeEleves
     * @param int $periode : numéro de la période de l'année sélectionnée
     * @param string $anneeScolaire (sous la forme XXXX-YYYY)
     */
     public function listeSimpleMentions($listeEleves, $periode, $anneeScolaire)
     {
         if (is_array($listeEleves)) {
             $listeElevesString = implode(',', array_keys($listeEleves));
         } else {
             $listeElevesString = $listeEleves;
         }
       $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
       $sql = 'SELECT matricule, mention, anscol, periode ';
       $sql .= 'FROM didac_bullMentions ';
       $sql .= "WHERE matricule IN ($listeElevesString) ";
       $sql .= "AND periode = $periode AND anscol= '$anneeScolaire' ";
       $sql .= "ORDER BY matricule ";

       $resultat = $connexion->query($sql);
       $liste = array();
       if ($resultat) {
         $resultat->setFetchMode(PDO::FETCH_ASSOC);
         while ($ligne = $resultat->fetch()) {
             $matricule = $ligne['matricule'];
             $mention = $ligne['mention'];
             $liste[$matricule] = $mention;
         }
       }

       Application::DeconnexionPDO($connexion);

       return $liste;
   }


   /**
    * renvoie les cotes finales (de délibé) obtenues pour l'ensemble des cours pour l'année scolaire en cours
    * et pour les élèves sélectionnés
    *
    * @param array : liste des élèves par matricule
    *
    * @return array
    */
   public function resultatsTousCours($listeEleves, $periode) {
       if (is_array($listeEleves)) {
           $listeElevesString = implode(',', array_keys($listeEleves));
       } else {
           $listeElevesString = $listeEleves;
       }
       $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
       $sql = 'SELECT matricule, coursGrp, sitDelibe, libelle ';
       $sql .= 'FROM '.PFX.'bullSituations AS dbs ';
       $sql .= "LEFT JOIN ".PFX."cours AS dc ON dc.cours = substr(coursGrp, 1, LOCATE('-', coursGrp)-1) ";
       $sql .= "WHERE bulletin=$periode ";
       $sql .= "AND matricule IN ($listeElevesString) ";
       $sql .= 'ORDER BY matricule, nbHeures DESC, libelle ';

       $liste = array();
       $resultat = $connexion->query($sql);
       if ($resultat) {
           $resultat->setFetchMode(PDO::FETCH_ASSOC);
           while ($ligne = $resultat->fetch()) {
               $matricule = $ligne['matricule'];
               $coursGrp = $ligne['coursGrp'];
               $liste[$matricule][$coursGrp] = $ligne;
           }
       }

       Application::deconnexionPDO($connexion);

       return $liste;
   }


   /**
    * renvoie les cotes obtenues pour l'ensemble des cours durant l'année scolaire indiquée pour les élèves sélectionnés
    * les informations proviendront du dernier bulletin de l'année scolaire de cette année écoulée
    *
    * @param  int $matricule     identifiant de l'élève
    * @param  string  $anneeScolaire année scolaire concernée sous la forme YYYY-YYYY
    *
    * @return array
    */

   public function infoAnneePrecedente ($matricule, $anneesPrecedentes) {
       // a-t-on des informations sur l'année précédente (élève arrivé à l'école en cours de degré)
       if (isset($anneesPrecedentes[$matricule])) {
           $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
           $sql = 'SELECT annee, matricule, coursGrp, sitDelibe, cours, libelle ';
           $sql .= 'FROM '.PFX.'bullSitArchives AS arch ';
           $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = substr(arch.coursGrp, 1, LOCATE('-', arch.coursGrp)-1) ";
           $sql .= 'JOIN '.PFX.'statutCours AS dsc ON dsc.cadre = dc.cadre ';
           $sql .= "WHERE annee LIKE :anneeScolaire AND matricule =:matricule AND bulletin =:periode ";
           $sql .= 'ORDER BY rang, nbheures DESC, libelle ';
           $requete = $connexion->prepare($sql);

           $liste = array();
           $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
           $anneeScolaire = $anneesPrecedentes[$matricule]['anScol'];
           $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);
           $nbPeriodes = $anneesPrecedentes[$matricule]['nbPeriodes'];
           $requete->bindParam(':periode', $nbPeriodes, PDO::PARAM_INT);

           $liste = array();
           $resultat = $requete->execute();
           if ($resultat) {
               $requete->setFetchMode(PDO::FETCH_ASSOC);
               while ($ligne = $requete->fetch()) {
                   $coursGrp = $ligne['coursGrp'];
                   $liste[$coursGrp] = $ligne;
               }
           }

           Application::deconnexionPDO($connexion);

           return $liste;
       }
       else return Null;
   }


   /**
    * retourne les classes dont le prof est titulaire et qui sont des "fins de degré"
    *
    * @param array $listeClasses : liste des classes dont le prof est titulaire
    * @param array $anneesDegre : liste des années d'étude de fin de degré (typiquement 2, 4, 6)
    *
    * @return array
    */
    function listeClassesFinDegre ($listeClasses, $anneesDegre) {
        $listeClassesDegre = array();
        foreach ($listeClasses as $uneClasse) {
            $annee = substr($uneClasse, 0, 1);
            if (in_array($annee, $anneesDegre)){
                $listeClassesDegre[$uneClasse] = $uneClasse;
            }
        }

        return $listeClassesDegre;
    }

    /**
     * recherche les années scolaires correspondant à une année d'étude pour les élèves de la liste
     * Ex: année scolaire 2013-2014 pour un élève en 2e année (année d'étude)
     *
     * @param int | array : liste des matricules des élèves
     * @param int : $anneeEtude
     *
     * @return array
     */
    public function anneesScolairesPrecedentes($listeEleves, $anneeEtude) {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT matricule, annee ';
        $sql .= 'FROM '.PFX.'bullSitArchives ';
        $sql .= "WHERE matricule IN ($listeElevesString) AND SUBSTR(coursGrp, 1, 1) =:anneeEtude ";

        $requete = $connexion->prepare ($sql);
        $requete->bindParam(':anneeEtude', $anneeEtude, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule]['anScol'] = $ligne['annee'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
        }

    /**
     * recherche pour chaque élève de la liste le nombre de périodes dans l'année scolaire (type 2016-2017) donnée
     *
     * @param array $anneesScolairesPrecedentes (liste des élèves avec leurs années scolaires précédentes, 1ère année du degré
     * @param $anneEtude : l'année d'étude po
     * @return array
     */
    public function nbPeriodesAnScol($anneesScolairesPrecedentes) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT annee, MAX(bulletin) AS periodes ';
        $sql .= 'FROM '.PFX.'bullSitArchives ';
        $sql .= 'WHERE annee=:anScol ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        foreach ($anneesScolairesPrecedentes as $matricule => $data) {
            $anScol = $data['anScol'];
            $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $annee = $ligne['annee'];
                    $liste[$annee] = $ligne['periodes'];
                }
            }

        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        return $liste;
        }

        /**
         * recherche la liste des mentions attribuées en délibé durant l'année scolaire en cours
         * sans tenir compte des "+" et des "-"
         *
         * @param string $anScol
         *
         * @return array
         */
        public function listeMentionsAnScol($anScol){
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT DISTINCT(mention) ';
            $sql .= 'FROM '.PFX.'bullMentions ';
            $sql .= 'WHERE anScol = :anScol ';
            $sql .= 'ORDER BY LOWER(mention) DESC ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);

            $liste = array();
            $resultat = $requete->execute();
            if ($resultat){
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()){
                    // on supprime les + et -
                    $mention = trim($ligne['mention'],'+-');
                    // si la mention n'est pas encore dans la liste
                    if (!(in_array($mention, $liste)) && ($mention != ''))
                        array_push($liste, trim($mention,'+-'));
                }
            }

            Application::deconnexionPDO($connexion);

            return $liste;
        }

        /**
         * recherche dans la listes des élèves ceux qui ont acquis une des mentions de la liste
         * durant la période choisie
         *
         * @param array $listeEleves : liste des matricules des élèves de la classe
         * @param int $periode : la période choisie
         * @param array $listeMentions : la liste des mentions recherchées
         * @param string $anScol : l'année scolaire en cours
         *
         * @return array : la liste des matricules des élèves concernés
         */
        public function listeSelectDelibe($listeEleves, $periode, $listeMentions, $anScol){
            $listeElevesString = implode(',', $listeEleves);
            if ($listeMentions != Null)
                $listeMentionsString = "'".implode("','", $listeMentions)."'";

            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT matricule, mention ';
            $sql .= 'FROM '.PFX.'bullMentions ';
            $sql .= 'WHERE anscol = :anScol ';
            if ($listeMentions != Null)
                $sql .= 'AND REPLACE(mention,"+","") IN ('.$listeMentionsString.') ';
            $sql .= 'AND periode = :periode ';
            $sql .= 'AND matricule IN ('.$listeElevesString.') ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
            $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

            $liste = array();
            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()){
                    $matricule = $ligne['matricule'];
                    array_push($liste, $matricule);
                }
            }

            Application::deconnexionPDO($connexion);

            return $liste;
        }
}
