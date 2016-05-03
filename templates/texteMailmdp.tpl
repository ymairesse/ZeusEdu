<p>Chère/cher {$identite.prenom} {$identite.nom},</p>

<p>Ce courriel vous est adressé par le système automatique d'envoi de mails de la plate-forme {$TITRECOURT} de l'école {$ECOLE}.</p>
<p>Ce {$jour} {$date} à {$heure}, quelqu'un (sans doute vous) à l'adresse IP {$identiteReseau.ip} ({$identiteReseau.hostname}) a demandé le changement de mot passe pour l'utilisateur <strong>{$identite.acronyme}</strong>.</p>
<p>Si vous n'êtes pas à l'origine de cette demande ou si vous n'avez rien demandé, négligez simplement ce mail.</p>
<p>Si vous souhaitez, par contre, réellement pouvoir changer votre mot de passe, cliquez sur le lien suivant (ou recopiez la ligne dans la barre d'adresse de votre navigateur).</p>
<a href="{$BASEDIR}/mdp/index.php?action=etape3&amp;acronyme={$identite.acronyme}&amp;token={$token}">{$BASEDIR}/mdp/index.php?action=etape3&amp;acronyme={$identite.acronyme}&amp;token={$token}</a>
<p>Attention: ce lien ne fonctionnera que pendant 48h à dater du moment précis de la demande, soit le moment d'envoi du présent mail. Si vous n'avez pas changé le mot de passe dans ce délai, il faudra faire une nouvelle demande.</p>
