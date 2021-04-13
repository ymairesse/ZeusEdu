<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">

            <h2>Réservation des ressources {$userStatus}</h2>

                    <div class="col-xs-12 col-md-4">
                        <h3>Types de ressources</h3>

                        <div class="form-group" id="typeRessources">

                            {include file="ressources/selectTypeRessource.tpl"}

                        </div>

                        <div class="btn-group btn-group-justified">
                            <a type="button" class="btn btn-success" id="btn-addRessourceType" href="javascript:void(0)">Ajouter un type de ressource</a>
                            <a type="button" class="btn btn-danger" id="btn-delRessourceType" data-idType="" href="javascript:void(0)" disabled>Supprimer ce type de ressource</a>
                        </div>


                        <h3>Ressources disponibles</h3>

                        <div class="btn-group btn-group-justified">
                            <a type="button" class="btn btn-xs btn-success" id="btn-addRessource" href="javascript:void(0)" disabled title="Ajouter une ressource" data-container="body"><i class="fa fa-plus"></i> </a>
                            <a type="button" class="btn btn-xs btn-info afterDel" id="btn-cloneRessource" href="javascript:void(0)" disabled title="Cloner cette ressource" data-container="body"><i class="fa fa-clone"></i> </a>
                            <a type="button" class="btn btn-xs btn-warning afterDel" id="btn-editRessource" href="javascript:void(0)" disabled title="Modifier cette ressource" data-container="body"><i class="fa fa-edit"></i> </a>
                            <a type="button" class="btn btn-xs btn-danger afterDel" id="btn-delRessource" data-idType="" href="javascript:void(0)" disabled title="Supprimer cette ressource" data-container="body"><i class="fa fa-times"></i></a>
                        </div>

                        <form id="formSelectRessources">

                            <div class="input-group input-daterange form-control">
                                <table class="table table-condensed">
                                    <tr>
                                        <td>
                                            <input type="text" class="form-control datepicker" id="dateStart" name="dateStart" value="" style="width:100%">
                                        </td>
                                        <td>à</td>
                                        <td>
                                            <select class="form-control" name="startTime" id="startTime">
                                                {foreach from=$listeHeuresCours key=wtf item=data}
                                                    <option value="{$data.debut}">{$data.debut}</option>
                                                {/foreach}
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control datepicker" id="dateEnd" name="dateEnd" value="" style="width:100%"></td>
                                        <td>à</td>
                                        <td>
                                            <select class="form-control" name="endTime" id="endTime">
                                                {foreach from=$listeHeuresCours key=wtf item=data}
                                                    <option value="{$data.debut}">{$data.debut}</option>
                                                {/foreach}
                                            </select>
                                        </td>
                                    </tr>
                                </table>

                            </div>


                        <div class="panel panel-default" id="panelDispo">

                            <div class="panel-body" style="height: auto;">
                                <div id="resDispo" style="height:20em; overflow: auto;">
                                    {include file="ressources/selectRessource.tpl"}
                                </div>
                            </div>

                            <div class="panel-footer">
                                Sélectionner un ou plusieurs éléments (Maj / Ctrl) <span class="pull-right">0 Sél.</span>
                            </div>

                        </div>
                        </form>

                        <button type="button" class="btn btn-primary btn-block" id="btn-selectRessources" disabled>Sélectionner >>>></button>

                    </div>


                    <div class="col-xs-12 col-md-8" id="detailsRessources">
                        {include file="ressources/detailsRessources.tpl"}
                    </div>

            </div>

        </div>

    </div>

</div>

<div id="modal"></div>



