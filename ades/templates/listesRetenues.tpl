<div class="container-fluid">

<h3>Dates des retenues</h3>

<button type="button" class="btn btn-primary pull-right btn-lg" data-typeretenue="{$typeRetenue}" id="new">Nouvelle retenue</button>

<h4>Type: {$infosRetenue.titreFait} Nombre: <span id="nbRetenues">{$listeRetenues|@count}</span></h4>

<button type="button" class="btn btn-primary" id="cache" title="Montrer les retenues cachées">Cacher/Montrer</button>

<div class="table-responsive">

	<table class="table table-condensed table-hover" id="tableRetenues">
		<thead>
			<tr>
			<th>&nbsp;</th>
			<th>Date</th>
			<th>Heure</th>
			<th>Durée</th>
			<th>Local</th>
			<th>Places</th>
			<th>Occupation</th>
			<th>Visible</th>
			<th>Éditer</th>
			<th>Cloner</th>
			<th>id</th>
			</tr>
		</thead>
		{foreach from=$listeRetenues key=idretenue item=uneRetenue}

			{include file="retenues/retenueDeListe.tpl"}

		{/foreach}
	</table>

</div>

</div>  <!-- container -->


<!-- boîte modale pour l'édition des retenues -->

<div class="modal fade" id="modalEdit" tabindex="-1" role="dialog" aria-labelledby="editTitle" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="editTitle">Édition des retenues</h4>
      </div>
      <div class="modal-body" id="formEdit">

		  <!-- emplacement du formulaire -->

      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(".cache").hide();

		$("#cache").click(function(){
				$('.cache').toggle();
				$('.pasCache').toggle();
			})

		$("#new").click(function(){
			$("#editTitle").text('Nouvelle retenue');
			var typeRetenue = $(this).data('typeretenue');
			var idRetenue = Null;
			$.post('inc/retenues/newRetenue.inc.php',{
				typeRetenue: typeRetenue
			},
			function(resultat){
				$("#formEdit").html(resultat);
				$("#modalEdit").modal('show');
			})
		})

		$('#tableRetenues').on('click', '.edit', function(){
			var typeRetenue = $(this).data('typeretenue');
			var idRetenue = $(this).data('idretenue');
			$.post('inc/retenues/newRetenue.inc.php',{
				typeRetenue: typeRetenue,
				idRetenue: idRetenue
			},
			function(resultat){
				$("#formEdit").html(resultat);
				$("#modalEdit").modal('show');
			})
		})

		$('#tableRetenues').on('click', '.eye', function(){
			var bouton = $(this);
			var idretenue=$(this).data('idretenue');
			var visible = $(this).data('visible');
			$.post('inc/retenues/visibleInvisible.inc.php', {
				idretenue: idretenue,
				visible: visible
			   },
			   function (resultat) {
				   	bouton.data('visible', resultat);
					bouton.closest('tr').fadeOut();
					if (resultat == 'N') {
						bouton.closest('tr').removeClass('pasCache').addClass('cache');
						bouton.removeClass('btn-success').addClass('btn-danger');
						bouton.find('i').removeClass().addClass('fa fa-eye-slash');
						}
						else {
							bouton.closest('tr').removeClass('cache').addClass('pasCache');
							bouton.removeClass('btn-danger').addClass('btn-success');
							bouton.find('i').removeClass().addClass('fa fa-eye');
						}
			   }
			)
			})

		// clonage d'une retenue existante
		$('#tableRetenues').on('click', '.cloner', function(){
			var bouton = $(this);
			var ligne = $(this).closest('tr').clone(true);
			var idretenue = $(this).data('idretenue');
			$.post('inc/saveCloneRetenue.inc.php', {
				idretenue: idretenue
			},
				function (resultat){
					var test = bouton.html();
					bouton.closest('tr').after(resultat).fadeIn();
				})
			})

		$('#tableRetenues').on('click', '.del', function(){
			if (confirm('Veuillez confirmer la suppression de cette retenue')) {
			var tr = $(this).closest('tr');
			var idretenue = $(this).data("idretenue");
			$.post('inc/delRetenue.inc.php', {
				'idretenue': idretenue
				},
				function(resultat) {
					if (resultat == 1) {
						tr.fadeOut().remove();
						nb = $("#nbRetenues").text();
						$("#nbRetenues").text(nb-resultat);
						}
					}
				);
			}
			})

	})

</script>
