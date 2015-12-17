<?php

$unAn = time() + 365*24*3600;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule', $matricule);

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$classe = Null;
// s'il n'y a qu'une classe dans la liste
if (count($listeTitus) == 1) {
	// alors, on prend le premier élément de la liste des classes
	$lesClasses = array_values($listeTitus);
	$classe = array_shift($lesClasses);
	}

$annee = ($classe != Null)?SUBSTR($classe,0,1):Null;
$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;

$smarty->assign('listeClasses', $listeTitus);
$smarty->assign('annee',$annee);
$smarty->assign('classe',$classe);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
$smarty->assign('onglet',$onglet);

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($mode) {
	case 'verrous':
		$smarty->assign ('selecteur','selectBulletinClasse');
		$smarty->assign('etape','showVerrous');
		switch ($etape) {
			case 'enregistrer':
				$nbEnregistrements = $Bulletin->saveLocksBulletin($_POST, $bulletin);
				$smarty->assign('message', array(
									'title'=>"Enregistrement des verrous",
									'texte'=>"$nbEnregistrements verrous activés",
									'urgence'=>'info')
									);
				// pas de break;
			default:
				if ($classe && $bulletin) {
					$listeEleves = $Ecole->listeEleves($classe,'groupe');
					$listeCoursGrpClasse = $Ecole->listeCoursGrpClasse($classe);
					$listeCoursGrpEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
					$listeVerrous = $Bulletin->listeLocksBulletin($listeEleves, $listeCoursGrpClasse, $bulletin);
					$smarty->assign('listeEleves',$listeEleves);
					$smarty->assign('listeCoursGrpEleves',$listeCoursGrpEleves);
					$smarty->assign('listeCoursGrpClasse',$listeCoursGrpClasse);
					$smarty->assign('listeVerrous',$listeVerrous);
					$smarty->assign('corpsPage','feuilleVerrous');
					}
				break;
			}
		break;
	case 'remarques':
		$smarty->assign ('selecteur','selectBulletinClasseEleve');
		$smarty->assign('etape','showEleve');
		// si une classe a déjà été choisie -présente éventuellement dans un Cookie- ET que le prof est titulaire de cette classe
		if (isset($classe) && in_array($classe,$listeTitus)) {
			$smarty->assign('classe',$classe);
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('listeEleves', $listeEleves);
			$prevNext = $Ecole->prevNext($matricule, $listeEleves);
			$smarty->assign('prevNext',$prevNext);
			}

		switch ($etape) {
			case 'enregistrer':
				$commentaire = isset($_POST['commentaire'])?$_POST['commentaire']:Null;
				$nbResultats = $Bulletin->enregistrerRemarque($commentaire, $matricule, $bulletin);
				$smarty->assign('message', array(
					'title'=>SAVE,
					'texte'=>'Commentaire enregistré',
					'urgence'=>'success'
					));
				// PAS DE BREAK;
			case 'showEleve':
				$annee = $Ecole->anneeDeClasse($classe);
				$eleve = new Eleve($matricule);
				$infoPersoEleve = $eleve->getDetailsEleve();

				// liste de tous les cours suivis par l'élève, y compris ceux qu'il ne suit plus (pas d'historique)
				$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
				$listeCoursGrp = $listeCoursGrp[$matricule];

				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);

				// pas d'indication de numéro de période, afin de les avoir toutes
				$commentairesProfs = $Bulletin->listeCommentairesTousCours($matricule, Null);
				// liste des mentions (grades) attribués durant cette année d'étude à l'élève dont on fournit le matricule
				$mentions = $Bulletin->listeMentions($matricule, Null, $annee);
				// fiche de discipline pour l'élève concerné
				$ficheEduc = $Bulletin->listeFichesEduc($matricule, $bulletin);

				// recherche des cotes de situation et délibé éventuelles pour toutes les périodes de l'année en cours
				$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
				$listeCoursActuelle = $listeCoursActuelle[$matricule];

				// cotes de gobal période pour le bulletin $bulletin
				$sommesTjCert = $Bulletin->sommesTJCertEleves($matricule, $bulletin);
				$ponderations = $Bulletin->getPonderationsBulletin($listeCoursGrp, $bulletin);
				$cotesPeriode = $Bulletin->cotesPeriodePonderees($sommesTjCert, $ponderations);

				$syntheseCotes4Titu = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);

				// pas d'indication de numéro de période, afin de les avoir toutes
				$listeRemarquesTitulaire = $Bulletin->remarqueTitu($matricule, Null);
				// s'il y a des remarques (possible qu'il n'y en ait pas à la période 1, avant le bulletin)
				$remarqueTitulaire = isset($listeRemarquesTitulaire[$matricule])?$listeRemarquesTitulaire[$matricule]:Null;

				// pas d'indication de numéro de bulletin afin de les avoir tous
				$tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, Null);
				$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
				$smarty->assign('matricule', $matricule);
				$smarty->assign('infoPerso', $infoPersoEleve);
				$smarty->assign('listeCoursGrp', $listeCoursGrp);
				$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
				$smarty->assign('commentairesProfs', $commentairesProfs);
				$smarty->assign('cotesPeriode',$cotesPeriode);

				$smarty->assign('syntheseCotes', $syntheseCotes4Titu);
				$smarty->assign('attitudes', $tableauAttitudes);
				$smarty->assign('ficheEduc', $ficheEduc);
				$smarty->assign('listeRemarquesTitu', $listeRemarquesTitulaire);
				$smarty->assign('remarqueTitu', $remarqueTitulaire);
				$smarty->assign('mentions',$mentions);

				$smarty->assign('corpsPage', 'commentairesTitu');
				break;
			default:
				break;
			}
			break;
		case 'padEleve':
			if ($etape == 'enregistrer') {
				$nb = $padEleve->savePadEleve($_POST);
				$texte = ($nb>0)?"$nb enregistrement(s) réussi(s)":"Pas de modification";
				$smarty->assign('message', array(
					'title'=>SAVE,
					'texte'=>$texte,
					'urgence'=>'success')
					);
				}

			// la liste des classes dont le prof est titulaire est dans $listeTitus
			if (isset($listeTitus)) {
				// la classe a été choisie? Sinon, on prend la première de la liste
				$classe = isset($_POST['classe'])?$_POST['classe']:current($listeTitus);
				$listeEleves = $Ecole->listeEleves($classe,'groupe');
				$smarty->assign('classe',$classe);
				$smarty->assign('listeClasses',$listeTitus);
				$smarty->assign('listeEleves',$listeEleves);

				if (isset($matricule) && ($matricule != '') && ($matricule != 'all')) {
					// le cookie pourrait contenir la valeur 'all' qui n'aurait pas de sens ici
					// si un matricule est donné, on aura sans doute besoin des données de l'élève
					$eleve = new Eleve($matricule);

					require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");
					$padEleve = new padEleve($matricule, $acronyme);

					$smarty->assign('padsEleve', $padEleve->getPads());

					// recherche des infos personnelles de l'élève
					$smarty->assign('eleve', $eleve->getDetailsEleve());
					// recherche des infos concernant le passé scolaire
					$smarty->assign('ecoles', $eleve->ecoleOrigine());

					// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
					$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
					$listeCoursActuelle = $listeCoursActuelle[$matricule];
					$smarty->assign('listeCoursGrp',$listeCoursActuelle);
					$syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
					$smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
					// résulats des épreuves externes dans le passé
					$smarty->assign('epreuvesExternes', $Bulletin->cotesExternesPrecedentes($matricule));
					// tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
					$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
					$smarty->assign('listeCoursActuelle', $listeCoursActuelle);
					$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);
					$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
					$smarty->assign('mentions', $Bulletin->listeMentions($matricule, Null, Null,Null));
					$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
					$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
					$titulaires = $eleve->titulaires($matricule);
					$smarty->assign('matricule',$matricule);
					$smarty->assign('titulaires', $titulaires);

					$smarty->assign('prevNext', $prevNext);
					$smarty->assign('etape','enregistrer');
					$smarty->assign('corpsPage', 'ficheEleve');
				}
			}
		$smarty->assign('selecteur','selectClasseEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;
	default:
		echo "bad mode $mode";
		break;
	}
?>
