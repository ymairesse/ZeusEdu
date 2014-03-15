<table class="tableauAdmin" style="width:100%">
<tr>
    <th><h2>Classe: {$classe}</h2></th>
    
	{foreach from=$listeCours key=cours item=detailsCours}
		<th class="tooltip">
			<span class="tip">{$detailsCours.dataCours.libelle} {$detailsCours.dataCours.nbheures}h <br />{$detailsCours.dataCours.statut}</span>
			<img src="imagesCours/{$cours}.png" alt="{$cours}">
		</th>
	{/foreach}
	
</tr>
{foreach from=$listeEleves key=matricule item=dataEleve}
<tr>
	<td class="tooltip">
		<div class="tip"><img src="../photos/{$matricule}.jpg" alt="{$matricule}" width="100px"><br>
		{assign var=nomPrenom value=$dataEleve.nom|cat:' '|cat:$dataEleve.prenom}
		<span class="micro">{$nomPrenom|truncate:18}<br>
		{$matricule}</span>
		</div>
		{$dataEleve.nom} {$dataEleve.prenom}</td>
	{foreach from=$listeCours key=cours item=detailsCours}
		{assign var=data value=$listeSituations.$matricule.$cours.$bulletin|default:''}
		<td	class="cote tooltip{if $data.cote|default:''|strstr:'I'} echec{/if}">
			<span class="tip">{if isset($listeCoursEleves.$matricule.$cours)}
					{assign var=coursGrp value=$listeCoursEleves.$matricule.$cours.coursGrp}
					{$listeCours.$cours.profs.$coursGrp|implode:','|default:''}
				{/if}</span>
				{if isset($listeCoursEleves.$matricule.$cours)}
					{$data.cote|default:'-'}
				{else}
				X
				{/if}
		</td>
	{/foreach}
</tr>
{/foreach}
</table>

