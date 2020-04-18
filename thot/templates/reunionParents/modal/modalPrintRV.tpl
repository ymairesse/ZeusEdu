<!-- .......................................................................... -->
<!-- .....fenêtre modale pour la réception du fichier PDF des RV                -->
<!-- .......................................................................... -->
<div class="modal fade noprint" id="modalPrintRV" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Votre liste est prête
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="../{$module}/{$acronyme}/{$acronyme}.pdf">sur ce lien</a></p>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#celien").click(function(){
		$("#modalPrintRV").modal('hide')
	})

})

</script>
