<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container">

    <h2>Les documents et dossiers que je partage</h2>

    <div id="listePartages">

        <ul class="nav nav-tabs">
            {foreach from=$sharesList key=groupe item=groupShares name=onglets}
            <li {if ($smarty.foreach.onglets.index == 0)}class="active"{/if}>
                <a data-toggle="tab" href="#tabs-{$smarty.foreach.onglets.index}">{$dicoShareGroups.$groupe}</a>
            </li>
            {/foreach}
        </ul>

        <div class="tab-content">

            {foreach from=$sharesList key=groupe item=groupShares name=onglets}
            <div id="tabs-{$smarty.foreach.onglets.index}" class="tab-pane fade in{if $smarty.foreach.onglets.index == 0} active{/if}">

                <ul class="nav nav-tabs">
                {foreach from=$groupShares key=leGroupe item=shareData name=groupe}
                    <li {if $smarty.foreach.groupe.index == 0}class="active"{/if}>
                        <a data-toggle="tab" href="#id-{$smarty.foreach.onglets.index}_{$smarty.foreach.groupe.index}">{$leGroupe}</a>
                    </li>
                {/foreach}
                </ul>

                <div class="tab-content">
                    {foreach from=$groupShares key=leGroupe item=shareData name=groupe}
                        <div id="id-{$smarty.foreach.onglets.index}_{$smarty.foreach.groupe.index}"
                            class="tab-pane fade in {if $smarty.foreach.groupe.index == 0} active{/if}"
                            style="height:30em; overflow: auto">

                            <table class="table table-condensed shareGroup">
                                <tr>
                                    <th style="width:2em">&nbsp;</th>
                                    <th>Chemin</th>
                                    <th>Nom du fichier</th>
                                    <th style="width:2em">&nbsp;</th>
                                    <th>Commentaire</th>
                                    <th>Partagé avec</th>
                                    <th style="width:2em">&nbsp;</th>
                                </tr>
                                {foreach from=$shareData key=shareId item=file}
                                <tr data-shareid="{$shareId}" data-fileid="{$file.fileId}" class="{$file.dirOrFile}">
                                    <td>
                                        <button
                                            type="button"
                                            title="Placer/retirer un espion"
                                            class="btn btn-xs {if isset ($spiedSharesList.$shareId)}btn-info btn-showSpy{else}btn-primary btn-spy{/if}" data-shareid="{$file.shareId}">
                                            <i class="fa fa-user-secret"></i>
                                        </button>
                                    </td>
                                    <td>
                                        {if $file.dirOrFile == 'dir'}
                                            <button
                                                type="button"
                                                class="btn btn-primary btn-xs btnFolder"
                                                data-shareid="{$file.shareId}"
                                                data-commentaire="{$file.path}{if $file.path != '/'}/{/if}{$file.fileName}">

                                                <i class="fa fa-folder-open text-danger"></i>
                                                {$file.path}{if $file.path != '/'}/{/if}{$file.fileName}
                                            </button>
                                        {else}
                                            {$file.path}
                                        {/if}
                                    </td>
                                    <td>
                                        {if $file.dirOrFile == 'file'}
                                            <i class="fa fa-file text-info"></i>
                                            <a href="inc/download.php?type=pfN&amp;f={$file.path}/{$file.fileName}">{$file.fileName}</a>
                                            {else}
                                        <span class="help-block">Tout le dossier</span>{/if}</td>
                                    <td>
                                        <button type="button" title="Modifier ce partage" class="btn btn-success btn-xs shareEdit" data-shareid="{$file.shareId}"><i class="fa fa-edit"></i></button>
                                    </td>
                                    <td class="commentaire">{$file.commentaire}</td>
                                    <td>{$file.libelle}</td>
                                    <td><button
                                            type="button"
                                            class="btn btn-danger btn-xs unShare"
                                            data-fileid="{$file.fileId}"
                                            data-shareId="{$file.shareId}"
                                            data-filename="{$file.fileName}"
                                            title="Arrêter le partage">
                                            <i class="fa fa-share-alt"></i>
                                        </button>
                                    </td>
                                </tr>

                                {/foreach}

                            </table>

                        </div>
                    {/foreach}
                    <strong class="pull-right">TOTAL: {$shareData|@count} fichiers ou dossier partagés</strong>
                </div>

            </div>
            {/foreach}

        </div>

    </div>

</div>

