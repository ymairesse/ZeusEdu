<?php
$unAn = time() + 365*24*3600;

require_once(INSTALL_DIR."/$module/inc/classes/classJdc.inc.php");
$jdc = new Jdc();

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$startDate = isset($_POST['startDate'])?$_POST['startDate']:Null;
$viewState = isset($_POST['viewState'])?$_POST['viewState']:Null;

switch ($mode) {

   case 'delete':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        $verifId = $jdc->verifIdProprio($id, $acronyme);
        if ($id == $verifId) {
            $nb = $jdc->deleteJdc($id);
            }
            else die('Ce journal de classe ne vous appartient pas');
            $message = array(
                'title'=>DELETE,
                'texte'=>sprintf('%d enregistrement supprimé',$nb),
                'urgence'=>$nb=1?'success':'warning'
                );
            $smarty->assign('message',$message);
            $smarty->assign('corpsPage','jdc');
        break;

    case 'save':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        // est-ce une mise à jour d'un enregistrement existant?
        if ($id != Null) {
            $verifId = $jdc->verifIdProprio($id, $acronyme);
            if ($id == $verifId) {
                $nb = $jdc->saveJdc($_POST,$acronyme);
                }
            else die('Ce journal de classe ne vous appartient pas');
            }
            // ou est-ce une nouvelle notification? // alors, on n'a pas encore d'id
            else {
                // on récupère l'id de l'enregistrement qui est renvoyé par la procédure
                $id = $jdc->saveJdc($_POST,$acronyme);
                $nb= ($id != Null)?1:0;
                }

        $message = array(
            'title'=>SAVE,
            'texte'=>sprintf('%d enregistrement effectué',$nb),
            'urgence'=>$nb=1?'success':'warning'
            );
        $smarty->assign('message',$message);
        if ($id != Null) {
            $smarty->assign('acronyme',$acronyme);
            $travail = $jdc->getTravail($id);

            $smarty->assign('travail',$travail);
            if ($travail['type'] == 'cours') {
                $coursGrp = $travail['destinataire'];
                $smarty->assign('coursGrp',$coursGrp);
                $smarty->assign('mode','cours');
                $smarty->assign('selecteur','selecteurs/selectCours');
                $smarty->assign('lblDestinataire',$jdc->denomination($listeCours,'cours',$coursGrp));
                }
                else if ($travail['type'] == 'classe') {
                    $classe = $travail['destinataire'];
                    $listeClasses = $user->listeTitulariats("'G','TT','S','C','D'");
                    $smarty->assign('listeClasses',$listeClasses);
                    $smarty->assign('classe',$classe);
                    $smarty->assign('mode','classe');
                    $smarty->assign('selecteur','selecteurs/selectClasse');
                    $smarty->assign('lblDestinataire',$jdc->denomination(Null,'classe',$classe));
                }
            }

        $smarty->assign('corpsPage','jdc');
        break;

    case 'cours':
        // les infos provenant de l'URL ou du formulaire selectCours viennent en GET
        // priorité au GET
        setcookie('type','coursGrp',$unAn, null, null, false, true);
        if (isset($_GET['coursGrp'])) {
            $coursGrp = $_GET['coursGrp'];
            setcookie('coursGrp',$coursGrp,$unAn, null, null, false, true);
            }
            // sinon, on voit s'il y a un Cookie existant
            else $coursGrp = (isset($_COOKIE['coursGrp']))?$_COOKIE['coursGrp']:Null;
        $smarty->assign('coursGrp',$coursGrp);  // pour le sélecteur
        $smarty->assign('selecteur','selecteurs/selectCours');
        $smarty->assign('lblDestinataire',$jdc->denomination($listeCours,$mode,$coursGrp));
        $smarty->assign('corpsPage','jdc');
        break;

    case 'classe':
        setcookie('type','classe',$unAn, null, null, false, true);
        $listeClasses = $user->listeTitulariats("'G','TT','S','C','D'");
        $smarty->assign('listeClasses',$listeClasses);
        // les infos provenant de l'URL ou du formulaire selectCours viennent en GET
        // priorité au GET
        if (isset($_GET['classe'])) {
            $classe = $_GET['classe'];

            setcookie('classe',$classe,$unAn, null, null, false, true);
            }
            else $classe = (isset($_COOKIE['classe']))?$_COOKIE['classe']:Null;

        $smarty->assign('classe',$classe);  // pour le sélecteur
        $smarty->assign('selecteur','selecteurs/selectClasse');
        $smarty->assign('lblDestinataire',$jdc->denomination($listeCours,$mode,$classe));
        $smarty->assign('corpsPage','jdc');
        break;

    case 'eleves':
        setcookie('type','eleves',$unAn, null, null, false, true);
        if (isset($_GET['matricule'])) {
            $matricule = $_GET['matricule'];
            setcookie('matricule',$matricule,$unAn, null, null, false, true);
            }
        if (isset($_GET['classe'])) {
            $classe = $_GET['classe'];
            setcookie('classe',$classe,$unAn, null, null, false, true);
            }
            else $classe = (isset($_COOKIE['classe']))?$_COOKIE['classe']:Null;
        $smarty->assign('classe',$classe);  // pour le sélecteur

        $listeClasses = $Ecole->listeClassesProf($acronyme);
        $smarty->assign('listeClasses',$listeClasses);

        $listeEleves=($classe!= Null)?$Ecole->listeEleves($classe,'groupe'):Null;
        if (isset($matricule)) {
            $eleve = $listeEleves[$matricule];
            $classeNomPrenom = sprintf('%s %s de %s',$eleve['prenom'], $eleve['nom'], $eleve['classe']);
            }
            else $classeNomPrenom = Null;
        $smarty->assign('lblDestinataire',$classeNomPrenom);
        $smarty->assign('classe',$classe);
        $smarty->assign('matricule',$matricule);
        $smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('selecteur','selecteurs/selectClasseEleve');
        $smarty->assign('corpsPage','jdc');

        break;

    default:
        // wtf
        break;
    }

$smarty->assign('legendeCouleurs',$jdc->categoriesTravaux());
$smarty->assign('startDate',$startDate);
$smarty->assign('viewState',$viewState);
