<div id="lastAccess" style="clear:both">
<h3>Vos précédents derniers accès. Est-ce possible? Voyez aussi dans votre "<a href="http://isnd.be/peda/profil/#tabs-4">Profil Personnel</a>"</h3>
{foreach from=$lastAcces item=acces}
Le {$acces.date} à {$acces.heure} depuis l'adresse {$acces.ip} ({$acces.host})<br>
{/foreach}
</div>
