{if isset($classe)}

	<div class="container">
	<form name="listeEleves" id="presencesEleves" action="index.php" method="POST" style="padding:0; margin:0">

	<input type="hidden" name="educ" value="{$identite.acronyme}">
	<input type="hidden" name="date" value="{$date}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="freeDate" value="{$freeDate}">
	<input type="hidden" name="parent" value="prof/educ">
	<input type="hidden" name="media" value="en classe">
	<input type="hidden" name="periode" id="periode" value="{$periode}">
	<input type="hidden" name="classe" value="{$classe}">
	<input type="hidden" name="oups" id="oups" value="">
	<input type="hidden" name="presAuto" id="presAuto" value="true">

	<button type="button" class="btn btn-warning pull-left" id="btnPresAuto">Présence Auto [Activé]</button>

	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" id="annuler">Annuler</button>
		<button type="submit" class="btn btn-primary"><span id="save"></span> Enregistrer</button>
	</div>
<div class="clearfix"></div>

	<strong>Classe: {$classe}</strong>

	{include file="feuillePresences.tpl"}
	</div>
{/if}
