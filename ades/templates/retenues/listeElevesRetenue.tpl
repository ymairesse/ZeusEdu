<div class="container">

	<div class="row">

			<h3>{$infosRetenue.jourSemaine|ucfirst}, le {$infosRetenue.dateRetenue}</h3>

			<form class="form-vertical" id="formRetenue">

				<span id="getPDF"></span>
				<button type="button" class="btn btn-success pull-right" data-idretenue="{$idretenue}" id="printPDF">Enregistrer et Imprimer <i class="fa fa-file-pdf-o"></i></button>

				<div class="table-responsive" id="tableauRetenues">

					{include file="retenues/tableauListeRetenues.tpl"}

				</div>

				<div class="btn-group pull-right">
					<button type="reset" class="btn btn-default">Annuler</button>
					<button type="button" class="btn btn-primary" id="saveRetenue">Enregistrer</button>
				</div>
				<input type="hidden" name="idretenue" value="{$idretenue}">

				<div class="clearfix"></div>

			</form>

	</div>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$(".popover-eleve").mouseenter(function(event) {
			$(this).popover('show');
		})

		$(".popover-eleve").mouseout(function(event) {
			$(this).popover('hide');
		})

		$("#printPDF").click(function(){
			// enregistrer l'état actuel de la liste
			$("#saveRetenue").trigger('click');
			// imprimer en PDF
			var idretenue = $(this).data('idretenue');
			$("#getPDF").hide(500).html('');
			$.post('inc/retenues/listeRetenuesPDF.inc.php', {
				idretenue: idretenue
				},
				function(resultat){
					$("#getPDF").html(resultat).show(500);
				})
		})

		$('#saveRetenue').click(function(){
			var formulaire = $("#formRetenue").serialize();
			$.post('inc/retenues/savePresencesRetenues.inc.php', {
				formulaire: formulaire
			},
			function(resultat){
				bootbox.alert(resultat);
			})
		})

	})
</script>
