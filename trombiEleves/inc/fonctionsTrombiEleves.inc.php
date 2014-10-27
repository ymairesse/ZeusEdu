<?php

/** Création d'un fichier CSV pour les élèves d'une liste donnée d'un groupe (classe) donné
 * @param $listeEleves : array
 * @param $groupeCours : string
 * @return $groupeCours : string
 */
function fichierCSV ($listeEleves, $groupeCours) {
	$listeMatricules = "(".implode(',', array_keys($listeEleves)).")";
	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
	$sql = "SELECT matricule, classe, nom, prenom, nomResp, telephone1, telephone2, telephone3 ";
	$sql .= "FROM ".PFX."eleves ";
	$sql .= "WHERE matricule IN $listeMatricules ";
	$sql .= "ORDER BY REPLACE(REPLACE (nom, ' ', ''),'''',''), prenom";
	$resultat = $connexion->query($sql);
	$texte = '';
	if ($resultat) {
		$texte = "\"Matricule\", \"Classe\",\"Nom\",\"Prénom\",\"Responsable\",\"telephone1\",\"telephone2\",\"telephone3\"".chr(10);
		while ($ligne = $resultat->fetch()) {
			$matricule = $ligne['matricule'];
			$classe = $ligne['classe'];
			$nom = $ligne['nom'];
			$prenom = $ligne['prenom'];
			$nomResp = $ligne['nomResp'];
			$telephone1 = $ligne['telephone1'];
			$telephone2 = $ligne['telephone2'];
			$telephone3 = $ligne['telephone3'];
			$texte .= "\"$matricule\",\"$classe\",\"$nom\",\"$prenom\",\"$nomResp\",\"$telephone1\",\"$telephone2\",\"$telephone3\"".chr(10);
			}
		Application::DeconnexionPDO($connexion);
		if (!($fp = fopen ("csv/$groupeCours.csv", "w"))) die ("erreur à l'ouverture du fichier");
		fwrite ($fp, $texte);
		fclose ($fp);
		}
	return $groupeCours;
}


/** 
/* Création d'une ou plusieurs pages de trombinoscope en PDF
/* on passe un nom de groupe/classe ou une abréviation de cours
*/
function pagePDF ($listeEleves, $fichier) {
	require_once("classPDF.inc.php");	
	//Instanciation of inherited class
	$pdf=new PDF();
	$pdf->setGroupe($fichier);
	$pdf->AliasNbPages();
	$pdf->AddPage();
	$pdf->SetFont('Arial','',8);
	
	$x = 10; $y = 10; 
	$width = 30; $h = 150; 
	$margeImage = 10;
	$leftMargin = 10; $topMargin = 30;
	$hauteurImage = 50;
	
	$posX = $leftMargin; $posY = $topMargin;
	
	foreach ($listeEleves as $matricule=>$unEleve) {
		// fpdf ne travaille pas en UTF-8
		$nomPrenom = utf8_decode($unEleve['classe'].' '.$unEleve['nom'].' '.$unEleve['prenom']);
		$image = "../photos/$matricule.jpg";
		if (file_exists($image))
			$pdf->Image($image, $posX, $posY, $width);
		
		$pdf->SetXY($posX, $posY+$hauteurImage);
		$pdf->MultiCell ($width,3,$nomPrenom,0,"C");
		
		$posX += $width+$margeImage;
		// remonter au niveau de la cellule précédente
		$pdf->SetY($posY);
		
		// si l'on dépasse une limite convientionnelle à droite, 
		// passer une ligne d'images plus bas
		if ($posX > 180) {
			$posX = $leftMargin;
			$posY += $hauteurImage+$margeImage;
			}
		// si l'on dépasse une limite convientionnelle vers le bas
		// passer à la page suivante
		if ($posY > 220) {
			$pdf->AddPage();
			$posX = $leftMargin;
			$posY = $topMargin;
			} 
		}
	$pdf->Output(INSTALL_DIR."/trombiEleves/pdf/".$fichier.".pdf", 'F');
	return $fichier;
	}

?>
