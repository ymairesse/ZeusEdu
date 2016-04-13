<?php

$date = isset($_POST['date']) ? $_POST['date'] : null;
$smarty->assign('date', $date);

$type = isset($_POST['type']) ? $_POST['type'] : null;
$smarty->assign('type', $type);

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();
// recherche des dates de réunions de parents déjà existantes
$listeReunions = $thot->listeDatesReunion();
$smarty->assign('listeDates', $listeReunions);

switch ($mode) {
    case 'periodesAdmin':
        $listeProfs = $thot->listeProfsRP();
        $smarty->assign('listeProfs', $listeProfs);
        // voir et administrerr les RV pour une date donnée
        if ($userStatus == 'admin') {
            // gestion de la réunion de parents pour tous les profs
            if ($date != '') {
                $smarty->assign('listePeriodes', $thot->getListePeriodes($date));
                switch ($type) {
                    // attribution des RV par élève
                    case 'eleve':
                        $smarty->assign('listeClasses', $Ecole->listeClasses(null, true));
                        $smarty->assign('corpsPage', 'reunionParents/adminEleves');
                        break;
                    // attribution des RV par prof
                    case 'prof':
                        // l'abréviation est celle du prof à affecter
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
                    }
            }
        }
        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;
    case 'periodesProfs':
        // gestion de la réunion de parent du prof utilisateur
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

        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'editNew':
        $listeProfs = $Ecole->listeProfs();
        $smarty->assign('listeProfs', $listeProfs);
        if (isset($date)) {
            $dateSql = Application::dateMysql($date);
            $infoRp = $thot->getInfoRp($date);
            $smarty->assign('infoRp', $infoRp);
            $locaux = $thot->getLocauxRp($date);
            $smarty->assign('locaux', $locaux);
        }
        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        $smarty->assign('firstLine', 'Nouvelle réunion de parents');
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        break;

    case 'delRP':
        $thot->delRP($date);
        // recherche des dates de réunions de parents encore existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('date', '');
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $message = array(
            'title' => DELETE,
            'texte' => 'Suppression effectuée',
            'urgence' => 'warning', );
        $smarty->assign('message', $message);
        break;

    case 'enregistrer':
        switch ($etape) {
            case 'etape1':
                // enregistrement du canevas général de la réunion de parents
                $nb = $thot->saveRPinit($_POST);
                $message = array(
                    'title' => 'Enregistrement',
                    'texte' => sprintf('%d plages de RV enregistrées', $nb),
                    'urgence' => 'success'
                    );
                break;
            case 'etape2':
                $retour = $thot->saveRPinit2($_POST);
                $message = array(
                    'title' => SAVE,
                    'texte' => $retour['texte'],
                    'urgence' => $retour['urgence']
                    );
                break;
            case 'locaux':
                $nb = $thot->saveLocaux($_POST);
                $message = array(
                    'title' => SAVE,
                    'texte' => sprintf('%d enregistrements effectués',$nb),
                    'urgence' => 'success'
                    );
                break;
        }
        $smarty->assign('message', $message);
        $smarty->assign('mode', 'editNew');
        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $infoRp = $thot->getInfoRp($date);
        $smarty->assign('infoRp', $infoRp);
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
