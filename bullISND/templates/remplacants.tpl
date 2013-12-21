<h1>Liste des profs remplacés</h1>
<table class="tableauAdmin">
	<tr>
		<th>Cours</th>
		<th>Prof</th>
	</tr>
	{foreach from=$listeRemplacements key=coursGrp item=remplacants}
		{assign var=pos value=$coursGrp|strpos:'-'}
		{assign var=cours value=$coursGrp|substr:0:(pos-3)}
		<tr>
			<th>{$coursGrp}</th>
			<th><strong>{if isset($listeCoursEleves.$cours)}{$listeCoursEleves.$cours.libelle}{else}Cours inconnu{/if}</strong></th>
		</tr>
		{foreach from=$remplacants item=unProf}
		<tr>
			<td>&nbsp;</td>
			<td>{$unProf}</td>
		</tr>
		{/foreach}
	{/foreach}
</table>
