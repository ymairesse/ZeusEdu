<div class="container">

    <div class="row">

        <div class="col-md-7 col-xs-12 table-responsive">

            <h3>En attente d'approbation</h3>

            {if $approbations|@count > 0}
                <table class="table table-condensed" id="waitApprove">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Titre</th>
                            <th>Amorce</th>
                            <th>Concerne</th>
                            <th style="width:2em"><i class="fa fa-thumbs-up fa-lg text-success"></i></th>
                            <th style="width:2em"><i class="fa fa-thumbs-down fa-lg text-danger"></i></th>
                        </tr>
                    </thead>

                {foreach from=$approbations key=id item=data name=boucle}
                    <tr data-id="{$id}" class="approve" style="cursor:pointer">
                        <td>{$data.date}</td>
                        <td>{$data.title}</td>
                        <td title="{$data.enonce}" data-container="body">{$data.enonce|truncate:40:'...'}</td>
                        <td>{$data.destinataire}
                            {if isset($data.libelle)} [{$data.libelle}]{/if}
                        </td>
                        <td><span class="badge badge-success">{$appreciations.$id.1|@count|default:0}</span></td>
                        <td><span class="badge badge-danger">{$appreciations.$id.0|@count|default:0}</span></td>
                        </td>
                    </tr>
                {/foreach}

                </table>
            {else}
                <p class="avertissement">Aucune approbation de jDC en attente</p>
            {/if}
        </div>

        <div class="col-md-5 col-xs-12" style="max-height:50em; overflow: auto">

            <div id="unTravail">
                {if $approbations|@count > 0}
                <strong>Veuillez sélectionner un item dans la liste ci-contre</strong>
                {/if}
                <div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>

            </div>

        </div>

    </div>

    <div id="zoneMod">
    </div>
    <div id="zoneDel">
    </div>

</div>

{include file="jdc/modal/modalDislikes.tpl"}

<script type="text/javascript">

    $(document).ready(function(){

		// suppression d'une note au JDC
		$("#unTravail").on('click', '#delete', function() {
			var id = $(this).data('id');
			$.post('inc/jdc/getModalDel.inc.php', {
					id: id,
				},
				function(resultat) {
					$("#zoneDel").html(resultat);
					$("#modalDel").modal('show');
				}
			)
		})

		// modification d'une note au JDC
		$("#unTravail").on('click', '#modifier', function() {
			var id = $(this).data('id');
			var destinataire = $(this).data('destinataire');
			var startDate = $("#startDate").val();
			var type = $('#type').val();
			var lblDestinataire = $("#lblDestinataire").val();
			$.post('inc/jdc/getMod.inc.php', {
					id: id,
					startDate: startDate,
					type: type,
					destinataire: destinataire,
				},
				function(resultat) {
					// construction de la boîte modale d'édition du JDC
					$("#zoneMod").html(resultat);
					$("#modalEdit").modal('show');
					// mise à jour du calendrier
					$('#calendar').fullCalendar('gotoDate', startDate);
					// $('#calendar').fullCalendar('refetchEvents');
				}
			)
		})

		$("#zoneMod").on('click', '#journee', function() {
			if ($(this).prop('checked') == true) {
				$("#duree").prop('disabled', true);
				$('#heure').prop('disabled', true).val('');
				$("#timepicker").prop('disabled', true);
				$("#listeDurees").addClass('disabled');
			} else {
				$("#duree").prop('disabled', false);
				$('#heure').prop('disabled', false);
				$("#timepicker").prop('disabled', false);
				$("#listeDurees").removeClass('disabled');
			}
		})

		$("#zoneMod").on('change', '#destinataire', function() {
			var type = $(this).find(':selected').data('type');
			$("#type").val(type);
		})

		$("#zoneMod").on('change', '#categorie', function(){
	        if (($('#titre').val() == '') && ($('#categorie').val() != '')) {
	            var texte = $("#categorie option:selected" ).text();
	            $('#titre').val(texte);
	        }
	    })

        $('#unTravail').on('click', '#approprier', function(){
            var id = $(this).data('id');
            $.post('inc/jdc/setProprioJdc.inc.php', {
                id: id
            }, function (resultat){
                if (resultat == 1) {
                    $('#waitApprove tr.selected').remove();
                    $.post('inc/jdc/getTravail.inc.php', {
                        id: id,
                        editable: true
                        },
                        function(resultat) {
                            $('#unTravail').html(resultat);
                        }
                    )
                }
            })
        })

        $('#unTravail').on('click', '#infoLikes', function(){
			var id = $(this).data('id');
			$.post('inc/jdc/getDislikes.inc.php', {
				id: id
			}, function(resultat){
				$('#modalDislikes .modal-body').html(resultat);
				$('#modalDislikes').modal('show');
			})
		})

        $('tr.approve').click(function(){
            var id = $(this).data('id');
            $('#waitApprove tr').removeClass('selected');
            $(this).closest('tr').addClass('selected');
            $.post('inc/jdc/getTravail.inc.php', {
                id: id,
                editable: true
            }, function(resultat){
                $('#unTravail').html(resultat);
            })
        })
    })

</script>
