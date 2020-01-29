<?php

$ok = $hermes->send_mail($_POST, $_FILES);

$smarty->assign('message',array(
    'title'=>"Envoi d'un mail",
    'texte'=>$ok==true?MAILOK:MAILKO,
    'urgence'=>$ok==true?'success':'danger'
    ));

// traiter le cas de l'expéditeur NOREPLY
$mailExpediteur = $_POST['mailExpediteur'];
$_POST['nomExpediteur'] = ($mailExpediteur == NOREPLY)?NOMNOREPLY:$_POST['nomExpediteur'];

// création du groupe éventuellement créé durant l'envoi du mail
$hermes->archiveMail($acronyme, $_POST, $_FILES);
if ($_POST['groupe'] != '') {
    $hermes->creerGroupe($acronyme,$_POST['groupe'],$_POST['mails']);
    }

// la liste des destinataires est dans $_POST sous forme mail#nom
// la liste des fichiers joints est dans $_FILES
$smarty->assign('detailsMail', array('post'=>$_POST,'files'=>$_FILES));
// éclater la liste des destinataires sur le #
// chaque destinataire est de la forme  "Prenom Nom#pnom@ecole.org"
$destinataires = $hermes->listeNomsFromDestinataires($_POST['mails']);
$smarty->assign('destinatairesString', implode(', ',$destinataires));
$smarty->assign('corpsPage','confirmMail');
