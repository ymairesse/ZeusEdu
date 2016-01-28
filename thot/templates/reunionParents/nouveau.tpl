<div class="container">

<div class="row">

    <div class="col-md-3 col-sm-4">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Définition</h3>
            </div>

            <div class="panel-body">
        <form action="" id="setCanevas" method="" class="form-vertical" role="form">

            <div class="form-group">
                <label for="date">Date</label>
                <input type="text" class="form-control" id="datepicker" placeholder="Date">
                <p class="help-block">Date de la réunion</p>
            </div>


            <div class="form-group">
                <label for="debut" class="sr-only">Heure de début</label>
                <input type="text" class="form-control" id="debut" name="debut" placeholder="Heure de début">
                <p class="help-block">Heure de début</p>
            </div>

            <div class="form-group">
                <label for="debut" class="sr-only">Heure de fin</label>
                <input type="text" class="form-control" id="fin" name="fin" placeholder="Heure de fin">
                <p class="help-block">Heure de fin</p>
            </div>


            <div class="form-group">
                <label for="intervalle" class="sr-only">Intervalle</label>
                <input type="text" class="form-control" id="intervalle" name="intervalle" placeholder="Durée">
                <p class="help-block">Durée d'un entretien (en minutes)</p>
            </div>

            <button type="button" class="btn btn-primary pull-right" id="creation">Création <i class="fa fa-arrow-right"></i></button>
            <div class="clearfix"></div>

            </div>

            <div class="panel-footer">
                <p>Le détail des RV sera disponible dans la zone centrale après la "création".</p>
            </div>
        </form>

    </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-6 col-sm-8">

        <div class="panel panel-info">

            <div class="panel-header">
                <h3 class="panel-title">RV possibles</h3>
            </div>

            <div class="panel-body">

        <form action="index.php" method="POST" role="form" id="tableHoraire" name="table" class="form-inline">

            <div class="row">

                <div class="col-md-5 col-sm-6">

                    <div style="height:30em; overflow:auto;">

                        <table class="table table-condensed" id="plusIntervalle">
                            <thead>
                                <tr>
                                    <th>&nbsp;</th>
                                    <th>Heure</th>
                                    <th class="text-center">Publié<br>
                                    <input type="checkbox" id="attribHeures" title="Attribuer tout"></th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>

                    </div>

                </div>  <!-- col-md-... -->

                <div class="col-md-7 col-sm-6">

                    <div style="height:30em; overflow:auto;">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <th>Prof</th>
                                    <th class="text-center">Attribution<br>
                                    <input type="checkbox" id="attribProfs" title="Attribuer à tous"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {assign var=i value=0}
                                {foreach from=$listeProfs key=acronyme item=unProf}
                                    <tr>
                                        <td>
                                            <span title="{$unProf.acronyme}">{$unProf.nom} {$unProf.prenom}</span>
                                        </td>
                                        <td class="text-center"><input type="checkbox" value="{$unProf.acronyme}" name="prof[]" class="cbProf"></td>
                                    </tr>
                                    {assign var=i value=$i+1}
                                {/foreach}

                            </tbody>
                        </table>
                    </div>

                </div>  <!-- col-md-... -->

            </div>  <!-- row -->

            <input type="hidden" name="action" value="{$action}">
            <input type="hidden" name="mode" value="{$mode}">
            <input type="hidden" name="etape" value="enregistrer">
            <input type="hidden" name="new" value="1">
            <input type="hidden" name="date" id="ladate" value="">
            <button type="submit" class="btn btn-primary pull-right" id="submit" style="display:none">Enregistrer</button>
        <div class="clearfix"></div>

        </form>

    </div>  <!-- panel-body -->

    </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-3 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Informations</h3>
            </div>
            <div class="panel-body">
                <p>Les périodes "publiées" sont disponibles pour les RV. On peut toujours définir des périodes surnuméraires qui ne sont pas publiées.</p>
                <p>Les périodes non publiées ne sont pas visibles par les parents. Seuls les professeurs peuvent les voir et, éventuellement, les publier pour eux-mêmes.</p>

                <p class="text-danger">La date de réunion de parents peut être effacée, mais tous les rendes-vous pris seront également effacés. À ne faire qu'après la date de la réunion</p>
            </div>
            <div class="panel-footer">
                &nbsp;
            </div>
        </div>
        <!-- panel -->

    </div>
    <!-- col-md-... -->

</div>
<!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

    $.validator.addMethod('time', function(value, element, param) {
        return value == '' || value.match(/^([01][0-9]|2[0-3]):[0-5][0-9]$/);
    }, 'Une heure valide svp: HH:mm');

    $(document).ready(function(){

        $("#creation").click(function() {
            var date = $("#datepicker").val();
            $("#ladate").val(date);
            var debut = $("#debut").val();
            var duree = parseInt($("#intervalle").val());
            if (duree > 0) {
                var momentDebut = moment(debut, 'HH:mm');
                var fin = $("#fin").val();
                var momentFin = moment(fin, 'HH:mm');
                var plusTard = momentDebut.format('HH:mm');
                var momentPlusTard = moment(plusTard, 'HH:mm');
                var i = 1;
                $("#plusIntervalle tbody").html(''); // remise à zéro éventuelle du tableau
                while (momentPlusTard <= momentFin) {
                    var h = momentPlusTard.format('HH:mm');
                    var stuk = "<tr><td>" + i + "<td><input class='rv' size='5' type='text' time='time' required='required' name='heure_" + i + "' id='stuk_" + i + "' value='" + h + "'></td>";
                    stuk += "<td class='text-center'><input type='checkbox' class='form-control cbHeure' name='publie_" + i + "' value='1'> </td>";
                    $("#plusIntervalle tbody").append(stuk);
                    momentPlusTard.add(duree, 'minutes').format('HH:mm');
                    i++;
                }
                $("#plusIntervalle").append("</table>");
                $("#submit").show();
            } else alert('Un temps > 0 svp');

        })
    })

    $("#datepicker").datepicker({
        format: 'dd/mm/yyyy',
        clearBtn: true,
        language: "fr",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true
    });

    $(".heure").timepicker({
        minuteStep: 5,
        showMeridian: false
    });

    $("#debut, #fin").timepicker({
        minuteStep: 5,
        showMeridian: false
    });

    $("#setCanevas").validate({
        rules: {
            intervalle: {
                required: true,
                number: true,
                range: [5, 60]
            },
            debut,
            fin: {
                required: true,
                time: true
            }
        }
    })

    $("#attribHeures").click(function(){
        var checked = $(this).is(':checked');
        $(".cbHeure").prop("checked",checked);
    })

    $("#attribProfs").click(function(){
        var checked = $(this).is(':checked');
        $(".cbProf").prop("checked",checked);
    })

    $("#delete").click(function(){
        var date = $("#dateOld").val();
        $("#dateModal").val(date);
        $("#delDate").html(date);
        $("#modalDel").modal('show');
    })

    $(".btnEdit").click(function(){
        var acronyme = $(this).data('acronyme');
        var date = $("#date").val();
        $.post('inc/listeRv.inc.php', {
            acronyme:acronyme,
            date:date
            },
            function (resultat) {
                $("#listeRV").html(resultat);
            }
        )
    })

</script>
