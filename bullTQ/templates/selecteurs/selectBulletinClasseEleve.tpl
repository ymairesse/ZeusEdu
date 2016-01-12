<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">

		Bulletin n°
		<select name="bulletin" id="bulletin">
			{section name=bulletins start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.bulletins.index}" {if $smarty.section.bulletins.index eq $bulletin} selected{/if}>
				{$smarty.section.bulletins.index}
			</option>
			{/section}
		</select>

		<select name="classe" id="selectClasse">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}" {if $uneClasse eq $classe} selected="selected" {/if}>{$uneClasse}</option>
			{/foreach}
		</select>
		<span id="choixEleve">
			{include file="listeEleves.tpl"}
		</span>
		<button type="submit" class="btn btn-primary btn-xs" id="envoi" {if !(isset($matricule))}style="display: none" {/if}>OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showEleve">
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function() {
			if ($("#selectEleve").val() != '') {
				$.blockUI();
				$("#wait").show();
			} else return false;
		})

		$("#bulletin").change(function() {
			$("#envoi").show();
		})

		$("#selectClasse").change(function() {
			// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
			if (classe != '') $("#envoi").show();
			else $("#envoi").hide();
			// la fonction listeEleves.inc.php renvoie la liste déroulante
			// des élèves de la classe sélectionnée
			$.post("inc/listeEleves.inc.php", {
					'classe': classe
				},
				function(resultat) {
					$("#choixEleve").html(resultat)
				}
			)
		});

		$("#choixEleve").on("change", "#selectEleve", function() {
			if ($(this).val() > 0) {
				// si la liste de sélection des élèves renvoie une valeur significative
				// le formulaire est soumis
				$("#formSelecteur").submit();
				$("#envoi").show();
			} else $("#envoi").hide();
		})
	})
</script>
