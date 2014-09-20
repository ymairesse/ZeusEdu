<?php

function bulletinEnCours () {
	return $_SESSION['configuration']['periodeEnCours'];
	}

function dirFiles ($dir) {
	$listeFichiers = array();
	if ($handle = @opendir("$dir")) {
		while (false !== ($file = readdir($handle))) {
			if (($file != '.') && ($file != '..'))
				$listeFichiers[] = $file;
			}
		closedir($handle);			
		}
    return $listeFichiers;
	}

// --------------------------------------------------------------------
// échange les "," contre des "." et supprime tous les espaces
function sansVirg ($nombre) {
	$nombre = str_replace(',','.',$nombre);
	$nombre = str_replace(' ','',$nombre);
	return $nombre;
	}

//// --------------------------------------------------------------------
//// vider le répertoire "$dir" de tous les fichiers qu'il contient
// function vider ($dir) {
//	// liste des fichiers sauf "." et ".."
//	$listeFichiers = dirFiles ($dir);
//	foreach ($listeFichiers as $unFichier) {
//		@unlink ("$dir/$unFichier");
//		}
//	}
//
//// --------------------------------------------------------------------
//function zipFiles ($dir, $filename) {
//	$zip = new ZipArchive();
//	if ($zip->open("$dir/$filename", ZIPARCHIVE::CREATE)!==TRUE) {
//		exit("Impossible d'ouvrir <$filename>\n");
//		}
//	$listeFichiers = dirFiles($dir);
//	foreach ($listeFichiers as $unFichier) {
//		$zip->addFile("$dir/$unFichier");
//		}
//	$zip->close();
//	}


// --------------------------------------------------------------------
// établir une liste de cours avec plusieurs titulaires
// parmi eux, certains sont des remplaçants/intérimaires
 function listeRemplacements ($profParCours) {
	 $listeCours = array();
	 foreach ($profParCours as $unProfCours) {
		 if (count($unProfCours) > 1)
			$listeCours[] = $unProfCours;
		 }
	 return $listeCours;
	 }



// --------------------------------------------------------------------
// liste des dates (et lieux) de naissance des élèves de la liste
//~ function listeNaissanceEleves ($listeEleves) {
	//~ $listeElevesString = implode(',', array_keys($listeEleves));
	//~ $connexion = connexion (NOM, MDP, BASE, SERVEUR);
	//~ $sql = "SELECT codeInfo, DateNaiss ";
	//~ $sql .= "FROM ".PFX."eleves ";
	//~ $sql .= "WHERE codeInfo in ($listeElevesString)";
	//~ $resultat = ExecuteRequete($sql, $connexion);
	//~ Deconnexion($connexion);
	//~ $liste = array();
	//~ while ($ligne = ligneSuivante($resultat)) {
		//~ $codeInfo = $ligne['codeInfo'];
		//~ $dateNaiss = $ligne['DateNaiss'];
		//~ $liste[$codeInfo] = array('date'=>$dateNaiss);
		//~ }
	//~ return ($liste);
	//~ }
	
	
// --------------------------------------------------------------------
// détermine si une cote est en échec
function echecBulletin ($cote, $max) {
	if ($max !=0)
		return (($cote/$max) < 0.5)?'echec':'';
		else return '';
	}


// --------------------------------------------------------------------
// compte le nombre de colonnes nécessaires pour exposer les compétences
// pour le TJ et pour les examens
function competencesTJEX ($listeResultats) {
	// -------------------------------------------
	die('SERTAQUOI');
	// -------------------------------------------
	/*
	$first = current($listeResultats);
	$listeCompetencesTJ = array();
	if (isset($first['TJ']))
		foreach ($first['TJ'] as $key=>$cotes) 
			$listeCompetencesTJ[$key]= $cotes['comp'];

	$listeCompetencesEX = array();
	if (isset($first['EX']))
		foreach ($first['EX'] as $key=>$cotes)
			$listeCompetencesEX[$key]=$cotes['comp'];
	reset($listeResultats);
	return array('compTJ'=>$listeCompetencesTJ, 'compEX'=>$listeCompetencesEX);
	*/}



