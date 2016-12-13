<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">
<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container">

    <div class="row">

        <div class="col-md-6 col-sm-12">

            <div class="panel panel-default" id="fileList">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des fichiers</h3>
                </div>
                <div class="panel-body" style="height: 30em; overflow: auto;" id="treeView">

                    {include file='files/treeview.tpl'}

                </div>
                <div class="panel-footer">
                    <span class="fileData micro">-</span>
                </div>
            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-6 col-sm-12">

            <div class="panel panel-default">

                <div class="panel-heading">
                    <h3 class="panel-title">Dossier actif: <span id="activeDir">/</span></h3>
                </div>
                <div class="panel-body">
                    <div class="btn-group">
                        <button type="button" class="btn btn-danger" id="btnMkdir"><i class="fa fa-folder-open-o"></i> Nouveau Dossier</button>
                        <button type="button" class="btn btn-info" id="btnUpload"><i class="fa fa-cloud"></i> Nouveaux fichiers</button>
                    </div>
                    <button type="button" class="btn btn-primary pull-right" id="btnMemoShared" title="Mémo des partages"><i class="fa fa-share-alt"></i> Mémo</button>

                    <div class="alert alert-info" id="fileInfo" style="display:none">

                        <div style="float:left; width:10%">
                            <i class="fa fa-file-o fa-2x"></i>
                        </div>
                        <div style="float:left; width:90%">
                            Nom&nbsp;: <strong id="fiFileName"></strong>
                            <br>Taille&nbsp;: <strong id="fiSize"></strong>
                            <br>Date: <strong id="fiDate"></strong>
                            <br>Dossier: <strong id="fiPath"></strong>
                            <button type="button" class="btn btn-success pull-right shareFile">
                                <i class="fa fa-share-square-o"></i> Partager
                            </button>
                        </div>

                        <div class="clearfix"></div>

                    </div>

                    <div class="alert alert-success" id="dirInfo" style="display:none">

                        <div style="float:left; padding-right:1em;">
                            <i class="fa fa-folder-o fa-2x"></i>
                        </div>
                        Dossier&nbsp;: <strong id="diDir"></strong>
                        <br> Nombre de fichiers&nbsp;: <strong id="diNb"></strong>
                        <button type="button" class="btn btn-danger pull-right shareDir">
                            <i class="fa fa-share-square-o"></i> Partager le dossier
                        </button>
                    </div>

                    <h4>Partagé avec</h4>
                    <div id="partages">-</div>

                </div>
                <div class="panel-footer">

                </div>
            </div>

        </div>
        <!-- col-md-... -->

    </div>

</div>

{include file='modal/modalNewDir.tpl'}
{include file='modal/modalDelDir.tpl'}
{include file='modal/modalDelFile.tpl'}
{include file='modal/modalShare.tpl'}
{include file='modal/modalUpload.tpl'}
{include file='modal/modalUnshareFile.tpl'}
{include file='modal/modalEditShare.tpl'}
{include file='modal/modalMemoShare.tpl'}

