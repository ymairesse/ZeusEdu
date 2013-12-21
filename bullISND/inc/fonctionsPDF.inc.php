<?php

// -----------------------------------------------------------
// tous les textes envoyés à FPDF doivent subir utf8_decode s'ils contiennent
// des caractères accentués
// -----------------------------------------------------------
require("../fpdf17/fpdf.php");
require("classes/class.pdfrotate.php");
require("classes/class.pdf.php");

function createPDFeleve ($classe, $matricule, $bulletin, $acronyme) {
	$annee = $Ecole->anneeDeClasse($classe);
	$titulaires = $Ecole->titusDeGroupe($classe);
	$eleve = new Eleve($matricule);
	$infoPerso = $eleve->getDetailsEleve();

	$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);

	// il n'y a qu'un élève, il n'y aura donc qu'une seule liste de pondérations
	$listeCoursGrp = $listeCoursGrp[$matricule];
	$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);

	// lectures dans la BD
	$sitPrecedentes = $Bulletin->situationsPeriode($matricule, $bulletin-1);
	$sitActuelles = $Bulletin->situationsPeriode($matricule, $bulletin);

	$listeCompetences = $Bulletin->listeCompetencesListeCoursGrp($listeCoursGrp);
	$listeCotes = $Bulletin->listeCotes($matricule, $listeCoursGrp, $listeCompetences, $bulletin);

	$ponderations = $Bulletin->getPonderations($listeCoursGrp, $bulletin);		
	$cotesPonderees = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);

	$commentairesCotes = $Bulletin->listeCommentairesTousCours($matricule, $bulletin);

	$mentions = $Bulletin->listeMentions($matricule, $bulletin, $annee);

	$ficheEduc = $Bulletin->listeFichesEduc($matricule, $bulletin);			
	$remarqueTitulaire = $Bulletin->remarqueTitu($matricule, $bulletin);
	$remarqueTitulaire = $remarqueTitulaire[$matricule][$bulletin];

	$tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, $bulletin);
	$noticeDirection = $Bulletin->noteDirection($annee, $bulletin);
	
	$detailsBulletin = array(
		'annee' => $annee,
		'titulaires' => $titulaires,
		'listeCoursEleve' => $listeCoursGrp,
		'listeProfs' => $listeProfsCoursGrp,
		'baremes' => $ponderations,
		'infoPerso' => $infoPerso,
		'sitPrec' => $sitPrecedentes,
		'sitActuelles' => $sitActuelles,
		'detailCotes' => $listeCotes,
		'listeCompetences'=>$listeCompetences,
		'cotesPonderees' => $cotesPonderees,
		'listeProfs' => $listeProfsCoursGrp,
		'commentairesCotes' => $commentairesCotes,
		'ficheEduc' => $ficheEduc,
		'attitudes' => $tableauAttitudes,
		'remTitu' => $remarqueTitulaire,
		'mention' => $mentions,
		'noticeDirection' => $noticeDirection
		);
	
	$pdf=new PDF('P','mm','A4');
	$pdf->SetFillColor (230);
	
	$eleve_nom = $infoPerso['prenom']." ".$infoPerso['nom'];
	createBulletinEleve ($pdf, $detailsBulletin, $bulletin);
	// création du répertoire correspondant à l'utilisateur en cours
	if (!(file_exists("pdf/$acronyme"))) {
		mkdir ("pdf/$acronyme");
		}
	$pdf->Output("pdf/$acronyme/$matricule.pdf");
	chmod ("pdf/$acronyme/$matricule.pdf", 0644);
	return "<a href='pdf/$acronyme/$matricule.pdf' title='Bulletin de $eleve_nom'>$matricule.pdf</a>";
	}

