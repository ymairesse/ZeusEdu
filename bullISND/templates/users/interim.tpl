<div class="container">

    <div class="alert alert-info">
        <p>Sélectionner un enseignant et un interimaire possible. Cliquez ensuite sur le bouton
            <button type="button" class="btn btn-primary" id="interim">Interim</button>
        </p>
    </div>

    <div class="row">

        <div class="col-md-6 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des enseignants</h3>
                </div>
                <div class="panel-body" style="height:40em; overflow:auto">
                    <table class="table table-condensed" id="listeProfs">
                        <thead>
                            <tr>
                                <th>Acronyme</th>
                                <th>Nom</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>

                        <tbody>
                            {foreach from=$listeProfs key=acronyme item=data}
                            <tr class="unProf">
                                <td>{$acronyme}</td>
                                <td>{$data.nom} {$data.prenom}</td>
                                <td>
                                    <input type="radio" class="prof" name="prof" value="{$acronyme}" data-nomprof="{$data.prenom} {$data.nom}">
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>

                    </table>
                </div>
            </div>
            <div class="panel-footer">

            </div>
        </div>
        <!-- col-md-... -->

        <div class="col-md-6 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des intérimaires possibles</h3>
                </div>
                <div class="panel-body" style="height:40em; overflow:auto">
                    <table class="table table-condensed" id="listeInterims">
                        <thead>
                            <tr>
                                <th>Acronyme</th>
                                <th>Nom</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>

                        <tbody>
                            {foreach from=$listeInterims key=acronyme item=data}
                            <tr class="unInterim">
                                <td>
                                    <input type="radio" name="interim" value="{$acronyme}" data-nomprof="{$data.prenom} {$data.nom}">
                                </td>
                                <td>{$acronyme}</td>
                                <td>{$data.nom} {$data.prenom}</td>
                            </tr>
                            {/foreach}
                        </tbody>

                    </table>
                </div>
            </div>
            <div class="panel-footer">

            </div>
        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

</div>
<!-- container -->

<div class="modal fade" id="modalInterim" tabindex="-1" role="dialog" aria-labelledby="titleInterim" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="index.php" method="POST" class="form-vertical" role="form">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="titleInterim">Sélection des cours en interim</h4>
                </div>
                <div class="modal-body">
                    <div class="col-sm-7">
                        <div id="coursProf" style="height:20em; overflow:auto"></div>
                    </div>
                    <div class="col-sm-5">
                        <div id="coursInterim" style="height:20em; overflow:auto"></div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="modal-footer">
                    <div class="btn-group pull-right">
                        <input type="hidden" name="prof" value="" id="inputModalProf">
                        <input type="hidden" name="interim" value="" id="inputModalInterim">
                        <input type="hidden" name="action" value="{$action}">
                        <input type="hidden" name="mode" value="{$mode}">
                        <input type="hidden" name="etape" value="enregistrer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Affecter les cours</button>
                    </div>

                </div>
            </form>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function() {

        $('.unProf').click(function() {
            $(this).find('input:radio').prop('checked', true);
            $('.unProf').removeClass('selected');
            $(this).addClass('selected');
        })

        $('.unInterim').click(function() {
            $(this).find('input:radio').prop('checked', true);
            $('.unInterim').removeClass('selected');
            $(this).addClass('selected');
        })

        $(document).on('click','.unCours', function() {
            var checkBox = $(this).find('input:checkbox');
            if (checkBox.prop('checked') == true) {
                checkBox.prop('checked',false);
                $(this).removeClass('selected');
            }
            else {
                checkBox.prop('checked',true);
                $(this).addClass('selected');
            }
        })

        $("#interim").click(function() {
            // identité du prof titulaire
            var prof = $("#listeProfs").find("input:radio:checked");
            var acronymeProf = prof.val();
            var nomProf = prof.data('nomprof');
            // identité du prof interimaire
            var interim = $("#listeInterims").find("input:radio:checked");
            var acronymeInterim = interim.val();
            var nomInterim = interim.data('nomprof');

            $('#inputModalProf').val(acronymeProf);
            $('#inputModalInterim').val(acronymeInterim);

            if ((acronymeProf != undefined) && (acronymeInterim != undefined)) {
                // présenter les cours du prof titulaire
                $.post('inc/users/coursProf.inc.php', {
                        acronyme: acronymeProf,
                        nomProf: nomProf
                    },
                    function(resultat) {
                        $("#coursProf").html(resultat);
                    });
                // pour information, les cours de l'interimaire pressenti
                $.post('inc/users/coursInterim.inc.php', {
                        acronyme: acronymeInterim,
                        nomProf: nomInterim
                    },
                    function(resultat) {
                        $("#coursInterim").html(resultat);
                    })
                $('#modalInterim').modal('show');
            }
        })

    })
</script>
