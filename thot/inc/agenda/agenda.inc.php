<?php

$idAgenda = isset($_POST['agenda']) ? $_POST['agenda'] : Null;

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.Agenda.php';
$Agenda = new Agenda();

if ($idAgenda == Null) {
    $idAgenda = $Agenda->getDefaultAgenda($acronyme);
    if ($idAgenda == Null) {
        $nom = 'Agenda personnel';
        $idAgenda = $Agenda->createAgenda4user($acronyme, $nom);
        }
    }

$listMyAgendas = $Agenda->getAgendas4user($acronyme);
$listeSharedAgendas = $Agenda->getAgendasShared4user($acronyme);

$smarty->assign('idAgenda', $idAgenda);
$smarty->assign('listeAgendas', $listMyAgendas);
$smarty->assign('listeShared', $listeSharedAgendas);

$smarty->assign('corpsPage', 'agenda/agenda');
