<?php

require(INSTALL_DIR."/fpdf181/fpdf.php");

class PDF extends FPDF {
	public $groupe;

	function setGroupe ($groupe) {
		$this->groupe = $groupe;
	}

	//Page header
	function Header() {
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
	function Footer() {
		//Position at 1.5 cm from bottom
		$this->SetY(-15);
		//Arial italic 8
		$this->SetFont('Arial','I',8);
		$this->Cell(20,10,date("d/m/Y"));
		//Page number
		$this->Cell(0,10,'Page '.$this->PageNo().'/{nb}',0,0,'C');
	}
}
