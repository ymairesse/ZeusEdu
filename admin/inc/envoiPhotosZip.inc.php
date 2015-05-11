<?php
if ($etape == 'Envoyer') {
	$fichier = $_FILES['file']['tmp_name'];
	$type = $_FILES['file']['type'];

	if ($fichier  != '')
		$type = $Application->checkFileType($fichier);
	if (isset($type)) {
		// un fichier a été envoyé
		$taille = $_FILES['file']['size'];
		$filename = $_FILES['file']['name'];		

		$name = explode('.', $filename);
		$extension = strtolower($name[1]);
		$name = $name[0];

		switch ($type) {
			// c'est une image jpg
			case 'image/jpeg; charset=binary':
				if ($extension == 'jpg') {
					$matricule = $name;
					if ($Ecole->eleveExiste($matricule)) {
						if ($taille < MAXIMAGESIZE) {
							$target_file = "../photos/".strtolower($filename);
							// suppression d'une éventuelle ancienne version de la photo
							@unlink($target_file);

							if (move_uploaded_file($fichier, $target_file)) {
								$texteMessage = "Votre fichier a été envoyé";
								$urgence = 'success';
								}
								else {
									$texteMessage = "Un problème est survenu. Veuillez ré-essayer";
									$urgence = 'warning';
									}
							}
							else {
								$texteMessage = sprintf("Ce fichier est trop gros (%d octets) > %d",$taille, MAXIMAGESIZE);
								$urgence = 'danger';
								}
						}
						else { 
							$texteMessage = sprintf("L'élève <strong>%s</strong> n'est pas connu",$matricule);
							$urgence = 'danger';
							}
					}
					else {
						$texteMessage = sprintf("Votre fichier doit porter l'extension .jpg et non \"%f\"", $extension);
						$urgence = 'danger';
						}
				break;
			
			// c'est une des variantes de fichiers .zip
			case 'application/zip':	// continuer
			case 'application/x-zip-compressed': // continuer
			case 'multipart/x-zip': // continuer
			case 'application/zip; charset=binary': // continuer
			case 'application/x-compressed': 
				if ($taille < 4000000) {
					$target_file = "../photos/".$filename;
					if (move_uploaded_file($fichier, $target_file)) {
						$zip = new ZipArchive();
						$x = $zip->open($target_file);
						$listeImages = array();
						if ($x === true) {
							$numFiles = $zip->numFiles;
							$numJpg = 0;
							for($i = 0; $i < $numFiles; $i++) {
								$image = $zip->getNameIndex($i);
								$matr = explode('.', $image);
								$matr = $matr[0];
								if ($Ecole->eleveExiste($matr)) {
									$listeImages[] = $image;
									// suppression d'une éventuelle ancienne version de la photo
									@unlink('../photos/'.$image);
									$zip->extractTo('../photos/', array($image));
									$numJpg++;
									}
								}
							$zip->close();
							unlink($target_file); 
							$texteMessage = sprintf("Votre archive contenant <strong>%d</strong> fichier(s) dont <strong>%d</strong> photo(s) a été envoyé et a été dézippé",$numFiles, $numJpg);
							$urgence = 'success';
							}
						}
						else {
							$texteMessage = "Un problème est survenu. Veuillez ré-essayer";
							$urgence = 'danger';
							}
					}
					else {
						$texteMessage = "Votre fichier est trop volumineux (> 4000 Ko)";
						$urgence = 'danger';
						}
				break;
				
			default: 
				$texteMessage = "Vous tentez d'envoyer un fichier d'un type incorrect (seuls .jpg et .zip sont admis)";
				$urgence = 'danger';
			} // switch $type
		}  // if $type
		
	if (isset($listeImages) && ($listeImages != Null))
		$smarty->assign('listeImages', $listeImages);

	if (!(isset($texteMessage))) {
		$texteMessage = "Aucun fichier de type admis n'a été soumis";
		$urgence = 'danger';
		}

	$smarty->assign('message', array(
					'title'=> 'Envoi de photos',
					'texte'=> $texteMessage,
					'urgence'=>$urgence
					));

	if (isset($matricule) && ($matricule != Null)) {
		$smarty->assign('matricule', $matricule);
		$smarty->assign('nomPrenomClasse', $Ecole->nomPrenomClasse($matricule));
		}

	$numFiles = isset($numFiles)?$numFiles:Null;
	$smarty->assign('numFiles', $numFiles);
	$numJpg = isset($numJpg)?$numJpg:Null;
	$smarty->assign('numJpg', $numJpg);
	$filename = isset($filename)?$filename:Null;
	$smarty->assign('filename',$filename);

	}  // if $etape

$smarty->assign ('corpsPage','formulaireZip');
?>
