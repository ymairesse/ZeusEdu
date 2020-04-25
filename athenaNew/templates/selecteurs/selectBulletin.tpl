<div class="selecteur">

	<form name="selectBulletin" id="selectBulletin" action="index.php" method="POST" class="form-inline" role="form">

		Bulletin n° {foreach from=$listeBulletins item=bulletin} {$bulletin}
		<input type="radio" value="{$bulletin}" name="noBulletin" class="noBulletin" {if $bulletin==$noBulletin} checked{/if}> {/foreach}
		<button type="button" class="btn btn-primary btn-xs" id="bulletin">OK</button>
		<input type="hidden" name="matricule" id="matricule" value="{$eleve.matricule}">
		<input type="hidden" name="anneeEtude" id="anneeEtude" value="{$eleve.annee[0]}">
	</form>

</div>

<div id="bulletinEleve">

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$("#bulletin").click(function(){
			var noBulletin = $('input[name=noBulletin]:checked', '#selectBulletin').val();
			var matricule = $('#matricule').val();
			var anneeEtude = $('#anneeEtude').val()
			$.post("inc/bulletin.inc.php", {
				matricule: matricule,
				noBulletin: noBulletin,
				anneeEtude: anneeEtude
				},
					function (resultat){
						$("#bulletinEleve").html(resultat)
					}
				)


		})

	})

</script>
