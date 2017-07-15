{strip}
<div class="row">

	<div class="col-xs-11">

		<div class="form-group">
			<label for="{$unChamp}" class="sr-only">{$data.label}</label>
			{strip}
			<textarea {if ($data.classCSS == 'obligatoire')} required {/if}
				style="min-width: 100%"
				name="{$unChamp}"
				tabIndex="{$tabIndex}"
				id="{$unChamp}"
				class="form-control"
				placeholder="{$data.label}">
				{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}</textarea>
			{/strip}
				{assign var="tabIndex" value=$tabIndex+1}

				{if isset($listeMemos.$unChamp)}

				{assign var=liste value=$listeMemos.$unChamp}
					<select name="memos"
							class="memos hidden form-control"
							id="memos_{$unChamp}"
							tabIndex="{$tabIndex}">
						<option value="">Sélectionner un {$data.label}</option>
						{foreach from=$liste key=k item=unMemo}
						<option value="{$unMemo@iteration}">{$unMemo.texte}</option>
						{/foreach}
					</select>
					{assign var="tabIndex" value=$tabIndex+1}

				{assign var="tabIndex" value=$tabIndex+1 scope="global"}
				{/if}
		</div>  <!-- form-group -->
	</div>  <!-- col-md... -->

	<div class="col-xs-1">
		<div class="btn-group-vertical motif pull-right">
			<button type="button" class="btn btn-warning btn-sm saveMotif" title="Enregistrer" id="save_{$unChamp}"><i class="fa fa-save" style="color:#000"></i></button>
			<button type="button" class="btn btn-danger btn-sm showMotifs" title="Voir la liste"> <i class="fa fa-question-circle" style="color:#fff"></i> </button>
		</div>

		<span class="saveOK_{$unChamp}"></span>
	</div>	  <!-- col-md ... -->

</div>   <!-- row -->
{/strip}
