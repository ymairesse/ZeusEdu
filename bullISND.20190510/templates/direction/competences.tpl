<div class="container">

    <h2>PIA et rapports de compétences</h2>

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
                            <tr class="classe">
                                <td>{$classe}</td>
                                <td>
                                    <input type="radio" name="classe" id="classe" class="uneClasse" value="{$classe}">
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>

                </div>
                <div class="panel-footer">
                    Sélectionnez une ou plusieurs classes
                </div>
            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-3 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Attributs</h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label for="datepicker" class="sr-only">Date d'impression</label>
                        <input type="text" class="form-control" name="date" id="datepicker" value="{$date}" placeholder="date d'impression">
                        <p class="help-block">Date d'impression du document</p>
                    </div>

                    <div class="form-group">
                        <label for="type" class="sr-only">Type de document</label>
                        <select class="form-control" id="typeDoc" name="typeDoc">
                            <option value="">Type de document</option>
                            <option value="competences" {if ($typeDoc=='competences' )}selected{/if}>Rapport de compétences</option>
                            <option value="pia" {if ($typeDoc=='pia' )}selected{/if}>Plan individuel d'apprentissage</option>
                        </select>
                        <p class="help-block">Type de document à produire</p>
                    </div>

                    <div class="form-group">
                        <label for="signature" class="checkbox-inline">
                            <input id="signature" name="signature" type="checkbox" value="1" {if $signature !='' }checked{/if}>Impression de la signature</label>
                        <strong>{$DIRECTION}</strong>
                        <div id="imgSignature">
                            <img src="images/direction.jpg" alt="signature de la direction" id="signe" class="img-responsive{if $signature == Null} hidden{/if}">
                        </div>

                    </div>

                    <button class="btn btn-primary btn-block" id="imprimer">Imprimer</button>

                </div>
                <div class="panel-footer">
                    Sélectionnez les attributs
                </div>
            </div>
            <!-- panel -->

        </div>
        <!-- col-md-... -->

        <div class="col-md-6 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Le fichier à imprimer</h3>
                </div>
                <div class="panel-body">
                    <div id="ajaxLoader" class="hidden">
                        <p>Veuillez patienter</p>
                        <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
                    </div>
                    <div id="link" class="hidden">

                    </div>
                </div>

            </div>

            <div class="alert alert-danger hidden" id="noClasses">
                <i class="fa fa-warning fa-2x"></i> Veuillez sélectionner une classe.
            </div>
            <!-- alert noClasses -->

            <div class="alert alert-danger hidden" id="noDate">
                <i class="fa fa-warning fa-2x"></i> Veuillez sélectionner une date d'impression.
            </div>
            <!-- alert noDate  -->

            <div class="alert alert-danger hidden" id="noType">
                <i class="fa fa-warning fa-2x"></i> Veuillez sélectionner un type de document (PIA ou Rapport de compétences).
            </div>
            <!-- alert noType -->

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Impression</h3>
                </div>
                <div class="panel-body">
                    Veuillez sélectionner:
                    <ol>
                        <li>Une ou plusieurs classes</li>
                        <li>La date d'impression souhaitée</li>
                        <li>Le type de document (PIA ou Rapport de compétences)</li>
                        <li>La signature</li>
                    </ol>
                    dans la partie gauche de l'écran
                </div>

            </div>
            <!-- panel -->

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

</div>
<!-- container -->


<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#link').addClass('hidden');
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#link').removeClass('hidden');
            $('#ajaxLoader').addClass('hidden');
        });

        $(".classe").click(function(){
            $('.classe').removeClass('selected');
            $(this).addClass('selected');
            $(this).find('input:radio').prop('checked',true);
        })

        $("#datepicker").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $("#datepicker").change(function() {
            if ($(this).val() != '')
                $("#noDate").addClass('hidden');
        })

        $("#typeDoc").change(function() {
            if ($(this).val() != '')
                $("#noType").addClass('hidden');
        })

        $("#signature").click(function() {
            if ($(this).prop('checked') == true)
                $("#signe").removeClass('hidden');
            else $("#signe").addClass('hidden');
        })

        $(".uneClasse").change(function() {
            $("#noClasses").addClass('hidden');
        })

        $("#imprimer").click(function() {
            var erreur = false;
            var classe = $("input.uneClasse:checked").val();
            if (classe == undefined) {
                $("#noClasses").removeClass('hidden');
                erreur = true;
            } else {
                $("#noClasses").addClass('hidden');
                }
            var laDate = $("#datepicker").val();
            if (laDate == '') {
                $("#noDate").removeClass('hidden');
                erreur = true;
            } else $("#noDate").addClass('hidden');
            var typeDoc = $("#typeDoc").val();
            if (typeDoc == '') {
                $("#noType").removeClass('hidden');
                erreur = true;
            } else $("#noType").addClass('hidden');

            var signature = $("#signature").is(':checked') ? 1 : 0;

            if (erreur === false) {
                $.post('inc/direction/printDoc.inc.php', {
                    classe: classe,
                    laDate: laDate,
                    typeDoc: typeDoc,
                    signature: signature
                }, function(resultat) {
                    $("#link").html(resultat);
                });
            }

        })
    })
</script>
