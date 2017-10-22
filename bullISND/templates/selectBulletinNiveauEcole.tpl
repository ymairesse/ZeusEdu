<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=foo start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.foo.index}"{if $smarty.section.foo.index == $bulletin} selected="selected"{/if}>{$smarty.section.foo.index}</option>
		{/section}
	</select>
	<select name="niveau" id="niveau" class="form-control input-sm">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected="selected"{/if}>{$unNiveau}</option>
		{/foreach}
	</select>

	<span id="choixEcole">{if isset($listeEcoles)}
		{include file="listeEcoles.tpl"}
	{/if}</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="etape" value="show">
	</form>
</div>
<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#choixEcole").html() == '')  || $("#ecole").val() == '') {
				return false;
		}
		$("#wait").show();
		$.blockUI();
	})

	$("#niveau").change(function(){
		$("#wait").show();
		var niveau = $(this).val();
		$.post("inc/listeEcoles.inc.php", {
			niveau: niveau},
				function (resultat){
					$("#choixEcole").html(resultat)
				}
			)
		$("#wait").hide();
	});

	$("#bulletin").change(function(){
		var ecole = $("#ecole").val();
		if (ecole != '')
			$("#formSelecteur").submit();

		})

	$("#choixEcole").on("change", "#ecole", function() {
		var ecole = $(this).val();
		if (ecole != '')
			$("#formSelecteur").submit();
	})
})

</script>
