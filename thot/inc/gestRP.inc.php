<?php

$date = isset($_POST['date']) ? $_POST['date'] : null;
$typeGestion = isset($_POST['typeGestion']) ? $_POST['typeGestion'] : null;

$smarty->assign('date', $date);

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();
// recherche des dates de réunions de parents déjà existantes
$listeReunions = $thot->listeDatesReunion();
$smarty->assign('listeDates', $listeReunions);

$infoRP = $thot->getInfoRp($date);

$typeRP = $infoRP['typeRP'];
$smarty->assign('typeRP',$typeRP);

switch ($mode) {
    case 'periodesAdmin':
        if ($typeRP == 'profs')
            $listeProfs = $thot->listeProfsRP();
            else $listeProfs = $Ecole->initalListe($Ecole->listeProfsTitus(true));

        $smarty->assign('listeProfs', $listeProfs);
        // voir et administrer les RV pour une date donnée
        if ($userStatus == 'admin') {
            // gestion de la réunion de parents pour tous les profs
            if ($date != '') {
                $smarty->assign('listePeriodes', $thot->getListePeriodes($date));
                switch ($typeGestion) {
                    // attribution des RV par élève
                    case 'eleve':
                        $smarty->assign('listeClasses', $Ecole->listeClasses(null, true));
                        $smarty->assign('corpsPage', 'reunionParents/adminEleves');
                        break;
                    // attribution des RV par prof
                    case 'prof':
                        $smarty->assign('listeRV', null);
                        $smarty->assign('listeAttente', null);
                        if (isset($abreviation)) {
                            $smarty->assign('abreviation', $abreviation);
                            $listeRV = $thot->getRVprof($abreviation, $date);
                            $listeAttente = $thot->getListeAttenteProf($date, $acronyme);
                            $smarty->assign('listeRV', $listeRV);
                            $smarty->assign('listeAttente', $listeAttente);
                        }
                        $smarty->assign('corpsPage', 'reunionParents/adminProfs');
                        break;
                    default: die("wtf");
                        break;
                    }
                    $smarty->assign('typeRP', $typeRP);
            }
        }

        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'periodesProfs':
        if ($typeRP == 'titulaires') {
            if($date != '') {
                $smarty->assign('acronyme',$acronyme);
                $smarty->assign('listePeriodes', $thot->getListePeriodes($date));

                $listeRV = $thot->getRVprof($acronyme, $date);
                $smarty->assign('listeRV', $listeRV);

                $listeAttente = $thot->getListeAttenteProf($date, $acronyme);
                $smarty->assign('listeAttente', $listeAttente);

                $nomProf = User::identiteProf($acronyme);
                $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

                $listeClasses = $user->listeTitulariats();
                $listeEleves = $Ecole->listeElevesMultiClasses($listeClasses);
                
                $smarty->assign('listeEleves', $listeEleves);
                $smarty->assign('corpsPage', 'reunionParents/adminTitu');
            }
        }
        else {
        // gestion de la réunion de parent par le prof utilisateur
        if ($date != '') {
            $smarty->assign('acronyme', $acronyme);
            $smarty->assign('listePeriodes', $thot->getListePeriodes($date));

            $nomProf = User::identiteProf($acronyme);
            $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

            $listeRV = $thot->getRVprof($acronyme, $date);
            $smarty->assign('listeRV', $listeRV);

            $listeAttente = $thot->getListeAttenteProf($date, $acronyme);
            $smarty->assign('listeAttente', $listeAttente);

            $smarty->assign('corpsPage', 'reunionParents/gestionRVprof');
        }
    }
        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'editNew':
        if (isset($date)) {
            $listeProfs = $thot->listeProfsAvecRv($date);
            $smarty->assign('listeProfs', $listeProfs);
            $dateSql = Application::dateMysql($date);
            $listeHeuresRP = $thot->getListeHeuresRP($date);
            $smarty->assign('listeHeuresRP', $listeHeuresRP);
            $infoRp = $thot->getInfoRp($date);
            $smarty->assign('infoRp', $infoRp);
            $locaux = $thot->getLocauxRp($date);
            $smarty->assign('locaux', $locaux);
            $smarty->assign('readonly', true);
        }

        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        break;

    case 'delRP':
        $thot->delRP($date);
        // recherche des dates de réunions de parents encore existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('date', '');
        $smarty->assign('listeProfs', Null);
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $message = array(
            'title' => DELETE,
            'texte' => 'Suppression effectuée',
            'urgence' => 'warning',
            );
        $smarty->assign('message', $message);
        $smarty->assign('mode', 'editNew');
        break;

    case 'enregistrer':
        // récupérer l'onglet précédemment actif
        $onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;
        $smarty->assign('onglet', $onglet);

        switch ($etape) {
            case 'etape1':
                // enregistrement du canevas général de la réunion de parents
                $result = $thot->saveNewRpDate($_POST);
                $nb = $thot->saveRPinit($_POST);
                $message = array(
                    'title' => SAVE,
                    'texte' => sprintf('%d plages de RV enregistrées', $nb),
                    'urgence' => 'success',
                    );
                break;
            case 'etape2':
                $retour = $thot->saveRPinit2($_POST);
                $message = array(
                    'title' => $retour['title'],
                    'texte' => $retour['texte'],
                    'urgence' => $retour['urgence'],
                    );
                break;
            case 'locaux':
                $nb = $thot->saveLocaux($_POST);
                $message = array(
                    'title' => SAVE,
                    'texte' => sprintf('%d enregistrements effectués', $nb),
                    'urgence' => 'success',
                    );
                break;
        }

        $date = $_POST['date'];
        $smarty->assign('listeProfs', $thot->listeProfsAvecRv($date));

        $locaux = $thot->getLocauxRp($date);
        $smarty->assign('locaux', $locaux);

        $smarty->assign('message', $message);
        $smarty->assign('mode', 'editNew');
        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        // recherche des caractéristiques globales de le RP de la date $date
        $smarty->assign('infoRp', $thot->getInfoRp($date));
        $smarty->assign('listeHeuresRP', $thot->getListeHeuresRP($date));

        $smarty->assign('readonly', true);

        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        break;

    case 'delRV':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        // relecture des informations
        $infoRV = $thot->getInfoRV($id);

        // envoi du mail d'information sauf si l'inscriptION a été faite par l'administration
        if ($infoRV['userParent'] != '') {
            include 'inc/reunionParents/mailAnnulation.inc.php';
        }

        // suppression effective du RV
        $nb = $thot->delRV($id);

        // la variable $acronyme est déjà prise pour le nom d'utilisateur => $abreviation
        $abreviation = $infoRV['acronyme'];
        $nomProf = User::identiteProf($abreviation);
        $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
        $smarty->assign('acronyme', $abreviation);

        $date = $infoRV['date'];
        $smarty->assign('date', $date);

        $smarty->assign('listePeriodes', $thot->getListePeriodes($date));

        $listeEleves = $thot->getElevesDeProf($abreviation);
        $smarty->assign('listeEleves', $listeEleves);

        $listeProfs = $thot->listeProfsRP();
        $smarty->assign('listeProfs', $listeProfs);

        $listeRV = $thot->getRVprof($abreviation, $date);
        $smarty->assign('listeRV', $listeRV);

        $listeAttente = $thot->getListeAttenteProf($date, $acronyme);
        $smarty->assign('listeAttente', $listeAttente);

        $smarty->assign('selecteur', 'selecteurs/selectDateType');

        if ($type == 'prof') {
            $smarty->assign('corpsPage', 'reunionParents/adminProfs');
        } else {
            $smarty->assign('corpsPage', 'reunionParents/adminEleves');
        }
        break;

    case 'printEleves':
        if (isset($date) && ($date != '')) {
            $smarty->assign('acronyme', $acronyme);
            $smarty->assign('date', $date);

            $smarty->assign('corpsPage', 'reunionParents/choixRVParents2pdf');
        }
        $smarty->assign('firstLine', 'Choisir une date');
        $smarty->assign('selecteur', 'selecteurs/selectDate');

        break;
    default:
        // wtf
}
