<?php

$eleve = new Eleve($matricule);
$dataEleve = $eleve->getDetailsEleve();
$smarty->assign('eleve', $dataEleve);

$classe = $dataEleve['groupe'];
$smarty->assign('classe',$classe);

$listeEleves = $Ecole->listeEleves($classe,'groupe');
$smarty->assign('listeEleves',$listeEleves);

$prevNext = $Ecole->prevNext($matricule, $listeEleves);
$smarty->assign('prevNext',$prevNext);

$titulaires = $eleve->titulaires($matricule);
$smarty->assign('titulaires', $titulaires);

require_once(INSTALL_DIR."/infirmerie/inc/classes/classInfirmerie.inc.php");
$infirmerie = new eleveInfirmerie($matricule);

$smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
$smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));

$smarty->assign('noBulletin',PERIODEENCOURS);
$smarty->assign('listeBulletins', range(0, PERIODEENCOURS));

require_once(INSTALL_DIR."/ades/inc/classes/classEleveAdes.inc.php");
$ficheDisc = new EleveAdes($matricule);
$smarty->assign('ficheDisc',$ficheDisc);

require_once(INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();
$smarty->assign('listeTypesFaits', $Ades->getTypesFaits());
$smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
$smarty->assign('descriptionChamps', $Ades->listeChamps());

$athena = new Athena(Null,$matricule);

switch ($mode) {
    case 'new':
        $smarty->assign('visite',Null);
        $smarty->assign('listeProfs',$Ecole->listeProfs());
        $smarty->assign('proprietaire',$acronyme);
        $smarty->assign('corpsPage','modifVisite');
        break;
    case 'edit':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        $visite = $athena->getDetailsSuivi($id, $acronyme);
        $smarty->assign('visite',$visite);
        $smarty->assign('listeProfs',$Ecole->listeProfs());
        $smarty->assign('proprietaire',$acronyme);
        $smarty->assign('corpsPage','modifVisite');
        break;
    case 'enregistrer':
        $nb = $athena->saveSuiviEleve($_POST);
        $smarty->assign('message',array(
            'title'=>SAVE,
            'texte'=>"$nb note enregistrée",
            'urgence'=>'success'
            ));
        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi',$listeSuivi);
        $smarty->assign('listeProfs',$Ecole->listeProfs());
        $smarty->assign('corpsPage','ficheEleve');
        break;
    case 'delete':
        $nb = $athena->delSuiviEleve($_POST);
        $smarty->assign('message',array(
            'title'=>DELETE,
            'texte'=>"$nb note supprimée",
            'urgence'=>'warning'
            ));
        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi',$listeSuivi);
        $smarty->assign('corpsPage','ficheEleve');
        break;
    default:
        $smarty->assign('listeProfs',$Ecole->listeProfs());
        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi',$listeSuivi);
        $smarty->assign('corpsPage','ficheEleve');
        break;
    }
