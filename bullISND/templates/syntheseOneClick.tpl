<div class="container">
	
<h2>Synthèse {$coursGrp} à verser au bulletin {$bulletin}</h2>

{if isset($noError) && ($noError == true)}

	{include file="noError.tpl"}

	{else}
		
		{if isset($erreursPoids)}
			{include file='noPoids.tpl'}
		{/if}
		
		{if isset($erreurTansfert) && ($erreurTransfert == true)}
			{include file='noTransfert.tpl'}
		{/if}
		
		{if isset($erreurVerrou) && ($erreurVerrou == true)}
			{include file='verrouQuestion.tpl'}
		{/if}

	{/if}

{* calcul du nombre de compétences différentes testées pour la période *}
{assign var=nbCol value=0}
{foreach from=$listeCompetences key=idComp item=dataCompetence}
	{foreach from=$dataCompetence key=type item=data}
		{assign var=nbCol value=$nbCol+1}
	{/foreach}
{/foreach}

<form name="formTransfert" id="formTransfert" action="index.php" method="POST" role="form" class="form-vertical">
	
	<div style="float:right">
		Effacer le contenu existant du bulletin (conseillé) 
		<input type="checkbox" name="effaceDetails" value="1"{if ($effaceDetails == true)} checked="checked"{/if}>

		<div class="btn-group">
			<button type="reset" class="btn btn-default">Annuler <span class="glyphicon glyphicon-remove" style="color:red"></span></button>
			<button class="btn btn-primary">Vers le bulletin <span class="glyphicon glyphicon-share-alt" style="color:green"></span></button>
		</div>

	</div>
	
<table class="table table-striped table-condensed">
	<tr>
		<th colspan="2">&nbsp;</th>
		<th style="text-align:center" colspan={$nbCol}>Totaux Carnet de cotes</th>
		<th style="text-align:center" colspan={$nbCol}>À transférer au bulletin</th>
	</tr>
	<tr>
		<th>Classe</th>
		<th>Nom</th>
		
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{foreach $dataCompetence key=type item=data}
			<th style="text-align:center" data-container="body" title="{$data.libelle}<br>{$idComp}" data-html="true">
				{$type}<br>
				{$data.libelle|truncate:6}<br>
			</th>
			{/foreach}
		{/foreach}
		
		<!-- entête des colonnes de transfert -->
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{foreach $dataCompetence key=type item=data}
			<th style="border:2px solid black;text-align:center"
				title="{$data.libelle}"
				data-container="body"
				data-html="true"
				data-content="{$data.libelle}">
				{$type}<br>
				{$data.libelle|truncate:6}<br>
				{if isset($poidsCompetences.$idComp)}
					<strong>{$poidsCompetences.$idComp.$type}</strong>
					{assign var=validCoursGrp value=$coursGrp|replace:' ':'$'|replace:'-':'#'}
					<input
						type="hidden"
						name="poids-coursGrp_{$validCoursGrp}-type_{$type}-comp_{$idComp}-bulletin_{$bulletin}"
						value="{$poidsCompetences.$idComp.$type}">
				{/if}
			</th>
			{/foreach}
		{/foreach}
		
	</tr>

	{assign var=tabIndex value=1}
	
	{foreach from=$listeEleves key=matricule item=dataEleve}
	<tr>
		<td>
			{$dataEleve.classe}
		</td>
		{assign var=nomPrenom value=$dataEleve.nom|cat:' '|cat:$dataEleve.prenom}			
		<td style="cursor:pointer"
		    class="pop" 
			data-html = "true"
		    data-placement="top"
			data-container="body"
			data-original-title="{$nomPrenom|truncate:15}"
		    data-content="<img src='../photos/{$dataEleve.photo}.jpg' style='width:100px' alt='{$matricule}'><br><span class='micro'>{$matricule}">
           {$nomPrenom}
		</td>
			
		<!-- Les sommes des cotes par compétence et par cert/form -->
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{assign var=couleur value=$idComp|substr:-1}
			{foreach $dataCompetence key=type item=data}
			<td title="{$data.libelle}" data-container="body" class="couleur{$couleur} cote micro">
				
				{if isset($sommesCotes.$matricule.$type.$idComp.cote) && ($sommesCotes.$matricule.$type.$idComp.cote >=0)}
				{$sommesCotes.$matricule.$type.$idComp.cote} / {$sommesCotes.$matricule.$type.$idComp.max}
				{else}&nbsp;
				{/if}
			</td>
			{/foreach}
		{/foreach}
		
		<!-- Les cotes calculees, prêtes pour le bulletin -->
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{assign var=couleur value=$idComp|substr:-1}
			{foreach $dataCompetence key=type item=data}
				<td title="{$data.libelle}" data-container="body" class="couleur{$couleur} cote" style="border:2px solid black">
					{if isset($poidsCompetences.$idComp)}
						{if ($poidsCompetences.$idComp.$type != '') && isset($sommesCotes.$matricule.$type.$idComp.cote) &&($sommesCotes.$matricule.$type.$idComp.cote >= 0)}
						{assign var=validCoursGrp value=$coursGrp|replace:' ':'$'|replace:'-':'#'}
						<input type="text" 
						name="bull-matr_{$matricule}-coursGrp_{$validCoursGrp}-type_{$type}-comp_{$idComp}-bulletin_{$bulletin}" 
						value="{$tableauBulletin.$matricule.$type.$idComp|default:''}"
						size="3" maxlength="5" tabindex="{$tabIndex}">
						{assign var=tabIndex value=$tabIndex+1}
						{else}
						&nbsp;
						{/if}
					{/if}
				</td>
			{/foreach}
		{/foreach}
	</tr>

	{/foreach}
	</table>
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	<input type="hidden" name="action" value="carnet">
	<input type="hidden" name="mode" value="oneClick">
	<input type="hidden" name="etape" value="transfert">
</form>

	</div>  <!-- container -->

<script type="text/javascript">

var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";

$(document).ready(function(){
		
	$("input").tabEnter();
		
			
	$("#formTransfert").submit(function(){
		$.blockUI();		
		$("#wait").show();
		})

})
	
</script>