{include file="modal/modalEditShare.tpl"}
{include file="modal/modalUnshareFile.tpl"}
{include file="modal/modalShowSpied.tpl"}
{include file='modal/modalTreeView.tpl'}

<script type="text/javascript">

    $(document).ready(function(){

        $(".btnFolder").click(function(){
            var shareId = $(this).data('shareid');
            var modalTitre = $(this).data('commentaire');
            $.post('inc/files/getTreeForOwner.inc.php',{
                shareId: shareId
            },
            function(resultat){
                $("#titleTreeview").text(modalTitre);
                $("#treeview").html(resultat);
                $("#modalTreeView").modal('show');
            })
        })

        $("#treeview").on('click', '.dirLink', function(event) {
            $(this).next('.filetree').toggle('slow');
            $(this).closest('li').toggleClass('expanded');
        })

        $('#modalShowSpied').on('click', '#btn-unspy', function(){
            var shareId = $(this).data('shareid');
            $.post('inc/files/delSpy.inc.php', {
                shareId: shareId
            },
            function(resultat){
                $('#listePartages .btn-showSpy[data-shareid="' + shareId + '"]').removeClass('btn-info btn-showSpy').addClass('btn-primary btn-spy');
                $('#modalShowSpied').modal('hide');
            })
        })

        $('#listePartages').on('click', '.btn-spy', function(){
            var bouton = $(this);
            var shareId = $(this).data('shareid');
            $.post('inc/files/createSpy.inc.php', {
                shareId: shareId
            },
            function(resultat){
                if (resultat == 'SESSION_EXPIRED') {
                    window.location.replace('../accueil.php');
                }
                if (resultat == 1) {
                    bouton.removeClass('btn-primary btn-spy').addClass('btn-info btn-showSpy');
                    bootbox.alert('Ce document est maintenant suivi')
                    }
            })
        })

        $('#listePartages').on('click', '.btn-showSpy', function(){
            var bouton = $(this);
            var shareId = $(this).data('shareid');
            $.post('inc/files/gestSpy.inc.php', {
                shareId: shareId,
            },
            function(resultat){
                $('#modalShowSpied .modal-body').html(resultat);
                $('#modalShowSpied').modal('show');
            })
        })

        $('.unShare').click(function(){
            var shareId = $(this).data('shareid');
            $.post('inc/files/getInfoForShareId.inc.php', {
                shareId: shareId
                },
                function(resultat){
                    var resultatJS = JSON.parse(resultat);
                    if (resultatJS.fileType == 'file')
                        $('#modalFileType').text('fichier');
                        else $('#modalFileType').text('dossier');
                    $('#modalUnShareFileName').text(resultatJS.fileName);
                    $('#modalUnShareWith').text(resultatJS.libelle);
                    $('#btnUnShareFile').data('shareid', resultatJS.shareId);
                    $('#modalUnShareFile').modal('show');
                })
            })

        $("#btnUnShareFile").click(function() {
            var shareId = $(this).data('shareid');
            $.post('inc/files/unShareFile.inc.php', {
                shareId: shareId
            }, function(resultat) {
                $(".unShare[data-shareid='" + shareId + "']").closest('tr').remove();
            })
            $("#modalUnShareFile").modal('hide');
        })

        $('.shareEdit').click( function(){
            var shareId = $(this).data('shareid');
            $.post('inc/files/getInfoForShareId.inc.php', {
                shareId: shareId
            },
                function(resultat){
                    var resultatJS = JSON.parse(resultat);
                    $("#shareEditId").val(resultatJS.shareId);
                    $("#shareEditPath").text(resultatJS.path);
                    $("#shareEditFileName").text(resultatJS.fileName);
                    $("#shareEditCommentaire").val(resultatJS.commentaire);
                    $("#shareEditSharedWith").text(resultatJS.libelle);
                    $("#modalShareEdit").modal('show');
                });
        })

        $('#modalShareEdit').on('shown.bs.modal', function () {
           $('#shareEditCommentaire').focus();
        });
    })

    $("#saveComment").click(function() {
        var shareId = $("#shareEditId").val();
        var commentaire = $("#shareEditCommentaire").val();
        $.post('inc/files/saveCommentaire.inc.php', {
                shareId: shareId,
                commentaire: commentaire
            },
            function(resultat) {
                var resultatJS = JSON.parse(resultat);
                $('#listePartages tr[data-shareid="' + shareId + '"] td.commentaire').text(resultatJS.commentaire);
                $("#modalShareEdit").modal('hide');
            })
    })

</script>
