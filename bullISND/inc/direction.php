<?php
$unAn = time() + 365*24*3600;
if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = $_COOKIE['classe'];
$smarty->assign('classe',$classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = $_COOKIE['matricule'];
$smarty->assign('matricule',$matricule);

$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;
$typeDoc = isset($_POST['typeDoc'])?$_POST['typeDoc']:Null;

$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('niveau',$niveau);
$smarty->assign('onglet',$onglet);
$smarty->assign('typeDoc',$typeDoc);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($mode) {
	case 'competences':
		$date = isset($_POST['date'])?$_POST['date']:Null;
		$signature = isset($_POST['signature'])?$_POST['signature']:Null;
		$classe = isset($_POST['classe'])?$_POST['classe']:Null;
		switch ($etape) {
			case 'print':
				if ($classe) {
					if ($typeDoc == 'competences')
						$listeEleves = $Ecole->listeEleves($classe,'classe', false, false);
						else $listeEleves = $Ecole->listeEleves($classe,'classe', false, true);
					$listeCours = $Ecole->listeCoursClasse($classe);
					$listeCompetences = $Bulletin->listeCompetencesListeCours($listeCours);
					$sommeCotes = $Bulletin->sommeToutesCotes($listeEleves,$listeCours,$listeCompetences);
					$listeAcquis = $Bulletin->listeAcquis($sommeCotes);
					$smarty->assign('listeEleves',$listeEleves);
					$smarty->assign('listeCours',$listeCours);
					$smarty->assign('listeCompetences',$listeCompetences);
					$smarty->assign('listeAcquis',$listeAcquis);
					}
				// break; pas de break
			default:
				$listeClasses = $Ecole->listeClasses(array('G','TT', 'S'));
				$smarty->assign('listeClasses',$listeClasses);
				$smarty->assign('classe',$classe);
				$smarty->assign('date',$date);
				$smarty->assign('signature',$signature);
				$smarty->assign('DIRECTION',DIRECTION);
				$smarty->assign('etape','print');
				$smarty->assign('selecteur','selectClasseDateSignature');
				$smarty->assign('corpsPage','rapportCompetences');
				break;
		}
		break;
	
	case 'eprExternes':
		if ($etape == 'enregistrer') {
			$resultat = $Bulletin->enregistrerEprExternes($_POST);
			$tableErreurs = $resultat['erreurs'];
			$smarty->assign('tableErreurs',$tableErreurs);
			$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=>$resultat['nb'].' enregistrements modifiées')
					);
			}
		if (isset($coursGrp)) {
			$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
			$listeCotes = $Bulletin->listeCotesEprExterne($coursGrp);
			$listeSituationsBulletin = $Bulletin->listeSituationsCours($listeEleves,$coursGrp,NBPERIODES);
			$smarty->assign('listeSituations', $listeSituationsBulletin);
			$smarty->assign('NBPERIODES',NBPERIODES);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeCotes',$listeCotes);
			$smarty->assign('etape','enregistrer');
				
			$smarty->assign('intituleCours',$Bulletin->intituleCours($coursGrp));
			$smarty->assign('listeClasses',$Bulletin->classesDansCours($coursGrp));
			$smarty->assign('corpsPage','gestEprExternes');
			}

		if (isset($niveau))
			$listeCoursGrp = $Bulletin->listeEprExterne($niveau);
		$smarty->assign('listeCoursGrp',$listeCoursGrp);
		$smarty->assign('listeNiveaux',Ecole::listeNiveaux());
		$smarty->assign('selecteur','selectNiveauEprExterne');
		break;
	case 'padEleve':
		$listeClasses = $Ecole->listeGroupes(array('G','TT','GT'));
		$smarty->assign('listeClasses',$listeClasses);
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('listeEleves',$listeEleves);
			}

		if (isset($matricule) && ($matricule != '')) {
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");
			$padEleve = new padEleve($matricule, $acronyme);

			if (isset($etape) && ($etape == 'enregistrer')) {
				$nb = $padEleve->savePadEleve($_POST);
				$smarty->assign("message", array(
						'title'=>"Enregistrement",
						'texte'=>"Note enregistrée"));
				}
			$smarty->assign("padEleve", $padEleve);

			// recherche des infos personnelles de l'élève
			$smarty->assign("eleve", $eleve->getDetailsEleve());
			// recherche des infos concernant le passé scolaire
			$smarty->assign("ecoles", $eleve->ecoleOrigine());
	
			// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
			$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
			$listeCoursActuelle = $listeCoursActuelle[$matricule];
			$smarty->assign('listeCoursGrp',$listeCoursActuelle);
			$syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
			$smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
			
			// tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
			$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
			$smarty->assign('listeCoursActuelle', $listeCoursActuelle);
			$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);
			$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
			$smarty->assign('mentions', $Bulletin->listeMentions($matricule, Null, Null));
			$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
			$titulaires = $eleve->titulaires($matricule);
			$smarty->assign('matricule',$matricule);
			$smarty->assign('titulaires', $titulaires);
		
			$smarty->assign('prevNext', $prevNext);
			$smarty->assign('etape','enregistrer');
			$smarty->assign('selecteur', 'selectClasseEleve');			
			$smarty->assign('corpsPage', 'ficheEleve');
		}
		$smarty->assign('selecteur','selectClasseEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;
	}
?>