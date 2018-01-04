<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">

		<select class="form-control input-sm" name="niveau" id="selectNiveau">
			<option value="">Tous les élèves</option>
			{foreach from=$listeNiveaux item=unNiveau}
				<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>Élèves de {$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}</option>
			{/foreach}
		</select>

		<select name="classe" id="selectClasse" class="form-control input-sm">
			{include file='selecteurs/listeOptionsClasses.tpl'}
		</select>

		<select name="matricule" id="selectEleve" class="form-control input-sm">
			{include file='selecteurs/listeOptionsEleves.tpl'}
		</select>

		<input type="text" name="type" id="type" value="{$type|default:'ecole'}">

	</form>
</div>

<script type="text/javascript">

$(document).ready(function(){
	
	$('#selectNiveau').change(function(){
		var niveau = $(this).val();
		$('#selectEleve').hide();
		if (niveau == '') {
			$('#selectClasse').hide();
			$('#type').val('ecole');
			$('#cible').text('tous les élèves')
			}
			else {
				$.post('inc/jdc/listeClassesNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#selectClasse').html(resultat).show();
					$('#type').val('niveau');
					var suffixe = (niveau == 1) ? "ères" : "èmes";
					$('#cible').text('tous les élèves de ' + niveau + suffixe);
					$('#calendar').fullCalendar('refetchEvents');
				})
			}
		})

	$("#selectClasse").change(function(){
		var classe = $(this).val();
		if (classe == '') {
			$('#selectEleve').hide();
			$('#type').val('niveau');
			}
			else {
				$.post('inc/jdc/listeEleves.inc.php',{
					classe: classe
				}, function (resultat){
					$('#selectEleve').html(resultat).show();
					$('#type').val('classe');
					$('#cible').text('tous les élèves de ' + classe);
					$('#calendar').fullCalendar('refetchEvents');
					}
				)
			}
		});

	$('#selectEleve').change(function(){
		var matricule = $(this).val();
		if (matricule == '') {
			$('#type').val('classe');
			}
			else {
				$('#type').val('eleve');
				var nomEleve = $('#selectEleve :selected').text()
				$('#cible').text(nomEleve);
				$('#calendar').fullCalendar('refetchEvents');
			}
		})
})

</script>
