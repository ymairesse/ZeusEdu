<?php

$listeNiveaux = Ecole::listeNiveaux();
$type = 'ecole';
$destinataire = 'all';
$smarty->assign('listeNiveaux', Ecole::listeNiveaux());

$unAn = time() + 365 * 24 * 3600;

// un niveau a-t-il été visité récemment?
$niveau = Application::postOrCookie('niveau', $unAn);
if ($niveau != '') {
    $listeClasses = $Ecole->listeClassesNiveau($niveau);
    $smarty->assign('listeClasses', $listeClasses);
    $type = 'niveau';
    $destinataire = $niveau;
    $smarty->assign('niveau', $niveau);

    $classe = Application::postOrCookie('classe', $unAn);
    if (in_array($classe, $listeClasses)) {
        $listeEleves = $Ecole->listeEleves($classe, 'groupe');
        $smarty->assign('listeEleves', $listeEleves);
        $type = 'classe';
        $destinataire = $classe;
        $smarty->assign('classe', $classe);

        $matricule = Application::postOrCookie('matricule', $unAn);
        if (in_array($matricule, array_keys($listeEleves))) {
            $type = 'eleve';
            $destinataire = $matricule;
            $smarty->assign('matricule', $matricule);
            }
        }
    }

$smarty->assign('editable', true);

switch ($type) {
    case 'niveau':
        $lblDestinataire =  $Jdc->getLabel('niveau', $niveau);
        break;
    case 'classe':
        $lblDestinataire =  $Jdc->getLabel('classe', $classe);
        break;
    case 'eleve':
        $infos = Eleve::staticGetDetailsEleve($matricule);
        $lblDestinataire =  $Jdc->getLabel('eleve', $matricule, $infos);
        break;
    default:
        $lblDestinataire =  $Jdc->getLabel('ecole','');
        break;
    }
$smarty->assign('type', $type);

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

$smarty->assign('destinataire', $destinataire);
$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->assign('selecteur', 'selecteurs/selectNiveauClasseEleve');

if ($type != '')
    $smarty->assign('corpsPage', 'jdc/jdcAny');