function createPDFclasse ($listeEleves, $classe, $bulletin, $acronyme) {
	$pdf=new PDF('P','mm','A4');
	$pdf->AddPage('P');
	$pdf->SetFont('Arial', 'B', 72);
	$pdf->SetFillColor (230);
	$pdf->SetY(100);
	$pdf->Cell(0, 72, $classe, 0,0, 'C');
	
	$annee = $Ecole->anneeDeClasse($classe);
	$titulaires = $Ecole->titusDeGroupe($classe);
	$listeCoursGrp = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);

	// lectures dans la BD
	$toutesSitPrecedentes = $Bulletin->situationsPeriode(array_keys($listeEleves), $bulletin-1);
	$toutesSitActuelles = $Bulletin->situationsPeriode(array_keys($listeEleves), $bulletin);
	
	$tousCommentairesCotes = $Bulletin->listeCommentairesTousCours($listeEleves, $bulletin);
	$toutesMentions = $Bulletin->listeMentions($listeEleves, $bulletin);

	$toutesFichesEduc = $Bulletin->listeFichesEduc($listeEleves, $bulletin);			
	$toutesRemarqueTitulaire = $Bulletin->remarqueTitu($listeEleves, $bulletin);

	$tousTableauxAttitudes = $Bulletin->tableauxAttitudes($listeEleves, $bulletin);
	$noticeDirection = $Bulletin->noteDirection($annee, $bulletin);

	foreach ($listeEleves as $matricule=>$eleve) {
		$eleve = new Eleve($matricule);
		$infoPerso = $eleve->getDetailsEleve();
		$listeCoursEleve = $listeCoursGrp[$matricule];
		$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursEleve);
		
		$listeCompetences = $Bulletin->listeCompetencesListeCoursGrp($listeCoursEleve);

		$detailCotesEleve = $Bulletin->listeCotes($matricule, $listeCoursEleve, $listeCompetences, $bulletin);
		$ponderations = $Bulletin->getPonderations($listeCoursEleve, $bulletin);
		$cotesPonderees = $Bulletin->listeGlobalPeriodePondere($detailCotesEleve, $ponderations, $bulletin);
		
		$detailsBulletin = array(
			'annee' => $annee,
			'titulaires'=>$titulaires,
			'listeCoursEleve' => $listeCoursEleve,
			'listeProfs' => $listeProfsCoursGrp,
			'baremes' => $ponderations,
			'infoPerso' => $infoPerso,
			'sitPrec' => $toutesSitPrecedentes,
			'sitActuelles' => $toutesSitActuelles,
			'detailCotes' => $detailCotesEleve,
			'listeCompetences'=>$listeCompetences,
			'cotesPonderees' => $cotesPonderees,
			'commentairesCotes' => $tousCommentairesCotes,
			'ficheEduc' => $toutesFichesEduc,
			'attitudes' => $tousTableauxAttitudes,
			'remTitu' => $toutesRemarqueTitulaire[$matricule][$bulletin],
			'mention' => $toutesMentions,
			'noticeDirection' => $noticeDirection
			);
		// $bulletinEleve = detailsBulletinEleve($matricule, $bulletin);
		createBulletinEleve ($pdf, $detailsBulletin, $bulletin);
		unset($eleve);
		}
	
	if (!(file_exists("pdf/$acronyme"))) {
		mkdir ("pdf/$acronyme");
		}
	$pdf->Output("pdf/$acronyme/$classe.pdf");
	return "<a href='pdf/$acronyme/$classe.pdf' title='Bulletin de $classe'>$classe.pdf</a>";
	}

// --------------------------------------------------------------------

function utf8($argument) {
	return utf8_decode($argument);
	}

// --------------------------------------------------------------------

function enteteBulletin ($pdf, $infoPerso, $titulaires, $bulletin) {
	$classe = utf8($infoPerso['classe']);
	$eleve_nom = utf8($infoPerso['nom']);
	$eleve_prenom = utf8($infoPerso['prenom']);
	$titulaires = utf8($titulaires);
	$x = 10;
	$y = 12;
	$pdf->SetLineWidth(0.2);
	$pdf->Image("../images/logo1.jpg",12,8,25);

	$pdf->SetXY($x+30,$y-2);
	$pdf->SetFont('Arial','B',14);
	$pdf->MultiCell(120,5,utf8(ECOLE),0,'L');
	$pdf->SetFont('Arial','',11);
	$pdf->SetXY($x+30,$y+3);
	$pdf->MultiCell(120,4,utf8(ADRESSE)."\n".utf8(VILLE)."\n".utf8(TELEPHONE),0,'L');
	$pdf->SetXY($x+30,$y+14);
	$pdf->SetFont('Arial','U',9);
	$pdf->MultiCell(120,5,SITEWEB,0,'L');

	$pdf->SetFont('Arial','B',11);
	$pdf->SetXY(90,$y-2);
	$jour = date("d"); $mois = date("m"); $annee = date("Y");
	// $titreEleve =  "$eleve_prenom $eleve_nom\n$classe\nTitulaire(s) : $titulaires \n";
	$titreEleve = sprintf(utf8("%s %s \n %s \n Titulaire(s): %s \n"),$eleve_prenom, $eleve_nom, $classe, $titulaires);
	$titreEleve .= sprintf(utf8("Le %02d-%02d-%04d, période %d"), $jour,$mois,$annee,$bulletin);
	$pdf->MultiCell(110,5, $titreEleve, 0,'R');
	$pdf->Ln();
	}

