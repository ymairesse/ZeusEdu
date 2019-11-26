	<h3>Critères de sélection</h3>
	<div style="border: 1px solid grey; padding: 1em 0.5em">

		<div class="form-group">
			<label for="debut">Depuis</label>
			<input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker form-control">
		</div>

		<div class="form-group">
			<label for="fin">Jusqu'à</label>
			<input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker form-control">
		</div>

		<div class="form-group">
			<label for="niveau">Niveau d'étude</label>
			<select name="niveau" id="niveau" class="form-control">
				<option value="">Tous les élèves</option>
				{foreach from=$listeNiveaux item=unNiveau}
					<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>{$unNiveau}e</option>
				{/foreach}
			</select>
		</div>

		<div id="listeClasses">
			{include file="selecteurs/listeClasses.tpl"}
		</div>

		<div id="listeEleves">
			{include file="selecteurs/listeEleves.tpl"}
		</div>

		<button type="button" class="btn btn-primary pull-right" id="btn-getRetards">Sélectionner <i class="fa fa-arrow-right"></i> </button>

		<span id="ajaxLoader" class="hidden">
			<img src="../images/ajax-loader.gif" alt="loading" class="img-responsive">
		</span>

		<div class="clearfix"></div>
	</div>
