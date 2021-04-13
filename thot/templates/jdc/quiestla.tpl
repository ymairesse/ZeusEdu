<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12 col-md-6">

            <div class="panel panel-info">

                <div class="panel-heading">
                    Sélection de la période de cours
                </div>

                <div class="panel-body">
                    <form id="selectTime">

                        <div class="form-group">

                            <select class="form-control" name="coursGrp" id="coursGrp" size="{$listeCoursGrp|count}">
                                {foreach from=$listeCoursGrp key=coursGrp item=data}
                                <option value="{$coursGrp}">{$coursGrp} {$data.statut} {$data.libelle} {$data.nbheures}h {if $data.nomCours != ''}[{$data.nomCours}]{/if}</option>
                                {/foreach}
                            </select>

                        </div>

                        {if in_array($userStatus, ['direction', 'admin', 'educ'])}
                            <select class="form-control" name="classe" id="classe">
                                <option value="">Choisir une classe</option>
                                {foreach from=$listeClasses key=wtf item=classe}
                                    <option value="{$classe}">{$classe}</option>
                                {/foreach}
                            </select>
                        {/if}

                        <div class="row">

                            <div class="form-group col-xs-4">
                                <label for="date">Date</label>
                                <input type="text" class="datepicker form-control" name="date" id="date" value="{$smarty.now|date_format:"%d/%m/%Y"}">
                            </div>

                            <div class="form-group col-xs-4">
                                <label for="start">Heure de début</label>
                                <input type="text" class="timepicker form-control" name="start" id="start" value="">
                            </div>

                            <div class="form-group col-xs-4">
                                <label for="start">Heure de fin</label>
                                <input type="text" class="timepicker form-control" name="end" id="end" value="">
                            </div>
                        </div>

                    </form>
                </div>

                <div class="panel-footer">
                    <button type="button" class="btn btn-primary pull-right" id="btn-periode">Chercher</button>
                    <div class="clearfix">

                    </div>
                </div>

            </div>

        </div>

        <div class="col-xs-12 col-md-6">

            <div class="panel panel-success">

                <div class="panel-heading">
                    Liste de présences
                </div>
                <div class="panel-body" id="listePresences">

                </div>

            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#selectTime').validate({
            rules: {
                coursGrp: {
                  required: function(element) {
                      var test = $('#classe').is(':selected') == true;
                      return test;
                  }
              },
              classe: {
                  required: function(element) {
                      var test = $('#coursGrp').is(':selected') == true;
                      return test;
                  }
              }
              }
        });

        $('#classe').change(function(){
            $('#coursGrp').val('');
        })
        $('#coursGrp').change(function(){
            $('#classe').val('');
        })

        $('#btn-periode').click(function(){

            if ($('#selectTime').valid())
                var formulaire = $('#selectTime').serialize();
                $.post('inc/jdc/getPresences.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    $('#listePresences').html(resultat);
                })

        })

        $(".datepicker").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
        });

        $(".timepicker").timepicker({
            minuteStep: 5,
            showMeridian: false
        });
    })

</script>
