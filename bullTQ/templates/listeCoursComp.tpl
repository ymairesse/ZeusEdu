
<div class="form-group">
	<select name="cours" id="cours" class="form-control">
		<option value="">Choisir un cours</option>
		{foreach from=$listeCoursComp key=leCours item=unCours}
		<option value="{$leCours}"{if isset($cours) && ($leCours == $cours)} selected="selected"{/if}>
			{$unCours.libelle} {$unCours.statut} {$unCours.nbheures}h [{$leCours}]</option>
		{/foreach}
	</select>
</div>

<script type="text/javascript">

	$("#cours").change(function(){
		if ($(this).val() != '')
			$("#formSelecteur").submit();
		})

</script>
