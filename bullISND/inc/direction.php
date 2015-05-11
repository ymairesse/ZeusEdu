<?php

$unAn = time() + 365*24*3600;
if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = isset($_COOKIE['classe'])?$_COOKIE['classe']:Null;
$smarty->assign('classe',$classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule',$matricule);

$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;

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
					'texte'=>$resultat['nb'].' enregistrements modifiées',
					'urgence'=>'success')
					);
			}
		if (isset($coursGrp)) {
			$listeEleves = $Ecole->listeElevesCours($coursGrp);
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

		$listeCoursGrp = (isset($niveau))?$Bulletin->listeEprExterne($niveau):Null;
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

		if (isset($matricule) && ($matricule != '')
			&& (in_array($matricule, array_keys($listeEleves)))  // le matricule fait partie de la classe sélectionnée
			&& ($matricule != 'all')) {  // le cookie pourrait contenir la valeur 'all' qui n'aurait pas de sens ici
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			
			require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");
			$padEleve = new padEleve($matricule, $acronyme);
			if (isset($etape) && ($etape == 'enregistrer')) {
				$nb = $padEleve->savePadEleve($_POST);
				$texte = ($nb>0)?"$nb enregistrement(s) réussi(s)":"Pas de modification";
				$smarty->assign('message', array(
					'title'=>"Enregistrement",
					'texte'=>$texte,
					'urgence'=>'success')
					);
				}

			$smarty->assign('padsEleve', $padEleve->getPads());

			// recherche des infos personnelles de l'élève
			$smarty->assign('eleve', $eleve->getDetailsEleve());
			// recherche des infos concernant le passé scolaire
			$smarty->assign('ecoles', $eleve->ecoleOrigine());
			// le CEB
			$smarty->assign('degre',$Ecole->degreDeClasse($eleve->groupe()));
			$smarty->assign('ceb',$Bulletin->getCEB($matricule));
			// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
			$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
			$listeCoursActuelle = $listeCoursActuelle[$matricule];
			$smarty->assign('listeCoursGrp',$listeCoursActuelle);
			$syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
			$smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
			$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
			
			// tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
			$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
			$smarty->assign('listeCoursActuelle', $listeCoursActuelle);
			
			$smarty->assign('epreuvesExternes', $Bulletin->cotesExternesPrecedentes($matricule));
			$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);
			$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
			$smarty->assign('mentions', $Bulletin->listeMentions($matricule, Null, Null,Null));
			$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
			$titulaires = $eleve->titulaires($matricule);
			$smarty->assign('matricule',$matricule);
			$smarty->assign('titulaires', $titulaires);
		
			$smarty->assign('prevNext', $prevNext);
			$smarty->assign('etape','enregistrer');
			$smarty->assign('corpsPage', 'ficheEleve');
		}
		$smarty->assign('selecteur','selectClasseEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;
	case 'pia':
		$smarty->assign('classe',$classe);
		$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null; // on ne prend pas la valeur du cookie qui pourrait ne pas correspondre à la classe
		$smarty->assign('matricule',$matricule);
		$smarty->assign('listeClasses',$Ecole->listeClasses());
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('listeEleves',$listeEleves);
			}
			
		if ($etape == 'showEleve') {
			require_once('../infirmerie/inc/classes/classInfirmerie.inc.php');
			if (isset($matricule) && ($matricule != Null) )
				$listeFichesEleves = array($matricule=>$matricule);
				else $listeFichesEleves = $Ecole->listeEleves($classe,'groupe');
			$listePIA = array();
			foreach ($listeFichesEleves as $matricule=>$wtf) {
				$eleve = new Eleve($matricule);
				$detailsEleve = $eleve->getDetailsEleve();
				$degre = $Ecole->degreDeClasse($detailsEleve['groupe']);
				$ceb = ($degre==1)?$Bulletin->getCEB($matricule):Null;
				$infirmerie = new eleveInfirmerie($matricule);
				$infosMedic = $infirmerie->getInfoMedic($matricule);
				$resultatsPre = $Bulletin->syntheseToutesAnnees($matricule);
				$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
				$listeCoursGrp = $listeCoursGrp[$matricule];
				$listeProfs = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
				$listeMails = $Ecole->listeMailsEleves($listeFichesEleves);
				if ($resultatsPre != Null) {
					//millésimes de l'année précédente
					$anPrec = array_keys($resultatsPre); 
					$anPrec = $anPrec[0];
					$anScolaire = $anPrec;
					// année d'étude précédente
					$resultatsPre = array_shift($resultatsPre);
					$niveauPre = array_keys($resultatsPre); $niveauPre = $niveauPre[0];
					$annee = $niveauPre;
					// les résultats rien que pour l'année précédente
					$resultatsPrec = array_shift($resultatsPre);
					// les mentions obtenues
					$mentions = $Bulletin->listeMentions($matricule, Null, Null,ANNEESCOLAIRE);
					}
					else {
						$anScolaire = Null;
						$niveauPre = Null;
						$resultatsPrec = Null;
						$mentions = Null;
						}
				$listePIA[$matricule] = array(
					'detailsEleve'=>$detailsEleve,
					'degre'=>$degre,
					'ceb'=>$ceb,
					'annee'=>$niveauPre,
					'anScolaire'=>$anScolaire,
					'listeCoursActuelle'=>$listeCoursGrp,
					'infosMedic'=>$infosMedic,
					'resultats'=>$resultatsPrec['resultats'],
					'listeCours'=>$resultatsPrec['listeCours'],
					'listeProfs'=>$listeProfs,
					'mentions'=>$mentions
					);
				}
			$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
			$smarty->assign('listePIA',$listePIA);
			$smarty->assign('corpsPage','couverturePIA');
			}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur','selectClasseOuEleve');		
		break;
	}
?>
