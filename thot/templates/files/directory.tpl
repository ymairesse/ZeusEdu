<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">
<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12 col-md-9">

            <div id="breadcrumbs" class="clearfix">
                {include file='files/breadcrumbs.tpl'}
            </div>

            <div class="dropzone hidden clearfix" id="myDropZone">
            </div>

            <div id="listeFichiers" class="clearfix">
                {include file="files/listeFichiers.tpl"}
            </div>

        </div>

        <div class="col-xs-12 col-md-3" id="partages">
            {include file="files/listePartages.tpl"}
        </div>

    </div>

</div>

{include file='files/modal/modalNewDir.tpl'}
{include file="files/modal/modalShare.tpl"}
{include file="files/modal/modalEditShare.tpl"}
{include file="files/modal/modalUnshareFile.tpl"}
{include file="files/modal/modalDelFile.tpl"}
{include file="files/modal/modalDelDir.tpl"}


<script type="text/javascript">

var nbFichiersMax = 5;
var maxFileSize = 25;

Dropzone.options.myDropZone = {
    maxFilesize: maxFileSize,
    maxFiles: nbFichiersMax,
    acceptedFiles: "image/jpeg,image/png,image/gif,application/pdf,.psd,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.odg,.csv,.txt,.pdf,.zip,.7z,.ggb,.mm,.xcf,.xmind,.rtf,.mp3",
    url: "inc/files/upload.inc.php",
    queuecomplete: function() {
        // raffraichissement de la liste des fichiers
        var arborescence = $('#arborescence').val();
        var directory = $(this).data('dir');
        $.post('inc/files/refreshFileList.inc.php', {
            arborescence: arborescence,
            directory: directory
        }, function(resultat){
            $("#listeFichiers").html(resultat);
        })

    },
    accept: function(file, done) {
        done();
    },
    init: function() {
        this.on("maxfilesexceeded", function(file) {
                alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
            }),
            this.on("sending", function(file, xhr, formData) {
                formData.append("arborescence", $("#arborescence").val());
            }),
            this.on('queuecomplete', function() {
                var dz = this;
                setTimeout(function() {
                    dz.removeAllFiles();
                }, 3000);
            })
    }
};

    $(document).ready(function(){

        $('#breadcrumbs').on('click', '#btn-mkdir', function(){
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            $('#father').data('father', arborescence).text(arborescence);
            $('#modalNewDir').modal('show');
        })

        $('#breadcrumbs').on('click', '#btn-upload', function() {
            $('#myDropZone').toggleClass('hidden').slideDown('slow');
        })

        function delFile (event, arborescence, fileName){
            if (event.ctrlKey) {
                $.post('inc/files/delFile.inc.php', {
                        fileName: fileName,
                        arborescence: arborescence
                    },
                    function(resultat) {
                        if (resultat == 1) {
                            $.post('inc/files/refreshFileList.inc.php', {
                                arborescence: arborescence,
                                directory: undefined
                            }, function(resultat){
                                $("#listeFichiers").html(resultat);
                            });
                            $('#listePartages').html('');
                        }
                        else alert('Impossible de supprimer ce fichier');
                    });
            }
            else {
            $.post('inc/files/shareList.inc.php', {
                    fileName: fileName,
                    arborescence: arborescence,
                    simple: true
                },
                function(resultat) {
                    $('#modalDelShareList').html(resultat);
                })
            $('#delFileName').text(fileName);
            $('#delPath').text(arborescence);
            $('#modalDelFile').modal('show');
            }
        }

        function delDir(event, arborescence, fileName) {
            $("#delRep").data('filename', fileName).text(fileName);
            $("#rootRep").data('arborescence', arborescence).text(arborescence);
            $.post('inc/files/listFiles.inc.php', {
                    arborescence: arborescence,
                    fileName: fileName
                },
                function(resultat) {
                    $("#listFiles").html(resultat);
                })
            $("#modalDelDir").modal('show');
        }

        $('#listeFichiers').on('click', '.delete', function(event){
            var fileName= $(this).data('filename');
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            var type = $(this).data('type');
            if (type == 'file') {
                delFile(event, arborescence, fileName);
                }
                else {
                    delDir(event, arborescence, fileName);
                }
        })

        $('#partages').on('click', '.unShare', function(event) {
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

        $("#partages").on('click', '.shareEdit', function() {
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

        $("#saveComment").click(function() {
            var shareId = $("#shareEditId").val();
            var commentaire = $("#shareEditCommentaire").val();
            $.post('inc/files/saveCommentaire.inc.php', {
                    shareId: shareId,
                    commentaire: commentaire
                },
                function(resultat) {
                    var resultatJS = JSON.parse(resultat);
                    var htmlText = resultatJS.libelle + '<br><span class="help-block pull-right">' + resultatJS.commentaire + '</span>';
                    $('#listePartages tr[data-shareid="' + shareId + '"] td.cible').html(htmlText);
                    $("#modalShareEdit").modal('hide');
                })
        })

        $('#listeFichiers').on('click', 'table tr', function() {
            $("#listeFichiers tr").removeClass('active');
            $(this).addClass('active');
            var fileName= $(this).data('filename');
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            var type = $(this).data('type');
            $.post('inc/files/getSharesForFile.inc.php', {
                fileName: fileName,
                arborescence: arborescence,
                type: type
            },
            function(resultat){
                $("#partages").html(resultat);
            })
        })

        $('#partages').on('click', '#btn-share', function() {
            // dir ou file?
            var type = $(this).data('type');
            var arborescence = $(this).data('arborescence');
            var fileName = $(this).data('filename');
            if (arborescence == ''){
                bootbox.alert({
                    title: 'Avertissement',
                    message: 'Le partage de la racine de votre répertoire n\'est pas autorisé.<br>Veuillez choisir un sous-répertoire.'
                })
                }
                else {
                    $('#inputFileName').val(fileName).removeClass('hidden');
                    $('#inputPath').val(arborescence);
                    $('#shareDirName').text(arborescence);
                    $('#shareFileName').text(fileName).removeClass('hidden').closest('p').removeClass('hidden');
                    $('#dirOrFile').val(type);
                    if (type == 'file')
                        $('#forDirOnly').addClass('hidden');
                        else $('#forDirOnly').removeClass('hidden');
                    $('#modalShare').modal('show');
                }
        })

        $('#modalShare, #modalShareEdit').on('shown.bs.modal', function () {
           $('#commentaire').focus();
        });
        $('#modalNewDir').on('shown.bs.modal', function () {
           $('#repName').focus();
        });

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

        $("#breadcrumbs").on('click', '.btn-crumb', function(){
            var arborescence = $(this).data('dir');
            var crumb = $(this);
            $('#arborescence').val(arborescence);
             $.post('inc/files/refreshBreadcrumbs.inc.php', {
                arborescence: arborescence,
                directory: undefined
                },
                function(resultat){
                    $('#breadcrumbs').html(resultat);
                });

            $.post('inc/files/refreshFileList.inc.php', {
                arborescence: arborescence,
                directory: ''
            }, function(resultat){
                $("#listeFichiers").html(resultat);
                var arborescence = crumb.data('dir');
                $.post('inc/files/getSharesForDir.inc.php', {
                    arborescence: arborescence,
                },
                function(resultat){
                    $("#partages").html(resultat);
                })
            })

        })

    })

</script>
