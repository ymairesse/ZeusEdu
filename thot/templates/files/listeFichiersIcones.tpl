<div id="fichiersIcones">

{foreach from=$dir item=oneFile}

{if $oneFile.type == 'dir'}

    <div class="conteneur"
        title="{$oneFile.fileName}"
        data-dirorfile="dir"
        data-filename="{$oneFile.fileName}">

        <div class="folderImage"></div>

        <div class="fileName" data-dirorfile='dir'>
            <i class="fa fa-play" style="font-size:6pt"></i> {$oneFile.fileName|truncate:20:'...'}
        </div>
    </div>

{else}

    <div class="conteneur"
        title="{$oneFile.fileName}"
        data-dirorfile="file"
        data-filename="{$oneFile.fileName}">

        <div class="fileImage ext_{$oneFile.ext}" style="display:block;"></div>

        <a href="inc/download.php?type=pfN&amp;f={$arborescence}/{if $directory != ""}{$directory}/{/if}{$oneFile.fileName}">

            <div class="fileName" data-dirorfile='file'>
                {$oneFile.fileName|truncate:20:'...'}<br>
                {$oneFile.size}
            </div>
        </a>
    </div>
{/if}

{/foreach}

</div>

<script type="text/javascript">

    $(document).ready(function(){

        // marquer le fichier "actif" et
        // voir les partages d'un fichier ordinaire ou d'un répertoire
        $('.conteneur').click(function(){
            $('.conteneur').removeClass('active');
            $(this).addClass('active');
            var dirOrFile = $(this).data('dirorfile');
            var fileName = $(this).data('filename');
            var arborescence = $('#arborescence').val();
            $('#btn-del').removeClass('disabled').data('dirorfile',dirOrFile).data('filename', fileName);

            $.post('inc/files/getSharesForFile.inc.php', {
                fileName: fileName,
                arborescence: arborescence,
                dirOrFile: dirOrFile
            },
            function(resultat){
                $("#partages").html(resultat);
                if (arborescence != '/')
                    $('#btn-share').removeClass('disabled');
                    else $('#btn-share').addClass('disabled');
            })
        })

        $('#modal').on('click', '#confirmDelFile', function() {
            var fileName = $('.conteneur.active').data('filename');
            var arborescence = $('#arborescence').val();
            $.post('inc/files/delFile.inc.php', {
                    fileName: fileName,
                    arborescence: arborescence
                },
                function(resultat) {
                    if (resultat == 1) {
                        // combien d'éléments dans l'affichage des fichiers?
                        var nbFiles = $('.conteneur').length;
                        // Si plus de 1, on efface l'élément actif
                        if (nbFiles > 1)
                            $('.conteneur.active').remove();
                            // sinon, on indique que le répertoire est dorénavant vide
                            else $('.conteneur.active').replaceWith("<p class='avertissement'>Dossier vide</p>");
                        $('#listePartages').html('-');
                        $('.popover').popover('hide');
                        bootbox.alert({
                            title: 'Suppression d\'un fichier',
                            message: 'Le fichier <strong>' + fileName + '</strong> et tous ses partages ont été supprimés'
                        })
                    }

                });
            $("#modalDelFile").modal('hide');
        })

        $('#modal').on('click', "#btnConfirmDelDir", function() {
            var arborescence = $('#rootRep').data('arborescence');
            var fileName = $('#delRep').data('filename');
            $.post('inc/files/delDir.inc.php', {
                    arborescence: arborescence,
                    fileName: fileName
                },
                function(resultat) {
                    // rustine
                    if (resultat != '')
                        {
                        var resultatJS = JSON.parse(resultat);
                        var nbDir = parseInt(resultatJS.nbDir);
                        var nbFiles = parseInt(resultatJS.nbFiles);
                        if (nbDir > 0) {
                            bootbox.alert({
                                    title: "Effacement d'un dossier",
                                    message: '<strong>1</strong> dossier contenant <strong>' + resultatJS.nbFiles + '</strong> fichier(s) supprimé(s)'
                                });
                            }
                        // nombre de fichirs résiduels
                        var nbFiles = $('.conteneur').length;
                        if (nbFiles > 1)
                            $('.conteneur.active').remove();
                            else $('.conteneur.active').replaceWith("<p class='avertissement'>Dossier vide</p>");
                        }
                });
            $("#modalDelDir").modal('hide');
        })


        // ouvrir un répertoire par un clic sur le nom du répertoire
        $('.fileName[data-dirorfile="dir"]').click(function(event){
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            var directory = $(this).closest('.conteneur').data('filename');

            $.post('inc/files/refreshBreadcrumbs.inc.php', {
                arborescence: arborescence,
                directory: directory
                },
                function(resultat){
                    $('#breadcrumbs').html(resultat);
                    $.post('inc/files/refreshFileList.inc.php', {
                        arborescence: arborescence,
                        directory: directory
                    }, function(resultat){
                        $("#listeFichiers").html(resultat);
                    })
                });
            })

    })

</script>
