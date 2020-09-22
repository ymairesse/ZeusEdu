<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

    <div class="row">

        <div class="col-md-9 col-sm-12">
            <h2>Les documents et dossiers que je partage</h2>

            <div id="listePartages">
                {* Onglets pour chaque groupe de partage *}
                <ul class="nav nav-tabs">
                    {foreach from=$sharesList key=groupe item=groupShares name=onglets}
                    <li {if ($smarty.foreach.onglets.index == 0)}class="active"{/if}>
                        <a data-toggle="tab" href="#tabs-{$smarty.foreach.onglets.index}">{$dicoShareGroups.$groupe}</a>
                    </li>
                    {/foreach}
                </ul>

                {* Panneaux correspondant aux onglets *}
                <div class="tab-content">

                    {foreach from=$sharesList key=groupe item=groupShares name=onglets}
                    <div id="tabs-{$smarty.foreach.onglets.index}" class="tab-pane fade in{if $smarty.foreach.onglets.index == 0} active{/if}">

                        <ul class="nav nav-tabs">
                        {foreach from=$groupShares key=leGroupe item=shareData name=groupe}
                            <li {if $smarty.foreach.groupe.index == 0}class="active"{/if}>
                                <a data-toggle="tab" href="#id-{$smarty.foreach.onglets.index}_{$smarty.foreach.groupe.index}">
                                    {$leGroupe}
                                </a>
                            </li>
                        {/foreach}
                        </ul>

                        <div class="tab-content">
                            {foreach from=$groupShares key=leGroupe item=shareData name=groupe}
                                <div id="id-{$smarty.foreach.onglets.index}_{$smarty.foreach.groupe.index}"
                                    class="tab-pane fade in {if $smarty.foreach.groupe.index == 0} active{/if}"
                                    style="height:30em; overflow: auto" data-groupe="{$leGroupe}">

                                    <table class="table table-condensed shareGroup">
                                        <tr>
                                            <th style="width:2em">&nbsp;</th>
                                            <th>Chemin</th>
                                            <th>Nom du fichier</th>
                                            <th style="width:2em">&nbsp;</th>
                                            <th>Commentaire</th>
                                            <th>Partagé avec</th>
                                            <th style="width:2em">
                                                <button type="button"
                                                    class="btn btn-danger btn-xs btn-unShare"
                                                    data-id="id-{$smarty.foreach.onglets.index}_{$smarty.foreach.groupe.index}"
                                                    title="Supprimer tous les partages de cette page">
                                                    <i class="fa fa-share-alt"></i> <i class="fa fa-arrow-down"></i>
                                                </button>
                                            </th>
                                        </tr>
                                        {foreach from=$shareData key=shareId item=file}
                                        <tr data-shareid="{$shareId}" data-fileid="{$file.fileId}" class="{$file.dirOrFile}">
                                            <td>
                                                <button
                                                    type="button"
                                                    title="Placer/retirer un espion"
                                                    class="btn btn-xs {if isset ($spiedSharesList.$shareId)}btn-info btn-showSpy{else}btn-default btn-spy{/if}" data-shareid="{$file.shareId}">
                                                    <i class="fa fa-eye"></i>
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
                                                    class="btn btn-danger btn-xs unShare pull-right"
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

                        </div>

                    </div>
                    {/foreach}

                </div>

            </div>

        </div>

        <div class="col-md-3 col-sm-12">

            <h3>Mode d'emploi</h3>
            <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Placer/retirer/visualiser un espion" class="btn btn-xs btn-info btn-showSpy">
                <i class="fa fa-eye"></i>
            </button>  Ajout / suppression / visualisation d'un espion sur le fichier. L'identité de l'utilisateur et la date de dernier teléchargement du document sont enregistrés. Clic sur le bouton pour voir les téléchargements ou supprimer l'espion.</p>

            <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Modifier ce partage" class="btn btn-success btn-xs shareEdit">
                <i class="fa fa-edit"></i>
            </button> Modification du commentaire associé au partage</p>

            <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Arrêter le partage" class="btn btn-danger btn-xs unShare">
                <i class="fa fa-share-alt"></i>
            </button> Clôture du partage: les autres utilisateurs n'auront plus accès au document. Le document n'est pas effacé. Si un document est partagé plusieurs fois avec divers utilisateurs, il faut dé-partager chacune des occurrences du partage.</p>

            <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Placer/retirer un espion" class="btn btn-xs btn-default btn-spy">
                <i class="fa fa-eye"></i>
            </button> Permet d'activer / désactiver l'option de suivi de téléchargement. Chaque téléchargement par un élève est enregistré. Seule le dernier téléchargement en date est conservé. Les téléchargements des fichiers par les collègues ne sont pas enregistrés.<br>
            Cliquer sur le bouton pour activer le suivi, pour prendre connaissance du suivi ou pour désactiver le suivi.
            </p>

        </div>

    </div>

</div>

{include file="files/modal/modalEditShare.tpl"}
{include file="files/modal/modalUnshareFile.tpl"}
{include file="files/modal/modalShowSpied.tpl"}
{include file='files/modal/modalTreeView.tpl'}

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
                $('#listePartages .btn-showSpy[data-shareid="' + shareId + '"]').removeClass('btn-info btn-showSpy').addClass('btn-default btn-spy');
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

    $('.btn-unShare').click(function(){
        var unShareFiles = $(this).closest('table').find('.unShare');
        var listeFichiers = [];
        var listeShareId = []
        unShareFiles.each(function(index){
            listeFichiers.push($(this).data('filename')+'<br>');
            listeShareId.push($(this).data('shareid'));
        })
        bootbox.confirm({
            'title': 'Arrêt du partage',
            'message': 'Confirmez l\'arrêt du partage des fichiers <br>' + listeFichiers,
            callback: function (result){
                if (result == true) {
                    $.post('inc/files/unShareSeries.inc.php', {
                        listeShareId: listeShareId
                    }, function(resultat){
                        alert(resultat);
                    })
                }
            }
        })
            // alert(listeFichiers);
            // alert(listeShareId);
    })

    $("#saveComment").click(function() {
        var shareId = $("#shareEditId").val();
        var commentaire = $("#shareEditCommentaire").val();
        $.post('inc/files/saveCommentaire.inc.php', {
                shareId: shareId,
                commentaire: commentaire
            },
            function(commentaire) {
                $('#listePartages tr[data-shareid="' + shareId + '"] td.commentaire').text(commentaire);
                $("#modalShareEdit").modal('hide');
            })
    })

</script>