// -------------------------------------------------------------------
function situationPrecedentePDF ($pdf, $sitPrec, $bulletin, $degre) {
	// la cote de situation précédente n'est indiquée qu'au D1
	$pdf->SetFont('Arial','',8);
	// encadrement pour situation précédente
	$pdf->SetLineWidth(0.2);
	// s'il y a une situation précédente
	if ($degre == 1)
		if ($sitPrec['maxSit'] != 0) {
			$pdf->Cell(40,5,utf8('Situation Précédente'),0,0,'R');
			$sitPrec = $sitPrec['sit']."/".$sitPrec['maxSit'];
			$pdf->Cell(17,5,$sitPrec,1,0,'C',true);
			}
		else {
		// il n'y a pas de situation précédente
		$pdf->Cell(40,5,utf8('Situation Précédente'),0,0,'R');
		$pdf->Cell(17, 5, '---', 0, 0,'C',true);
		}
		else // on n'est pas au D1;
		$pdf->Cell(40+17,5,'',0,0,'R');
	}

// -------------------------------------------------------------------
function entetesColonnesPDF($pdf, $cotesPonderees) {
	$pdf->SetFont('Arial','',7);
	// encadrement pour les entêtes de colonnes TJ et Cert
	$pdf->SetLineWidth(0.2);
	if (isset($cotesPonderees)) {
		$form = $cotesPonderees['form']['cote'];
		$maxForm = $cotesPonderees['form']['max'];

		// Entête de colonne pour le Formatif
		$pdf->SetFontSize(5);
		$pdf->Cell(4,5,'TJ',1,0,'C', true);
		$pdf->SetFontSize(7);
		if ($form >= 0) {
			if ($cotesPonderees['form']['echec'])
				rouge($pdf); else noir($pdf);
			$pdf->Cell(10,5,$form.'/'.$maxForm, 1, 0,'C',true);
			noir($pdf);
			}
			else $pdf->Cell(10,5,'-', 1, 0,'C',true);

		$cert = $cotesPonderees['cert']['cote'];
		$maxCert = $cotesPonderees['cert']['max'];
		// Entête de colonne pour les Cert
		$pdf->SetFontSize(5);
		$pdf->Cell(4,5,'C',1,0,'C', true);
		$pdf->SetFontSize(7);
		if ($cert >= 0) {
			if ($cotesPonderees['cert']['echec'])
				rouge($pdf); else noir($pdf);
			$pdf->Cell(10,5,$cert.'/'.$maxCert, 1, 0,'C',true);
			noir($pdf);
			}
			else $pdf->Cell(10,5,'-', 1, 0,'C',true);
		}
	else {
		$pdf->Cell(14,5,'',1,0,'C',true);
		$pdf->Cell(14,5,'',1,0,'C',true);
		}
	}

