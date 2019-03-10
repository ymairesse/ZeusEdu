<div class="container-fluid">

    <div class="row">

        <h2 class="col-xs-12">Traitement des retards</h2>

        <div class="col-md-3 col-xs-12">

            {include file='selecteurs/selectRetards.tpl'}

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

        $('#zoneSynthese').on('click', '#btn-reset', function(){
            $('#ulDates li').remove();
            $('#btn-save').prop('disabled', true);
        })

        $('#zoneSynthese').on('click', '#btn-save', function(){
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

        $('#zoneSynthese').on('click', '.btn-print', function(){
            var ref = $(this).data('ref');
            var matricule = $(this).data('matricule');
            $.post('inc/retards/generateRetard4PDF.inc.php', {
                matricule: matricule,
                ref: ref
            }, function(resultat){
                bootbox.alert({
                    title: 'Sanction pour retards',
                    message: resultat
                });
            })
        })

        $('#zoneSynthese').on('click', '.btn-delete', function(){
            var ref = $(this).data('ref');
            bootbox.confirm({
                title: 'Veuillez confirmer',
                message: 'Effacement définitif de cette sanction',
                callback: function(result) {
                    if (result == true) {
                        $.post('inc/retards/delSanctionRef.inc.php', {
                            ref: ref
                        }, function(resultat){
                            $('.btn-sanction[data-ref="' + ref  +'"]').attr('disabled', false);
                            $('.cbDate[data-ref="' + ref  +'"]').prop('checked', false).attr('disabled', false);
                            $('span[data-ref="' + ref  +'"]').remove();
                            $('#btn-getRetards').trigger('click');
                        })
                    }
                }
            })
        })

        $('#zoneSynthese').on('click', '.btn-sanction', function(){
            var matricule = $(this).data('matricule');
            var listeIds = [];
            $('.cbDate[data-matricule="' + matricule + '"]:checked').not(':disabled').each(function(){
                listeIds.push($(this).data('id'));
                })
            if (listeIds.length > 0) {
                $.post('inc/retards/modalDateSanction.inc.php', {
                    matricule: matricule,
                    listeIds: listeIds
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalChoixSanction').modal('show');
                })
            }
            else bootbox.alert({
                size: 'small',
                title: 'Problème',
                message: 'Veuillez sélectionner au moins un retard'
            })
        })


		$('#btn-getRetards').click(function(){
			if ($('#formSelect').valid()){
				var formulaire = $('#formSelect').serialize();
                $.post('inc/retards/generateListeRetards.inc.php', {
                    formulaire: formulaire
                    },
                function (resultat){
                    $("#zoneSynthese").html(resultat);
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
				classe: classe
				},
			   function (resultat) {
				$("#listeEleves").html(resultat);
			   }
			)
			})

	})

</script>
