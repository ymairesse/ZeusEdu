<div class="container">
	
	<h1 title="{$eleve.matricule}">{$eleve.prenom} {$eleve.nom} {$eleve.classe} | Bulletin {$bulletin}</h1>

		{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
	
			{assign var=cours value=$listeCoursGrp.$coursGrp.cours}
			
			<h2 title="{$coursGrp}">{$dataCours.libelle} {$dataCours.nbheures}h ({$listeProfs.$coursGrp})</h2>
			<h3>Mentions globales</h3>
			
			{assign var=matricule value=$eleve.matricule}
			<table class="tableauBull">
				<tr style="background-color: #FECF69;">
					<th style="width:12%; text-align: center;">TJ > </th>
					<td style="width:12%; text-align: center;"><strong>{$cotesGlobales.$coursGrp.$matricule.Tj|default:'&nbsp;'}</strong></td>
					<th style="width:12%; text-align: center;">Ex > </th>
					<td style="width:12%; text-align: center;"><strong>{$cotesGlobales.$coursGrp.$matricule.Ex|default:'&nbsp;'}</strong></td>
					<th style="width:12%; text-align: center;">Période > </th>
					<td style="width:12%; text-align: center;"><strong>{$cotesGlobales.$coursGrp.$matricule.periode|default:'&nbsp;'}</strong></td>
					<th style="width:12%; text-align: center;">Global > </th>
					<td style="width:12%; text-align: center;"><strong>{$cotesGlobales.$coursGrp.$matricule.global|default:'&nbsp;'}</strong></td>
				</tr>
				
			</table>
			
			{if isset($listeCotesGeneraux.$bulletin.$matricule.$coursGrp)}
			<h3>Détails par compétence</h3>
			<table class="tableauBull">
				<tr>
					<th style="width:70%">Compétence</th>
					<th style="width:15%">Travail Journalier</th>
					<th style="width:15%">Examen</th>
				</tr>
				{foreach from=$listeCompetences.$cours key=idComp item=data}
				{assign var=cotes value=$listeCotesGeneraux.$bulletin.$matricule.$coursGrp.$idComp}
				{if ($cotes.Tj != '') || ($cotes.Ex != '')}
				<tr>
					<td data-container="body" title="compétence {$idComp}" style="text-align:right">{$data.libelle}</td>
					<td style="text-align: center;"><strong>{$listeCotesGeneraux.$bulletin.$matricule.$coursGrp.$idComp.Tj|default:'&nbsp;'}</strong></td>
					<td style="text-align: center;"><strong>{$listeCotesGeneraux.$bulletin.$matricule.$idComp.Ex|default:'&nbsp;'}</strong></td>
				</tr>
				{/if}
				{/foreach}
			</table>
			{/if}
		
			<h3>Commentaire du professeur</h3>
			<div class="remarqueProf">
			{$commentaires.$bulletin.$coursGrp.$matricule|default:''|nl2br}
			</div>
			
		{/foreach}

		<h3>Commentaire du titulaire</h3>
			<div class="remarqueProf">
				{$remarqueTitu.$bulletin.$matricule|default:'&nbsp;'}
			</div>


</div>  <!-- container -->