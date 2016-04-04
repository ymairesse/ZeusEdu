<div class="container">

    <div class="row">

        <div class="col-md-8 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Impression des fiches "parents"</h3>
                </div>
                <div class="panel-body">
                    <p>Veuillez choisir entre l'impression de toutes les fiches "parents" ou seulement les fiches complétées par les administrateurs.</p>
                    <div class="col-xs-6">
                        <button type="button" data-mode="partiel" data-acronyme="{$acronyme}" class="btn btn-success btn-block print">Impression partielle</button>
                    </div>
                    <div class="col-xs-6">
                        <p>N'imprimer que les fiches "parents" dont les RV ont été pris par les administrateurs</p>
                    </div>

                    <div class="col-xs-6">
                        <button type="button" data-mode="complet" data-acronyme="{$acronyme}" class="btn btn-danger btn-block print">Impression totale</button>
                    </div>
                    <div class="col-xs-6">
                        <p>Imprimer toutes les fiches "parents"</p>
                    </div>

                </div>

            </div>
            <!-- panel -->

        </div>
        <!-- col-md-... -->

        <div class="col-md-4 col-sm-6">

            <div class="panel panel-default hidden" id="panneau">
                <div class="panel-heading">
                    <h3 class="panel-title" id="title">Le fichier à imprimer</h3>
                </div>
                <div class="panel-body">
                    <div id="ajaxLoader" class="hidden">
                        <p>Veuillez patienter</p>
                        <img src="images/ajax-loader.gif" alt="loading" class="center-block">
                    </div>
                    <div id="link" class="hidden">
                    <p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="../{$module}/PDF/{$acronyme}/{$acronyme}.pdf">sur ce lien</a></p>
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

        $(document).ajaxStart(function(){
            $('#link').addClass('hidden');
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#link').removeClass('hidden');
            $('#ajaxLoader').addClass('hidden');
        });

        $(".print").click(function() {
            var mode = $(this).data('mode');
            var date = $("#date").val()
            var acronyme = $(this).data('acronyme');
            var module = 'thot';
            $("#panneau").removeClass('hidden');
            $.post('inc/reunionParents/RVParents2pdf.inc.php', {
                    date: date,
                    mode: mode,
                    acronyme: acronyme,
                    module: module
                },
                function(resultat) {

                })
        })
    })
</script>
