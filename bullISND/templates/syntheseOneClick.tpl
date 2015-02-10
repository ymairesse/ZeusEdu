<h2>Synthèse {$coursGrp} à verser au bulletin {$bulletin}</h2>

{if isset($erreursPoids)}
	{include file='noPoids.tpl'}
{/if}

{assign var=nbCol value=0}
{foreach from=$listeCompetences key=idComp item=dataCompetence}
	{foreach from=$dataCompetence key=type item=data}
		{assign var=nbCol value=$nbCol+1}
	{/foreach}
{/foreach}
<form name="formTransfert" id="formTransfert" action="index.php" method="POST">
	<div style="float:right">
	Effacer le contenu existant du bulletin (conseillé) 
	<input type="checkbox" name="effaceDetails" value="1"{if ($effaceDetails == true)} checked="checked"{/if}">
	<span title="Annuler" id="boutonReset" class="fauxBouton">
		Annuler <img alt="annuler" src="../images/suppr.png">
	</span>
	<span title="Transfert vers le bulletin" id="boutonTransfert" class="fauxBouton">
		Vers bulletin <img alt="=&gt;" src="../images/flecheOut.gif">
	</span>
	<input type="reset" value="Annuler" name="reset" id="reset" style="display:none">
	<input type="submit" value="Transférer" name="submit" id="submit" style="display:none">
	</div>
<table class="tableauAdmin">
	<tr>
		<th colspan="2">&nbsp;</th>
		<th colspan={$nbCol}>Totaux Carnet de cotes</th>
		<th colspan={$nbCol}>À transférer au bulletin</th>
	</tr>
	<tr>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{foreach $dataCompetence key=type item=data}
			<th class="tooltip">
				<span class="tip">{$data.libelle}<br>{$idComp}</span>
				{$type}<br>
				{$data.libelle|truncate:6}<br>
			</th>
			{/foreach}
		{/foreach}
		<!-- entête des colonnes de transfert -->
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{foreach $dataCompetence key=type item=data}
			<th class="tooltip"  style="border:2px solid black">
				<span class="tip">{$data.libelle}<br>{$idComp}</span>
					{$type}<br>
					{$data.libelle|truncate:6}<br>
					{if isset($poidsCompetences.$idComp)}
						<strong>{$poidsCompetences.$idComp.$type}</strong>
						{assign var=validCoursGrp value=$coursGrp|replace:' ':'$'|replace:'-':'#'}
						<input type="hidden" 
						name="poids-coursGrp_{$validCoursGrp}-type_{$type}-comp_{$idComp}-bulletin_{$bulletin}"
						value="{$poidsCompetences.$idComp.$type}">
					{/if}
			</th>
			{/foreach}
		{/foreach}
	</tr>
	
	{foreach from=$listeEleves key=matricule item=dataEleve}
	<tr>
		<td>{$dataEleve.classe}</td>
		<td class="tooltip">
			<span class="tip"><img src="../photos/{$matricule}.jpg" alt="{$matricule}" style="width:100px;"><br>
			{assign var=nomPrenom value=$dataEleve.nom|cat:' '|cat:$dataEleve.prenom}
			{$nomPrenom|truncate:15}<br>{$matricule}
			</span>
			{$dataEleve.nom} {$dataEleve.prenom}</td>
			
		<!-- Les sommes des cotes par compétence et par cert/form -->
		{foreach from=$listeCompetences key=idComp item=dataCompetence}
			{assign var=couleur value=$idComp|substr:-1}
			{foreach $dataCompetence key=type item=data}
			<td title="{$data.libelle}" class="couleur{$couleur} cote micro">
				
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
				<td title="{$data.libelle}" class="couleur{$couleur} cote" style="border:2px solid black">
					{if isset($poidsCompetences.$idComp)}
						{if ($poidsCompetences.$idComp.$type != '') && isset($sommesCotes.$matricule.$type.$idComp.cote) &&($sommesCotes.$matricule.$type.$idComp.cote >= 0)}
						{assign var=validCoursGrp value=$coursGrp|replace:' ':'$'|replace:'-':'#'}
						<input type="text" 
						name="bull-matr_{$matricule}-coursGrp_{$validCoursGrp}-type_{$type}-comp_{$idComp}-bulletin_{$bulletin}" 
						value="{$tableauBulletin.$matricule.$type.$idComp|default:''}"
						size="3" maxlength="5">

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

<script type="text/javascript">
{literal}
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";

	$(document).ready(function(){
		
		$("input").tabEnter();
		
		$("#messageErreur").dialog({
			modal: true,
			width: 400,
			buttons: {
				Ok: function() {
					$( this ).dialog("close" );
					}
				}
			});

		$("#formTransfert").submit(function(){
			$.blockUI();		
			$("#wait").show();
			})
		
		$("#boutonTransfert").click(function(){
			$("#submit").click();
			})
		$("#boutonReset").click(function(){
			$("#reset").click();
			})
			
		$("#reset").click(function(){
			if (!(confirm(confirmationReset)))
				return false;
			})
		
	})
{/literal}
</script>
