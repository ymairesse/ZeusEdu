{assign var=bull value=$bulletin-1}
<div id="dialog" title="Bulletin one click">
	<p>Aucune cote à transférer: le carnet de cotes est vide pour le cours <br>
	<strong>{$listeCours.$coursGrp.libelle} ({$coursGrp})</strong> et <br>
	pour la période <strong>{$bulletin} ({$NOMSPERIODES.$bull})</strong></p>
</div>

<script type="text/javascript">
	$(function() {
		$( "#dialog" ).dialog({
			width: 400,	
			buttons: {
				Ok: function() {
					$( this ).dialog( "close" );
					}
				}
			});
	});
</script>