// --------------------------------------------------------------------
function brancheProfPDF ($pdf, $unCours) {
	// nom de la branche et titulaire du cours
	// encadrement du nom du cours et du prof
	$pdf->SetLineWidth(0.2);
	$pdf->SetFont('Arial','B',7);
	// $pdf->SetFont('Arial','B',8);
	$nomCours = utf8($unCours['libelle']);
	$nbh = $unCours['nbheures'];
	$listeProfs = $Ecole->listeProfsListeCoursGrp($unCours['coursGrp']);
	
	$prof = utf8(implode(', ',$Ecole->listeProfsListeCoursGrp($unCours['coursGrp'])));
	$texte = "$nomCours [$nbh h] $prof";
	// $limite = 48;
	$limite = 60;
	if (strlen($texte) > $limite)
		$texte = substr($texte, 0, $limite)."...";
	$pdf->Cell(83,5,$texte, 1,0,'L',true);
	$y = $pdf->GetY();

	// ligne de séparation entre les cours
	$pdf->SetLineWidth(0.4);
	$pdf->Line(6,$y,200,$y);
	// ligne descendante pour le bord gauche de l'encadrement
	$pdf->Line(6,$y,6,$y+5);
	$pdf->SetLineWidth(0.2);
	}

// ------------------------------------------------------------------
/* 
 * function situationActuellePDF
 * 
 * @param $pdf			// objet PDF
 * @param $sitActuelle	
 * @param $bulletin		// période pour le bulletin à imprimer
 * @param $degre   		// la présentation du bulletin varie selon le degré
 * */	
function situationActuellePDF ($pdf, $sitActuelle, $bulletin, $degre) {
	// tableau des périodes de délibés, sans espaces
	$arrayDelibes = explode(',', str_replace(' ','',PERIODESDELIBES));
	$pdf->SetFont('Arial','',8);
	// encadrement pour situation actuelle
	$pdf->SetLineWidth(0.2);
	
	if (in_array($bulletin, $arrayDelibes)) {	// sommes nous en période de délibé
		// la situation de délibé est-elle connue?
		$sitDelibe = trim($sitActuelle['sitDelibe']);
		if ($sitDelibe != '') {
			$pdf->Cell (12,5,'Situation', 1, 0, 'C', true);
			if (echec(trim($sitDelibe,'*²[]'),100)) rouge($pdf); else noir($pdf);
			$pdf->Cell (14,5,utf8($sitDelibe.' %'),1, 1,'C',true);
			noir($pdf);
			}
			else $pdf->Cell(12+14,5,'',1,1,'C',true);	// déplacer le pointeur
		}	// on n'est pas en période de délibés
		else {
			if ($degre == 1) {	// sommes-nous au premier degré
				// la situation est-elle connue?
				$sit = trim($sitActuelle['sit']);
				$max = $sitActuelle['maxSit'];
				if ($max == '') $sit = '';
				if ($sit != '') {
					$sit = ($sitActuelle['sit'] > 50)?round($sitActuelle['sit'],0):round($sitActuelle['sit'],1);
					$pdf->Cell (12,5,'Situation', 1, 0, 'C', true);
					if (echec($sit,$max)) rouge($pdf); else noir($pdf);
					$pdf->Cell (14,5,$sit.'/'.$max,1, 1,'C',true);
					noir($pdf);
					}
					// on n'a rien à écrire
					else $pdf->Cell(12+14,5,'',1,1,'C',true);	// déplacer le pointeur
				}
				else $pdf->Cell(12+14,5,'',1,1,'C',true);	// déplacer le pointeur
			}
	}

function attitudesPDF ($pdf, $attitudes) {
	if ($attitudes != Null) {
		$pdf->SetLineWidth(0.2);
		$y = $pdf->GetY();
		$x = 10;
		$pdf->SetXY($x,$y);
		$pdf->SetFont('Arial','B',12);
		// titre de la rubrique
		$pdf->Cell(50,5,"Attitudes",0,1,'L');
		// rectangle gris vide
		$pdf->Rect(10,$y+5,50,17,'DF');
		$pdf->SetY($y+22);
		// différentes attitudes
		$pdf->SetFont('Arial','',9);
		$pdf->SetX(10); $pdf->MultiCell(50,5,utf8("Respect des autres"),1,'L',1);
		$pdf->SetX(10); $pdf->MultiCell(50,5,utf8("Respect des consignes"),1,'L',1);
		$pdf->SetX(10); $pdf->MultiCell(50,5,utf8("Volonté de progresser"),1,'L',1);
		$pdf->SetX(10); $pdf->MultiCell(50,5,utf8("Ordre et soin"),1,'L',1);

		// position X = 10 + 50
		$x = 60; $y+=5;
		foreach ($attitudes as $coursGrp=>$unCours) {
			// entete du tableau des attitudes indiquant le cours
			$pdf->SetXY($x,$y);
			$pdf->SetFont('Arial','B',9.5);
			$pdf->Rect($x,$y,8,17,'DF');
			// $cours = $unCours['coursGrp'];
			$cours = substr($coursGrp, strpos($coursGrp,':')+1);
			$cours = substr($cours, 0, strpos($cours,'-'));

			$pdf->RotatedText($x+5,$y+16, $cours, 90);
			// ériture des différentes attitudes A ou N
			$y1 = $y + 17;
			for ($i=1; $i<=4; $i++) {
				$pdf->SetFont('Arial','B',9.5);
				$attitude = $unCours['att'.$i];
				if ($attitude == 'N') {
					$attitude = 'NA';
					rouge($pdf);
					}
				$pdf->SetXY($x,$y1);
				$pdf->Cell(8,5,$attitude,1,'C',0);
				noir($pdf);
				$y1 +=5;
				}
			// colonne suivante
			$x += 8;
			}
		$pdf->Ln(10);
		}
	}

