<?php
require('../../fpdf16/fpdf.php');
require_once ("../../inc/fonctions.inc.php");

class PDF extends FPDF
{
public $groupe;

function setGroupe ($groupe) {
	$this->groupe = $groupe;	
}
//Page header
function Header()
{
    //Arial bold 15
    $this->SetFont('Arial','B',15);
    //Move to the right
    $this->Cell(80);
    //Title
    $this->Cell(30,10,$this->groupe,1,0,'C');
    //Line break
    $this->Ln(20);
}

//Page footer
function Footer()
{
    //Position at 1.5 cm from bottom
    $this->SetY(-15);
    //Arial italic 8
    $this->SetFont('Arial','I',8);
    $this->Cell(20,10,date("d/m/Y"));
    //Page number
    $this->Cell(0,10,'Page '.$this->PageNo().'/{nb}',0,0,'C');
}
}

require('fonctionsTrombi.inc.php');
require_once ("../../config/constantes.inc.php");

$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;
$cours = isset($_GET['cours'])?$_GET['cours']:Null;
if (($groupe == Null) && ($cours == Null)) die();

if ($groupe) {
	$listeEleves = elevesDeClasseFromBulluc ($groupe);
	$fichier = $groupe;
	}
if ($cours) {
	$listeEleves = ElevesDuCoursFromBulluc($cours);
	$fichier = $cours;
	}

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

foreach ($listeEleves as $unEleve) {
	$codeInfo = $unEleve['codeInfo'];
	// fpdf ne travaille pas en UTF-8
	$nomPrenom = utf8_decode($unEleve['nomPrenom']);
	$image = "../../photos/$codeInfo.jpg";
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
$pdf->Output("../pdf/".$fichier.".pdf", 'F');

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign("groupe", $fichier);
$smarty->display("telechargerpdf.tpl");
?>
