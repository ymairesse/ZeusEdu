{if isset($classe)}
<div class="container">
<form name="listeEleves" id="presencesEleves" action="index.php" method="POST" style="padding:0; margin:0">

<input type="hidden" name="educ" value="{$identite.acronyme}">
<input type="hidden" name="date" value="{$date}">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="freeDate" value="{$freeDate}">
<input type="hidden" name="freePeriode" value="{$freePeriode}">
<input type="hidden" name="parent" value="prof/educ">
<input type="hidden" name="media" value="en classe">
<input type="hidden" name="periode" id="periode" value="{$periode}">
<input type="hidden" name="classe" value="{$classe}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<div class="btn-group pull-right">
	<a class="btn btn-default" type="button" href="index.php?action=presences&amp;mode=classe&amp;classe={$classe}">Annuler</a>
	<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
</div>
<h2>Classe: {$classe}</h2>

{include file="feuillePresences.tpl"}
</div>
{/if}