// -------------------------------------------------------------------
function remarqueTituPDF ($pdf, $remarqueTitulaire) {
	$pdf->SetLineWidth(0.2);
	$pdf->SetFont('Arial','B',10);
	$pdf->SetX(5);
	$pdf->MultiCell(194,5,"Avis du titulaire ou du Conseil de Classe",1,'C', 1);
	$pdf->SetX(5);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(194,4,utf8(html_entity_decode($remarqueTitulaire)),1,'L',0);
	$pdf->Ln();
	}

// -------------------------------------------------------------------
function mentionPDF ($pdf,$mention) {
	$pdf->SetLineWidth(0.2);
	$pdf->SetX(6);
	$pdf->SetFont('Arial','B',12);
	$pdf->MultiCell(194,8,utf8("Mention: ".$mention),1,'C');
	$pdf->Ln();
	}

// -------------------------------------------------------------------
function commentaireProfPDF ($pdf, $commentaire, $y) {
	$pdf->SetLineWidth(0.2);
	$pdf->SetFont('Arial','',8);
	$commentaire = str_replace("…","...",$commentaire);
	$commentaire = str_replace("’","'",$commentaire);

	$commentaire = utf8(html_entity_decode($commentaire));
	$pdf->setXY(91,$y);
	$pdf->MultiCell(0,4,$commentaire, 1,'L',false);
	}
// -------------------------------------------------------------------
function signatures ($pdf) {
	$pdf->SetLineWidth(0.2);
	$x = 20;
	$y = $pdf->GetY() + 3;
	$pdf->SetXY($x,$y);
	$pdf->SetFont('Arial','B',8.5);
	$pdf->MultiCell(40,5,"Le titulaire",0,'C');
	$x = 85;
	$pdf->SetXY($x,$y);
	$pdf->MultiCell(40,5,"Les parents",0,'C');
	$x = 150;
	$pdf->SetXY($x,$y);
	$pdf->MultiCell(40,5,utf8('L\'élève'),0,'C');
	$pdf->Ln();
	}
// -------------------------------------------------------------------
function educPDF ($pdf, $rubriques) {
	$ficheDisc = $rubriques['fiche'];
	if ($ficheDisc) {
		$pdf->SetLineWidth(0.2);
		$pdf->SetFont('Arial','B',10);
		$pdf->SetX(5);
		$pdf->MultiCell(194,5,utf8('Note des éducateurs'),1,'C', true);
		$pdf->SetX(5);
		$pdf->SetFont('Arial','',9);
		$pdf->MultiCell(194,4,utf8('Feuille de comportements jointe au bulletin; à signer par les parents.'),1,'L');
		$pdf->Ln();
		}
	}

// -------------------------------------------------------------------
function notaBulletin ($pdf, $nota) {
	if ($nota) {
		$nota = str_replace('<br />','', utf8(html_entity_decode($nota)));
		$pdf->SetLineWidth(0.2);
		$pdf->SetFont('Arial','B',10);
		$pdf->SetX(5);
		$pdf->MultiCell(194,5,'Informations de la direction et/ou du coordinateur',1,'C', true);
		$pdf->SetX(5);
		$pdf->SetFont('Arial','',9);
		$pdf->MultiCell(194,4,$nota, 1);
		$pdf->Ln();
		}
	}