// --------------------------------------------------------------------
// détermination du degré dans lequel se trouve une classe
// VOIR LA FONCTION degreDeClasse dans classEcole.inc.php
/* function degreEleve ($classe) {
	$annee = substr($classe,0,1);
	$degre = 0;
	switch ($annee) {
		case 6: $degre = 3; break;
		case 5: $degre = 3; break;
		case 4: $degre = 2; break;
		case 3: $degre = 2; break;
		case 2: $degre = 1; break;
		case 1: $degre = 1; break;
		}
	return $degre;
	}

*/

// --------------------------------------------------------------------
// création des étiquettes verticales "images" pour les noms des cours
// sans les années et sans les groupes Ex: NL2, EDM4
function imagesPngCours ($hauteur) {
	$listeCours = listeCours();
	$largeur = 18;
	$fontSize = 10;
	$font = "../inc/font/LiberationMono-Bold.ttf";
	$liste = array();
	foreach ($listeCours as $unCours) {
		$nomImage = $unCours;
		$texte = $unCours;
		creeTexteVerticalPng ($largeur, $hauteur, $texte, $fontSize, $font, "imagesCours/$nomImage.png");
		$liste[] = array('nomImage'=>$nomImage, 'texte'=>$texte);
		}
	return $liste;
	}


// --------------------------------------------------------------------
// création d'une image d'un texte sur base des paramètres
function creeTexteVerticalPng ($largeur, $hauteur, $texte, $taillePolice, $font, $nomImage) {
    // crée un texte disposé verticalement pour les entêtes des feuilles de cotes
    $im = imagecreate($largeur,$hauteur);
    
    // couleur de fond de l'image
    $gris = imagecolorallocate($im,0xdd,0xdd,0xdd);
    $white = imagecolorallocate($im, 0xff, 0xff, 0xff);    
    $black = imagecolorallocate($im, 0x00, 0x00, 0x00);
    
    // angle d'écriture = 90
    imagettftext($im, $taillePolice, 90, $taillePolice+3, $hauteur-4, $white, $font, $texte);
    imagettftext($im, $taillePolice, 90, $taillePolice+4, $hauteur-5, $black, $font, $texte);
    
    // Sauvegarde l'image
    imagepng($im, "$nomImage");
    imagedestroy($im);
    }



function calculePourcents ($cote) {
	$sit = $cote['sit'];
	$max = $cote['max'];
	if ($max > 0)
		return round(100*$sit/$max,0);
		else return Null;
	}


// --------------------------------------------------------------------
// tri naturel des noms d'élèves se basant sur l'absence d'espaces, de trait d'union,
// et d'apostrophes
function triSurNoms ($listeEleves) {

	function cleanName ($nom) {
		$nom = str_replace(' ','',$nom);
		$nom = str_replace('-','',$nom);
		$nom = str_replace('\'','',$nom);
		return $nom;
		}
	function cmpNames ($nom1, $nom2) {
		$nom1 = cleanName($nom1);
		$nom2 = cleanName($nom2);
		if ($nom1 == $nom2)
			return 0;
			return ($nom1 < $nom2)?-1:1;
		}
uasort($listeEleves, 'cmpNames');
return $listeEleves;
}


// --------------------------------------------------------------------
// liste des écoles d'origine des élèves
function listeEcoles($niveau) {
	$connexion = connexion (NOM, MDP, BASE, SERVEUR);
	$sql = "SELECT DISTINCT ".PFX."elevesEcoles.ecole, nomEcole ";
	$sql .= "FROM ".PFX."elevesEcoles ";
	$sql .= "JOIN ".PFX."ecoles ON (".PFX."ecoles.ecole = ".PFX."elevesEcoles.ecole) ";
	$sql .= "WHERE codeInfo IN  (SELECT codeInfo ";
	$sql .= "FROM `".PFX."eleves` ";
	$sql .= "WHERE substr(annee,1,1) = '$niveau') ";
	$sql .= "ORDER BY nomEcole";
	$resultat = ExecuteRequete($sql, $connexion);
	Deconnexion($connexion);
	$listeEcoles = array();
	while ($ligne = ligneSuivante($resultat)) {
		$ecole = $ligne['ecole'];
		$nomEcole = $ligne['nomEcole'];
		$listeEcoles[$ecole] = $nomEcole;
		}
	return $listeEcoles;
	}
	
