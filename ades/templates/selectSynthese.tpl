<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		Depuis <input type="text" value="{$debut}" name="debut" id="debut" size="10" maxlength="10">
		Jusqu'à <input type="text" value="{$fin}" name="fin" id="fin" size="10" maxlength="10">
		<select name="niveau" id="niveau">
			<option value="">Niveau</option>
			{foreach from=$listeNiveaux item=unNiveau}
				<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>{$unNiveau}e</option>
			{/foreach}
		</select>
			
		<span id="listeClasses">
			{include file="listeClasses.tpl"}
		</span>
		
		<span id="listeEleves">
			{include file="listeEleves.tpl"}
		</span>

		<input type="submit" name="submit" value="OK" id="submit">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
	</form>
	
</div>


<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$("#debut, #fin").datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	
		});
		
		if ($("#niveau").val() == '') 
			$("#submit").hide();
			else $("#submit").show();
		
		$("#niveau").change(function(){
			var niveau = $(this).val();
			$.post('inc/listeClasses.inc.php',
				   {'niveau': niveau},
				   function (resultat) {
					$("#listeClasses").html(resultat)
				   }
				);
			if (niveau == '') {
				$("#submit").hide();
				$("#listeClasses, #listeEleves").html('');
				}
				else $("#submit").show();
			})
		
		$("#listeClasses").on("change","#selectClasse",function(){
			var classe = $(this).val();
			$.post('inc/listeEleves.inc.php',
				   {'classe': classe},
				   function (resultat) {
					$("#listeEleves").html(resultat);
				   }
				)
			})
		
		$("#listeEleves").on("change", "#selectEleve", function(){
			// $("#formSelecteur").submit();
		})
		

	})
{/literal}
</script>
