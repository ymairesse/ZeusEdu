<div class="container-fluid">

    <div class="row">

        <form id="formSelect" method="POST" action="inc/retards/printSyntheseRetards.php">

            <h2 class="col-xs-12">Synthèse des sanctions pour retards <button type="submit" name="button" class="btn btn-primary pull-right"><i class="fa fa-print fa-lg"></i> </button> </h2>

            <div class="col-md-3 col-xs-12" id="selecteurEleves">

                {include file='selecteurs/selectRetards.tpl'}

            </div>

            <div class="col-md-9 col-xs-12" id="zoneSynthese">

            </div>

            <div class="clearfix"></div>
            
        </form>
    </div>
</div>

<div id="zonePDF">

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

		$('#btn-getRetards').click(function(){
			if ($('#formSelect').valid()){
                $('#btn-print').attr('disabled', false);
				var formulaire = $('#formSelect').serialize();
                $.post('inc/retards/generateListeSynthese.inc.php', {
                    formulaire: formulaire
                    },
                function (resultat){
                    $("#zoneSynthese").html(resultat);
                })
			}
            else {
                $('#btn-print').attr('disabled', true);
            }
		})

		$("#debut, #fin").datepicker({
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
		});

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

		$("#listeClasses").on("change", "#selectClasse", function(){
			var classe = $(this).val();
			$("#selectEleve").val('');
			$.post('inc/listeEleves.inc.php', {
				classe: classe
				},
			   function (resultat) {
				$("#listeEleves").html(resultat);
			   }
			)
			})

        $('#btn-print').click(function(){
            var formulaire = $('#formSelect').serialize();
            $.post('inc/retards/printSyntheseRetards.inc.php', {
                formulaire: formulaire
                },
            function (resultat){
                $("#zonePDF").html(resultat);
            })
        })
	})

</script>
