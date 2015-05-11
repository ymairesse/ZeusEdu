<?php

function uploadFile ($files, $acronyme) {
	$erreur = '';
	$nomFichier = $files['nomFichier']['name'];
	if (isset($nomFichier)) {
		// vérification du type de fichier
		$type=$files['nomFichier']['type'];
		$typesAutorises = array('image/jpeg');
		$typeOK = in_array($type, $typesAutorises);
		if (!($typeOK)) $erreur .= UNAUTHORIZED."<br>";
		
		// vérification de la taille du fichier
		$taille = $files['nomFichier']['size'];
		// MAXIMAGESIZE est défini dans /config/constantes.inc.php
		$sizeOK = ($taille <= MAXIMAGESIZE);
		if (!($sizeOK)) $erreur .=  sprintf(TOOBIG, MAXIMAGESIZE);
		if (($sizeOK) && ($typeOK)) {
			$tmp_name = $files['nomFichier']['tmp_name'];
			$saveOK = move_uploaded_file($files["nomFichier"]["tmp_name"], "../photosProfs/$acronyme.jpg");
			if (!($saveOK)) $erreur .= NOSAVE;
			}
		}
	else $erreur = NOFILE;
	return $erreur;
	}
?>
