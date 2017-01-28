<p class="enteteMail">Exp: <span>{$mail.mailExp}</span>  Objet: <span>{$mail.objet}</span>  <span class="pull-right">{$mail.date} {$mail.heure}</span></p>
{$mail.texte}
{if $mail.PJ != ''}
Pièce jointe: <a href="upload/{$acronyme}/{$mail.PJ}" target="_blank">{$mail.PJ}</a>
{/if}
