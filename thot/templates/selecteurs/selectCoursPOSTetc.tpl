<div id="selecteur" class="selecteur noprint" style="clear:both">

<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

	<select class="form-control input-sm" name="niveau" id="selectNiveau">
		<option value="">Tous les élèves</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>Élèves de {$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}</option>
		{/foreach}
	</select>

	<select name="classe" id="selectClasse"
		class="form-control input-sm {if (!(isset($listeClasses)))} hidden{/if}">
		{if isset($niveau)}
		{include file='selecteurs/listeOptionsClasses.tpl'}
		{/if}
	</select>

	<select name="matricule" id="selectEleve" class="form-control input-sm {if !(isset($listeEleves))} hidden{/if}">
		{if isset($classe)}
		{include file='selecteurs/listeOptionsEleves.tpl'}
		{/if}
	</select>

	<button type="submit" id="submit" class="btn btn-primary btn-sm">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode|default:'voir'}">
	<input type="hidden" name="etape" value="show">
	<input type="hidden" name="type" id="type" value="{$type|default:'ecole'}">
	<input type="hidden" name="cible" id="cible" value="{$cible|default:'all'}">

</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$('#selectNiveau').change(function(){
		var niveau = $(this).val();
		if (niveau != '') {
			$('#cible').val(niveau);
			$('#type').val('niveau');
			$.post('inc/jdc/listeClassesNiveau.inc.php', {
				niveau: niveau
			}, function(resultat){
				$('#selectClasse').html(resultat).removeClass('hidden');
				$('#selectEleve').html('').addClass('hidden');
			})
		}
		else {
			$('#type').val('ecole');
			$('#cible').val('all');
			$('#selectClasse').html('').addClass('hidden');
			$('#selectEleve').html('').addClass('hidden');
		}
	})

	$('#selectClasse').change(function(){
		var classe = $(this).val();
		if (classe != '') {
			$('#cible').val(classe);
			$('#type').val('classe');
			$.post('inc/jdc/listeEleves.inc.php', {
				classe: classe
			}, function(resultat){
				$('#selectEleve').html(resultat).removeClass('hidden');
			})
		}
		else {
			var niveau = $('#selectNiveau').val();
			$('#type').val('niveau');
			$('#cible').val(niveau);
			$('#selectEleve').html('').addClass('hidden');
		}
	})

	$('#selectEleve').change(function(){
		var matricule = $(this).val();
		if (matricule != '') {
			$('#cible').val(matricule);
			$('#type').val('eleve');
		}
		else {
			var classe = $('#selectClasse').val();
			$('#cible').val(classe);
			$('#type').val('classe');
		}
	})

})

</script>
