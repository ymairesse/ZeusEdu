<h2>Classe de {$classe}</h2>
<table class="tableauAdmin">
	<tr>
		<th>Nom</th>
		<th>Situation fin de 1ère</th>
		<th>Situation fin de 2ème</th>
		<th>Situation 2ème uniquement</th>
	</tr>
	
	{foreach from=$listeEleves key=eleve_ID item=nom}
	<tr>
		<td title="{$eleve_ID}">{$nom.nom}</td>
		<td class="cote{if $situations.$eleve_ID.0.moyenne < 50} echec{/if}">
			<div class="fraction" style="font-size:smaller; color:grey">
			<div class="num" title="somme des cote de situation en fin de 1e">{$situations.$eleve_ID.0.sum}</div>
			<div class="den" title="nombre de cotes">{$situations.$eleve_ID.0.nb}</div>
			</div> {$situations.$eleve_ID.0.moyenne}%
		</td>
		<td class="cote{if $situations.$eleve_ID.5.moyenne < 50} echec{/if}">
			<div class="fraction" style="font-size:smaller; color:grey">
			<div class="num" title="somme des cotes de situation en fin de 2e">{$situations.$eleve_ID.5.sum}</div>
			<div class="den" title="nombre de cotes">{$situations.$eleve_ID.5.nb}</div>
			</div> {$situations.$eleve_ID.5.moyenne}%
		</td>
		<td class="cote{if $situations.$eleve_ID.only2.moyenne < 50} echec{/if}">
			<div class="fraction" style="font-size:smaller; color:grey">
			<div class="num" title="somme des cotes de situation en 2e seulement">{$situations.$eleve_ID.only2.sum}</div>
			<div class="den" title="nombre de cotes dans la feuille de délibés">{$situations.$eleve_ID.only2.nb}</div>
			</div> {$situations.$eleve_ID.only2.moyenne}%
		</td>		
	</tr>
	{/foreach}
</table>
