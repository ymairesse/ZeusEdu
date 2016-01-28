{strip}
<div class="row">

	<div class="col-md-11 col-sm-10">
		<div class="form-group">
			<label for="{$unChamp}">{$data.label}</label>
			{strip}
			<textarea 
				{if $data.colonnes > 0} cols="{$data.colonnes}" {/if}
				{if $data.lignes > 0} rows="{$data.lignes}" {/if}
				{if ($data.classCSS == 'obligatoire')} required {/if}
				name="{$unChamp}"
				tabIndex="{$tabIndex}"
				id="{$unChamp}"
				class="form-control">
				{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}</textarea>
			{/strip}
				{assign var="tabIndex" value=$tabIndex+1}
		
				{if isset($listeMemos.$unChamp)}
				<label for="memos_{$unChamp}">^^^^^^^</label>
				{assign var=liste value=$listeMemos.$unChamp}
					<select name="memos" class="memos" id="memos_{$unChamp}" style="width:40em" tabIndex="{$tabIndex}">
						<option value="">Sélectionner un texte</option>
						{foreach from=$liste key=k item=unMemo}
						<option value="{$unMemo@iteration}">{$unMemo.texte}</option>
						{/foreach}
					</select>
					{assign var="tabIndex" value=$tabIndex+1}
		
				<span class="copier" title="copier le texte" tabIndex="{$tabIndex}">
					<span class="glyphicon glyphicon-upload" style="font-size:150%; color:orange"></span>
				</span>
				{assign var="tabIndex" value=$tabIndex+1 scope="global"}
				{/if}
		</div>  <!-- form-group -->
	</div>  <!-- col-md... -->
	
	<div class="col-md-1 col-sm-2">
		<span class="glyphicon glyphicon-floppy-save saveMotif" id="save_{$unChamp}" title="Enregistrer" style="font-size:130%; padding-top:3em; color:blue"></span>
		<span class="saveOK_{$unChamp}"></span>
	</div>	  <!-- col-md ... -->

</div>   <!-- row -->
{/strip}