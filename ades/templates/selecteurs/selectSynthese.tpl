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
			<option value="">Niveau</option>
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
	<div class="btn-group-vertical btn-block" style="display:none" id="boutons">
		<button type="button" class="btn btn-primary" title="À l'écran" id="generer">Générer <i class="fa fa-eye"></i></button>
		<button type="button" class="btn btn-success" title="Fichier PDF" id="genererPDF">Générer en <i class="fa fa-file-pdf-o"></i></button>
	</div>
	<span id="ajaxLoader" class="hidden">
		<img src="images/ajax-loader.gif" alt="loading" class="img-responsi">
	</span>

</div>
