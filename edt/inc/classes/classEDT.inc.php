<?php

/**
 * class Edt
 */

class Edt {

	public function listeImages($dir) {
		if (is_dir($dir)){
		  if ($dh = opendir($dir)){
			while (($file = readdir($dh)) !== false){
				$extension = explode('.', $file)[1];
				if ($extension == 'png')
					$listeImages[] = $file;
			}
			closedir($dh);
		  }
		  return $listeImages;
		}
	}

	public function stripAccents($str) {
    	return strtr(
			utf8_decode($str),
			utf8_decode('àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ'),
			'aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY'
		);
	}

	/**
	 * Entrée des noms d'élèves simplifiés dans la table EDTeleves
	 *
	 * @param void
	 *
	 * @return array : liste des noms simplifiés
	 */
	public function simplifieNom(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT matricule, nom, prenom ';
		$sql .= 'FROM '.PFX.'eleves ';
		$sql .= 'WHERE section != "PARTI" ';
		$requete = $connexion->prepare($sql);

		$liste = array();
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$matricule = $ligne['matricule'];
				$np = substr(strtolower($this->stripAccents(sprintf('%s %s', $ligne['nom'], $ligne['prenom']))), 0, 25);
				$np = str_replace(' ', '_', $np);
				$np = str_replace('-', '', $np);
				$np = str_replace('\'', '', $np);
				$liste[$matricule] = $np;
			}
		}

		$sql = 'INSERT IGNORE INTO '.PFX.'EDTeleves ';
		$sql .= 'SET matricule = :matricule , nomSimple = :nomSimple ';
		$requete = $connexion->prepare($sql);

		$resultat = 0;
		foreach ($liste AS $matricule => $nomSimple){
			$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
			$requete->bindParam(':nomSimple', $nomSimple, PDO::PARAM_STR, 30);
			$resultat += $requete->execute();
		}

		Application::DeconnexionPDO($connexion);

		return $liste;
	}

	/**
	 * Enregistre les correspondances matricule, nomSimplifié, image EDT
	 *
	 * @param array $listeImagesSimples : array('matricule' => , 'nomSimple' => , 'image' => )
	 *
	 * @return int nombre d'enregistrements
	 */
	public function saveImagesSimples($listeImagesSimples) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'INSERT INTO '.PFX.'EDTeleves ';
		$sql .= 'SET matricule = :matricule, nomSimple = :nomSimple, nomImage = :nomImage ';
		$sql .= 'ON DUPLICATE KEY UPDATE nomSimple = :nomSimple, nomImage = :nomImage ';
		$requete = $connexion->prepare($sql);

		$resultat = 0;
		foreach ($listeImagesSimples as $matricule => $data){
			$nomSimple = $data['nomSimple'];
			$nomImage = $data['image'];

			$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
			$requete->bindParam(':nomSimple', $nomSimple, PDO::PARAM_STR, 30);
			$requete->bindParam(':nomImage', $nomImage, PDO::PARAM_STR, 70);

			$resultat += $requete->execute();
		}

		Application::DeconnexionPDO($connexion);

		return $resultat;
	}

	/**
	 * retourne l'image de l'EDT de l'élève dont on fournit le matricule
	 *
	 * @param int $metricule
	 *
	 * @return string|Null
	 */
	public function getEdtEleve($matricule){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT nomImage FROM '.PFX.'EDTeleves ';
		$sql .= 'WHERE matricule = :matricule ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
		$resultat = $requete->execute();
		$nomImage = 'No image';
		if ($resultat) {
			$ligne = $requete->fetch();
			$nomImage = $ligne['nomImage'];
		}

		Application::DeconnexionPDO($connexion);

		return $nomImage;
	}

    /**
     * retourne l'image en base64 de l'horaire de l'élève $matricule depuis le répertoire $directory
     *
     * @param string $directory : le répertoire où se trouve l'image
     * @param int $matricule
     *
     * @return string
     */
    public function getHoraire($directory, $matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nomImage, nomSimple ';
        $sql .= 'FROM '.PFX.'EDTeleves ';
        $sql .= 'WHERE matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $src = '';
        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
            $image = $directory.'/'.$ligne['nomImage'];
            $imageData = base64_encode(file_get_contents($image));
            $src = 'data: '.mime_content_type($image).';base64,'.$imageData;
            }

        Application::deconnexionPDO($connexion);

        return $src;
    }

	/**
	 * enregistrement des événements du fichier iCal exporté de EDT
	 *
	 * @param string $acronyme : du prof dont on examine le calendrier iCal
	 * @param array $profEvents
	 *
	 * @return int : nombre d'enregistrements  dans la BD
	 */
	public function saveProfEvents($acronyme, $profEvents, $listePeriodes){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'INSERT INTO '.PFX.'EDTprofsICal ';
		$sql .= 'SET acronyme = :acronyme, ';
		$sql .= 'jour = :jour, startTime = :startTime, endTime = :endTime, local = :local, ';
		$sql .= 'matiere = :matiere, profs = :profs, classes = :classes, parties = :parties, exportDate = :exportDate ';
		$sql .= 'ON DUPLICATE KEY UPDATE ';
		$sql .= 'jour = :jour, startTime = :startTime, endTime = :endTime, local = :local, ';
		$sql .= 'matiere = :matiere, profs = :profs, classes = :classes, parties = :parties, exportDate = :exportDate ';
		$requete = $connexion->prepare($sql);

		$dash = '-'; $col = ':';
		$nb = 0;

		// on ne retient que la colonne "début" de la liste des périodes
		$listeDebutsCours = array_column($listePeriodes, 'debut');
		// on ne retient que la colonne "end" de la liste des périodes
		$listeFinsCours = array_column($listePeriodes, 'fin');

		// (SUBSTR($DTSTART[1], 0, 2)+1) : +1 pour corriger la timezone de EDT
		foreach ($profEvents AS $id => $event) {
			// $profEvents = liste des cours donnés par un prof durant sa semaine
			// certains cours sont formés par plusieurs périodes qu'il faudra séparer
			// un $event est une série de 1 à n périodes consécutives
			$DTSTART = explode('T', $event['DTSTART']);
			$startDate = SUBSTR($DTSTART[0], 0, 4).$dash.SUBSTR($DTSTART[0], 4, 2).$dash.SUBSTR($DTSTART[0],6, 2);
			$startTime = (SUBSTR($DTSTART[1], 0, 2)).$col.SUBSTR($DTSTART[1], 2, 2).$col.SUBSTR($DTSTART[1], 4, 2);
			// correction pour la timeZone de EDT + 1 heure
			$timestamp = strtotime($startTime) + 60*60;
			$startTime = date('H:i', $timestamp);
			$start = sprintf('%s %s', $startDate, $startTime);

			$DTEND = explode('T', $event['DTEND']);
			$endDate = SUBSTR($DTEND[0], 0, 4).$dash.SUBSTR($DTEND[0], 4, 2).$dash.SUBSTR($DTEND[0],6, 2);
			$endTime = (SUBSTR($DTEND[1], 0, 2)).$col.SUBSTR($DTEND[1], 2, 2).$col.SUBSTR($DTEND[1], 4, 2);
			// correction pour la timeZone de EDT + 1 heure
			$timestamp = strtotime($endTime) + 60*60;
			$endTime = date('H:i', $timestamp);
			$end = sprintf('%s %s', $endDate, $endTime);

			// le jour de la semaine
			$dayofweek = date('w', strtotime($start));
			// l'heure en heures et minutes du début de la séance
			// (éventuellement plusieurs périodes)
			$heure = SUBSTR($startTime, 0, 5);

			$DTSTAMP = explode('T', $event['DTSTAMP']);
			$creationDate = SUBSTR($DTSTAMP[0], 0, 4).$dash.SUBSTR($DTSTAMP[0], 4, 2).$dash.SUBSTR($DTSTAMP[0],6, 2);
			$creationTime = (SUBSTR($DTSTAMP[1], 0, 2)+1).$col.SUBSTR($DTSTAMP[1], 2, 2).$col.SUBSTR($DTSTAMP[1], 4, 2);
			$exportDate = $creationDate.' '.$creationTime;

			$matiere = isset($event['SUMMARY;LANGUAGE=fr']) ? trim($event['SUMMARY;LANGUAGE=fr']) : Null;
			// limiter la longueur pour le champ dans la BD + suppression des ""\"
			$matiere = str_replace('\\', '', SUBSTR($matiere, 0, 60));
			$local = isset($event['LOCATION;LANGUAGE=fr']) ? trim($event['LOCATION;LANGUAGE=fr']): Null;

			// les champs de la description
			$description = array_filter(explode('\\n', $event['DESCRIPTION;LANGUAGE=fr']));
			$descr = Null;
			foreach ($description as $n => $data){
				$data = explode(' : ', $data);
				$field = trim($data[0]);
				$descr[$field] = trim($data[1]);
			}

			// les autres profs impliqués dans ce cours
			$profs = isset($descr['Professeurs']) ? array_map('trim', explode('\,', $descr['Professeurs'])) : Null;
			// une ou plusieurs classes
			$classe = isset($descr['Classe']) ? $descr['Classe'] : Null;
			$classes = isset($descr['Classes']) ? array_map('trim', explode('\,', $descr['Classes'])) : Null;

			// une ou plusieurs parties de classe?
			$partie = isset($descr['Partie de classe']) ? $descr['Partie de classe'] : Null;
			$parties = isset($descr['Parties de classe']) ? array_map('trim', explode('\,', $descr['Parties de classe'])) : Null;

			// recombinaisons des parties, des classes et des profs
			$parties = ($parties != Null) ? array_push($parties, $partie) : Null;
			$classe = ($classes != Null) ? array_push($classes, $classe) : Null;

			// retour éventuel en string
			if (is_array($parties))
				$parties = implode(', ', $parties);
			if (is_array($classes))
				$classes = implode(', ', $classes);
			if (is_array($profs))
				$profs = implode(', ', $profs);
			// limiter la longueur pour le champ dans la BD
			$parties = SUBSTR($parties, 0, 60);
			$classes = SUBSTR($classes, 0, 60);
			$profs = SUBSTR($profs, 0, 60);
			$local = SUBSTR($local, 0, 60);

			// $requete->bindParam(':id', $id, PDO::PARAM_INT);
			$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
			$requete->bindParam(':jour', $dayofweek,  PDO::PARAM_INT);
			$requete->bindParam(':local', $local, PDO::PARAM_STR, 10);
			$requete->bindParam(':matiere', $matiere, PDO::PARAM_STR, 30);
			$requete->bindParam(':profs', $profs, PDO::PARAM_STR, 60);
			$requete->bindParam(':classes', $classes, PDO::PARAM_STR, 60);
			$requete->bindParam(':parties', $parties, PDO::PARAM_STR, 60);
			$requete->bindParam(':exportDate', $exportDate, PDO::PARAM_STR, 20);

			// traitement des cours sur plusieurs périodes ********************
			// recherche du numéro de la période de cours dans la liste des périodes existantes
			$noPeriode = array_search($heure, $listeDebutsCours);
			// heure de fin de la séance de cours (éventuellement plusieurs périodes)
			$endPeriode = SUBSTR($endTime, 0, 5);

			while ($noPeriode != -1){
				// recherche du début de la période dans la liste des périodes
				$heureDebut = $listeDebutsCours[$noPeriode];
				$heureFin = $listeFinsCours[$noPeriode];

				$startTime =  sprintf('%s:00', $heureDebut);
				$endTime = sprintf('%s:00', $heureFin);

				$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 8);
				$requete->bindParam(':endTime', $endTime, PDO::PARAM_STR, 8);

				$resultat = $requete->execute();

				// encore une période pour ce cours?
				$noPeriode = ($endPeriode != $heureFin) ? $noPeriode + 1 : -1;

				$nb += $requete->rowCount();
			}
		}
