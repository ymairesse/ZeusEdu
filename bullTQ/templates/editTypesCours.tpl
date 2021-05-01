<div class="container-fluid">

<form name="formTypesCours" id="formTypesCours" action="index.php" method="POST">

	<div class="panel panel-info">

		<div class="panel-heading">
			Définition des types de cours
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default">Annuler</button>
				<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
			</div>

		</div>

		<div class="panel-body">
			<table class="table table-condensed">
				<tr>
					<th>Cours d'option</th>
					<th>Cours général</th>
					<th>Nom du cours</th>
					<th>Abréviation</th>
				</tr>

				{foreach from=$listeCoursTypes key=cours item=dataCours}
					<tr>
						{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
						{assign var=coursPROT value=$dataCours.cours|replace:' ':'~'}
						<td>
							<label class="radio-inline">
								<input name="field_{$coursPROT}" type="radio" value="option" {if $dataCours.type == 'option'} checked{/if}>
								Option
							</label>
						</td>
						<td>
						   <label class="radio-inline">
							   <input name="field_{$coursPROT}" type="radio" value="general" {if $dataCours.type == 'general'} checked{/if}>
							   Général
						   </label>
						</td>

						<td>
						<span {if !(isset($dataCours.type)) || $dataCours.type == Null}class="erreur"{/if} title="{$dataCours.cours}">{$dataCours.libelle} {$dataCours.statut} {$dataCours.nbheures}h</span>
						</td>
						<td>
							{$dataCours.cours}
						</td>

					</tr>
				{/foreach}

				</table>

			<input type="hidden" name="etape" value="{$etape}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="niveau" value="{$niveau}">
		</div>

	</div>

</form>

</div>
