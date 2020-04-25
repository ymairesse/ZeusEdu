<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

    <div class="row">

        <div class="col-md-3">
            <h3>Destinataires</h3>
            {foreach from=$dicoShareGroups key=type item=libelle}
            <button type="button" class="btn btn-primary btn-block btn-choixGroupe" data-type="{$type}">{$libelle}</button>
            {/foreach}

            <div id="ajaxLoader" class="hidden">
                <img src="images/ajax-loader.gif" alt="loading" class="center-block">
            </div>
        </div>

        <div class="col-md-9 col-sm-12" id="listePartages" style="height:35em; overflow: auto;">

            <p class="avertissement">Veuillez sélectionner une catégorie à gauche</p>

        </div>

        </div>

        <div class="row">

            <div class="col-md-4 col-sm-12">

                <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Placer/retirer/visualiser un espion" class="btn btn-xs btn-info btn-showSpy">
                    <i class="fa fa-eye"></i>
                </button>  Ajout / suppression / visualisation d'un espion sur le fichier. L'identité de l'utilisateur et la date de dernier teléchargement du document sont enregistrés. Clic sur le bouton pour voir les téléchargements ou supprimer l'espion.</p>
            </div>
            <div class="col-md-4 col-sm-12">
                <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Modifier ce partage" class="btn btn-success btn-xs shareEdit">
                    <i class="fa fa-edit"></i>
                </button> Modification du commentaire associé au partage</p>
            </div>
            <div class="col-md-4 col-sm-12">
                <p style="border: 1px solid #333; padding: 0.5em"><button type="button" title="Arrêter le partage" class="btn btn-danger btn-xs unShare">
                    <i class="fa fa-share-alt"></i>
                </button> Clôture du partage: les autres utilisateurs n'auront plus accès au document. Le document n'est pas effacé. Si un document est partagé plusieurs fois avec divers utilisateurs, il faut dé-partager chacune des occurrences du partage.</p>

            </div>

        </div>

</div>

{include file="files/modal/modalEditShare.tpl"}
{include file="files/modal/modalUnshareFile.tpl"}
{include file="files/modal/modalShowSpied.tpl"}
{include file='files/modal/modalTreeView.tpl'}

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('.btn-choixGroupe').click(function(){
            var type = $(this).data('type');
            $('.btn-success').removeClass('btn-success').addClass('btn-primary');
            $(this).removeClass('btn-primary').addClass('btn-success');
            $.post('inc/files/getSharedByType.inc.php', {
                type: type
            }, function(resultat){
                $('#listePartages').html(resultat);
            })
        })

        $('#listePartages').on('click', ".btnFolder", function(){
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

        $('#listePartages').on('click', '.dirLink', function(event) {
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

        $('#listePartages').on('click', '.unShare', function(){
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

        $('#listePartages').on('click', '.shareEdit', function(){
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
