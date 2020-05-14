<form id="formPrint">

	<h3>Critères d'impression</h3>
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

		<div class="btn-group btn-group-justified">
			<div class="btn-group">
			<button type="button" class="btn btn-warning" title="Sélection des faits à imprimer" id="printSelect">Sélection <i class="fa fa-wrench"></i></button>
			</div>
			<div class="btn-group">
			<button type="button" class="btn btn-primary" title="À l'écran" id="generer"> <i class="fa fa-eye"></i> Vue écran</button>
			</div>
			<div class="btn-group">
			<button type="button" class="btn btn-success" title="Fichier PDF" id="genererPDF"> <i class="fa fa-file-pdf-o"></i> Impression</button>
			</div>
		</div>

		<span id="ajaxLoader" class="hidden">
			<img src="images/ajax-loader.gif" alt="loading" class="img-responsive">
		</span>

	</div>

	<div id="modalPrintFait" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalPrintFaitLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	        <h4 class="modal-title" id="modalPrintFaitLabel">Faits à imprimer</h4>
	      </div>
	      <div class="modal-body">
			  <div class="row">
			  	<div class="col-md-6 col-xs-12">
					{foreach from=$listeTypesFaits key=typeFait item=data}
		  				<div class="checkbox">
		  				<label><input type="checkbox" name="type_{$typeFait}" class="cbPrint" value="1"{if $data.print==1} checked{/if}>
		  					{$data.titreFait}
		  				</label>
		  				</div>
		  			{/foreach}
			  	</div>
				<div class="col-md-6 col-xs-12">
					<p class="notice">
						Sélectionnez à gauche les types de faits disciplinaires qui apparaîtront dans les fiches de comportement.<br>
						L'administrateur peut décider quels faits sont imprimables par défaut.
					</p>
				</div>
			  </div>

	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="confPrint">Clôturer</button>
	      </div>
	    </div>
	  </div>
	</div>
</form>
