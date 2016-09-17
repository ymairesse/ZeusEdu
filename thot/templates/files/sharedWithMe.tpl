<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container">

    <h3>Documents partagés avec moi</h3>
    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Destinataire</th>
                <th>Propriétaire</th>
                <th>Document</th>
                <th>Commentaire</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeFichiers item=unFichier}
            <tr>
                <td>
                    {if $unFichier.destinataire == 'all'}Tous {else} {$unFichier.destinataire} {/if}
                </td>
                <td>
                    <span title="{$unFichier.acronyme}">{$unFichier.prenom} {$unFichier.nom}</span>
                </td>
                <td>
                    {if $unFichier.fileName == ''}
                    <button
                        type="button"
                        class="btn btn-primary btn-xs btnFolder"
                        data-fileid="{$unFichier.fileId}"
                        data-commentaire="{$unFichier.commentaire}">
                        <i class="fa fa-folder-open"></i> {$unFichier.commentaire}
                    </button>
                    {else}
                    <a href="inc/download.php?f={$unFichier.fileId}">{$unFichier.fileName}</a>
                    {/if}
                </td>
                <td>
                    {$unFichier.commentaire}
                </td>
            </tr>

            {/foreach}
        </tbody>
    </table>

</div>

{include file='modal/modalTreeView.tpl'}

<script type="text/javascript">

$(document).ready(function(){

    $(".btnFolder").click(function(){
        var fileId = $(this).data('fileid');
        var modalTitre = $(this).data('commentaire');
        $.post('inc/files/getTreeForId.inc.php',{
            fileId: fileId
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

})

</script>
