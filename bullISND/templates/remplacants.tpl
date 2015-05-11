<div class="container">
	
<h2>Liste des profs remplacés</h2>

<table class="tableauAdmin table">
	<thead>
	<tr>
		<th>Cours</th>
		<th>Prof</th>
	</tr>
	</thead>
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

</div>