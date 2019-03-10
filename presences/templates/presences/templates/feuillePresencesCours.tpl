<div>

	<div class="btn-group pull-left">
		<button type="button" class="btn btn-warning" id="btnPresAuto">Présence Auto [Activé]</button>
		<button type="button" class="btn btn-lightPink" id="btnRetard"><i class="fa fa-moon-o"></i> Retard au cours [Désactivé]</button>
	</div>

	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" id="annuler">Annuler</button>
		<button type="button" class="btn btn-primary" id="save"><i class='fa fa-floppy-o'></i> Enregistrer</button>
	</div>
	<div class="clearfix"></div>

	<strong>
		<span class="hidden-sm">{$prof.prenom} {$prof.nom} | </span>
		{$detailsCours.statut} {$detailsCours.libelle} {$detailsCours.nbheures}h -> [{$coursGrp}]
	</strong>

</div>

{include file="feuillePresences.tpl"}
