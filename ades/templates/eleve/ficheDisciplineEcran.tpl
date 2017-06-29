<div class="container">

    <div class="row">

        <h2>Fiches de comportement</h2>

        <div class="col-md-2 col-xs-12">

            {include file='selecteurs/selectSynthese.tpl'}

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
					$("#listeClasses").html(resultat);
                    $("#listeEleves").html('');
                    if (niveau == '') {
                        $("#listeClasses").html('');
                        $("#boutons").hide();
                        }
                        else $("#boutons").show();
				   }
				);
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
