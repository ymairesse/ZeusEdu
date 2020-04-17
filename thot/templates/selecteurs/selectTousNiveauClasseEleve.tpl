<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" class="form-inline">

		<select class="form-control input-sm" name="niveau" id="selectNiveau">
			<option value="">Tous les élèves</option>
			{foreach from=$listeNiveaux item=unNiveau}
				<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>Élèves de {$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}</option>
			{/foreach}
		</select>

		<select name="classe" id="selectClasse" class="form-control input-sm hidden">
			{include file='selecteurs/listeOptionsClasses.tpl'}
		</select>

		<select name="matricule" id="selectEleve" class="form-control input-sm hidden">
			{include file='selecteurs/listeOptionsEleves.tpl'}
		</select>

		<input type="hidden" name="type" id="type" value="{$type|default:''}">

	</form>
</div>

<script type="text/javascript">

	$(document).ready(function(){

	$('#selectNiveau').change(function(){
		var niveau = $(this).val();
		if (niveau != '') {
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
			$('#selectClasse').html('').addClass('hidden');
			$('#selectEleve').html('').addClass('hidden');
		}
		$('#calendar').fullCalendar('refetchEvents');
	})

	$('#selectClasse').change(function(){
		var classe = $(this).val();
		if (classe != '') {
			$('#type').val('classe');
			$.post('inc/jdc/listeEleves.inc.php', {
				classe: classe
			}, function(resultat){
				$('#selectEleve').html(resultat).removeClass('hidden');
			})
		}
		else {
			$('#type').val('niveau')
			$('#selectEleve').html('').addClass('hidden');
		}
		$('#calendar').fullCalendar('refetchEvents');
	})

	$('#selectEleve').change(function(){
		var matricule = $(this).val();
		if (matricule != '') {
			$('#type').val('eleve');
		}
		else {
			$('#type').val('classe');
		}
        $('#calendar').fullCalendar('refetchEvents');
	})

})

</script>
