<div class="container">

    <h2>Couvertures des documents PIA</h2>

    <div class="row">

        <div class="col-md-3 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des classes</h3>
                </div>
                <div class="panel-body" style="height:30em; overflow:auto">
                    <table class="table table-condensed table-bordered">
                        <thead>
                            <tr>
                                <th>Classe</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$listeClasses item=classe}
                            <tr class="trClasse">
                                <td>{$classe}</td>
                                <td>
                                    <input type="radio" name="classe" class="classe" value="{$classe}">
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>

                    </table>
                </div>
                <div class="panel-footer">
                    Sélectionner une classe
                </div>
            </div>
        </div>
        <!-- col-md-... -->

        <div class="col-md-4 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Listes des élèves</h3>
                </div>
                <div class="panel-body" style="height:30em; overflow: auto" id="listeEleves">

                    <div class="alert alert-info">
                        <i class="fa fa-info fa-2x"></i> Veuillez d'abord choisir une classe dans la zone de gauche.
                    </div>

                </div>
                <div class="panel-footer">
                    Sélectionner un ou plusieurs élèves
                </div>
            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-5 col-sm-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Obtenir le PDF</h3>
                </div>
                <div class="panel-body">

                    <div id="ajaxLoader" class="hidden">
                        <p>Veuillez patienter</p>
                        <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
                    </div>

                    <div id="link" class="hidden">

                    </div>

                    <button class="btn btn-primary btn-block hidden" id="genPdf">Générer le fichier</button>

                    <div id="dead">
                        <!-- message si session terminée -->
                    </div>
                </div>
                <div class="panel-footer">

                </div>
            </div>
        </div>

    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#link').addClass('hidden');
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#link').removeClass('hidden');
            $('#ajaxLoader').addClass('hidden');
        });

        $('.trClasse').click(function() {
            $('.trClasse').removeClass('selected');
            $(this).addClass('selected');
            $(this).find('input:radio').prop('checked', true);
            var classe = $("input:radio.classe:checked").val();
            $.post('inc/direction/listeEleves.inc.php', {
                    classe: classe
                },
                function(resultat) {
                    $('#listeEleves').html(resultat);
                }
            )
        })

        $('.classe').change(function() {
            $('#genPdf').addClass('hidden');
            $('#link').html('');
        })

        $(document).on('click', "#checkAll", function() {
            $(".eleves").trigger('click');
        })

        $(document).on('change', '.eleves', function() {
            var nb = $('.eleves:checkbox:checked').length;
            if (nb > 0)
                $('#genPdf').removeClass('hidden');
            else $('#genPdf').addClass('hidden');
        })

        $('#genPdf').click(function() {
            var classe = $("input:radio.classe:checked").val();
            var eleves = $('.eleves:checkbox:checked');
            var listeEleves = [];
            eleves.each(function(i) {
                matricule = $(this).val();
                listeEleves[i] = matricule
            });
            $.post('inc/direction/printPia.inc.php', {
                classe: classe,
                listeEleves: listeEleves
            }, function(resultat) {
                $('#link').html(resultat);
            })
        })

    })
</script>
