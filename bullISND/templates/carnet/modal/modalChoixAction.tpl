<div class="modal fade noprint" id="modalChoixAction" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Évaluation du {$entete.date}
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<form name="choixEdit" methode="POST" action="index.php">
					<p><strong>Libellé:</strong> {$entete.libelle}</p>
					<p><strong>Remarque:</strong> {$entete.remarque}</p>
					<p><strong>Compétence:</strong> {$entete.competence}</p>
					<p><strong>Max:</strong> {$entete.max} points</p>
					<p>Que souhaitez-vous faire?</p>
					<div class="btn-group">
						<button type="button" class="btn btn-info boutonEdit" data-idcarnet="{$entete.idCarnet}">Modifier l'évaluation</button>
						<button type="button" class="btn btn-primary boutonEncoder" data-idcarnet="{$entete.idCarnet}">Encoder les cotes</button>
						<button type="button" class="btn btn-danger boutonSuppr" data-idcarnet="{$entete.idCarnet}">Supprimer cette évaluation</button>
					</div>
				</form>
			</div>
		</div>

	</div>

</div>
