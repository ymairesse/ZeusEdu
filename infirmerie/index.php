<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");
// ----------------------------------------------------------------------------
//

$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$consultID = isset($_POST['consultID'])?$_POST['consultID']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('selecteur', 'selectClasseEleve');

require_once(INSTALL_DIR."/$module/inc/classes/classVisite.inc.php");

// le sélecteur retourne une valeur pour $matricule ou pour $matricule2
if (($matricule != '') || ($matricule2 != '')) {
	$matricule = ($matricule!='')?$matricule:$matricule2;
    // si un matricule est donné, on aura sans doute besoin des données de l'élève
    $eleve = new Eleve($matricule);
    $smarty->assign('eleve', $eleve->getDetailsEleve());
	$titulaires = $eleve->titulaires($matricule);
	$smarty->assign('titulaires', $titulaires);
    require_once("inc/classes/classInfirmerie.inc.php");
    $infirmerie = new eleveInfirmerie($matricule);
    }

$smarty->assign('lesGroupes', $Ecole->listeGroupes());
$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);
$smarty->assign('matricule2',$matricule2);

$listeEleves = $classe!=''?$Ecole->listeEleves($classe):Null;
$smarty->assign('listeEleves',$listeEleves);

switch ($action) {
	case 'parEleve':
		if (isset($matricule)) {
            $smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
            $smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
            }
		$action = $action;
		$mode = 'wtf';
		$smarty->assign('corpsPage','ficheEleve');
		break;
    case 'modifier':
        if (isset($matricule)) {
        switch ($mode) {
            case 'medical':
                $smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
				$action = 'enregistrer';
				$mode = 'medical';
				$smarty->assign('corpsPage','modifMedical');
                break;
            case 'visite':
                // modifier les données d'une visite à l'infirmerie
                $smarty->assign('listeProfs', $Ecole->listeProfs());
                if ($consultID) { // c'est une modification d'une visite existante
                    $smarty->assign('consultID',$consultID);
                    $smarty->assign('visites',$infirmerie->getVisitesEleve($matricule, $consultID));
                    }
                    else { // c'est une nouvelle visite
                        $smarty->assign('visites',Null);
                        }
				$action = 'enregistrer';
				$mode = 'visite';
                $smarty->assign('corpsPage','modifVisite');
                break;
            }
        }
        break;
    case 'supprimer':
        if (isset($matricule)) {
            // suppression d'une visite à l'infirmerie
            if ($consultID) {
                $nbResultats = $infirmerie->deleteVisite($consultID);
				$smarty->assign('message', array(
					'title'=>'Suppression',
					'texte'=>"Effacement de: $nbResultats visite"),
				3000);
                }
            }
		$smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
		$smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
        $smarty->assign('classe',$classe);
		$action = 'parEleve';
		$mode = 'wtf';
        $smarty->assign('corpsPage', "ficheEleve");
        break;
    case 'enregistrer':
        if (isset($matricule)) {
            switch ($mode) {
                case 'medical':
                    $nb = $infirmerie->enregistrerMedical($_POST);
					$smarty->assign("message", array(
						'title'=>SAVE,
						'texte'=>"Enregistrement de: $nb fiche"),
						3000);
                    break;
                case 'visite':
                    $nb = $infirmerie->enregistrerVisite($_POST);
					$smarty->assign("message", array(
						'title'=>SAVE,
						'texte'=>"Enregistrement de: $nb visite"),
						3000);
                    break;
                }
            $smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
            $smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
            $smarty->assign('classe',$classe);
			$action = 'parEleve';
			$mode = 'wtf';
            $smarty->assign('corpsPage', 'ficheEleve');
        }
        break;
	case 'recherche':
		if ($mode == 'parDate') {
			if ($etape == 'showliste') {
				$dateDebut = $_POST['dateDebut'];
				$dateFin = $_POST['dateFin'];
				$dateDebutSQL = implode("-",array_reverse(explode("/",$dateDebut)));
				$dateFinSQL = implode("-",array_reverse(explode("/",$dateFin)));
				$smarty->assign("dateDebut", $dateDebut);
				$smarty->assign("dateFin", $dateFin);
				if ($dateDebut && $dateFin && ($dateDebutSQL <= $dateFinSQL)) {
					$listeVisites = visiteInfirmerie::listeVisitesParDate($dateDebutSQL, $dateFinSQL);
					$smarty->assign('listevisites', $listeVisites);
					$smarty->assign('corpsPage', 'listesParDates');
					}
				}
			$smarty->assign('action',$action);
			$smarty->assign('mode',$mode);
			$smarty->assign('etape', 'showliste');
			$smarty->assign('selecteur', 'selectPeriode');
			}
		break;
	case 'news':
		$autorise = array('educ','admin');
		if (in_array($user->userStatus($module), $autorise))
			include ("inc/delEditNews.php");
		break;
	default:
		include ("inc/news.php");
		break;
	}
$action = ($action==Null)?'parEleve':$action;
$mode = ($mode==Null)?'wtf':$mode;

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

// si rien n'a encore été assigné au sélecteur, on présente le sélecteur par défaut.
if ($smarty->getTemplateVars('selecteur') == Null)
	$smarty->assign('selecteur', 'selectClasseEleve');

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
