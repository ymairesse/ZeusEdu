{debug}

	<div class="container-fluid">
	<form id="presencesEleves" >

	<input type="hidden" name="date" value="{$date}">
	{* <input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="freeDate" value="{$freeDate}">
	<input type="hidden" name="parent" value="prof/educ">
	<input type="hidden" name="media" value="en classe">
	<input type="hidden" name="periode" id="periode" value="{$periode}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	<input type="hidden" name="selectProf" value="{$acronyme|default:''}">
	<input type="hidden" name="oups" id="oups" value="">
	<input type="hidden" name="presAuto" id="presAuto" value="true"> *}

	<button type="button" class="btn btn-warning pull-left" id="btnPresAuto">Présence Auto [Activé]</button>
	<button type="button" class="btn btn-lightPink" id="btnRetard"><i class="fa fa-moon-o"></i> Retard au cours [Désactivé]</button>

	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" id="annuler">Annuler</button>
		<button type="submit" class="btn btn-primary"><span id="save"></span> Enregistrer</button>
	</div>
	<div class="clearfix"></div>

	<strong>
		<span class="hidden-sm">{$prof.prenom} {$prof.nom} | </span>
		{$detailsCours.statut} {$detailsCours.libelle} {$detailsCours.nbheures}h -> [{$coursGrp}]</strong>

	{include file="feuillePresences.tpl"}

	</div>
