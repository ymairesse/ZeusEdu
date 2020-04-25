<?php

$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);
// $classe = isset($_POST['classe'])?$_POST['classe']:Null;

$matricule = Application::postOrCookie('matricule', $unAn);
// $matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;

switch ($mode) {
	case 'fichesDisc':
		switch ($etape) {
			case 'enregistrer':
				Bulletin::enregistrerFichesDisc($_POST);
				break;
			case 'selection':
				$dates[0] = $_POST['date_0'];
				$dates[1] = $_POST['date_1'];
				$selectionEleves = Bulletin::selectEleveFromPageDisc ($classe, $dates[0], $dates[1]);
				$smarty->assign("classe", $classe);
				$smarty->assign("dates",$dates);
				$smarty->assign("action","educ");
				$smarty->assign("mode","ficheDisc");
				$smarty->assign("etape","enregistrer");
				$smarty->assign("selection",$selectionEleves);
				$smarty->assign("bulletin",$bulletin);
				$smarty->assign("corpsPage","choixImpression");
				// pas de break;
			default:
				$listeClasses = $Ecole->listeClasses();
				$smarty->assign("action","educ");
				$smarty->assign("mode","fichesDisc");
				$smarty->assign("etape","selection");
				$smarty->assign("listeClasses",$listeClasses);
				$smarty->assign("selecteur", "selectClasse2dates");
				break;
		}
		break;
		case 'noteEduc':
			$listePeriodes = $Bulletin->listePeriodes(NBPERIODES);
			$smarty->assign('acronyme', $acronyme);
			$smarty->assign('nbBulletins', NBPERIODES);
			$smarty->assign('bulletin', $bulletin);
			$listeClasses = $Ecole->listeGroupes();
			$smarty->assign('listeClasses', $listeClasses);
			$smarty->assign('classe', $classe);
			$smarty->assign('etape', 'showClasse');
			$smarty->assign('selecteur', 'selecteurs/selectBulletinClasse');
			switch ($etape) {
				case 'enregistrer':
					$nb = $Bulletin->saveCommentEduc($_POST, $acronyme);
					$smarty->assign('message', array(
	                                'title' => SAVE,
	                                'texte' => sprintf('%d enregistrement(s) effectué(s)', $nb),
	                                'urgence' => 'success', )
	                                );
					// break; pas de break;
				case 'showClasse':
					$listeEleves = $Ecole->listeElevesClasse($classe);
					$listeCommentaires = $Bulletin->listeCommentairesEduc($listeEleves);
					$smarty->assign('listeCommentaires', $listeCommentaires);
					$smarty->assign('listeEleves', $listeEleves);
					$smarty->assign('matricule', $matricule);
					$smarty->assign('corpsPage', 'encodageBulletin/encodageEduc');
					break;
				default:
					break;
			}
			break;
	default: echo "missing mode";
		break;
	}
