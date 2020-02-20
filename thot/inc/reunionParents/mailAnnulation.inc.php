<?php

$raison = isset($_POST['raison']) ? $_POST['raison'] : null;
$date = $infoRV['date'];
$heure = $infoRV['heure'];
$mailParent = $infoRV['mail'];
$abreviation = $infoRV['acronyme'];

$nomParent = sprintf('%s %s %s', $infoRV['formule'], $infoRV['prenom'], $infoRV['nom']);
$prof = User::identiteProf($abreviation);
$nomProf = sprintf('%s %s', $prof['prenom'], $prof['nom']);

// texte du mail d'annulation
$texte = file_get_contents('templates/reunionParents/mail/texteAnnulation.tpl');
$texte = str_replace('##nomparent##', $nomParent, $texte);
$texte = str_replace('##date##', $date, $texte);
$texte = str_replace('##heure##', $heure, $texte);
$texte = str_replace('##raison##', $raison, $texte);
$texte = str_replace('##nomprof##', $nomProf, $texte);

$identiteProf = User::identiteProf($acronyme);
$mailExpediteur = $identiteProf['mail'];
$nomExpediteur = sprintf('%s. %s', substr($identiteProf['prenom'], 0, 1), $identiteProf['nom']);

$objet = 'Annulation de rendez-vous '.ECOLE;

// ajout de la signature
$signature = file_get_contents('templates/reunionParents/mail/signature.tpl');
$signature = str_replace('##expediteur##', $nomExpediteur, $signature);
$signature = str_replace('##mailExpediteur##', $mailExpediteur, $signature);
$texte .= $signature;

// ajout du disclaimer
$disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
$texte .= "<hr> $disclaimer";

$mail = new PHPmailer();
$mail->IsHTML(true);
$mail->CharSet = 'UTF-8';
$mail->From = $mailExpediteur;
$mail->FromName = $nomExpediteur;

// envoi du mail au parent
$mail->AddAddress($mailParent, $nomParent);

// envoyer le mail à l'expéditeur aussi
$mail->AddBCC($mailExpediteur, $nomExpediteur);

$mail->Subject = $objet;
$mail->Body = $texte;

$envoiMail = ($mail->Send());

$title= 'Envoi de mail';
if ($envoiMail == false) {
    $message = array(
            'title' => $title,
            'texte' => 'Envoi de mail en échec',
            'urgence' => 'warning'
        );
}
else {
    $message = array(
            'title'=>$title,
            'texte'=> sprintf('Mail envoyé à %s',$mailParent),
            'urgence' => 'success'
        );
}
$smarty->assign('message', $message);
