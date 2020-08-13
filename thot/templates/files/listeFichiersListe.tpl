<table class="table table-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Nom du fichier</th>
        <th>Date d'enregistrement</th>
        <th>Taille</th>
    </tr>

    {foreach from=$dir item=file}
    <tr class="{$file.type}" data-filename="{$file.fileName}" data-dirorfile="{$file.type}">

        <td {if $file.type=='file' } class="ext_{$file.ext}" {/if} style="width:32px">
            {if $file.type == 'dir'}<i class="fa fa-folder-open-o"></i>{/if}
        </td>
        <td>{if $file.type == 'file'}
            <a title="{$file.fileName}" href="inc/download.php?type=pfN&amp;f={$arborescence}/{if $directory != ''}{$directory}/{/if}{$file.fileName}">
                {$file.fileName|truncate:30:'...'}
            </a>
            {/if}

            {if $file.type == 'dir'}
            <a title="{$file.fileName}" href="javascript:void(0)" class="directory" data-dir="{$file.fileName}">{$file.fileName}</a>
            {/if}
        </td>
        <td>{$file.dateTime}</td>
        <td>{if $file.type == 'file'}{$file.size}{else}-{/if}</td>
    </tr>
    {/foreach}

</table>

<script type="text/javascript">

    $(document).ready(function(){

        // marquer le fichier "actif" et
        // voir les partages d'un fichier ordinaire ou d'un répertoire
        $('table tr').click(function(){
            $('#listeFichiers tr').removeClass('active');
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

        $("#listeFichiers").on('click', '.directory', function(){
            // l'arborescence se trouve dans breadcrumbs.tpl
            var arborescence = $('#arborescence').val();
            var directory = $(this).data('dir');
            $.post('inc/files/refreshBreadcrumbs.inc.php', {
                arborescence: arborescence,
                directory: directory
                },
                function(resultat){
                    $('#breadcrumbs').html(resultat);
                });
            $.post('inc/files/refreshFileList.inc.php', {
                arborescence: arborescence,
                directory: directory
            }, function(resultat){
                $("#listeFichiers").html(resultat);
            })
        })

        $('#modal').on('click', '#confirmDelFile', function() {
            var fileName = $('#delFileName').text();
            var arborescence = $('#delPath').text();
            $.post('inc/files/delFile.inc.php', {
                    fileName: fileName,
                    arborescence: arborescence
                },
                function(resultat) {
                    if (resultat == 1) {
                        $('tr.active').remove();
                        $('#listePartages').html('-');
                        $('.popover').popover('hide');
                        bootbox.alert({
                            title: 'Suppression d\'un fichier',
                            message: 'Le fichier et tous ses partages ont été supprimés'
                        })
                    }
                });
            $("#modalDelFile").modal('hide');

        })

        // *******************************************************************************
        $('#listeFichiers').on('click', '.delete[data-dirorfile="dir"]', function(){
            var fileName= $(this).data('filename');
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            $.post('inc/files/getModalDelDir.inc.php', {
                arborescence: arborescence,
                fileName: fileName
            }, function(resultat){
                $('#modal').html(resultat);
                $("#modalDelDir").modal('show');
            })
        })

        $('#modal').on('click', "#btnConfirmDelDir", function() {
            var arborescence = $('#rootRep').data('arborescence');
            var fileName = $('#delRep').data('filename');
            $.post('inc/files/delDir.inc.php', {
                    arborescence: arborescence,
                    fileName: fileName
                },
                function(resultat) {
                    var resultatJS = JSON.parse(resultat);
                    var nbDir = parseInt(resultatJS.nbDir);
                    var nbFiles = parseInt(resultatJS.nbFiles);
                    if (nbDir > 0) {
                        bootbox.alert({
                                title: "Effacement d'un dossier",
                                message: '<strong>1</strong> dossier contenant <strong>' + resultatJS.nbFiles + '</strong> fichier(s) supprimé(s)'
                            });
                    } else alert('Houston, We\'ve Got a Problem. Ce dossier ne peut être supprimé');
                });
            // supprimer la ligne du tableau des fichiers
            $('#listeFichiers tr.active').remove();
            $("#modalDelDir").modal('hide');
        })


        // ******************************************************************************************
        $('#listeFichiers').on('click', 'table tr', function() {
            $("#listeFichiers tr").removeClass('active');
            $(this).addClass('active');
            var fileName= $(this).data('filename');
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            var dirOrFile = $(this).data('dirorfile');

            $.post('inc/files/getSharesForFile.inc.php', {
                fileName: fileName,
                arborescence: arborescence,
                dirOrFile: dirOrFile
            },
            function(resultat){
                $("#partages").html(resultat);
            })
        })

    })

</script>
