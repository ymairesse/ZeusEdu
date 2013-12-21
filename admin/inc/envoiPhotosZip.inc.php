<?php
if ($etape == 'Envoyer') {
	$filename = $_FILES['file']['name'];
	$type = $_FILES['file']['type'];
	if ($type) {
		// un fichier a été envoyé
		$source = $_FILES['file']['tmp_name'];
		$taille = $_FILES['file']['size'];

		$name = explode('.', $filename);
		$extension = strtolower($name[1]);
		$name = $name[0];

		switch ($type) {
			// c'est une image jpg
			case 'image/jpeg':
				if ($extension == 'jpg') {
					$matricule = $name;
					if ($Ecole->eleveExiste($matricule)) {
						if ($taille < MAXIMAGESIZE) {
							$target_file = "../photos/".strtolower($filename);
							// suppression d'une éventuelle ancienne version de la photo
							@unlink($target_file);

							if (move_uploaded_file($source, $target_file)) 
								$texteMessage = "Votre fichier a été envoyé";
								else $texteMessage = "Un problème est survenu. Veuillez ré-essayer";
							}
							else $texteMessage = sprintf("Ce fichier est trop gros (%d octets) > %d",$taille, MAXIMAGESIZE);
						}
						else 
							$texteMessage = sprintf("L'élève <strong>%s</strong> n'est pas connu",$matricule);
					}
					else $texteMessage = sprintf("Votre fichier doit porter l'extension .jpg et non \"%f\"", $extension);
				break;
			
			// c'est une des variantes de fichiers .zip
			case 'application/zip':	// continuer
			case 'application/x-zip-compressed': // continuer
			case 'multipart/x-zip': // continuer
			case 'application/x-compressed': 
				if ($taille < 4000000) {
					$target_file = "../photos/".$filename;
					if (move_uploaded_file($source, $target_file)) {
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
							}
						}
						else $texteMessage = "Un problème est survenu. Veuillez ré-essayer";
					}
					else $texteMessage = "Votre fichier est trop volumineux (> 4000 Ko)";
				break;
				
			default: 
				$texteMessage = "Vous tentez d'envoyer un fichier d'un type incorrect (seuls .jpg et .zip sont admis)";
			} // switch $type
		}  // if $type
		
	if ($listeImages != Null)
		$smarty->assign('listeImages', $listeImages);
	if (!$texteMessage)
		$texteMessage = "Aucun fichier de type admis n'a été soumis";
	$smarty->assign("info",$texteMessage);

	if ($matricule) {
		$smarty->assign('matricule', $matricule);
		$smarty->assign('nomPrenomClasse', $Ecole->nomPrenomClasse($matricule));
		}

	if ($numFiles) {
		$smarty->assign('numFiles', $numFiles);
		$smarty->assign('numJpg', $numJpg);
		}
	if ($filename)
		$smarty->assign('filename',$filename);

	}  // if $etape

$smarty->assign ('corpsPage','formulaireZip');
?>
