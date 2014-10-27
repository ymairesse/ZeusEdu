<?php
// $table est le fichier éventuellement uploadé
$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;

switch ($mode) {
	case 'resetLocks':
		require_once(INSTALL_DIR."$module/inc/classes/classBulletin.inc.php");
		$Bulletin = new Bulletin();
		$nb = $Bulletin->renewAllLocks();
		$smarty->assign("message",
						array(
							'title'=>"Initialisation des verrous",
							'texte'=>sprintf("%d verrous initialisés (ouverts)",$nb)
						));
		break;
	default:
		if ($table == Null) die("missing table");
		switch ($table) {
		case 'anciens':
			switch ($mode) {
				case 'Confirmer':
					// suppression effective et définitive
					$resultat = $Application->suppressionAnciens($_POST, $table);
					$smarty->assign("message",
						array(
							'title'=>"Suppression des anciens élèves",
							'texte'=>sprintf("Nombre d'élèves concernés: %d<br>Nombre de tables traitées: %d<br>Nombre total d'effacements %d",
											 $resultat['nbEleves'], $resultat['nbTables'], $resultat['nbSuppr']
											 )
						));
					break;

				case 'Envoyer':  // visualisation du fichier CSV envoyé et demande de confirmation
					$nomTemporaire = $_FILES['nomFichierCSV']['tmp_name'];   // $_FILES provenant du formulaire
					// vérification du type de fichier
					$fileType = $Application->checkFileType($nomTemporaire);
					// au minimum, 'text/plain'
					$textPlainOK = (strpos($fileType,'text/plain')===0);

					// liste des champs attendus (le minimum pour pouvoir contrôler les suppressions)
					$nomsChamps = array(0=>'matricule', 1=>'nom', 2=>'prenom', 3=>'classe');

					$rubriquesErreurs = array();
					if ($textPlainOK) { // c'est bien un fichier "text"
						if (!(move_uploaded_file($nomTemporaire, $table.".csv")))  die("upload failed");

						$tableau = $Application->csv2array($table);
						$listeEleves = $Application->tableau2listeEleves($tableau);
						// on ne retient que l'entête
						$entete = array_shift($tableau);
						$smarty->assign("tableau",$tableau);
						$smarty->assign("table",$table);

						// Il y a peut-être des différences entre les deux modèles
						$differences = $Application->hiatus($entete, $nomsChamps);
						if ($differences == Null) {
							// les entêtes correspondent; c'est OK
							$smarty->assign("entete",$entete);
							if ($fileType != 'text/plain; charset=utf-8') {
								// le fichier est OK mais pas UTF-8; pas forcément très grave
								$smarty->assign("fileType",$fileType);
								$rubriquesErreurs[]="utf8";
								}
							}
							else { // il y a des différences entre les champs fournis et les champs demandés
								$smarty->assign("champs", $nomsChamps);
								$smarty->assign("hiatus", $differences);
								$rubriquesErreurs[]="hiatus";
								}
						}
						else {
							// ce n'est pas un fichier "text" => échec de l'importation
							$smarty->assign("fileType",$fileType);
							$smarty->assign("champs", $champs);
							$rubriquesErreurs[]="pageFileType"; // c'est terminé :o(
							}
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
			break;
		default: die("wrong table name");
		}
	}

?>
