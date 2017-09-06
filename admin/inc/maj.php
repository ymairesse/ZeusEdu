<?php

// $table est le nom du fichier éventuellement uploadé
$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;

if (!(isset($table)) || $table == Null) die("missing table");

switch ($mode) {
	case 'Confirmer':
		// suppression effective et définitive
		$resultat = $Application->suppressionAnciens($_POST, $table);
		$smarty->assign('message', array(
				'title'=>'Suppression des anciens élèves',
				'texte'=>sprintf("Nombre d'élèves concernés: %d<br>Nombre de tables traitées: %d<br>Nombre total d'effacements %d",
								 $resultat['nbEleves'], $resultat['nbTables'], $resultat['nbSuppr']
								 ),
				'urgence'=>'danger'
			));
		break;

	case 'Envoyer':  // visualisation du fichier CSV envoyé et demande de confirmation

		// liste des champs attendus (le minimum pour pouvoir contrôler les suppressions)
		$nomsChamps = array(0=>'matricule', 1=>'nom', 2=>'prenom', 3=>'classe');
		$nomTemporaire = $_FILES['nomFichierCSV']['tmp_name'];   // $_FILES provenant du formulaire
		$rubriquesErreurs = array();

		if ($nomTemporaire == '')
			$rubriquesErreurs[] = 'no file';
			else {
			// vérification du type de fichier
			$fileType = $Application->checkFileType($nomTemporaire);
			// au minimum, 'text/plain'; on vérifiera UTF-8 plus loin
			$textPlainOK = (strpos($fileType,'text/plain')===0);

			// c'est bien un fichier "text"
			if ($textPlainOK) {
				if (!(move_uploaded_file($nomTemporaire, $table.".csv")))  die("upload failed");

				// mise en tableau du fichier CSV transmis
				$tableau = $Application->csv2array($table);
				// on en extrait la première ligne qui doit contenir les noms des champs
				$entete = current($tableau);

				// Il y a peut-être des différences entre les deux modèles
				$champsCherches = array_intersect($entete,$nomsChamps);
				$differences = $Application->hiatus($champsCherches, $nomsChamps);

				if ($differences == Null) {
					// les entêtes correspondent; c'est OK
					$smarty->assign('entete',$entete);

					$listeEleves = $Application->tableau2listeEleves($tableau);

					// le contenu du fichier sous forme d'array()
					$smarty->assign('tableau',$tableau);
					// le nom de la table dans la BD
					$smarty->assign('table',$table);

					// est-ce de l'utf-8 ?
					if ($fileType != 'text/plain; charset=utf-8') {
						// le fichier est OK mais pas UTF-8; pas forcément très grave
						$smarty->assign('fileType',$fileType);
						$rubriquesErreurs[]='utf8';
						}
					}
					// il y a des différences entre les champs fournis et les champs demandés
					else {
						$smarty->assign('champs', $nomsChamps);
						$smarty->assign('hiatus', $differences);
						$rubriquesErreurs[]='hiatus';
						}
				}
			else {
				// ce n'est pas un fichier "text" => échec de l'importation
				$smarty->assign('fileType',$fileType);
				$smarty->assign('champs', $nomsChamps);
				$rubriquesErreurs[]='fileType'; // c'est terminé :o(
				}
			}  // un $nomTemporaire existait

		// liste des tables affectées par la mise à jour (celles qui contiennent des champs nommmés 'matricule')
		$listeTables = $Application->listeTablesAvecChamp('matricule');
		$smarty->assign('listeTables', $listeTables);
		$smarty->assign('rubriquesErreurs',$rubriquesErreurs);
		$smarty->assign('action',$action);
		$smarty->assign('mode','Confirmer');
		$smarty->assign('corpsPage','supprAnciens');
		break;
	default:
		$champs = array(
				0=>array('Field'=>'matricule','Comment'=>'matricule de l\'élève'),
				1=>array('Field'=>'nom','Comment'=>'nom de l\'élève'),
				2=>array('Field'=>'prenom','Comment'=>'prénom de l\'élève'),
				3=>array('Field'=>'classe', 'Comment'=>'classe')
				);
		$smarty->assign('champs', $champs);
		$smarty->assign('table', $table);
		$smarty->assign('CSVfile','nomFichierCSV');
		$smarty->assign('action', $action);
		$smarty->assign('mode', 'Envoyer');
		$smarty->assign('corpsPage', 'formulaireImport');
		break;
		}
