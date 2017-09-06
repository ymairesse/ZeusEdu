<?php
//session_start();
//require_once ("../../config/BD/utilBD.inc.php");
//require_once ("../../inc/fonctions.inc.php");
//require_once ("../../config/constantes.inc.php");
//require_once ("fonctionsDelibes.inc.php");
//
//$codeInfo = isset($_GET['codeInfo'])?$_GET['codeInfo']:Null;
//$periodes = $_SESSION['configuration']['periodes'];
//
//if ($codeInfo != "")
//    {	
//	$cotesBrutes = listeCotesEleve($codeInfo);
//	// réorganisation du tableau issu de la requête
//	$listeCours = array();
//	foreach ($cotesBrutes as $unCoursPeriode)
//		{
//		$periode = $unCoursPeriode['periode'];
//		$listeCours[$periode][]=$unCoursPeriode;
//		}
//
//	$lesBilans = array();
//	foreach ($listeCours as $coursPeriode)
//		{
//		// initialisation du tableau de bilan pour la période
//		$bilan = initBilan();
//		foreach ($coursPeriode as $unCours)
//			{
//			$laCote = $unCours['cote'];
//			$periode = $unCours['periode'];
//			if ($laCote != "") {
//				// on supprime l'étoile éventuelle
//				$laCote = trim($laCote, "*");
//				// si la cote est entre crochets, elle ne compte pas
//				if (($laCote == trim($laCote, "[]")) && (trim($laCote) != "")) {
//					$bilan['nbheures'] += $unCours['nbheures'];
//					$bilan['nbBranches'] ++;
//					$bilan['nbCotes'] ++;
//					$bilan['total'] += $laCote;
//					if (($laCote < 50) && !($unCours['immunise'])) {
//						$bilan['nbEchecs']++;
//						$bilan['heuresEchecs'] += $unCours['nbheures'];
//						$bilan['coursEchec'] .= "/".$unCours['libelle'];
//						}
//					}
//				}
//			}
//		if ($bilan['nbCotes'] > 1)
//			$bilan['moyenne'] = number_format($bilan['total'] / $bilan['nbCotes'], 2);
//			else $bilan['moyenne'] = "--";
//		array_push($lesBilans, $bilan);
//		}
//	$listeCours = tourner ($listeCours);
//    }
//
//	require_once ("../../smarty/Smarty.class.php");
//	$smarty = new Smarty();
//	$smarty->template_dir = "../templates";
//	$smarty->compile_dir = "../templates_c";	
//	$smarty->assign("nomPrenomClasse", nomPrenomClasse($codeInfo));
//	$smarty->assign("periodes", $periodes);
//	$smarty->assign("nbPeriodes", count($periodes));
//	$smarty->assign("listeCours", $listeCours);
//	$smarty->assign("bilans", $lesBilans);
//	
//	$smarty->display("tableauCotesEleve.tpl");
?>