<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-selectRessources').click(function(){
            var dateStart = $('#dateStart').val();
            startTime = $('#startTime').val();
            dateStart = dateStart.split('/').reverse().join('-') + 'T' + startTime
            var dateDebut = new Date(dateStart);

            var dateEnd = $('#dateEnd').val();
            startTime = $('#endTime').val();
            dateEnd = dateEnd.split('/').reverse().join('-') + 'T' + startTime
            var dateFin = new Date(dateEnd);

            var n = $('#selectRessource option:selected').length;
            if ((dateDebut < dateFin) && n > 0) {
                var formulaire = $('#formSelectRessources').serialize();
                $.post('inc/ressources/getWantedRessources.inc.php', {
                        formulaire: formulaire
                    }, function(resultat){
                        $('#detailsRessources').html(resultat)
                    })
                }
                else bootbox.alert({
                    title: 'Erreur',
                    message: 'Veuillez sélectionner au moins un item et une période de plus de 50 minutes d\'emprunt'
                })
        })

        $('#dateStart').on("change", function (e) {
            var d = $("#dateStart").datepicker('getDate');
             var n = new Date(d.getFullYear(), d.getMonth(), d.getDate());
            $("#dateEnd").datepicker('setStartDate', n).datepicker('setDate', n);
            if ($('#dateEnd').val() != $('#dateStart').val()) {
                $('#endTime option').attr('disabled', false);
                }
                else {
                    var n = 0;
                    while ($('#startTime option').eq(n).val() <= $('#startTime option:selected').val()){
                        $('#endTime option').eq(n).attr('disabled', true);
                        n++;
                    }
                }
        });

        $('#dateEnd').on('change', function(e){
            if ($('#dateEnd').val() != $('#dateStart').val()) {
                $('#endTime option').attr('disabled', false);
                }
                else {
                    var n = 0;
                    var heure;
                    while ($('#startTime option').eq(n).val() <= $('#startTime option:selected').val()){
                        $('#endTime option').eq(n).attr('disabled', true);
                        heure = $('#endTime option').eq(n).val();
                        n++;
                    }
                    $('#endTime :not(:disabled)').first().prop('selected', true);
                }
        })

        var d = new Date();
        var today = new Date().toLocaleDateString();
        $('.datepicker').val(today);

        $('#dateStart, #dateEnd').datepicker({
            startDate: today,
            format: 'dd/mm/yyyy',
            clearBtn: true,
            language: 'fr',
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        })

        $('#startTime').change(function(){
            var heure = $('#startTime :selected').next().val();
            $('#endTime').val(heure);
            if ($('#dateStart').val() == $('#dateEnd').val()){
                heure = $('#startTime option').first().val();
                $('#endTime option').attr('disabled', false);
                var n = 0;
                while ($('#startTime option').eq(n).val() <= $('#startTime option:selected').val()){
                    $('#endTime option').eq(n).attr('disabled', true);
                    n++;
                }
            }
        })

        $('body').on('change', '#typeRessource', function(){
            var idType = $(this).val();
            $.post('inc/ressources/getRessourceByType.inc.php', {
                idType: idType
            }, function(resultat){
                $('#resDispo').html(resultat);
                $('#btn-delRessource').attr('disabled', true);
                $('#btn-cloneRessource').attr('disabled', true);
                $('#btn-editRessource').attr('disabled', true);
                $('#btn-selectRessources').attr('disabled', true);
            })
        })

        $('body').on('click', '#btn-delRessource', function(){
            var idRessource = $('#selectRessource').val()[0];
            var idType = $('#typeRessource').val();
            var texte = $('#selectRessource :selected').text();
            bootbox.confirm({
                title: 'Suppression d\'une ressource',
                message: 'Veuille confirmer la suppression de la ressource <strong>' + texte + '</strong>',
                callback: function(result){
                    if (result == true)
                        $.post('inc/ressources/delRessource.inc.php', {
                            idType: idType,
                            idRessource: idRessource
                        }, function(resultat){
                            $('#resDispo').html(resultat);
                            $('.afterDel').attr('disabled', true);
                        })
                }
            })
        })

        $('#modal').on('click', '#hasCaution', function(){
            if ($(this).is(':checked'))
                $('#caution').attr('disabled', false);
                else $('#caution').attr('disabled', true);
        })

        $('#modal').on('click', '#btn-reset', function(){
            $('#formAddRessource').trigger('reset');
        })

        $('#btn-editRessource').click(function(){
            var idRessource = $('#selectRessource').val()[0];
            var idType = $('#typeRessource').val();
            $.post('inc/ressources/editRessource.inc.php', {
                idType: idType,
                idRessource: idRessource
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalAddRessource').modal('show');
            })
        })

        $('#btn-addRessource').click(function(){
            var idType = $('#typeRessource').val();
            $.post('inc/ressources/addRessource.inc.php', {
                idType: idType
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalAddRessource').modal('show');
                $('.afterDel').attr('enabled', true);
            })
        })
        $('#modal').on('click', '#btn-save', function(){
            if ($('#formAddRessource').valid()){
                var reference = $('#reference').val();
                var description = $('#description').val();
                var texteType = $('#typeRessource :selected').text();
                var formulaire = $('#formAddRessource').serialize();
                $.post('inc/ressources/saveRessource.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    var resultJSON = JSON.parse(resultat);
                    var idRessource = resultJSON.idRessource;
                    if (idRessource != null) {
                        bootbox.alert({
                            title: 'Nouvelle ressource',
                            message: 'La ressource <strong>' + description + '</strong> a été ajoutée'
                        })
                        $('#resDispo').html(resultJSON.html);
                        $('#btn-delRessource').attr('disabled', false);
                        $('#modalAddRessource').modal('hide');
                    }
                    else bootbox.alert({
                        title: 'Problème',
                        message: 'Une ressource avec la référence <strong>' + reference + '</strong> pour le type <strong> ' + texteType + ' </strong>existe déjà.'
                        })
                });
            }
        })

        $('body').on('change', '#typeRessource', function(){
            var type = $(this).val();
            if (type != '') {
                $('#btn-delRessourceType').attr('disabled', false);
                $('#btn-addRessource').attr('disabled', false)
                }
                else {
                    $('#btn-delRessourceType').attr('disabled', true);
                    $('#btn-addRessource').attr('disabled', true)
                }
        })
        $('#btn-delRessourceType').click(function(){
            var idType = $('#typeRessource').val();
            var texte = $('#typeRessource :selected').text();
            var title = 'Suppression d\'un type de ressource';
            $.post('inc/ressources/delTypeRessource.inc.php', {
                idType: idType
            }, function(resultat){
                if (resultat != '') {
                    $('#typeRessources').html(resultat);

                    $.post('inc/ressources/getRessourceByType.inc.php', {
                        idType: 0
                    }, function(resultat){
                        $('#resDispo').html(resultat);
                        $('#btn-delRessourceType').attr('disabled', true);
                        bootbox.alert({
                            title: 'Le titre',
                            message: 'Le type de ressource ' + texte + ' a été supprimé'
                            });
                    })
                }
                else bootbox.alert({
                    title: title,
                    message: 'Ce type contient des ressources et ne peut être supprimé'
                    })
            })
        })

        $('#btn-addRessourceType').click(function(){
            bootbox.prompt({
                title: 'Dénomination de ce nouveau type',
                callback: function(result){
                    if (result != '') {
                        $.post('inc/ressources/addTypeRessource.inc.php', {
                            type: result
                        }, function(resultat){
                            $('#typeRessource').html(resultat);
                            $.post('inc/ressources/getRessourceByType.inc.php', {
                                idType: 0
                            }, function(resultat){
                                $('#resDispo').html(resultat);
                                $('#btn-delRessourceType').attr('disabled', false);
                            })
                        })
                    }
                }
            })
        })

        $('body').on('change', '#selectRessource', function(){
            var idRessource = $(this).val();
            $('#panelDispo .panel-footer span').text(idRessource.length + ' Sél.')
            $('#btn-selectRessources').attr('disabled', false);
            if (idRessource.length == 1){
                $('#btn-delRessource').attr('disabled', false);
                $('#btn-cloneRessource').attr('disabled', false);
                $('#btn-editRessource').attr('disabled', false);
                }
                else {
                     $('#btn-delRessource').attr('disabled', true);
                     $('#btn-cloneRessource').attr('disabled', true);
                     $('#btn-editRessource').attr('disabled', true);
                }
        })

    })

</script>
