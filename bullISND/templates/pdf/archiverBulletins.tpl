<div class="container-fluid">

    <h2 data-anscol="{$ANNEESCOLAIRE}">Archivage des bulletins de l'année scolaire {$ANNEESCOLAIRE}</h2>

    <div class="col-md-3 col-sm-6">

        <div class="panel panel-info">
            <div class="panel-heading">
                Niveau d'étude
            </div>
            <div class="panel-body" id="panel-buttons">
                {foreach from=$listeNiveaux item=unNiveau}
                    <div class="btn-group btn-group-justified">
                    <a class="btn btn-level btn-sm {if $niveau == $unNiveau}btn-success{else}btn-primary{/if}"
                        data-niveau="{$unNiveau}"
                        style="width:80%"
                        type="button">{$unNiveau}e année</a>

                    <a class="btn btn-refreshLevel btn-sm {if $niveau == $unNiveau}btn-success{else}btn-primary{/if}"
                        title="Régénérer pour le niveau d'étude et la période"
                        data-niveau="{$unNiveau}"
                        style="width:20%"
                        type="button"
                        {if $niveau != $unNiveau}disabled{/if}>
                        <i class="fa fa-refresh"></i>
                    </a>
                    </div>

                {/foreach}
            </div>

            <div class="panel-footer">
                <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
            </div>

        </div>


    </div>

    <div class="col-md-9 col-sm-6" id="detailsArchive">

        {include file="pdf/archiveNiveau.tpl"}

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('body').on('click', '.tab-pane', function(){
            var periode = $(this).data('periode');
            Cookies.set('periode', periode);
        })

        $('.btn-level').click(function(){
            var niveau = $(this).data('niveau');
            Cookies.set('niveau', niveau);
            $('.btn-level, .btn-refreshLevel').removeClass('btn-success').addClass('btn-primary');
            $('.btn-refreshLevel').attr('disabled', true);
            $('.btn[data-niveau="'+niveau+'"]').removeClass('btn-primary').addClass('btn-success');
            $('.btn-refreshLevel[data-niveau="' + niveau + '"]').attr('disabled', false);
            $.post('inc/pdf/detailsArchives.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#detailsArchive').html(resultat);
            })
        })

        $('#detailsArchive').on('click', '.btn-refreshClasse', function(){
            var classe = $(this).data('classe');
            var periode = $(this).data('periode');
            $.post('inc/pdf/refreshClasse.inc.php', {
                classe: classe,
                periode: periode
            }, function(resultatJSON){
                var resultat = JSON.parse(resultatJSON);
                var ANNEESCOLAIRE = resultat.ANNEESCOLAIRE;
                var link = '<a href="archives/' + resultat.ANNEESCOLAIRE + '/' + periode + '/' + resultat.file.fileName + '">' + resultat.file.fileName + '</a>';
                $('#periode_' + periode + ' td.fileName[data-classe="' + classe + '"][data-periode="' + periode + '"]').html(link);
                $('#periode_' + periode + ' td.fileSize[data-classe="' + classe + '"][data-periode="' + periode + '"]').text(resultat.file.size);
                $('#periode_' + periode + ' td.fileTime[data-classe="' + classe + '"][data-periode="' + periode + '"]').text(resultat.file.dateTime);
            })
        })

        $('.btn-refreshLevel').click(function(){
            var niveau = $(this).data('niveau');
            var periode = $('#detailsArchive').find('li.active').data('periode');
            bootbox.confirm({
                title: 'Archivage des bulletins',
                message: 'Veuillez confirmer l\'archivage des bulletins de <strong>' + niveau + 'e année</strong> pour la période <strong>' + periode + '</strong>',
                callback: function(result){
                    if (result == true){
                        $.post('inc/pdf/refreshLevel.inc.php', {
                            niveau: niveau,
                            periode: periode
                        }, function(resultatJSON){
                            var resultat = JSON.parse(resultatJSON);
                            var ANNEESCOLAIRE = resultat.ANNEESCOLAIRE;
                            var directory = resultat.directory;
                            $.each(directory, function(classe, file){
                                var link = '<a href="archives/' + ANNEESCOLAIRE + '/' + periode + '/' + file.fileName + '">' + file.fileName + '</a>';
                                $('#periode_' + periode + ' td.fileName[data-classe="' + classe + '"][data-periode="' + periode + '"]').html(link);
                                $('#periode_' + periode + ' td.fileSize[data-classe="' + classe + '"][data-periode="' + periode + '"]').text(file.size);
                                $('#periode_' + periode + ' td.fileTime[data-classe="' + classe + '"][data-periode="' + periode + '"]').text(file.dateTime);
                            })
                        })
                    }
                }
            })

        })

    })

</script>
