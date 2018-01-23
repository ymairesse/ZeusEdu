<div class="container">

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<fieldset>
				<legend>Grouper des classes</legend>
				{if $listeGroupes|@count > 0}
					<form name="formGroupe" id="formGroupe" action="index.php" method="POST">
					<h3>Groupes existants</h3>
					<table class="table table-condensed table-striped">
						<thead>
							<tr>
								<th>Nom du groupe</th>
								<th>Formé des classes</th>
								<th>Séparer</th>
							</tr>
						</thead>
					{foreach from=$listeGroupes key=nomGroupe item=lesClasses}
						<tr>
							<td><strong>{$nomGroupe}</strong></td>
							<td><strong>{", "|implode:$lesClasses}</strong></td>
							<td><input type="checkbox" name="checkbox_{$nomGroupe}" value="{$nomGroupe}"></td>
					{/foreach}
						</tr>
					</table>
					<div class="btn-group pull-right">
						<button class="btn btn-default" type="reset" name="reset" id="reset">Annuler</button>
						<button class="btn btn-primary" type="submit" name="submit" id="submit">Dégrouper</button>
					</div>
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="unGroup">
					</form>
				{/if}
			</fieldset>

		</div>  <!-- col-md... -->

		<div class="col-md-6 col-sm-12">
			<fieldset>
				<legend>DEgrouper des classes</legend>
				<form name="form" action="index.php" method="POST" role="form" class="form-vertical">

					<h3>Formation de nouveaux groupes de classes</h3>
					<div class="form-group">
						<label for="classes">Choisir une ou plusieurs classes</label>
						<select name="classes[]" size="10" multiple="multiple" id="classes" class="form-control">
							{foreach from=$listeClasses item=classe}
								{if isset($selectedClasses)}
								<option value="{$classe}"{if $classe|@in_array:$selectedClasses} selected{/if}>{$classe}</option>
								{else}
								<option value="{$classe}">{$classe}</option>
								{/if}
							{/foreach}
						</select>
						<div class="help-block">Maintenir une touche Ctrl enfoncée pour une sélection multiple</div>
					</div>

					<div class="form-group">
						<label for="groupe">Nom du groupe à former</label>
						<input type="text" name="groupe" id="groupe" value="{$groupe|default:Null}" maxlength="5" class="form-control">
					</div>
					<input type="hidden" name="action" value="gestEleves">
					<input type="hidden" name="mode" value="groupEleve">
					<div class="btn-group pull-right">
						<button class="btn btn-default" type="reset" name="reset" id="reset">Annuler</button>
						<button class="btn btn-primary" type="submit" name="OK">Grouper</button>
					</div>

				</form>
			</fieldset>

		</div> <!-- col-md... -->

	</div>  <!-- row -->

</div>  <!-- container -->
