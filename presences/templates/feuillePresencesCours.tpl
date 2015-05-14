{if isset($acronyme)}

	<div class="container">
	<form name="listeEleves" id="presencesEleves" action="index.php" method="POST" style="padding:0; margin:0">
	
	<input type="hidden" name="educ" value="{$identite.acronyme}">
	<input type="hidden" name="date" value="{$date}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="freeDate" value="{$freeDate}">
	<input type="hidden" name="freePeriode" value="{$freePeriode}">
	<input type="hidden" name="parent" value="prof/educ">
	<input type="hidden" name="media" value="en classe">
	<input type="hidden" name="periode" id="periode" value="{$periode}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	<input type="hidden" name="selectProf" value="{$acronyme|default:''}">
	
	<div class="btn-group pull-right">
		<a class="btn btn-default" type="button" href="index.php?action=presences&amp;mode=tituCours&amp;coursGrp={$coursGrp}">Annuler</a>
		<button type="submit" class="btn btn-primary">Enregistrer</button>
	</div>
	
	<h3><span class="hidden-xs">{$listeProfs.$acronyme.prenom} {$listeProfs.$acronyme.nom|truncate:20} | </span>
		<span class="hidden-sm">{$acronyme} | </span>
		{$listeCoursGrp.$coursGrp.libelle} -> [{$coursGrp}]</h3>
	
	{include file="feuillePresences.tpl"}
	</div>

{/if}