// echo "</table>";
		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * recherche l'acronyme du prof dont l'horaire est décrit dans le fichier .ics
	 * On le trouve dans la rubrique "DESCRIPTION" dans le champ "Professeur"
	 *
	 * @param array $profEvents
	 *
	 * @return string | null
	 */
	public function searchAcronyme($profEvents){
		$i = 1;
		$found = false; $acronyme = Null;
		$nb = count($profEvents);
		while (($i <= $nb) && !$found) {
			$event = $profEvents[$i];
			$description = array_filter(explode('\\n', $event['DESCRIPTION;LANGUAGE=fr']));
			$descr = Null;
			foreach ($description as $n => $data){
				$data = explode(' : ', $data);
				$field = trim($data[0]);
				$descr[$field] = trim($data[1]);
			}
			if (isset($descr['Professeur'])) {
				$acronyme = $descr['Professeur'];
				$found = true;
				}
				else $i++;
		}

		return $acronyme;
	}

	/**
     * convertit les tailles de fichiers en valeurs usuelles avec les unités.
     *
     * @param $bytes : la taille en bytes
     *
     * @return string : la taille en unités usuelles
     */
    public function unitFilesize($size)
    {
        $precision = ($size > 1024) ? 2 : 0;
        $units = array('octet(s)', 'Ko', 'Mo', 'Go', 'To', 'Po', 'Eo', 'Zo', 'Yo');
        $power = $size > 0 ? floor(log($size, 1024)) : 0;

        return number_format($size / pow(1024, $power), $precision, '.', ',').' '.$units[$power];
    }

	/**
	 * renvoie le contenu d'un répertoire de manière non-récursive
	 *
	 * @param string $dir : le répertoire, y compris le path
	 *
	 * @return array : liste des fichiers commençant par les répertoires
	 */
	public function flatDirectory($dir) {
		$results = scandir($dir);
		$listFiles = array('dir' => array(), 'file' => array());
		$ds = DIRECTORY_SEPARATOR;
		foreach ($results as $entry) {
			// éviter les répertoires "." et ".." ainsi que les répertoires de service (Ex: "#thot")
			if (!(in_array($entry, array('.', '..'))) && (substr($entry,0,1) != '#')){
				$type = is_dir($dir.$ds.$entry) ? 'dir' : 'file';
				$ext = pathinfo($dir.$ds.$entry, PATHINFO_EXTENSION);
				$listFiles[$type][] = array(
					'fileName' => $entry,
					'type' => $type,
					'size' => $this->unitFilesize(filesize($dir.$ds.$entry)),
					'dateTime' => strftime('%x %X', filemtime($dir.$ds.$entry)),
					'ext' => $ext,
				);
			}
		}

		return array_merge($listFiles['dir'], $listFiles['file']);
	}

	/**
	 * recherche le modèle d'événements EDT pour le prof $acronyme
	 *
	 * @param string $acronyme
	 *
	 * @return array
	 */
	public function getEvents4prof($acronyme, $dateLundi){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT id, ical.acronyme, jour, startTime, endTime, local, matiere, ';
		$sql .= 'profs, classes, parties, exportDate ';
		$sql .= 'FROM '.PFX.'EDTprofsICal as ical ';
		$sql .= 'JOIN '.PFX.'profs AS p ON p.acronyme = ical.acronyme ';
		$sql .= 'WHERE ical.acronyme = :acronyme ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$liste = array();
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()) {
				$acronyme = $ligne['acronyme'];
				$startTime = strtotime($ligne['startTime']);
				$startTime = date('H:i', $startTime);
				$endTime = strtotime($ligne['endTime']);
				$endTime = date('H:i', $endTime);
				// compenser le jour "lundi = 1" de EDT
				$jour = $ligne['jour']-1;
				$liste[] = array(
					'id' => $ligne['id'],
					'title' => sprintf('%s %s', $startTime, $endTime),
					'acronyme' => $ligne['acronyme'],
					'jour' => $ligne['jour'],
					'start' => date('Y-m-d', strtotime($dateLundi . '+' . $jour . 'day')).' '.$startTime,
					'end' => date('Y-m-d', strtotime($dateLundi . '+' . $jour . 'day')).' '.$endTime,
					'local' => $ligne['local'],
					'matiere' => $ligne['matiere'],
					'profs' => $ligne['profs'],
					'classes' => $ligne['classes'],
					'parties' => $ligne['parties'],
					'exportDate' => $ligne['exportDate'],
					'className' => 'bat_'.substr($ligne['local'], 0, 1),
				);
			}
		}

		Application::deconnexionPDO($connexion);

		return $liste;
	}

	/**
	 * enregistre une liste de dates d'absences depuis son horaire de cours iCal
	 * pour le prof $acronyme
	 *
	 * @param string $acronyme
	 * @param array $arrayDates : array de dates 'date' => 'YYYY-MM-DD', 'jour' => int(jour de la semaine)
	 *
	 * @return int nombre d'enregistrements
	 */
	public function transfertListeAbsences($acronyme, $arrayDates, $statutAbs) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// recherche du modèle de semaine du prof
		$sql = 'SELECT jour, startTime, endTime, local, matiere, profs, classes, parties, ';
		$sql .= 'sexe, nom, prenom ';
		$sql .= 'FROM '.PFX.'EDTprofsICal AS ical ';
		$sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = ical.acronyme ';
		$sql .= 'WHERE ical.acronyme = :acronyme AND jour = :jour ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		// établir la liste des périodes de cours pour la durée de l'absence
		$listeAbsences = array();
		foreach ($arrayDates AS $wtf => $uneDate) {

			$jour = $uneDate['jour'];
			$date = $uneDate['date'];
			$requete->bindParam(':jour', $jour, PDO::PARAM_INT);
			$resultat = $requete->execute();
			if ($resultat){
				$requete->setFetchMode(PDO::FETCH_ASSOC);
				while ($ligne = $requete->fetch()) {
					$ligne['startTime'] = sprintf('%s %s',$date, $ligne['startTime']);
					$ligne['endTime'] = sprintf('%s %s',$date, $ligne['endTime']);
					$listeAbsences[] = $ligne;
				}
			}
		}

		// enregistrement pour chacune des dates d'absence et pour chaque période de cours
		$sql = 'INSERT INTO '.PFX.'EDTprofsABS ';
		$sql .= 'SET acronyme = :acronyme, startTime = :startTime, endTime = :endTime, heure = :heure, date = :date, ';
		$sql .= 'statutAbs = :statutAbs, local = :local, matiere = :matiere, profs = :profs, classes = :classes, parties = :parties ';
		$sql .= 'ON DUPLICATE KEY UPDATE endTime = :endTime, local = :local, ';
		$sql .= 'matiere = :matiere, profs = :profs, classes = :classes, parties = :parties ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':statutAbs', $statutAbs, PDO::PARAM_STR, 12);

		$nb = 0;
		foreach ($listeAbsences as $wtf => $data){
			$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
			$startTime = $data['startTime'];
			$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
			// extraire l'heure de début du cours qui pourra être déplacée
			$heure = SUBSTR($startTime, 11, 5);
			$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
			// extraire la date du cours
			$date = SUBSTR($startTime, 0, 10);
			$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
			$endTime = $data['endTime'];
			$requete->bindParam(':endTime', $endTime, PDO::PARAM_STR, 20);
			$local = $data['local'];
			$requete->bindParam(':local', $local, PDO::PARAM_STR, 60);
			$matiere = $data['matiere'];
			$requete->bindParam(':matiere', $matiere, PDO::PARAM_STR, 60);
			$profs = $data['profs'];
			$requete->bindParam(':profs', $profs, PDO::PARAM_STR, 60);
			$classes = $data['classes'];
			$requete->bindParam(':classes', $classes, PDO::PARAM_STR, 50);
			$parties = $data['parties'];
			$requete->bindParam(':parties', $parties, PDO::PARAM_STR, 2);

			$resultat = $requete->execute();

			$nb += $requete->rowCount();
		}

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * retourne l'ensemble des informations d'absences pour la date $laDate donnée
	 *
	 * @param string $laDate
	 *
	 * @return array
	 */
	 public function getAbsences4date($laDate){
 		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
 		$sql = 'SELECT abs.acronyme, startTime, endTime, heure, date, statutAbs, ';
 		$sql .= 'local, matiere, profs, classes, parties, eduProf, remarque, ';
 		$sql .= 'sexe, nom, prenom ';
 		$sql .= 'FROM '.PFX.'EDTprofsABS AS abs ';
 		$sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = abs.acronyme ';
 		$sql .= 'WHERE startTime LIKE :laDate ';
 		$sql .= 'ORDER BY REPLACE("\'", "", REPLACE("-","", REPLACE(" ","",nom))), prenom, startTime ';
 		$requete = $connexion->prepare($sql);

 		$laDate = $laDate.'%';
 		$requete->bindParam(':laDate', $laDate, PDO::PARAM_STR, 20);

 		$liste = array();
 		$resultat = $requete->execute();
 		if ($resultat) {
 			$requete->setFetchMode(PDO::FETCH_ASSOC);
 			while ($ligne = $requete->fetch()){
 				$acronyme = $ligne['acronyme'];
 				$heure = $ligne['heure'];
 				// éclatement du champ "matière"
 				$matiere = explode('-', $ligne['matiere']);
 				$ligne['classe'] = isset($matiere[1]) ? $matiere[1] : '';
 				$matiere = explode(' ', $matiere[0]);
 				$ligne['branche'] = $matiere[0];
 				$ligne['brancheFR'] = $matiere[1];
 				$ligne['dateFR'] = Application::datePHP($ligne['date']);

 				$liste[$acronyme][$heure] = $ligne;
 			}
 		}

 		Application::deconnexionPDO($connexion);

 		return $liste;
 	}

	/**
	 * recherche les informations relatives à l'absence du prof $acronyme
	 * à la date et à l'heure données
	 *
	 * @param string $acronyme
	 * @param string $date
	 * @param string $heure
	 *
	 * @return array
	 */
	public function getAbsence4periode($acronyme, $date, $heure){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT abs.acronyme, startTime, heure, statutAbs, date, local, matiere, profs, classes, parties, ';
		$sql .= 'eduProf, remarque, sexe, nom, prenom ';
		$sql .= 'FROM '.PFX.'EDTprofsABS AS abs ';
		$sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = abs.acronyme ';
		$sql .= 'WHERE abs.acronyme = :acronyme AND date = :date AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$ligne = Null;
		$resultat = $requete->execute();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $requete->fetch();
		}

		Application::deconnexionPDO($connexion);

		return $ligne;
	}

	/**
	 * recherche les absences du prof $acronyme entre les dates $start et $end
	 *
	 * @param string $start : date de début d'Absences
	 * @param string $end : date de fin d'absences
	 * @param string $acronyme : abréviation de l'enseignant
	 *
	 * @return array
	 */
	public function getAbsences4prof($start, $end, $acronyme){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT DISTINCT startTime, acronyme, heure, matiere ';
		$sql .= 'FROM '.PFX.'EDTprofsABS WHERE acronyme = :acronyme ';
		$sql .= 'AND startTime BETWEEN :start AND :end ';
		$sql .= 'ORDER BY startTime ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':start', $start, PDO::PARAM_STR, 10);
		$requete->bindParam(':end', $end, PDO::PARAM_STR, 10);

		$liste = array();
		$resultat = $requete->execute();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$start = $ligne['startTime'];
				$heure = $ligne['heure'];
				$matiere = explode('-', $ligne['matiere']);
				$classe = isset($matiere[1]) ? $matiere[1] : '';
				$liste[] = array(
					'title' => sprintf('%s %s', $heure, $classe),
					'start' => $start
					);
			}
		}

		Application::deconnexionPDO($connexion);

		return $liste;
	}

	/**
	 * ajout ou modification d'une absence pour une période/jour donné pour un acronyme
	 *
	 * @param array $record: enregistrement à effectuer
	 *
	 * @return int
	 */
	public function setAbsence4periode($record){
		$acronyme = $record['acronyme'];
		$startTime = $record['startTime'];
		$heure = $record['heure'];
		$date = $record['date'];
		$local = $record['local'];
		$matiere = $record['matiere'];
		$profs = $record['profs'];
		$classes = $record['classes'];
		$parties = $record['parties'];
		$eduProf = $record['eduProf'];
		$remarque = $record['remarque'];

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'INSERT INTO '.PFX.'EDTprofsABS ';
		$sql .= 'SET acronyme = :acronyme, startTime = :startTime, heure = :heure, date = :date, local = :local, matiere = :matiere, ';
		$sql .= 'profs = :profs, classes = :classes, parties = :parties, eduProf = :eduProf, remarque = :remarque ';
		$sql .= 'ON DUPLICATE KEY UPDATE ';
		$sql .= 'local = :local, eduProf = :eduProf, remarque = :remarque ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':local', $local, PDO::PARAM_STR, 60);
		$requete->bindParam(':matiere', $matiere, PDO::PARAM_STR, 60);
		$requete->bindParam(':profs', $profs, PDO::PARAM_STR, 60);
		$requete->bindParam(':classes', $classes, PDO::PARAM_STR, 60);
		$requete->bindParam(':parties', $parties, PDO::PARAM_STR, 60);
		$requete->bindParam(':eduProf', $eduProf, PDO::PARAM_STR, 7);
		$requete->bindParam(':remarque', $remarque, PDO::PARAM_STR, 80);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * recherche les statuts pour une période d'absence donnée pour un $acronyme donné
	 *
	 * @param string $acronyme
	 * @param string $date (format SQL)
	 * @param string $heure
	 *
	 * @return array
	 */
	public function getStatuts4periode($acronyme, $date, $heure){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT statut, date, heure, startTime ';
		$sql .= 'FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE acronyme = :acronyme AND date = :date AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$listeStatuts = array();
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$heure = $ligne['heure'];
				$listeStatuts[] = $ligne['statut'];
			}
		}

		Application::deconnexionPDO($connexion);

		return $listeStatuts;
	}

	/**
	 * enregistrement des modifications des détails d'une absence
	 *
	 * @param string $abreviation : acronyme du prof absent
	 * @param string $dateSQL : date de l'absence
	 * @param string $heure : heure du cours
	 * @param string $eduprof : educ/prof remplaçant
	 *
	 * @return int
	 */
	public function saveDataPeriodeAbs($acronyme, $dateSQL, $heure, $remarque, $eduprof, $statutAbs){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'UPDATE '.PFX.'EDTprofsABS ';
		$sql .= 'SET remarque = :remarque, eduprof = :eduprof, statutAbs = :statutAbs ';
		$sql .= 'WHERE acronyme = :acronyme AND date = :dateSQL AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':dateSQL', $dateSQL, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':remarque', $remarque, PDO::PARAM_STR, 80);
		$requete->bindParam(':eduprof', $eduprof, PDO::PARAM_STR, 7);
		$requete->bindParam(':statutAbs', $statutAbs, PDO::PARAM_STR, 12);

		$resultat = $requete->execute();
		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * modification des statuts d'une période d'absence $startTime pour le prof $acronyme
	 *
	 * @param string $acronyme
	 * @param string $dateSQL
	 * @param string $heure
	 * @param string $startTime (startTime conservé avec le déplacement)
	 * @param array statuts : liste des statuts pour cette période
	 *
	 * @return int
	 */
	public function setStatuts4periode4prof($acronyme, $dateSQL, $heure, $startTime, $listeStatuts){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// suppression de tous les statuts existants
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE acronyme = :acronyme AND  date = :dateSQL AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':dateSQL', $dateSQL, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		// enregistrement des nouveaux statuts
		$sql = 'INSERT INTO '.PFX.'EDTprofsStatut ';
		$sql .= 'SET acronyme = :acronyme, date = :dateSQL, heure = :heure, statut = :statut, startTime = :startTime ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':dateSQL', $dateSQL, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);

		$nb = 0;
		foreach ($listeStatuts AS $statut){
			$requete->bindParam(':statut', $statut, PDO::PARAM_STR, 10);
			$resultat = $requete->execute();
			$nb += $requete->rowCount();
		}

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * Ajout éventuel d'un statut pour une absence à la date $startTime du prof $acronyme
	 *
	 * @param string $acronyme
	 * @param string $startTime
	 * @param string $statut
	 *
	 * @return int
	 */
	public function addStatut4periodeProf($acronyme, $startTime, $heure, $statut){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'INSERT IGNORE INTO '.PFX.'EDTprofsStatut ';
		$sql .= 'SET acronyme = :acronyme, statut = :statut, startTime = :startTime, date = :date, heure = :heure ';
		$requete = $connexion->prepare($sql);

		$date = SUBSTR($startTime,0, 10);

		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':statut', $statut, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$resultat = $requete->execute();
		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * Suppression d'une absence qui n'a pas subi un déplacement.
	 *
	 * @param string $acronyme
	 * @param string $date
	 * @param  string $heure
	 *
	 * @return int
	 */
	public function delAbsenceOrdinaire($acronyme, $date, $heure){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// suppression des statuts pour la période $date, $heure et $acronyme
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE date = :date AND heure = :heure AND acronyme = :acronyme ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		// suppression de l'absence pour la période $date, $heure et $acronyme
		$sql = 'DELETE FROM '.PFX.'EDTprofsABS ';
		$sql .= 'WHERE date = :date AND heure = :heure AND acronyme = :acronyme ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		Application::deconnexionPDO($connexion);

		return $resultat;
	}

	/**
	 * Suppression d'une absence en se basant sur la vraie heure de cours
	 * et la vraie date de la période de cours (utile pour les périodes déplacées)
	 *
	 * @param string $acronyme
	 * @param string $date
	 * @param  string $heure
	 * @param string $startTime : commun à l'absence originale et à la "déplacée"
	 *
	 * @return int
	 */
	public function delAbsenceDeplacee($acronyme, $date, $heure, $startTime){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// suppression de l'absence pour la période déplacée ($date et $heure réels)
		$sql = 'DELETE FROM '.PFX.'EDTprofsABS ';
		$sql .= 'WHERE acronyme = :acronyme AND date = :date AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		// rétablissement du statut de la période originale ('movedFrom')
		// pour la rendre à nouveau déplaçable
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE startTime = :startTime AND acronyme = :acronyme AND statut = "movedFrom" ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		// effacement des statuts pour cette date et heure
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE acronyme = :acronyme AND date = :date AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * suppression d'une absence originale avec acquisition du statut "ordinaire"
	 * pour la période déplacée correspondante
	 *
	 * @param string $acronyme
	 * @param string $date
	 * @param string $heure
	 * @param string $startTime
	 *
	 * @return int
	 */
	public function delAbsenceOriginale($acronyme, $date, $heure, $startTime){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// suppression du statut 'movedFrom' à la période déplacée (elles partagent le même startTime)
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE statut IN ("movedFrom","movedTo") AND acronyme = :acronyme AND startTime = :startTime ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		// suppression de la période d'absence originale
		$sql = 'DELETE FROM '.PFX.'EDTprofsABS ';
		$sql .= 'WHERE acronyme = :acronyme AND date = :date AND heure = :heure ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$n = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $n;
	}


	/**
	 * suppression d'une absence pour une heure de cours $startTime pour le prof $acronyme
	 *
	 * @param string $acronyme
	 * @param string startTime
	 *
	 * @return int
	 */
	public function delAbsenceTotale($acronyme, $startTime){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// suppression de l'absence originale et de l'absence déplacée
		$sql = 'DELETE FROM '.PFX.'EDTprofsABS ';
		$sql .= 'WHERE acronyme = :acronyme AND startTime = :startTime ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		// effacement des statuts de l'absence originale et de l'absence déplacée
		$sql = 'DELETE FROM '.PFX.'EDTprofsStatut ';
		$sql .= 'WHERE acronyme = :acronyme AND startTime = :startTime ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
	 * suppression de toutes les absences du prof $acronyme à partir de la date $dateFrom
	 *
	 * @param string $acronyme
	 * @param string $dateFrom
	 *
	 * @return int
	 */
	public function delAbsencesFutures($acronyme, $dateFrom){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'DELETE FROM '.PFX.'EDTprofsABS ';
		$sql .= 'WHERE acronyme = :acronyme AND startTime >= :dateFrom ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 20);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
	}

	/**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void
     *
     * @return array liste des périodes de cours
     */
    public function getPeriodesCours($start=true, $end=true) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin ';

        $resultat = $connexion->query($sql);
        $listePeriodes = array();
        $periode = 1;
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $debut = $ligne['debut'];
                $fin = $ligne['fin'];
				if ($start == true){
					$listePeriodes[$periode]['debut'] = $debut;
					}
				if ($end == true) {
					$listePeriodes[$periode]['fin'] = $fin;
				}
				$periode++;
			}
        }
        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

	/**
	 * vider la table didac_EDTprofsICal pour une prochaine importation
	 *
	 * @param
	 *
	 * @return
	 */
	public function iCalTruncate(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'TRUNCATE didac_EDTprofsICal ';
		$requete = $connexion->prepare($sql);

		$resultat = $requete->execute();

		Application::deconnexionPDO($connexion);
	}

	/**
	 * vider la table didac_EDTeleves pour une prochaine compilation
	 *
	 * @param
	 *
	 * @return
	 */
	public function EDTelevesTruncate(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'TRUNCATE didac_EDTeleves ';
		$requete = $connexion->prepare($sql);

		$resultat = $requete->execute();

		Application::deconnexionPDO($connexion);
	}

	/**
	 * enregistrer une information pour une date donnée
	 *
	 * @param string $type : 'info' ou 'retard'
	 * @param string $info
	 * @param string $dateSQL
	 * @param string $proprio
	 *
	 * @return int
	 */
	public function saveInfo($type, $acronyme, $info, $dateSQL, $proprio, $idEDTinfo = Null){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($idEDTinfo == Null) {
			$sql = 'INSERT INTO '.PFX.'EDTinfos ';
			$sql .= 'SET acronyme = :acronyme, type = :type, info = :info, date = :dateSQL, proprio = :proprio ';
			}
			else {
				$sql = 'UPDATE '.PFX.'EDTinfos ';
				$sql .= 'SET acronyme = :acronyme, info = :info, date = :dateSQL, proprio = :proprio ';
				$sql .= 'WHERE idEDTinfo = :idEDTinfo AND type = :type ';
			}
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':type', $type, PDO::PARAM_STR, 6);
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
		$requete->bindParam(':info', $info, PDO::PARAM_STR, 40);
		$requete->bindParam(':proprio', $proprio, PDO::PARAM_STR, 7);
		$requete->bindParam(':dateSQL', $dateSQL, PDO::PARAM_STR, 10);
		if ($idEDTinfo != Null) {
			$requete->bindParam(':idEDTinfo', $idEDTinfo, PDO::PARAM_INT);
			}

		$resultat = $requete->execute();
		$n = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $n;
		}

	/**
	 * supprimer l'info complémentaire dont l'identifiant est '$id'
	 *
	 * @param int $id
	 *
	 * @return int
	 */
	public function delInfo ($idEDTinfo, $proprio){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'DELETE FROM '.PFX.'EDTinfos ';
		$sql .= 'WHERE idEDTinfo = :idEDTinfo AND proprio = :proprio ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':idEDTinfo', $idEDTinfo, PDO::PARAM_INT);
		$requete->bindParam(':proprio', $proprio, PDO::PARAM_STR, 7);

		$resultat = $requete->execute();
		$n = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $n;
	}

	/**
	 * recherche des infos complémentaires pour la date donnée
	 *
	 * @param string $dateSQL
	 *
	 * @return array
	 */
	public function getInfos4date($type, $dateSQL){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT type, acronyme, info, proprio, idEDTinfo ';
		$sql .= 'FROM '.PFX.'EDTinfos ';
		$sql .= 'WHERE date = :dateSQL AND type = :type ';
		$sql .= 'ORDER BY idEDTinfo ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':dateSQL', $dateSQL, PDO::PARAM_STR, 10);
		$requete->bindParam(':type', $type, PDO::PARAM_STR, 6);

		$resultat = $requete->execute();
		$liste = array();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$idEDTinfo = $ligne['idEDTinfo'];
				$liste[$idEDTinfo] = $ligne;
			}
		}

		Application::deconnexionPDO($connexion);

		return $liste;
	}

	/**
	 * recherche l'info dont on fournit l'id
	 *
	 * @param int $id
	 *
	 * @return array
	 */
	public function getInfo($id){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT type, proprio, idEDTinfo, date, acronyme, info ';
		$sql .= 'FROM '.PFX.'EDTinfos ';
		$sql .= 'WHERE idEDTinfo = :id ';
		$requete = $connexion->prepare($sql);
/*echo $sql;*/
		$requete->bindParam(':id', $id, PDO::PARAM_INT);
/*die($id);*/
		$info = Null;
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			$info = $requete->fetch();
		}

		Application::deconnexionPDO($connexion);

		return $info;
	}

	/**
	 * recherche la liste des éducs en charge pour une date donnée
	 *
	 * @param string $date (au format SQL)
	 *
	 * @return array
	 */
	public function getEducs4date($dateSQL){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT date, periode, educs.acronyme, nom, prenom ';
		$sql .= 'FROM '.PFX.'EDTeducs AS educs ';
		$sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = educs.acronyme ';
		$sql .= 'WHERE date = :date ';
		$sql .= 'ORDER BY periode ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':date', $dateSQL, PDO::PARAM_STR, 10);

		$liste = array();
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$periode = $ligne['periode'];
				$liste[$periode] = $ligne;
			}
		}

		Application::deconnexionPDO($connexion);

		return $liste;
	}

	/**
	 * enregistre l'affectation des éducs depuis la liste par période de cours donnée
	 * entre les dates $start et $end (au format SQL)
	 *
	 * @param array $listeEducs : liste d'affectation par période de cours
	 * @param string $start
	 * @param string $end
	 *
	 * @return int
	 */
	public function saveEducs($listeEducs, $startSQL, $endSQL){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'INSERT INTO '.PFX.'EDTeducs ';
		$sql .= 'SET date = :date, periode = :periode, acronyme = :acronyme ';
		$sql .= 'ON DUPLICATE KEY update acronyme = :acronyme ';
		$requete = $connexion->prepare($sql);

		$startSQL = new DateTime($startSQL);
		$endSQL = new DateTime($endSQL);
		$endSQL = $endSQL->modify( '+1 day' );

		$listeDates = new DatePeriod(
		     $startSQL,
		     new DateInterval('P1D'),
		     $endSQL
			);

		$n = 0;
		foreach ($listeDates as $wtf => $value) {
			$uneDate = $value->format('Y-m-d');
			// détermination du jour de la semaine
			$date = new DateTime($uneDate);
			$timestamp = $date->getTimestamp();
			$dw = date( "w", $timestamp);
			// ne pas enregistrer les samedis et dimanches
			if (($dw != 0) && ($dw != 6)) {
				$requete->bindParam(':date', $uneDate, PDO::PARAM_STR, 10);
				foreach ($listeEducs as $periode => $acronyme){
					$requete->bindParam(':periode', $periode, PDO::PARAM_INT);
					$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR);
					$resultat = $requete->execute();
					$n += $requete->rowCount();
				}
			}
		}

		Application::deconnexionPDO($connexion);

		return $n;
	}

	/**
     * retourne le nom complet du prof dont on fournit l'abréviation.
     *
     * @param string $acronyme
     *
     * @return string : le nom du prof ou une chaîne vide si abréviation pas trouvée
     */
    public function abr2name($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom, prenom, sexe ';
        $sql .= 'FROM '.PFX.'profs ';
        $sql .= 'WHERE acronyme LIKE :acronyme ';
        $requete = $connexion->prepare($sql);

        $nomPrenom = $acronyme;
        $acronyme = '%'.$acronyme.'%';
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 9);
        $resultat = $requete->execute();

		$laListe = array();
        if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
	            if ($ligne != ''){
					$nomPrenom = sprintf('%s %s', $ligne['prenom'], $ligne['nom']);
					$laListe[] = $nomPrenom;
					}
        		}
			}
        Application::DeconnexionPDO($connexion);

		// renvoyer éventuellement le dernier $nomPrenom vu dans la boucle
		return (count($laListe) == 1) ? $nomPrenom : '???';
    }

	/**
	 * renvoie, si possible, l'acronyme complet correspondant à une amorce
	 *
	 * @param string $amorce
	 *
	 * @return string
	 */
	public function getFullAcronyme($amorce){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT acronyme ';
		$sql .= 'FROM '.PFX.'profs ';
		$sql .= 'WHERE acronyme LIKE :acronyme ';
		$requete = $connexion->prepare($sql);

		$amorce = '%'.$amorce.'%';

		$requete->bindParam(':acronyme', $amorce, PDO::PARAM_STR, 9);
        $resultat = $requete->execute();

		$liste = array();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$acronyme = $ligne['acronyme'];
				$liste[] = $acronyme;
			}
		}

		Application::deconnexionPDO($connexion);

		return (($liste != Null) && (count($liste) == 1)) ? $acronyme : Null;
	}

}