// -------------------------------------------------------------------
function ecrireCotesPDF ($pdf, $cotes, $listeCompetences) {
	$limite=57;
	$pdf->SetFont('Arial','',8);

	foreach ($cotes as $idComp=>$lesCotes) {
		// ligne descendante pour le bord gauche de l'encadrement
		$pdf->SetLineWidth(0.4);
		$y = $pdf->GetY();
		$pdf->Line(6,$y,6,$y+6);
		$pdf->SetLineWidth(0.2);
		// S'il y a quelque chose dans la cote, alors on imprime
		if (($lesCotes['form']['cote'] != '') || ($lesCotes['form']['maxForm'] != '')
			|| ($lesCotes['cert']['cote'] != '') || ($lesCotes['cert']['maxCert'] != '')) {
	
			// écriture de la colonne de gauche: nom des compétences et cotes TJ/Cert
			$libelle = utf8($listeCompetences[$idComp]['libelle']);
			if (strlen($libelle) > $limite)
				$libelle = substr($libelle, 0, $limite)."...";
			$coteForm = utf8($lesCotes['form']['cote']); $maxForm = utf8($lesCotes['form']['maxForm']);
			$coteCert = utf8($lesCotes['cert']['cote']); $maxCert = utf8($lesCotes['cert']['maxCert']);
			$pdf->SetFontSize(6);
			$pdf->Cell($limite,6,$libelle,1,0,'R',false);
			$pdf->SetFontSize(8);
			if ($coteForm != '') {
				if (echec($coteForm, $maxForm)) rouge($pdf); else noir($pdf);
				$pdf->Cell(14,6,"$coteForm / $maxForm",1,0,'C',false);
				}
				else $pdf->Cell(14,6,'',1,0,'C',false);
			if ($coteCert != '') {
				if (echec($coteCert, $maxCert)) rouge($pdf); else noir($pdf);
				$pdf->Cell(14,6,"$coteCert / $maxCert",1,1,'C',false);
				}
				else $pdf->Cell(14,6,'',1,1,'C',false);
			noir($pdf);
			}
		}
	}

// -------------------------------------------------------------------
function noir ($pdf) {
	$pdf->SetTextColor(0,0,0);
	$pdf->SetFont('Arial');
	}
// -------------------------------------------------------------------
function rouge ($pdf) {
	$pdf->SetTextColor(217,3,3);
	$pdf->SetFont('Arial','BU');
	}

function echec ($cote, $max) {
	if (($max > 0) && (is_numeric($cote)))
			return (($cote / $max) < 0.5);
		else return false;
	}

function piedPage ($pdf, $page) {
	$pdf->SetXY(180,270);
	$pdf->SetFont('Arial','',8.5);
	$pdf->MultiCell(20,5,"page $page / 2",0,'R',0);
	}

function newPage ($pdf, $infoPerso, $titulaires, $bulletin, $page) {
	piedPage ($pdf, $page);
	$pdf->AddPage('P');
	$pdf->SetLeftMargin(6);
	$x = 10;
	$y = 12;

	enteteBulletin($pdf, $infoPerso, $titulaires, $bulletin);
	noir($pdf);
	return $page+1;
	}

// --------------------------------------------------------------------