// --------------------------------------------------------------------
// renvoie le nom de l'école dont on fournit l'identifiant
function ecole ($identifiant) {
	$connexion = connexion (NOM, MDP, BASE, SERVEUR);
	$sql = "SELECT nomEcole, adresse, cpostal, commune ";
	$sql .= "FROM ".PFX."ecoles ";
	$sql .= "WHERE ecole = '$identifiant'";
	$resultat = ExecuteRequete($sql, $connexion);
	$ligne = ligneSuivante($resultat);
	Deconnexion($connexion);
	return $ligne;
	}
	
// --------------------------------------------------------------------
// prépare une grille remplie de "-" pour tous les élèves et pour tous les cours
// passés en arguments
function initGrille ($listeEleves, $listeCoursEleves) {
	$grille = array();
	foreach ($listeEleves as $matricule=>$nomEleve) {
		$grille[$matricule] = array('identite'=>$nomEleve, 'cotes'=>array());
		foreach ($listeCoursEleves as $cours=>$details)
			$grille[$matricule]['cotes'][$cours] = '-';
		}
	return $grille;
	}
	

// --------------------------------------------------------------------
// retourne la notice "coordinateurs" pour le bulletin donné au niveau donné
function noticeCoordinateursSERTAQUOI ($bulletin, $annee) {
	$connexion = connexion (NOM, MDP, BASE, SERVEUR);
	$sql = "SELECT remarque FROM ".PFX."notesBulletins ";
	$sql .= "WHERE bulletin='$bulletin' AND annee LIKE '$annee%'";
	$resultat = ExecuteRequete($sql, $connexion);
	$ligne = ligneSuivante($resultat);
	Deconnexion($connexion);
	return ($ligne['remarque']);
	}

// --------------------------------------------------------------------
// enregistrement de la notice "ccordinateurs" pour un bulletin et un niveau donné
function saveNoticeCoordinateurs($annee, $bulletin, $notice) {
	if ($bulletin && $annee) {
		$notice = nl2br(addslashes($notice));
		$connexion = connexion (NOM, MDP, BASE, SERVEUR);
		$sql = "INSERT INTO ".PFX."notesBulletins ";
		$sql .= "(bulletin, annee, remarque) VALUES ('$bulletin', '$annee', '$notice') ";
		$sql .= "ON DUPLICATE KEY UPDATE remarque='$notice'";
		$resultat = ExecuteRequete($sql, $connexion);
		Deconnexion($connexion);
		return true;
		}
	}


// ---------------------------------------------------------------------
// calcul de la situation pour les cours de la liste passée en argument
// pour tous les élèves de la liste passée en argument
// pour une période donnée
// la liste des élèves et la liste de cours sont des entités séparées par des virgules
function recalculSituation ($listeEleves, $listeCours, $bulletin) {
	// liste des situations précédentes
	$listeSitPrec = listeSituationsPrecedentes ($listeEleves, $listeCours, $bulletin);
	// recherche des des cotes de la période actuelle ($bulletin)
	$listeGlobalPeriode = listeGlobalPeriode($listeEleves, $listeCours, $bulletin);
	// recherche des barèmes pour les cours de la liste ----------------
	$baremesCours = baremesCours($listeCours, $bulletin);
	// application de la pondération sur les cotes globales période
	$listeGlobalPeriodePondere = listeGlobalPeriodePondere($listeGlobalPeriode, $baremesCours);
	// Situations actuelles = situation précédente + période pondérée
	$listeSitActuelles = listeSitActuelles($listeSitPrec, $listeGlobalPeriodePondere);
	enregistrerSituation ($listeSitActuelles, $bulletin);
	}
	

function date_php_sql ($date) {
$chiffres = explode("/", $date);
$an=$chiffres[2];
$mois=$chiffres[1];
$jour=$chiffres[0];
$date=$an."-".$mois."-".$jour;
return $date;
}

function date_sql_php ($date) {
	$chiffres = explode ("-",$date);
	$an = $chiffres[0];
	$mois=$chiffres[1];
	$jour = $chiffres[2];
	$date = $jour."/".$mois."/".$an;
	return $date;
	}



?>






