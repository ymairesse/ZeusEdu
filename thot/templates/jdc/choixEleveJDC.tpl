<div class="container-fluid">

    <div class="row">

        <div id="ajaxLoader" class="hidden">
            <img src="images/ajax-loader.gif" alt="loading" class="center-block">
        </div>

        <div class="col-md-8 col-sm-12" style="max-height: 35em; overflow: auto">

            <h3>Charge du journal de classe </h3>

            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>Classe</th>
                        <th>Nom</th>
                        <th>Période</th>
                        <th style="width:2em;">&nbsp;</th>
                    </tr>
                </thead>

                {foreach from=$listeEleves key=matricule item=eleve}
                    <tr data-matricule="{$matricule}"{if isset($listeCharges.$matricule.selected)} class="selected"{/if}>
                        <td>{$eleve.classe}</td>
                        <td class="pop"
    						data-toggle="popover"
    						data-content="<img src='../photos/{$unEleve.photo|default:"nophoto"}.jpg' alt='{$unEleve.matricule|default:'Pas de photo'}' style='width:100px'>"
    						data-html="true"
    						data-container="body">
                        {$eleve.nom} {$eleve.prenom}</td>
                        <td>
                            <div class="input-group">
                            <input type="text" class="form-control dateDebut input-sm datepicker" value="{$listeCharges.$matricule.dateDebut|default:''}">
                            <div class="input-group-addon"> au </div>
                            <input type="text" class="form-control dateFin input-sm datepicker" value="{$listeCharges.$matricule.dateFin|default:''}">
                        </div>
                        </td>
                        <td>
                            <button
                                type="button"
                                class="btn btn-danger btn-xs delCharge"
                                data-matricule="{$matricule}"
                                data-nom="{$eleve.prenom} {$eleve.nom}">
                            <i class="fa fa-times"></i>
                            </button>
                          </td>
                    </tr>
                {/foreach}
            </table>

        </div>
        <div class="col-md-4 col-sm-12">
            <p class="notice">Veuillez sélectionner les dates de début et de fin de période de charge du journal de classe pour chacun des élèves de la classe.<br>
            Plusieurs élèves peuvent être simultanément en charge du journal de classe.<br>
            Pour supprimer une période de charge, cliquez sur le bouton <button type="button" class="btn btn-danger btn-xs" name="button"><i class="fa fa-times"></i></button>.<br>
            Les modifications sont prises en compte instantanément.</p>
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

        $('.dateFin').focus(function(){
            if ($(this).val() == '') {
                var date = $(this).closest('tr').find('.dateDebut').val();
                $(this).val(date);
                $(this).datepicker('update');
            }
        })

        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
            });

        $('.dateDebut, .dateFin').on('changeDate', function(){
            var zone = $(this);
            var matricule = $(this).closest('tr').data('matricule');
            var dateDebut = $(this).closest('tr').find('.dateDebut').val();
            var dateFin = $(this).closest('tr').find('.dateFin').val();

            $.post('inc/jdc/setDateCharge.inc.php', {
                dateDebut: dateDebut,
                dateFin: dateFin,
                matricule: matricule
            },
            function(resultat){
                switch (resultat) {
                    case '':
                        zone.addClass('erreurInput');
                        bootbox.alert('La date n\'a pas été enregistrée');
                        break;
                    case '-1':
                        zone.addClass('erreurInput');
                        bootbox.alert('La date de début est postérieure à la date de fin');
                        break;
                    case '1':
                        var dd = moment(dateDebut, 'DD/MM/YYYY');
                        var df = moment(dateFin, 'DD/MM/YYYY');
                        // date d'aujourd'hui sans les heures/minutes/secondes
                        var today = new Date().toLocaleDateString();
                        var td = moment(today, 'DD/MM/YYYY');
                        if (td.isBetween(dd, df) || td.isSame(dd) || td.isSame(df))
                            zone.closest('tr').addClass('selected');
                            else zone.closest('tr').removeClass('selected');
                        zone.removeClass('erreurInput');
                    }
            })
        })

        $('.delCharge').click(function(){
            var matricule = $(this).data('matricule');
            var dateDebut = '';
            var dateFin = '';
            $(this).closest('tr').find('.dateDebut').val('').removeClass('erreurInput');
            $(this).closest('tr').find('.dateFin').val('').removeClass('erreurInput');
            $(this).closest('tr').removeClass('selected');
            $.post('inc/jdc/setDateCharge.inc.php', {
                dateDebut: '',
                dateFin: '',
                matricule: matricule
            }, function(resultat){

            })

        })
    })

</script>