function createBulletinEleve ($pdf, $bulletinEleve, $bulletin) {
	foreach ($bulletinEleve as $key=>$data)
		$$key = $data;
	/* $bulletinEleve
		'annee' => $annee,
		'titulaires' => $titulaires,
		'listeCoursEleve' => $listeCoursGrp,
		'listeProfs' => $listeProfsCoursGrp,
		'baremes' => $ponderations,
		'infoPerso' => $infoPersoEleve,
		'sitPrec' => $sitPrecedentes,
		'sitActuelles' => $sitActuelles,
		'detailCotes' => $listeCotes,
		'listeCompetences'=>$listeCompetences,
		'cotesPonderees' => $cotesPonderees,
		'listeProfs' => $listeProfsCoursGrp,
		'commentairesCotes' => $commentairesCotes,
		'ficheEduc' => $ficheEduc,
		'attitudes' => $tableauAttitudes,
		'remTitu' => $remarqueTitulaire,
		'mention' => $mentions,
		'noticeDirection' => $noticeDirection
		*/
	$matricule = $infoPerso['matricule'];
	$classe = $infoPerso['classe'];
	$titulaires = implode(', ', $titulaires);

	$degre = $Ecole->degredeClasse($classe);

	$eleve_nom = utf8($infoPerso['nom']);
	$eleve_prenom = utf8($infoPerso['prenom']);
	$x = 10;
	$y = 12;

	$pdf->AddPage('P');
	$pdf->SetLeftMargin(6); // fixe la marge de gauche
	$page=1;
	enteteBulletin ($pdf, $infoPerso, $titulaires, $bulletin);
	$pdf->SetFont('Arial','',8);

	// on passe tous les cours en revue
	foreach ($listeCoursEleve as $coursGrp=>$dataCours) {
		$debutX = $pdf->GetX(); $debutY = $pdf->GetY();

		// s'il y a des cotes pour ce cours
		if (isset($detailCotes[$matricule][$coursGrp])) {
			situationPrecedentePDF($pdf, $sitPrec[$matricule][$coursGrp], $bulletin, $degre);
			entetesColonnesPDF($pdf, $cotesPonderees[$matricule][$coursGrp]);
			}
			else $pdf->setX(91); // il n'y a pas de cotes, déplacer la marge de gauche
		brancheProfPDF($pdf, $listeCoursEleve[$coursGrp]);

		// on vérifie qu'il y a une situation actuelle pour ce cours; sinon, Null
		$situationCours = isset($sitActuelles[$matricule][$coursGrp])?$sitActuelles[$matricule][$coursGrp]:Null;
		situationActuellePDF ($pdf, $situationCours, $bulletin, $degre);

		// on retient la position Y du début d'écriture des cotes
		// on en aura  besoin pour positionner le multicell du commentaire du prof
		$yDebutCotes = $pdf->GetY();
		// s'il y a des cotes pour ce cours		
	
		if (isset($detailCotes[$matricule][$coursGrp])) {
			$cours = $Bulletin->coursDeCoursGrp($coursGrp);
			ecrireCotesPDF($pdf, $detailCotes[$matricule][$coursGrp], $listeCompetences[$cours]);
			}

		// quand toutes les cotes sont écrites, on récupère la valeur de Y
		$yFinCotes = $pdf->GetY();
		$prof = $listeProfs[$coursGrp];
		$commentaire = isset($commentairesCotes[$matricule][$coursGrp])?$commentairesCotes[$matricule][$coursGrp]:'';

		commentaireProfPDF($pdf, $commentaire[$bulletin], $yDebutCotes);

		$yFinCommentaire = $pdf->GetY();
		// se positionner sous le bloc le plus haut: compétences ou commentaires
		$pdf->SetY(max($yFinCotes, $yFinCommentaire));

		// vérifier s'il faut un saut de page préventif
		if ($pdf->GetY() > 235)
			// $page = newPage ($pdf, $page, $eleve_nom, $eleve_prenom, $classe_nom, $bulletin, $nomsTitulaires);
			$page = newPage ($pdf, $infoPerso, $titulaires, $bulletin, $page);
			else $pdf->Ln(1);
		} // foreach $listeCoursEleve

	// Le tableau des attitudes et l'avis du titu sont toujours à la page 2
	if ($page == 1)
		// $page = newPage ($pdf, $page, $eleve_nom, $eleve_prenom, $classe_nom, $bulletin, $nomsTitulaires);
		$page = newPage ($pdf, $infoPerso, $titulaires, $bulletin, $page);
		else $pdf->Ln(1);
	attitudesPDF ($pdf, $attitudes[$bulletin][$matricule]);

		// 		*************************************************************************************

	if ($mention)
		mentionPDF ($pdf,$mention[$matricule][$bulletin]);
	remarqueTituPDF ($pdf, $remTitu);
	educPDF ($pdf, $ficheEduc[$matricule]);
	notaBulletin ($pdf, $noticeDirection);
	signatures($pdf);
	piedPage ($pdf, $page);
}// fin fonction

?>
