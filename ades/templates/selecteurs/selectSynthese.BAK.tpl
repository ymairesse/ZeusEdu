<div class="container">

	<div class="row">
		<h3>Génération des fiches disciplinaires</h3>

		<div class="col-md-2 col-xs-12">

			<div style="border: 1px solid grey; padding: 1em 0.5em">

				<div class="form-group">
					<label for="debut">Depuis</label>
					<input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker form-control">
				</div>

				<div class="form-group">
					<label for="fin">Jusqu'à</label>
					<input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker form-control">
				</div>

				<div class="form-group">
					<label for="niveau">Niveau d'étude</label>
					<select name="niveau" id="niveau" class="form-control">
						<option value="">Niveau</option>
						{foreach from=$listeNiveaux item=unNiveau}
							<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>{$unNiveau}e</option>
						{/foreach}
					</select>
				</div>

				<div id="listeClasses">
					{include file="selecteurs/listeClasses.tpl"}
				</div>

				<div id="listeEleves">
					{include file="selecteurs/listeEleves.tpl"}
				</div>
				<div class="btn-group-vertical btn-block" id="boutons">
					<button type="button" class="btn btn-primary" title="À l'écran" id="generer">Générer <i class="fa fa-eye"></i></button>
					<button type="button" class="btn btn-success" title="Fichier PDF" id="genererPDF">Générer en <i class="fa fa-file-pdf-o"></i></button>
				</div>
				<span id="ajaxLoader" class="hidden">
					<img src="images/ajax-loader.gif" alt="loading">
				</span>

			</div>

		</div>

		<div class="col-md-10 col-xs-12" id="zoneSynthese">

		</div>

	</div>

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

		$("#genererPDF").click(function(){
			var debut = $("#debut").val();
			var fin = $("#fin").val();
			var niveau = $("#niveau").val();
			var classe = $("#selectClasse").val();
			var matricule = $("#selectEleve").val();
			$.post('inc/eleves/generateFichesPDF.inc.php', {
				debut: debut,
				fin: fin,
				niveau: niveau,
				classe: classe,
				matricule: matricule
				},
				function(resultat){
					$("#zoneSynthese").html(resultat);
				}
			)
		})

		$("#generer").click(function(){
			var debut = $("#debut").val();
			var fin = $("#fin").val();
			var niveau = $("#niveau").val();
			var classe = $("#selectClasse").val();
			var matricule = $("#selectEleve").val();
			$.post('inc/eleves/generateFicheDisc.inc.php', {
				debut: debut,
				fin: fin,
				niveau: niveau,
				classe: classe,
				matricule: matricule
				},
				function(resultat){
					$("#zoneSynthese").html(resultat);
				}
			);
		})

		$("#debut, #fin").datepicker({
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
		});

		if ($("#niveau").val() == '')
			$("#boutons").hide();
			else $("#boutons").show();

		$("#niveau").change(function(){
			var niveau = $(this).val();
			$("#selectClasse").val('');
			$("#selectEleve").val('');
			$.post('inc/listeClasses.inc.php', {
				'niveau': niveau
					},
				   function (resultat) {
					$("#listeClasses").html(resultat)
				   }
				);
			if (niveau == '') {
				$("#boutons").hide();
				$("#listeClasses, #listeEleves").html('');
				}
				else $("#boutons").show();
			})

		$("#listeClasses").on("change","#selectClasse",function(){
			var classe = $(this).val();
			$("#selectEleve").val('');
			$.post('inc/listeEleves.inc.php', {
				'classe': classe
					},
				   function (resultat) {
					$("#listeEleves").html(resultat);
				   }
				)
			})


	})

</script>
