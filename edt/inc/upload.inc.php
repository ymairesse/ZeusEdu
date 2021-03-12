<?php

if (isset($_FILES)) {
	$fichierTemp = $_FILES['file']['tmp_name'];
	$type = $_FILES['file']['type'];
	$fileName = $_FILES['file']['name'];
	$fileSize = $_FILES['file']['size'];

	switch ($type) {
		case 'text/calendar':
			$target_file = "../ical/".$fileName;
			move_uploaded_file($fichierTemp, $target_file);
			break;
		// c'est une des variantes de fichiers .zip
		case 'application/zip':	// continuer
		case 'application/x-zip-compressed': // continuer
		case 'multipart/x-zip': // continuer
		case 'application/zip; charset=binary': // continuer
		case 'application/x-compressed':
			$target_file = "../ical/".$fileName;
			if (move_uploaded_file($fichierTemp, $target_file)) {
				$zip = new ZipArchive();
				$x = $zip->open($target_file);
				$listeIcal = array();
				if ($x === true) {
					$numFiles = $zip->numFiles;
					$numIcal = 0;
					for($i = 0; $i < $numFiles; $i++) {
						$fichier = $zip->getNameIndex($i);
						$extension = strtolower(explode('.', $fichier)[1]);
						if ($extension == 'ics') {
							$listeIcal[] = $fichier;
							$zip->extractTo('../ical/', array($fichier));
							$numIcal++;
							}
						}
					$zip->close();
					unlink($target_file);
				}
			}
			break;
		}
}
