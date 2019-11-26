<div class="container-fluid">

    <div class="row">

        <form id="formSelect" method="POST">

            <h2 class="col-xs-12">Traitement des retards</h2>

            <div class="col-md-3 col-xs-12" id="selecteurEleves">

                {include file='selecteurs/selectRetards.tpl'}

            </div>

            <div class="col-md-9 col-xs-12" id="zoneTraitement">

            </div>

        <div class="clearfix"></div>

        </form>

    </div>
</div>


<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('#zoneTraitement').on('click', '#btn-reset', function(){
            $('#ulDates li').remove();
            $('#btn-save').prop('disabled', true);
        })

        $('#zoneTraitement').on('click', '#btn-save', function(){
            var formulaire = $('#formDates').serialize();
            $.post('inc/retards/saveSanctionRetard.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                if (resultat != ''){
                    $('#btn-getRetards').trigger('click');
                    $('#modalChoixSanction').modal('hide');
                }
            })
        })

        $('#zoneTraitement').on('click', '.delButton', function(){
            var idTraitement = $(this).parent().data('idtraitement');
            $('.btn-printer[data-idtraitement="' + idTraitement + '"]').removeClass('btn-info').addClass('btn-default');
            $(this).closest('div').remove();
        })

        $('#zoneTraitement').on('click', '.btn-printer', function(){
            var matricule = $(this).data('matricule');
            var idTraitement = $(this).data('idtraitement');
            if ($(this).hasClass('btn-info')) {
                $(this).removeClass('btn-info').addClass('btn-default');
                $('.billet[data-idtraitement="' + idTraitement + '"]').remove();
                $(this).next('input').val('');
                }
                else {
                    $(this).removeClass('btn-default').addClass('btn-info');
                    $(this).next('input').val(matricule + "_" + idTraitement);
                }
            var nbPrint = $('.btn-printer.btn-info').length;
            if (nbPrint == 0)
                $('#printRetards').text('Imprimer').attr('disabled', true);
                else {
                    var texte = 'Imprimer <span class="badge">' + nbPrint + '</span>';
                    $('#printRetards').html(texte).attr('disabled', false);
                }
        })

		$('#btn-getRetards').click(function(){
			if ($('#formSelect').valid()){
				var formulaire = $('#formSelect').serialize();
				$.post('inc/retards/generateListeRetards.inc.php', {
                    formulaire: formulaire
                    },
                function (resultat){
                    $("#zoneTraitement").html(resultat);
                })
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

	})

</script>