<script type="text/javascript">
    $(document).ready(function() {

        var activeDir = '/';

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        function finfo(truc) {
            $("#dirInfo").hide();
            var fileName = truc.data('filename');
            var path = truc.data('path');
            var date = truc.data('date');
            var size = truc.data('size');
            $('#fiFileName').text(fileName);
            $('#fiDate').text(date);
            $('#fiSize').text(size);
            $('#fiPath').text(path);
            $("#fileInfo").fadeIn();
        }

        function dirInfo(truc) {
            $("#fileInfo").fadeOut();
            // $('#partages').fadeOut();
            $("#btnDelfile").addClass('disabled');
            $("#diDir").text(truc.data('dir'));
            var nbFiles = truc.next('.filetree').find('li').length;
            $("#diNb").text(nbFiles);
            if (truc.data('dir') != '/')
                $("#btnDeldir").removeClass('disabled');
            else $("#btnDeldir").addClass('disabled');

            $("#dirInfo").fadeIn();
        }

        $("#treeView").on('click', '.file', function() {
            $('#treeView *').removeClass('activeFile');
            $(this).addClass('activeFile');
            var details = $(this).closest('li');
            finfo(details);
            var fileName = details.data('filename');
            var path = details.data('path');

            $.post('inc/files/shareList.inc.php', {
                path: path,
                fileName: fileName
            }, function(resultat) {
                $('#partages').html(resultat).fadeIn();
            })
        })

        $("#treeView").on('click', '.dirLink', function(event) {
            $(this).next('.filetree').toggle('slow');
            $(this).closest('li').toggleClass('expanded');
            $('.dirLink').removeClass('activeDir');
            $(this).addClass('activeDir');
            $("#activeDir").html($(this).data('dir'));
            dirInfo($(this));

            var fileName = '';
            var path = $(this).data('dir');
            $.post('inc/files/shareList.inc.php', {
                path: path,
                fileName: fileName
            }, function(resultat) {
                $('#partages').html(resultat).fadeIn();
            })
        })

        $("#treeView").on('contextmenu', '.dirLink', function(event) {
            dirInfo($(this));
            event.preventDefault();
        })

        $("#treeView").on('contextmenu', '.file', function(event) {
            $('#treeView *').removeClass('activeFile');
            $(this).addClass('activeFile');
            finfo($(this));
            event.preventDefault();
        })

        $('#treeView').on('mouseenter', '.file', function() {
            var size = $(this).data('size');
            var date = $(this).data('date');
            $("#fileList .panel-footer .fileData").text('Taille: ' + size + ' Date: ' + date);
        })

        $('#treeView').on('mouseleave', '.file', function() {
            $("#fileList .panel-footer .fileData").text('-');
        })

        $('#treeView').on('mouseenter', 'a.dirLink', function() {
            var nbFiles = $(this).data('nbfiles');
            $("#fileList .panel-footer .fileData").text(nbFiles + ' fichiers et/ou répertoires inclus');
        })

        $('#treeView').on('mouseleave', 'a.dirLink', function() {
            $("#fileList .panel-footer .fileData").text('-');
        })

        $('#treeView').on('mouseenter', '.delFile', function() {
            $('#fileList .panel-footer .fileData').text('Ctrl+clic pour effacer sans confirmation.')
        })

        $('#treeView').on('mouseleave', '.delFile', function() {
            $("#fileList .panel-footer .fileData").text('-');
        })

        $('#treeView').on('click', '.delFile', function(event) {
            var fileName = $(this).closest('li').data('filename');
            var path = $(this).closest('li').data('path');
            // ctrl+clic pour effacer sans confirmation /!\
            if (event.ctrlKey) {
                $.post('inc/files/delFile.inc.php', {
                        fileName: fileName,
                        path: path
                    },
                    function(resultat) {
                        if (resultat == 1) {
                            // suppression dans l'arboresence
                            $('.activeFile').remove();
                            $('#fileInfo').hide();
                            $("#btnDelfile").addClass('disabled');
                        } else alert('Impossible de supprimer ce fichier');
                    });
            } else {
                $.post('inc/files/shareList.inc.php', {
                        fileName: fileName,
                        path: path,
                        simple: true
                    },
                    function(resultat) {
                        $('#modalDelShareList').html(resultat);
                    })
                $('#delFileName').text(fileName);
                $('#delPath').text(path);
                $('#modalDelFile').modal('show');
            }
        })

        $("#btnMkdir").click(function() {
            var activeDir = $("#activeDir").text();
            $("#father").text(activeDir);
            $("#repName").val('');
            $("#modalNewDir").modal('show');
        })

        $("#btnUpload").click(function() {
            var activeDir = $("#activeDir").text();
            $("#uploadDir").text(activeDir);
            $("#modalUpload").modal('show');
        })

        $("#treeView").on('click', '.delDir', function() {
            var activeDir = $(this).next('.dirLink').data('dir');
            $('#treeView *').removeClass('activeDir');
            $(this).next('.dirLink').addClass('activeDir');
            $("#activeDir").text(activeDir);
            $("#attention").addClass('hidden');

            // le nom du répertoire à supprimer, à la fin de la chaîne 'activeDir' sans le '/' final
            var delDir = activeDir.substring(activeDir.substring(0, activeDir.length - 1).lastIndexOf('/') + 1, activeDir.length - 1);
            // le sous-repertoire correspondant: le début de la chaîne activeDir'
            var rootDir = activeDir.substring(0, activeDir.lastIndexOf(delDir));

            $("#delRep").text(delDir);
            $("#rootRep").text(rootDir);
            $.post('inc/files/listFiles.inc.php', {
                    activeDir: activeDir
                },
                function(resultat) {
                    if (resultat != '')
                        $("#attention").removeClass('hidden');
                    $("#listFiles").html(resultat);
                })
            $("#modalDelDir").modal('show');
        })


        $('.shareFile').click(function() {
            var fileName = $('.activeFile').data('filename');
            var path = $('.activeFile').data('path');
            $('#inputFileName').val(fileName).removeClass('hidden');
            $('#inputPath').val(path);
            $('#shareDirName').text(path);
            $('#shareFileName').text(fileName).removeClass('hidden').closest('p').removeClass('hidden');
            $('#modalShare').modal('show');
        })

        $('.shareDir').click(function(){
            var activeDir = $('#activeDir').text();
            $('#inputPath').val(activeDir);
            $("#inputFileName").val('');
            $('#shareFileName').text('').addClass('hidden').closest('p').addClass('hidden');
            $('#shareDirName').text(activeDir);
            $('#modalShare').modal('show');
        })

        $('#partages').on('click', '.unShare', function(event) {
            var shareId = $(this).data('shareid');
            // effacement sans confirmation
            if (event.ctrlKey) {
                $.post('inc/files/unShareFile.inc.php', {
                    shareId: shareId
                }, function(resultat) {
                    $(".unShare[data-shareid='" + shareId + "']").closest('.shared').remove();
                })
            } else {
                var shareWith = $(this).data('libelle');
                var fileName = $("#fiFileName").text();
                $("#modalUnShareFileName").html(fileName);
                $("#modalUnShareWith").html(shareWith);
                $("#btnUnShareFile").data('shareid', shareId);
                $("#modalUnShareFile").modal('show');
            }
        })

        $("#partages").on('click', '.shareEdit', function() {
            var commentaire = $(this).data('commentaire');
            var shareId = $(this).data('shareid');
            var shareWith = $(this).next('span').data('libelle');
            var fileName = $('.activeFile').data('filename');
            var path = $('.activeFile').data('path');
            $("#shareEditId").val(shareId);
            $("#shareEditPath").text(path);
            $("#shareEditFileName").text(fileName);
            $("#shareEditCommentaire").val(commentaire);
            $("#shareEditSharedWith").text(shareWith);
            $("#modalShareEdit").modal('show');
        })

        $("#btnMemoShared").click(function(){
            $("#shareInput").addClass('hidden');
            $.post('inc/files/userShared.inc.php',{ },
            function(resultat){
                $("#memoShared").html(resultat);
                $("#modalMemo").modal('show');
            })
        })

        // focus sur le premier champ des boîtes modales à l'ouverture
        $('.modal').on('shown.bs.modal', function() {
            $(this).find('input:visible:first').focus();
        });

    })
</script>
