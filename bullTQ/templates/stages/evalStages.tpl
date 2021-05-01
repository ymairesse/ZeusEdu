<div class="container">

    {if $listeEleves|count > 0}

    <div class="row">

        <div class="col-md-4 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des élèves</h3>
                </div>
                <div class="panel-body">
                    <select class="form-control" id="listeEleves" size="{$listeEleves|@count}">
                    {foreach from=$listeEleves key=matricule item=unEleve}
                    <option value="{$matricule}">{$detailsEleves.$matricule.groupe} - {$detailsEleves.$matricule.nom} {$detailsEleves.$matricule.prenom}</option>
                    {/foreach}
                    </select>
                </div>
                <div class="panel-footer">
                    Sélectionnez un élève
                </div>
            </div>

        </div>

        <div class="col-md-3 col-sm-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Élève sélectionné</h3>
                </div>
                <div class="panel-body" id="detailsEleve">

                </div>
                <div class="panel-footer">

                </div>
            </div>

        </div>

        <div class="col-md-5 col-sm-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Détail des évaluations</h3>
                </div>
                <div class="panel-body" id="evaluations">

                </div>
                <div class="panel-footer">

                </div>
            </div>

        </div>

    </div>

    {else}

    <div class="alert alert-warning">
        <i class="fa fa-exclamation-triangle"></i> Vous n'avez aucun élève en suivi de stage.
    </div>

    {/if}
</div>

<script type="text/javascript">
    var memMatricule = '';

    $(document).ready(function() {

        $("#listeEleves").click(function() {
            var matricule = $(this).val();
            // ne rien faire si l'élève est déjà sélectionné
            if (matricule != memMatricule) {
                $.post('inc/stages/detailsEleves.inc.php', {
                    matricule: matricule
                }, function(resultat) {
                    $("#detailsEleve").html(resultat);
                })

                $.post('inc/stages/detailsCotesQualif.inc.php', {
                    matricule: matricule
                }, function(resultat) {
                    $("#evaluations").html(resultat);
                })

                memMatricule = matricule;
            }
        });

        $("#listeEleves").change(function() {
            var matricule = $(this).val();

            $.post('inc/stages/detailsEleves.inc.php', {
                matricule: matricule
            }, function(resultat) {
                $("#detailsEleve").html(resultat);
            })

            $.post('inc/stages/detailsCotesQualif.inc.php', {
                matricule: matricule
            }, function(resultat) {
                $("#evaluations").html(resultat);
            })
        })

        $("#evaluations").on('click', '#submitStages', function() {
            var matricule = $("#listeEleves").val();
            var listeCotes = []
            $("#evaluations input:text").each(function(i, element) {
                console.log(element.disabled);
                if (!(element.disabled)) {
                    id = element.id;
                    val = $(element).val();
                    listeCotes.push([id, val]);
                }
            })
            $.post('inc/stages/saveStagesSuivis.inc.php', {
                    matricule: matricule,
                    listeCotes: listeCotes
                },
                function(resultat) {
                    bootbox.alert(resultat + ' évaluations enregistrées');
                })
        })

        $('#evaluations').on('change', 'input.majuscules', function() {
            $(this).val($(this).val().toUpperCase());
        })

    })
</script>
