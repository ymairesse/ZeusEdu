<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">
            <h2>Compilation</h2>
        </div>

        <div class="col-xs-6">
            <h2>Compilation des cours des professeurs</h2>
            <p>La compilation des données pour les professeurs remplira la table contenant les informations d'emploi du temps des professeurs dans la base de données. Toutes les données précédemment stockées seront remplacées.</p>
            <p>Cette compilation doit être faite après chaque importation des fichiers iCal depuis EDT</p>
            <button type="button" class="btn btn-success btn-block" id="btn-compileProfs">Compilation pour les professeurs</button>

        </div>

        <div class="col-xs-6">
            <h2>Compilation des horaires des élèves</h2>
            <p>Le processus permet de relier les matricules des élèves aux noms des fichiers "images" importées depuis EDT</p>
            <p>Cette compilation doit être faite après chaque importation des images des emplois du temps depuis EDT.</p>

            <button type="button" class="btn btn-info btn-block" id="btn-compileEleves">Compilation pour les élèves</button>

        </div>

        <div class="col-xs-12">
             <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
        </div>
    </div>

</div>


<script type="text/javascript">

    $(document).ready(function(){

        var title = 'Compilation';

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('#btn-compileEleves').click(function(){
            $.post('inc/compilationEleves.inc.php', {
            }, function(resultat){
                bootbox.alert({
                    title: title,
                    message: resultat
                })
            })
        })

        $('#btn-compileProfs').click(function(){
            $.post('inc/compilationPr.inc.php', {
            }, function(resultat){
                bootbox.alert({
                    title: title,
                    message: resultat
                })
            })
        })

    })

</script>
