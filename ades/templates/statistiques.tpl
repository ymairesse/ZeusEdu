<div class="container">
	
	<h2>Statistiques disciplinaires</h2>
	<p>Entre le <strong>{$debut}</strong> et le <strong>{$fin}</strong></p>
	<p>Niveau d'étude: <strong>{$niveau}</strong></p>
	{if $classe != ''}
	<p>Classe: <strong>{$classe}</strong></p>
	{/if}
	{if $matricule != ''}
	<p><strong>{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</strong></p>
	{/if}
	
	<table class="table table-condensed">
		<thead>
			<tr>
				<th style="width: 12em">Nombre de faits</th>
				<th>Type de fait</th>
			</tr>
		</thead>		
		{foreach from=$statistiques item=typeFait}
		<tr style="background-color: #{$typeFait.couleurFond}; color: #{$typeFait.couleurTexte}">
			<td>{$typeFait.nbFaits}</td>
			<td>{$typeFait.titreFait}</td>
		</tr>
		{/foreach}
	</table>

</div>