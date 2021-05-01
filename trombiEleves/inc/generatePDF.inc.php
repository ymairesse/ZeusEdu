<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(2);

$cible = isset($_POST['cible']) ? $_POST['cible'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.trombiEleves.php';
$Trombi =  new trombiEleves();

switch ($cible) {
    case 'classe':
        $listeEleves = $Trombi->getFichierPDF($cible, $classe, $acronyme);
        $destinataire = $classe;
        break;
    case 'coursGrp':
        $listeEleves = $Trombi->getFichierPDF($cible, $coursGrp, $acronyme);
        $destinataire = $coursGrp;
        break;
    default:
        // wtf
        break;
}


require_once "classPDF.inc.php";
//Instanciation of inherited class
$pdf=new PDF();
$pdf->setGroupe($destinataire);
$pdf->AliasNbPages();
$pdf->AddPage();
$pdf->SetFont('Arial','',8);

$x = 10; $y = 10;
$width = 30; $h = 150;
$margeImage = 10;
$leftMargin = 10; $topMargin = 30;
$hauteurImage = 50;

$posX = $leftMargin; $posY = $topMargin;

foreach ($listeEleves as $matricule => $unEleve) {
    // fpdf ne travaille pas en UTF-8
    $nomPrenom = utf8_decode($unEleve['groupe'].' '.$unEleve['nom'].' '.$unEleve['prenom']);

    $image = "../../photos/$matricule.jpg";
    if (!file_exists($image))
        $image = '../../photos/nophoto.jpg';
    $pdf->Image($image, $posX, $posY, $width);

    $pdf->SetXY($posX, $posY + $hauteurImage);
    $pdf->MultiCell ($width, 3, $nomPrenom, 0, "C");

    $posX += $width + $margeImage;
    // remonter au niveau de la cellule précédente
    $pdf->SetY($posY);

    // si l'on dépasse une limite convientionnelle à droite,
    // passer une ligne d'images plus bas
    if ($posX > 180) {
        $posX = $leftMargin;
        $posY += $hauteurImage + $margeImage;
        }
    // si l'on dépasse une limite convientionnelle vers le bas
    // passer à la page suivante
    if ($posY > 220) {
        $pdf -> AddPage();
        $posX = $leftMargin;
        $posY = $topMargin;
        }
    }

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
if (!(file_exists($chemin)))
    mkdir($chemin, 0700, true);

$ds = DIRECTORY_SEPARATOR;
$pdf->Output(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds.$destinataire.".PDF", 'F');

echo '<a href="inc/download.php?dirFn='.$module.$ds.$destinataire.'.PDF">'.$module.$ds.$destinataire.'.PDF</a>';
