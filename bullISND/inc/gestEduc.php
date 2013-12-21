<?php
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

switch ($mode) {
	case 'fichesDisc':
		switch ($etape) {
			case 'enregistrer':
				Bulletin::enregistrerFichesDisc($_POST);
				break;
			case 'selection':
				$dates[0] = $_POST['date_0'];
				$dates[1] = $_POST['date_1'];
				$classe = isset($_POST['classe'])?$_POST['classe']:Null;
				$selectionEleves = Bulletin::selectEleveFromPageDisc ($classe, $dates[0], $dates[1]);
				$smarty->assign("classe", $classe);
				$smarty->assign("dates",$dates);
				$smarty->assign("action","educ");
				$smarty->assign("mode","ficheDisc");
				$smarty->assign("etape","enregistrer");
				$smarty->assign("selection",$selectionEleves);
				$smarty->assign("bulletin",PERIODEENCOURS);
				$smarty->assign("corpsPage","choixImpression");
				// pas de break;
			default:
				$listeClasses = Ecole::listeClasses();
				$smarty->assign("action","educ");
				$smarty->assign("mode","fichesDisc");
				$smarty->assign("etape","selection");
				$smarty->assign("listeClasses",$listeClasses);
				$smarty->assign("selecteur", "selectClasse2dates");
				break;
		}
		break;
	default: echo "missing mode";
		break;
	}

?>
