<div class="container">

    <div class="row">

        <div class="col-md-4 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des professeurs de la section</h3>
                </div>
                <div class="panel-body">
                    <select id="selectProf" class="form-control" size="{$listeProfs|@count}">
                      {foreach from=$listeProfs key=acronyme item=unProf}
                      <option value="{$acronyme}">{$unProf.nom} {$unProf.prenom}
                      {/foreach}
                  </select>
                </div>
                <div class="panel-footer">
                    Sélectionner un professeur puis un ou plusieurs élèves
                </div>
            </div>

        </div>


        <div class="col-md-4 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des élèves de la classe</h3>
                </div>
                <div class="panel-body">
                    <button type="button" class="btn btn-primary btn-block" id="associer">Associer les élèves et le professeur >></button>
                    <select id="selectEleves" class="form-control" size="{$listeEleves|@count}" multiple>
                        {foreach from=$listeEleves key=matricule item=unEleve}
                            <option value="{$matricule}" data-matricule="{$matricule}">{$unEleve.nom} {$unEleve.prenom}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="panel-footer">
                    Sélectionner un ou plusieurs élèves
                </div>
            </div>

        </div>

        <div class="col-md-4 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Stages suivis par le professeur</h3>
                </div>
                <div class="panel-body" id="stages">

                </div>
                <div class="panel-footer">
                    Sélectionner un élève pour le supprimer
                </div>
            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function() {

        $("#selectProf").change(function() {
            var acronyme = $(this).val();
            $.post('inc/stages/listeStagesProf.inc.php', {
                    acronyme: acronyme
                },
                function(resultat) {
                    $("#stages").html(resultat);
                });
            $.post('inc/stages/listeElevesProfStage.inc.php', {
                acronyme: acronyme
            },
            function(resultat){
                $("#stages").html(resultat);
            })
        })

        $("#associer").click(function() {
            var acronyme = $("#selectProf").val();
            var listeEleves = [];
            $("#selectEleves :selected").each(function(i, selected){
                listeEleves.push($(selected).val());
            })
            $.post('inc/stages/associeProfEleves.inc.php',{
                acronyme: acronyme,
                listeEleves: listeEleves
            },
            function(resultat){
                $("#stages").html(resultat);
            })
        })

        $("#stages").on('click', '#dissocier', function(){
            var acronyme = $("#selectProf").val();
            var matricule = $("#stagesEleves option:selected").val();
            bootbox.confirm("Voulez-vous vraiment supprimer cet élève?", function(result){
                if(result == true) {
                    $.post('inc/stages/dissocieProfEleves.inc.php', {
                        acronyme: acronyme,
                        matricule: matricule
                    },
                    function(resultat){
                        $("#stages").html(resultat);
                    })
                }
             }
         );

        })
    })

</script>
