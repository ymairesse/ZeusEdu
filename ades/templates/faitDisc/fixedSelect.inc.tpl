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
			<select name="{$unChamp}"
					id="{$unChamp}"
					class="form-control"
					readonly>
				{foreach from=$listeRetenues key=unidretenue item=uneRetenue}
					{if isset($fait.idretenue) && ($fait.idretenue == $unidretenue)}
						<option value="{$unidretenue}">
							{$uneRetenue.jourSemaine} {$uneRetenue.dateRetenue} [durée: {$uneRetenue.duree}h à {$uneRetenue.heure}] : {$uneRetenue.occupation}/{$uneRetenue.places}
						</option>
					{/if}
				{/foreach}
			</select>
		</div>
		<!-- form-group -->

	</div>  <!-- col-sm-... -->

</div>  <!-- row -->
{/strip}
