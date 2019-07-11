<div class="container">

    <h2>Certificat récapitulatif du degré d'étude</h2>

    <div class="row">

        <div class="col-md-4 col-xs-12">

            <form class="form-vertical" id="formRecap">

                <div id="ajaxLoader" class="hidden">
                    <p>Veuillez patienter</p>
                    <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
                </div>

                <div class="form-group">
                    <label for="selectDegre">Degré d'étude</label>
                    <select class="form-control" name="degre" id="selectDegre">
                    <option value="">Degré d'étude</option>
                    {foreach $listeDegres key=wtf item=unDegre}
                        <option value="{$unDegre}" {if ($unDegre == $degre) || ($listeDegres|count == 1)} selected{/if}>{$unDegre}</option>
                    {/foreach}
                    </select>
                    <p class="help-block">Pour quel niveau d'étude</p>
                </div>

                <div id="listeClasses">

                    {include file='direction/listeClasses.tpl'}

                </div>

                <div class="btn-group pull-right">
                  <button type="reset" class="btn btn-default">Annuler</button>
                  <button type="button" class="btn btn-primary" id="print">Générer le document</button>
                </div>

            <div class="clearfix"></div>
            </form>

        </div>

        <div class="col-md-5 col-xs-12" id="documents">

        </div>

        <div class="col-md-3 col-xs-12">
            <div class="panel panel-info">
                <div class="panel-title">
                    <h3>Information</h3>
                </div>
                <div class="panel-body">
                    <p>Sélectionnez le degré et la classe dans la colonne de gauche.</p>
                    <p>Les documents sont générés à la volée et disponibles au centre de la page, après quelques instants de patience.</p>
                    <p>Vous pouvez trouver les documents générés dans les "Documents partagés" de l'application Thot si elle est installée.</p>
                </div>
            </div>

        </div>

    </div>


</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#link').addClass('hidden');
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#link').removeClass('hidden');
            $('#ajaxLoader').addClass('hidden');
        });

        var degre = $("#selectDegre").val();
        // si le degré est déjà connu, on peut récupérer la liste des classes du degré
        if (degre != '') {
            $.post('inc/direction/listeClassesDegre.inc.php', {
                degre: degre
                },
                function(resultat) {
                    $("#listeClasses").html(resultat);
                })
            }

        $('#selectDegre').change(function(){
            var degre = $(this).val();
            if (degre != '') {
                $.post('inc/direction/listeClassesDegre.inc.php', {
                    degre: degre
                    },
                    function(resultat) {
                        $("#listeClasses").html(resultat);
                    })
                }
            else ($("#listeClasses").html(' '));
        })

        $('#formRecap').on('click', '#print', function(){
            var classe = $('#listeClasses :selected').val();
            if (classe != undefined) {
                $("#documents").html('');
                $.post('inc/direction/generateRecapDegre.inc.php', {
                    classe: classe
                    },
                    function(resultat){
                        $("#documents").html(resultat);
                    })
                }
        })

    })

</script>
