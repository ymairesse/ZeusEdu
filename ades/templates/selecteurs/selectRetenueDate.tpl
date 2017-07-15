<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">

		<select name="typeRetenue" id="selectType" class="form-control input-sm">
		<option value="">Type de retenue</option>
		{foreach from=$listeTypes key=ceType item=unType}
			<option value="{$ceType}"{if isset($typeRetenue) && ($typeRetenue == $ceType)} selected="selected"{/if}>{$unType.titreFait}</option>
		{/foreach}
		</select>

		<span id="choixDateRetenue">

			{include file="selecteurs/selectListesRetenues.tpl"}

		</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi" {if (!isset($listeRetenues))}style="display:none"{/if}>OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectType").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})


	$("#selectType").change(function(){
		// on a choisi une classe dans la liste déroulante
		var type = $(this).val();

		if (type != '')
			$("#envoi").show();
		// la fonction listeRetenues.inc.php renvoie la liste déroulante des retenues du type sélectionné
		$.post("inc/retenues/listeRetenues.inc.php", {
			type: type
			},
			function (resultat){
				$("#choixDateRetenue").html(resultat)
			}
		)
	});

	$("#choixDateRetenue").on("change", "#selectRetenue", function(){
		if ($(this).val() != '') {
			$("#formSelecteur").submit();
			}
		})

})

</script>
