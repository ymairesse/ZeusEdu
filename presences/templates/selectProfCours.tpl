<div id="selecteurProf" class="noprint">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="selectProf" id="selectProf">
		<option value="">Professeur</option>
			{foreach from=$listeProfs item=unProf}
				<option value="{$unProf.acronyme}" {if $unProf.acronyme == $acronyme}selected{/if}>{$unProf.nom|truncate:15} {$unProf.prenom}</option>
			{/foreach}
		</select>

		<span id="selectCoursGrp">		
		{if $listeCoursGrp}
		<select name="coursGrp" id="coursGrp">
			<option value="">Sélectionnez un cours</option>
		{foreach from=$listeCoursGrp key=cours item=data}
			<option value="{$cours}"{if $cours == $coursGrp}selected="selected"{/if}>{$data.libelle|truncate:25} ({$data.classes})</option>
		{/foreach}
		</select>
		{else}
		<select name="coursGrp" id="coursGrp">
			<option value=''>Cours</option>
		</select>
		{/if}
		</span>
		
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="listeEleves">
	</form>
	
</div>

<script type="text/javascript">
{literal}
	$(document).ready (function() {
	
		$("#selectProf").change(function(){
			var acronyme = $(this).val();
			if (acronyme != '')
				$.post("inc/listeCoursProf.inc.php",
				{'acronyme': acronyme},
					function (resultat){
						$("#selectCoursGrp").html(resultat)
					}
				)
		})
		
		$("#coursGrp").live("change",function(){
			$("#formSelecteur").submit();
			})
		
		$("#formSelecteur").submit(function(){
			if (($("#selectProf").val() == '') || ($("#coursGrp").val() == ''))
				return false;
				else {
					$.blockUI();
					$("#wait").show();
					}
		})
	})
{/literal}
</script>
