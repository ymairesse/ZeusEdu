{strip}
{if $prototype.structure.typeRetenue != 0}
	<!-- Nous sommes dans le cas d'une retenue => ancienne valeur du idretenue (en cas d'édition) -->
	<input type="hidden" name="oldIdretenue" value="{$fait.idretenue|default:''}">
	<!-- dans ce cas, 6 colonnes suffisent -->
{/if}
<div class="row">
	<div class="col-sm-12">
		<div class="form-group">
			<label for="{$unChamp}">{$data.label}</label>
			<select name="{$unChamp}" id="{$unChamp}" tabindex="{$tabIndex}" class="form-control" {if ($data.classCSS=='obligatoire' )} required{/if}>
				{if ($fait.idretenue != '') && !(in_array($fait.idretenue, array_keys($listeRetenues)))}
					<option value=''>Cette date a été masquée</option>
				{else}
					<option value=''>Choisir une date</option>
				{/if}
				{foreach from=$listeRetenues key=unidretenue item=uneRetenue}
					{if $uneRetenue.affiche == 'O'}
					<option value="{$unidretenue}"
					{if ($uneRetenue.places <= $uneRetenue.occupation) && isset($fait.idretenue) && ($fait.idretenue != $unidretenue)} disabled="disabled" {/if}
					{if isset($fait.idretenue) && ($fait.idretenue == $unidretenue)} selected="selected" {/if}>
						{$uneRetenue.jourSemaine} {$uneRetenue.dateRetenue} [durée: {$uneRetenue.duree}h à {$uneRetenue.heure}] : {$uneRetenue.occupation}/{$uneRetenue.places}
					</option>
				{/if}
				{/foreach}
			</select>
		</div>
		<!-- form-group -->
		{assign var="tabIndex" value=$tabIndex+1}
	</div>  <!-- col-sm-... -->

</div>  <!-- row -->
{/strip}
