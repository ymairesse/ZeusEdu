{if $etape == 'demander'}
	<div id="dialog-confirm" title="Suppression de la nouvelle">
	<p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
	La nouvelle "{$titre}" sera supprimée. Veuillez confirmer.</p>
	</div>
{/if}



<script type="text/javascript">
var id={$id};

{literal}
$(document).ready(function(){
	
	 $( "#dialog-confirm" ).dialog({
		resizable: false,
		height:200,
		width: 400,
		modal: true,
		buttons : {
			"Effacer" : function() {
				$(this).dialog("close");
				$.post("inc/deleteFlashInfo.inc.php",
					{'id': id},
					function (resultat) {
						$("#flashInfo"+id).html(resultat);
						}
					);
					},
			"Annuler" : function() {
				$(this).dialog("close");
				}
			}
		});

	})
{/literal}
</script>
