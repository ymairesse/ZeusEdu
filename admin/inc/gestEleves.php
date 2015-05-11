<?php
require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$Ecole = new Ecole();
// liste de plusieurs classes à grouper = $classes
// une seule classe venant d'une liste de sélection = $selectClasse
// un groupe reprenant plusieurs classes = $groupe
// un élève = $matricule

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$groupe = isset($_POST['groupe'])?$_POST['groupe']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$classes = isset($_POST['classes'])?$_POST['classes']:Null;
$laClasse = isset($_POST['laClasse'])?$_POST['laClasse']:Null;

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('etape',$etape);

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('laClasse', $laClasse);
if ($laClasse != '') {
	$listeEleves = $Ecole->listeEleves($laClasse,'classe');
	$smarty->assign('listeEleves', $listeEleves);
	}
if (isset($matricule))
	$Eleve = new Eleve($matricule);

switch ($mode) {
	case 'addEleve':
		$smarty->assign('eleve',Null);
		$smarty->assign('mode','save');
		$smarty->assign('recordingType','new');
		$smarty->assign('corpsPage', 'inputEleve');
		break;
	case 'save':
		$nbModifications = $Eleve->enregistrer($_POST);
		$smarty->assign('laClasse', $laClasse);
		$smarty->assign('message', array(
				'title'=>'Information',
				'texte'=>"$nbModifications modification(s)",
				'urgence'=>'success'));
		$smarty->assign('matricule',$matricule);
		$smarty->assign('etape','showEleve');
		$smarty->assign('selecteur','selectClasseEleve');
		// break;  // PAS DE BREAK
		
	case 'modifEleve':
		switch ($etape) {
			case 'showEleve':
				$smarty->assign('eleve',$Eleve->getDetailsEleve());
				$smarty->assign('info', $Ecole->getUserPasswdEleve($matricule));
				$smarty->assign('matricule', $matricule);
				$smarty->assign('selecteur','selectClasseEleve');
				$smarty->assign('mode', 'save');
				// on ouvre le formulaire en modification
				$smarty->assign('recordingType','modif');
				$smarty->assign('corpsPage', 'inputEleve');
				break;
			default:
				// choix de l'élève
				$smarty->assign('selecteur','selectClasseEleve');
				break;
		}
		break;

	case 'supprEleve':
		switch ($etape) {
			case 'confirmer':
				$listeEleves = $_POST['eleves'];
				$nb = $Ecole->supprEleves($listeEleves);
				$smarty->assign("message", array(
					'title'=>'Information',
					'texte'=>"$nb élève(s) supprimé(s) de la base de données",
					'urgence'=>'warning'
					));
				// break; pas de break
			default:
				$smarty->assign('listeEleves', $Ecole->listOrphanEleves());
				$smarty->assign('corpsPage', 'selectEleveDel');
				break;
			}
		break;
	case 'unGroup':
		$listUngroup = array();
		foreach ($_POST as $field=>$value) {
			$field = explode("_", $field);
			if ($field[0] == 'checkbox') {
				$Ecole->ungroup($value);
				$listUngroup[]=$value;
				}
			}
		$listeGroupes = implode($listUngroup,', ');
		$smarty->assign('message',array(
			'title'=>'Dégroupage',
			'texte'=>"Les groupe $listeGroupes ont été défaits",
			'urgence'=>'success'
			));
		// pas de break: on continue sur la gestion des groupes
	case 'groupEleve':
		if (isset($groupe)) {
			if (isset($classes))
				$nb = $Ecole->saveGroupesClasses($groupe, $classes);
				$smarty->assign('message',array(
						'title'=>'Formation de groupes',
						'texte'=>"Le groupe $groupe a été formé",
						'urgence'=>'success'
						));
			}
		$listeClasses = $Ecole->listeClasses();
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('selectedClasses',$classes);
		$listeGroupes = $Ecole->listeGroupesEtClasses(true);	// true = format compact, rien que les vrais groupes
		$smarty->assign('listeGroupes',$listeGroupes);
		$smarty->assign ('corpsPage','groupeClasses');
		break;
	case 'envoiPhotos':
		require ('envoiPhotosZip.inc.php');
		break;
	case 'attribMdp':
		switch ($etape) {
			case 'save':
				$longueur = isset($_POST['longueur'])?$_POST['longueur']:Null;
				if (!(isset($longueur)) || !(is_numeric($longueur)) || ($longueur < 3) || $longueur > 12)
					die('incorrect value');
				$nbResultats = $Ecole->attribPasswdEleves($longueur);
				$smarty->assign("message", array(
					'title'=>"Mots de passe",
					'texte'=>"$nbResultats mot(s) de passe attribué(s)",
					'urgence'=>'success'
					));
			// break;  pas de break
			default:
				$smarty->assign('corpsPage','complexitePasswd');
			break;
		}
		break;
	default: die("missing mode");
	}
?>
