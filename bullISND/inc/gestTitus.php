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

$classe = $Application->postOrCookie('classe', $unAn);

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();

// s'il n'y a qu'une classe dans la liste
if (count($listeTitus) == 1) {
	// alors, on prend le premier élément de la liste des classes
	$lesClasses = array_values($listeTitus);
	$classe = array_shift($lesClasses);
	}

// le prof est-il titulaire d'une classe de fin de degré
$tituFinDegre = false;
$arrayAnneeDegre = explode(',', ANNEEDEGRE);
if (count($listeTitus) > 0) {
	foreach ($listeTitus as $uneClasse){
		// on extrait l'année d'étude, le premier caractère de la classe
		$annee = substr($uneClasse, 0, 1);
		if (in_array($annee, $arrayAnneeDegre))
			$tituFinDegre = true;
	}
}

if ($classe != Null) {
	$listeEleves = $Ecole->listeEleves($classe, 'groupe');
}
else $listeEleves = Null;
$smarty->assign('listeEleves', $listeEleves);

$annee = ($classe != Null) ? SUBSTR($classe,0,1) : Null;
// récupérer l'onglet actif
$onglet = isset($_POST['onglet']) ? $_POST['onglet']: 0;

$smarty->assign('listeClasses', $listeTitus);
$smarty->assign('annee', $annee);
$smarty->assign('classe', $classe);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
$smarty->assign('onglet', $onglet);
$smarty->assign('tituFinDegre', $tituFinDegre);

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($mode) {
	case 'verrous':
		$smarty->assign ('selecteur', 'selecteurs/selectBulletinClasse');
		$smarty->assign('etape', 'showVerrous');
		if ($classe && $bulletin) {
			// $listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$listeCoursGrpClasse = $Ecole->listeCoursGrpClasse($classe);
			$listeCoursGrpEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeVerrous = $Bulletin->listeLocksBulletin($listeEleves, $listeCoursGrpClasse, $bulletin);

			// $smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeCoursGrpEleves', $listeCoursGrpEleves);
			$smarty->assign('listeCoursGrpClasse', $listeCoursGrpClasse);
			$smarty->assign('listeVerrous', $listeVerrous);
			$smarty->assign('corpsPage', 'titu/feuilleVerrous');
			}
		break;
	case 'remarques':
		$smarty->assign ('selecteur','selectBulletinClasseEleve');
		$smarty->assign('etape','showEleve');

		// si une classe a déjà été choisie -présente éventuellement dans un Cookie- ET que le prof est titulaire de cette classe
		if (isset($classe) && in_array($classe, $listeTitus)) {
			$smarty->assign('classe', $classe);
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
				$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin, true);
				$listeCoursGrp = $listeCoursGrp[$matricule];

				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);

				// pas d'indication de numéro de période, afin de les avoir toutes

				$commentairesProfs = $Bulletin->listeCommentairesTousCours($matricule, Null);

				// liste des mentions (grades) attribués durant cette année d'étude à l'élève dont on fournit le matricule
				$mentions = $Bulletin->listeMentions($matricule, Null, $annee);

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
				$remarqueTitulaire = isset($listeRemarquesTitulaire[$matricule]) ? $listeRemarquesTitulaire[$matricule] : Null;

				// notice relative au parcours scolaire
				$noticeParcours = $Bulletin->getNoticesParcours($matricule, $annee);
				$noticeParcours = ($noticeParcours != Null) ? $noticeParcours : Null;
				$noticeParcours = isset($noticeParcours[$annee]) ? $noticeParcours[$annee] : Null;

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

				$smarty->assign('listeRemarquesTitu', $listeRemarquesTitulaire);
				$smarty->assign('remarqueTitu', $remarqueTitulaire);
				$smarty->assign('noticeParcours', $noticeParcours);
				$smarty->assign('mentions',$mentions);

				$smarty->assign('corpsPage', 'commentairesTitu');
				break;
			default:
				break;
			}
			break;

	case 'padEleve':
		require_once 'titu/padEleve.inc.php';
		break;
	}
