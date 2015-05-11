<?php
$unAn = time() + 365*24*3600;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;

if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = isset($_COOKIE['classe'])?$_COOKIE['classe']:Null;
$smarty->assign('classe', $classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule', $matricule);

if (isset($_POST['niveau'])) {
	$niveau = $_POST['niveau'];
	setcookie('niveau',$niveau,$unAn, null, null, false, true);
	}
	else $niveau = isset($_COOKIE['niveau'])?$_COOKIE['niveau']:Null;
$smarty->assign('niveau', $niveau);

$acronyme = $_SESSION[APPLICATION]->getAcronyme();

switch ($mode) {
	case 'archive':
		$anneeScolaire = isset($_POST['anneeScolaire'])?$_POST['anneeScolaire']:Null;

		$smarty->assign('listeAnnees', $Bulletin->anneesArchivesDispo());
		$smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('etape','showEleve');
		$smarty->assign('selecteur','selectAnneeNiveauEleve');
		if ($etape == 'showEleve') {
			$listeElevesArchives = $Bulletin->listeElevesArchives($anneeScolaire, $niveau);
			$smarty->assign('listeEleves', $listeElevesArchives);
			$nomEleve = isset($_POST['nomEleve'])?$_POST['nomEleve']:Null;
			$anneeScolaire = isset($_POST['anneeScolaire'])?$_POST['anneeScolaire']:Null;
			$smarty->assign('nomEleve', $nomEleve);
			$smarty->assign('anneeScolaire', $anneeScolaire);
			$classeArchive = $Bulletin->classeArchiveEleve($matricule, $anneeScolaire);
			$smarty->assign('periodes', $Bulletin->listePeriodes(NBPERIODES));
			$smarty->assign('classeArchive', $classeArchive);
			$smarty->assign('corpsPage','bulletinsArchive');
		}
		break;

	case 'bulletinIndividuel':
		$listeClasses = $Ecole->listeGroupes(array('G','TT','S'));
		if ($classe != Null)
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			else $listeEleves = Null;
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('listeEleves',$listeEleves);
		$smarty->assign('nbBulletins',NBPERIODES);
		$smarty->assign('bulletin',$bulletin);
		$smarty->assign('etape','showEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur', 'selectBulletinClasseEleve');

		if ($etape == 'showEleve') {
			if ($matricule) {
				$smarty->assign('acronyme', $acronyme);
				// effacement de tous les fichiers PDF de l'utilisateur sauf pour les admins
				if ($user->userStatus($Application->repertoireActuel()) != 'admin')
					$Application->vider("./pdf/$acronyme");
				$dataEleve = array(
						'matricule'=>$matricule,
						'classe'=>$classe,
						'annee'=>$Ecole->anneeDeClasse($classe),
						'degre'=>$Ecole->degreDeClasse($classe),
						'titulaires'=>$Ecole->titusDeGroupe($classe)
						);
				$link = $Bulletin->createPDFeleve($dataEleve, $bulletin, $acronyme);
				$smarty->assign('link',$link);
				$smarty->assign('corpsPage', 'corpsPage');
				}
			}
		break;
	case 'bulletinClasse':
		// liste complète des noms des classes en rapport avec leur classe
		$listeClasses = $Ecole->listeGroupes(array('G','TT','S'));
		$smarty->assign('selecteur','selectBulletinClasse');
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('nbBulletins',NBPERIODES);
		$smarty->assign('bulletin',$bulletin);
		$smarty->assign('action',$action);
		$smarty->assign('mode', $mode);
		$smarty->assign('etape', 'showClasse');

		if ($etape == 'showClasse') {
			if ($classe) {
				// retourne la liste des élèves pour une classe donnée
				$listeEleves = $Ecole->listeEleves($classe,'groupe');
				// effacement de tous les fichiers PDF de l'utilisateur sauf pour les admins
				if ($user->userStatus($Application->repertoireActuel()) != 'admin')
					$Application->vider ("./pdf/$acronyme");
				$link = $Bulletin->createPDFclasse($listeEleves, $classe, $bulletin, $acronyme);
				$smarty->assign('acronyme', $acronyme);
				$smarty->assign('link',$link);
				$smarty->assign('corpsPage', 'corpsPage');
				}
			}
		break;
	case 'niveau':
		$smarty->assign('nbBulletins', NBPERIODES);
		$listeNiveaux = $Ecole->listeNiveaux();
		$smarty->assign('selecteur','selectBulletinNiveau');
		$smarty->assign('listeNiveaux',$listeNiveaux);
		$smarty->assign('bulletin',$bulletin);
		$smarty->assign('action',$action);
		$smarty->assign('mode', $mode);

		if ($etape == 'showNiveau') {
			if ($niveau) {
				$listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe', array('G','TT','S'));
				if ($user->userStatus($Application->repertoireActuel()) != 'admin')
					$Application->vider("./pdf/$acronyme");
				// accumuler tous les bulletins dans des fichiers par classe
				$listeEleves = Null;
				foreach ($listeClasses as $classe) {
					$listeEleves = $Ecole->listeEleves($classe,'groupe');
					$link = $Bulletin->createPDFclasse($listeEleves, $classe, $bulletin, $acronyme, true);
					}
				// zipper l'ensemble des fichiers
				if ($listeEleves != Null) {
					$Application->zipFilesNiveau("pdf/$acronyme", $bulletin, $listeClasses);
					$smarty->assign('acronyme', $acronyme);
					$smarty->assign('link',$niveau);
					$smarty->assign('corpsPage','corpsPage');
					}
				}
			}
		break;
	case 'delete':
		if ($etape == 'confirmation') {
			$listeFichiers = array();
			foreach ($_POST as $nomChamp=>$value) {
				if (preg_match('/^del#/',$nomChamp))
					$listeFichiers[] = $value;
					@unlink("./pdf/$acronyme/$value");
				}
			$nb = count($listeFichiers);
			if ($nb > 0) {
				$listeFichiers = implode(', ',$listeFichiers);
				$smarty->assign('message',array(
					'title'=>'Confirmation',
					'texte'=>"Le(s) fichier(s) $listeFichiers a/ont été effacé(s)",
					'urgence'=>'warning'
					));
				}
				else {
					$smarty->assign('message',array(
					'title'=>'Désolé',
					'texte'=>'Aucun fichier effacé',
					'urgence'=>'danger'
					));
				}
			}
		// break;  pas de break
	default:
		$listeFichiers = $Application->scanDirectories ("./pdf/$acronyme/");
		$smarty->assign('action', $action);
		$smarty->assign('mode', 'delete');
		$smarty->assign('etape', 'confirmation');
		$smarty->assign('acronyme',$acronyme);
		$smarty->assign('listeFichiers', $listeFichiers);
		$smarty->assign('userName', $acronyme);
		$smarty->assign('corpsPage', 'tableauFichiersPDF');
		break;
	}
?>
