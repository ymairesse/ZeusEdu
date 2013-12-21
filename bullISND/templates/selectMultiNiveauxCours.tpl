<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="niveau[]" id="niveau" multiple="multiple" size="2" value="{","|implode:$niveau}">
		<option value="">Niveaux</option>
		{foreach from=$listeNiveaux key=k item=unNiveau}
			<option value="{$unNiveau}">{$unNiveau}</option>
		{/foreach}
	</select>
	
	<span id="choixCours">
		{include file="listeCours.tpl"}
	</span>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		var cours=$("#coursGrp");
		if (cours != '') {
			$("#wait").show();
			$("#corpsPage").hide();
		}
	})

	$("#niveau").change(function(){
		$("#wait").show();
		var niveau = $(this).val();
		$.post("inc/listeCoursNiveau.inc.php",
			{niveau: niveau},
				function (resultat){
					$("#choixCours").html(resultat)
				}
			)
		$("#wait").hide();
	});

		
	$("#coursGrp").change(function() {
		var coursGrp = $(this).val();
		if (courGrp != '')
			$("#formSelecteur").submit();
	})
})
{/literal}
</script>