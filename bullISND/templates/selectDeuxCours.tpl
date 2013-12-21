<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
	
	<label for="niveauOrigine">Origine</label>
	<select name="niveauOrigine" id="niveauOrigine">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux key=k item=unNiveau}
			<option value="{$unNiveau}"{if $unNiveau eq $niveauOrigine} selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>
	
	<span id="choixCoursOrigine">
		{include file="listeCoursStatiqueOrigine.tpl"}
	</span>
	
	<br>
	
	<label for="niveauDestination">Destination</label>
	<select name="niveauDestination" id="niveauDestination">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux key=k item=unNiveau}
			<option value="{$unNiveau}"{if $unNiveau eq $niveauDestination} selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>
	
	<span id="choixCoursDest">
		{include file="listeCoursStatiqueDestination.tpl"}
	</span>
	
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="transfertCours">
	<input type="hidden" name="etape" value="transfert">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {


	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$("#corpsPage").hide();
	})

	$("#niveauDestination").change(function(){
			$("#wait").show();
			var niveau = $(this).val();
			$.post("inc/listeCoursNiveauDestination.inc.php",
				{niveau: niveau},
					function (resultat){
						$("#choixCoursDest").html(resultat)
					}
				)
			$("#wait").hide();
		});
	
	$("#niveauOrigine").change(function(){
		$("#wait").show();
		var niveau = $(this).val();
		$.post("inc/listeCoursNiveauOrigine.inc.php",
			{niveau: niveau,
			"nom": "groupeOrig"},
				function (resultat){
					$("#choixCoursOrigine").html(resultat)
				}
			)
		$("#wait").hide();
	});	

})
{/literal}
</script>