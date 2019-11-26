<div class="btn-group pull-left col-xs-5">
	<button type="button" class="btn btn-warning" id="btnPresAuto">Présence Auto [Activé]</button>
	<button type="button" class="btn btn-lightPink" id="btnRetard"><i class="fa fa-moon-o"></i> Retard au cours [Désactivé]</button>
</div>

<div class="col-xs-2">
	{if $userStatus == 'educ' || $userStatus == 'admin'}
		<div class="input-group date">
			<input type="text" class="datepicker form-control" name="date" id="datePresences" value="{$date}">
			<div class="input-group-addon"><i class="fa fa-calendar"></i> </div>
		</div>
	{/if}

</div>

<div class="col-xs-5">
	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" id="annuler">Annuler</button>
		<button type="button" class="btn btn-primary" id="save"><i class='fa fa-floppy-o'></i> Enregistrer</button>
	</div>
</div>


<span class="hidden-sm">Titulaires:
	<strong>{$titusClasse|implode:', '}</strong>
</span>


{include file="feuillePresences.tpl"}
