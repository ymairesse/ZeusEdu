<div class="container-fluid">

	<div class="row">

		<h2>Statistiques</h2>

		<div class="col-md-3 col-xs-12">

			{include file='selecteurs/selectSynthese.tpl'}

		</div>

		<div class="col-md-9 col-xs-12" id="zoneSynthese">

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

		$("#printSelect").click(function(){
            $("#modalPrintFait").modal('show');
        })

        $("#confPrint").click(function(){
            $("#modalPrintFait").modal('hide');
        })

		$("#genererPDF").click(function(){
			var formulaire = $("#formPrint").serialize();
			$.post('inc/eleves/generateStatsPDF.inc.php', {
				formulaire: formulaire
				},
				function(resultat){
					$("#zoneSynthese").html(resultat);
				}
			)
		})

		$("#generer").click(function(){
			var formulaire = $("#formPrint").serialize();
			$.post('inc/eleves/generateStats.inc.php', {
				formulaire: formulaire
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
