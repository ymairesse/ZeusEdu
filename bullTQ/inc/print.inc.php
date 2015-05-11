<?php
$classe = (isset($_POST['classe']))?$_POST['classe']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$smarty->assign('bulletin',$bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('acronyme', $acronyme);

$listeClasses = $Ecole->listeGroupes(array('TQ'));
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);

switch ($mode) {
	case 'indivEcran':
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur', 'selectBulletinClasseEleve');
		$listeEleves = $Ecole->listeEleves($classe,'groupe');
		$smarty->assign('listeElevesClasse', $listeEleves);
		$smarty->assign('matricule', $matricule);
		if ($etape == 'showEleve') {
			$eleve = new Eleve($matricule);
			$infoPersoEleve = $eleve->getDetailsEleve();
			$smarty->assign('eleve',$infoPersoEleve);
			$listeCoursGrp = $BullTQ->listeCoursGrpEleves($matricule);

			if (isset($listeCoursGrp) && isset($matricule)) {
				$listeCoursGrp = $listeCoursGrp[$matricule];
				$smarty->assign('listeCoursGrp', $listeCoursGrp);
				
				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
				$smarty->assign('listeProfs',$listeProfsCoursGrp);
				
				$listeCompetences = $BullTQ->listeCompetencesListeCoursGrp($listeCoursGrp);
				$smarty->assign('listeCompetences', $listeCompetences);

				$listeCotesGlobales = $BullTQ->listeCotesGlobales($listeCoursGrp, $bulletin);
				if ($listeCotesGlobales != Null)
					$smarty->assign('cotesGlobales',$listeCotesGlobales[$bulletin]);
					else $smarty->assign('cotesGlobales',Null);

				$listeCotesGeneraux = $BullTQ->toutesCotesCoursGeneraux($listeCoursGrp, $matricule, $bulletin);
				$smarty->assign('listeCotesGeneraux', $listeCotesGeneraux);
				
				$listeCommentaires = $BullTQ->listeCommentaires($matricule, $listeCoursGrp);
				$smarty->assign('commentaires', $listeCommentaires);
				
				$remarqueTitu = $BullTQ->remarqueTitu($matricule, $bulletin);
				$smarty->assign('remarqueTitu', $remarqueTitu);	
				$smarty->assign('corpsPage','bulletinEcran');
			}
		}
		
		break;
	case 'indivPDF':
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur', 'selectBulletinClasseEleve');
		$listeEleves = $Ecole->listeEleves($classe,'groupe');
		$smarty->assign('listeElevesClasse', $listeEleves);
		$smarty->assign('matricule', $matricule);
		if ($etape == 'showEleve') {
			$eleve = new Eleve($matricule);
			$infoPersoEleve = $eleve->getDetailsEleve();
			$link = $BullTQ->createPDFeleve($acronyme, $infoPersoEleve, $bulletin);
			$smarty->assign("corpsPage", "corpsPDF");
			}
		
		break;
	case 'classePDF':
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('etape', 'showClasse');
		$smarty->assign('selecteur', 'selectBulletinClasse');
		if ($etape == 'showClasse') {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			if ($user->userStatus($Application->repertoireActuel()) != 'admin')
				$Application->vider ("./pdf/$acronyme");
				
			$link = $BullTQ->createPDFclasse($acronyme, $listeEleves, $classe, $bulletin);
			$smarty->assign("corpsPage", "corpsPDF");	
			}
		
		break;
}

?>
