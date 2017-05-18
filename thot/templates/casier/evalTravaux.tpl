<div class="box">

    <div class="row">
        <div class="col-sm-3">
            <button
                type="button"
                class="btn btn-success btn-block"
                id="carnetCotes"
                data-idtravail="{$infoTravail.idTravail}">
                Carnet de cotes <i class="fa fa-arrow-left"></i>
            </button>
        </div>

        <div class="col-sm-9">

            <select class="form-control" id="selectEleve">
                <option value="">Sélectionnez un élève</option>
                {foreach from=$listeTravaux key=leMatricule item=dataTravail}
                <option
                    class="{if $dataTravail.remis == 1}remis{else}nonRemis{/if}"
                    value="{$leMatricule}"
                    data-photo="{$dataTravail.photo}"
                    data-idtravail="{$dataTravail.idTravail}"
                    {if isset($matricule) && ($matricule == $leMatricule)}selected{/if}>
                    {$dataTravail.groupe} - {$dataTravail.nom} {$dataTravail.prenom} {if $dataTravail.total != ''}[{$dataTravail.total} / {$infoTravail.max}]{/if}
                </option>
                {/foreach}

            </select>

        </div>

    </div>

    <div id="detailsEvaluation">

    </div>

</div>

<script type="text/javascript">
    $(document).ready(function() {

        // $("#zoneEdition").on("click", "#carnetCotes", function(){
        //     var idTravail = $(this).data('idtravail')
        //     $.post('inc/casier/modalTransfertCarnet.inc.php', {
        //         idTravail: idTravail
        //     },
        //     function(resultat){
        //         $("#transfert").html(resultat);
        //     });
        //     $("#modalCarnetCotes").modal('show');
        // })

        // $("#btn-transfert").click(function() {
        //     var formulaire = $("#formTransfert").serialize();
        //     $.post('inc/casier/transfertCarnet.inc.php', {
        //             formulaire: formulaire
        //         },
        //         function(nb) {
        //             $("#modalCarnetCotes").modal('hide');
        //             bootbox.alert({
        //                 message: nb + " cotes enregistrées",
        //                 backdrop: true
        //             });
        //         })
        // })

        $("#hideShowConsignes").click(function() {
            $("#consignes").toggle('slow');
        })

        // remplacer la virgule par un point dans la cote
        $("#cote").blur(function(e) {
            laCote = $(this).val().replace(',', '.');
            $(this).val(laCote);
        })

    })
</script>
