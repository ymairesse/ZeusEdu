<div class="container-fluid">

    <div class="row">

        <div class="col-md-8 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Impression des fiches "parents"</h3>
                </div>
                <div class="panel-body">
                    <p>Veuillez choisir entre l'impression de toutes les fiches "parents" ou seulement les fiches complétées par les administrateurs.</p>
                    <div class="col-xs-6">

                            <div class="dropdown">
                                <a href="javascript:void(0)" data-toggle="dropdown" class="dropdown-toggle btn btn-block btn-success btn-partiel">Impression partielle <b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    {foreach from=$listeNiveaux item=niveau}
                                        <li><a href="#" class="print" data-mode="partiel" data-niveau="{$niveau}">{$niveau}e année</a></li>
                                    {/foreach}
                                </ul>
                            </div>

                        {* <button type="button" data-mode="partiel" data-acronyme="{$acronyme}" class="btn btn-success btn-block print">Impression partielle</button> *}

                    </div>
                    <div class="col-xs-6">
                        <p>N'imprimer que les fiches "parents" dont les RV ont été pris par les administrateurs</p>
                    </div>

                    <div class="col-xs-6">

                        <div class="dropdown">
                            <a href="javascript:void(0)" data-toggle="dropdown" class="dropdown-toggle btn btn-block btn-danger btn-complet">Impression totale <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                {foreach from=$listeNiveaux item=niveau}
                                    <li><a href="#" class="print" data-mode="complet" data-niveau="{$niveau}">{$niveau}e année</a></li>
                                {/foreach}
                            </ul>
                        </div>


                        {* <button type="button" data-mode="complet" data-acronyme="{$acronyme}" class="btn btn-danger btn-block print">Impression totale</button> *}
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
                    <h3 class="panel-title" id="title">Préparation de votre fichier</h3>
                </div>
                <div class="panel-body">
                    <div id="ajaxLoader" class="hidden">
                        <p>Veuillez patienter</p>
                        <img src="images/ajax-loader.gif" alt="loading" class="center-block">
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
            var idRP = $("#idRP").val()
            var niveau = $(this).data('niveau');

            $("#panneau").removeClass('hidden');
            $.post('inc/reunionParents/RVParents2pdf.inc.php', {
                    idRP: idRP,
                    mode: mode,
                    niveau: niveau
                },
                function(resultat) {
                    bootbox.alert({
                        title: 'Votre fichier est prêt',
                        message: 'Vous pouvez récupérer le document au format PDF en cliquant ' + resultat
                    });
                    $('#panneau').addClass('hidden');
                })
        })
    })
</script>
