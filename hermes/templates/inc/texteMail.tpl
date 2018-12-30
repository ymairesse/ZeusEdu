<p class="enteteMail">Exp: <span>{$recentArchive.mailExp}</span>  Objet: <span>{$recentArchive.objet}</span>  <span class="pull-right">{$recentArchive.date} {$mail.heure}</span></p>
{$recentArchive.texte}


{if count($recentArchive.PJ) > 0}
Pièces jointes: 
<ul class="list-unstyled">
{foreach from=$recentArchive.PJ key=wtf item=unePJ}
	<li><a href="upload/{$acronyme}/{$unePJ}" target="_blank">{$unePJ}</a></li>
{/foreach}
</ul>
{/if}
