<div class="container">
	
	<h2>Liste des partages</h2>
	
	<div class="row">
		
		<div class="col-md-8 col-sm-12">
			
			<h3>{if (isset($coursGrp))}
				{$listeCours.$coursGrp.nomCours|default:''} - [{$coursGrp}] {$listeCours.$coursGrp.statut} {$listeCours.$coursGrp.libelle} {$listeCours.$coursGrp.nbheures}h
			{/if}
			{if isset($classe)}
				Classe: {$classe}
			{/if}
			</h3>
			
			<table class="table table-hover table-condensed">
			<tr>
				<th style="width:30em" title="{$matricule}">Nom</th>
				<th>Partages</th>
			</tr>
			{foreach from=$listeEleves key=matricule item=eleve}
			<tr>
				<td>{$eleve.classe} {$eleve.nom} {$eleve.prenom}</td>
				<td>
					{if isset($listePartages[$matricule])}
						{assign var=lesPartages value=$listePartages[$matricule]}
						{foreach from=$lesPartages key=acronyme item=mode}
							<span class="{$mode}" title="{$listeProfs.$acronyme.prenom|default:''} {$listeProfs.$acronyme.nom|default:''}">{$acronyme}</span>
						{/foreach}
					{else}
					&nbsp;
					{/if}
				 </td>
			</tr>
			{/foreach}
			
			</table>
		</div>  <!-- col-md... -->
		
	
		<div class="col-md-4 col-sm-12">
		
		<h4>Légende</h4>
		<table class="table table-condensed">
			<tr>
			<td style="width:30em;" class="r">Lecture seule (pas de modification)</td>
			<td style="width:30em" class="rw">Lecture et écriture (modifications autorisées</td>
			</tr>
		</table>
		
		</div>  <!-- col-md-4 -->
		
	</div>  <!-- row -->
	
</div>  <!-- container -->