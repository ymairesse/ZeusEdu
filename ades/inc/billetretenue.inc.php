<?php
// Rédaction du billet de retenue: choisir l'un des deux modes d'impression
// *********************************************************
// Impression en mode "Paysage" = "Landscape" sur pages A5
$pdf=new FPDF('L','mm','A5');
// impression en mode "Portrait" = "Portrait" sur page A4
// $pdf=new FPDF('P','mm','A4');
// *********************************************************
$pdf->AddPage();

$pdf->Image('config/logoisnd.png', 15, 10, 40,40, 'png');
$pdf->SetFont('Arial','',14);
$pdf->SetXY(90,10);
$pdf->Cell(100,5,"Institut des Soeurs de Notre-Dame", 0, 2, 'C', 0);
$pdf->SetXY(90,15);
$pdf->Cell(100,5,"40, rue de Veeweyde", 0, 2, 'C', 0);
$pdf->SetXY(90,20);
$pdf->Cell(100,5,'Téléphone: 02 521 04 41', 0, 2, 'C', 0);

$pdf->SetFont('Arial','',12);
$dt = date("d/m/y");
$pdf->SetXY(140,35);
$pdf->Cell(50,5,'Anderlecht, le '.$dt, 0, 2, 'R');

$pdf->SetFont('','B',24);
$pdf->SetXY(70,45);
$pdf->Cell(110,10, $intitule, 1, 0, 'C');

$pdf->SetXY(10,65);
$pdf->SetFont('', 'B',10);
$chaine = "M. $prenom $nom en classe de $classe\n";
$pdf->Cell(200,5, $chaine, 0,0,'L');
//$pdf->Write(5, $chaine);

$pdf->SetXY(10,70);
$pdf->SetFont('');
$chaine = "a mérité une retenue de $duree h ce $dateRetenue à $heure ";
$chaine .= "(local $local) pour le motif suivant\n";
$pdf->Cell(200,5, $chaine, 0,0,'L');
//$pdf->Write(5, $chaine);
$pdf->SetXY(10,75);
$pdf->SetFont('','',12);
// $pdf->Cell (150,20, $motif, 1,0,'L');
$pdf->Write(5, $motif);
$pdf->SetFont('', '', 10);
$pdf->SetXY(10,90);

$chaine = "Matériel à apporter: Jcl, de quoi écrire - $materiel.\n";
$chaine .= "Travail à effectuer: $travail.\n";
$chaine .= "Veuillez prendre contact avec l'éducateur de votre enfant. Merci.\n";

$pdf->Write(5, $chaine);

$pdf->SetXY(10,110);
$pdf->Cell(30,5,"Le professeur", 0, 0, 'L', 0);
$pdf->SetXY(80,110);
$pdf->Cell(30,5,"Le CPE", 0, 0, 'L', 0);
$pdf->SetXY(150,110);
$pdf->Cell(30,5,"Les parents", 0, 0, 'L', 0);

$pdf->Output();
?>