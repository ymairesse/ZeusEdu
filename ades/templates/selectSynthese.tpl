<div id="selecteur" class="noprint">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		Depuis <input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker">
		Jusqu'à <input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker">
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

		<button type="submit" class="btn btn-primary btn-sm" id="submit">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
	</form>
	
</div>


<script type="text/javascript">

	$(document).ready(function(){
		
		$("#debut, #fin").datepicker({ 
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
		});
		
		if ($("#niveau").val() == '') 
			$("#submit").hide();
			else $("#submit").show();
		
		$("#niveau").change(function(){
			var niveau = $(this).val();
			$.post('inc/listeClasses.inc.php', {
				'niveau': niveau
					},
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
			$.post('inc/listeEleves.inc.php', {
				'classe': classe
					},
				   function (resultat) {
					$("#listeEleves").html(resultat);
				   }
				)
			})
		

	})

</script>
