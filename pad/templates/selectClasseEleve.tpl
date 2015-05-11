<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<div class="input-group">
			<label for="selectClasse">Classe</label>
				<select name="classe" id="selectClasse" class="form-control-inline">
				<option value="">Classe</option>
				{foreach from=$listeClasses item=uneClasse}
					<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected{/if}>{$uneClasse}</option>
				{/foreach}
				</select>
		</div>
		<span id="choixEleve">
			
		{include file='listeEleves.tpl'}
	
		</span>
				
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
		})
	

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		if (classe != '') $("#envoi").show();
		// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
		$.post("inc/listeEleves.inc.php",{
			'classe': classe
			},
			function (resultat){
				$('#choixEleve').html(resultat)
				}
			)
		});

	$("#choixEleve").on("change", "#selectEleve", function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative, le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
			}
			else $("#envoi").hide();
		})
		
	$("#prev").click(function(){
		var matrPrev = $("#matrPrev").val();
		$("#selectEleve").val(matrPrev);
		$("#formSelecteur").submit();
		})
	
	$("#next").click(function(){
		var matrNext = $("#matrNext").val();
		$("#selectEleve").val(matrNext);
		$("#formSelecteur").submit();
		})
})

</script>
