<div class="container">

	<div class="questionImportante">
		{assign var=debut value='Veuille confirmer la suppression définitive de '}
	<fieldset style="clear:both">
		<legend>Effacement définitif</legend>
		<form name="form" id="confirmDel" action="index.php" method="POST">
		{if $type == 'ponderations'}
		<p>{$debut} <strong>toutes les pondérations</strong>.</p>
		{/if}
		{if $type == 'carnet'}
		<p>{$debut} <strong>tous les carnets de cotes</strong>.</p>
		{/if}
		{if $type == 'details'}
		<p>{$debut} <strong>toutes les cotes entrées aux bulletins</strong>.</p>
		{/if}
		{if $type == 'commentProfs'}
		<p>{$debut} <strong>de tous les commentaires des cotes entrés aux bulletins</strong>.</p>
		{/if}
		{if $type == 'commentTitus'}
		<p>{$debut} <strong>tous les commentaires des titulaires entrés aux bulletins</strong>.</p>
		{/if}
		{if $type == 'resetAttitudes'}
		<p>{$debut} <strong>toutes les "Attitudes" entrées aux bulletins</strong>.</p>
		{/if}
		{if $type == 'resetCoordinateurs'}
		<p>{$debut} <strong>toutes les notices "Coordinateurs" entrées aux bulletins</strong>.</p>
		{/if}
		{if $type == 'resetSituations'}
		<p>{$debut} <strong>toutes les cotes de Situation et des épreuves externes entrées aux bulletins (avec archivage)</strong>.</p>
		{/if}
		{if $type == 'resetHistorique'}
		<p>{$debut} <strong>tous les historiques des changements de cours</strong>.</p>
		{/if}
		{if $type == 'resetEduc'}
		<p>{$debut} <strong>tous les commentaires des éducateurs entrés aux bulletins</strong>.</p>
		{/if}

		<p>Attention, la décision est irrévocable. Il ne faut plus utiliser cette fonction après le début de l'année scolaire!!!</p>

		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
		<input type="hidden" name="action" value="{$action}">
		<button type="submit" class="btn btn-danger pull-right" id="envoi">Supprimer</button>
		</form>
	</fieldset>
	</div>

</div>
