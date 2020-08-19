<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12 col-md-7">

            <div id="breadcrumbs" class="clearfix">
                {include file='files/breadcrumbs.tpl'}
            </div>

            <div class="dropzone hidden clearfix" id="myDropZone"></div>

            <div class="clearfix" id="listeFichiers" data-viewmode="{$viewMode}">

                {include file="files/listeFichiers.tpl"}

            </div>

        </div>

        <div class="col-xs-12 col-md-5" id="partages">
            {include file="files/listePartages.tpl"}
        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

var nbFichiersMax = 5;
var maxFileSize = 20;

Dropzone.options.myDropZone = {
    maxFilesize: maxFileSize,
    maxFiles: nbFichiersMax,
    acceptedFiles: "image/jpeg,image/png,image/gif,image/svg+xml,application/pdf,.psd,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.odg,.csv,.txt,.pdf,.zip,.7z,.ggb,.mm,.xcf,.xmind,.rtf,.mp3",
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

    // expression régulière pour le test d'un nom de fichier
    var reg = new RegExp(
        "^((?:\\w|[\\-_ ](?![\\-_ ])|[\\u00C0\\u00C1\\u00C2\\u00C3\\u00C4\\u00C5\\u00C6\\u00C7\\u00C8\\u00C9\\u00CA\\u00CB\\u00CC\\u00CD\\u00CE\\u00CF\\u00D0\\u00D1\\u00D2\\u00D3\\u00D4\\u00D5\\u00D6\\u00D8\\u00D9\\u00DA\\u00DB\\u00DC\\u00DD\\u00DF\\u00E0\\u00E1\\u00E2\\u00E3\\u00E4\\u00E5\\u00E6\\u00E7\\u00E8\\u00E9\\u00EA\\u00EB\\u00EC\\u00ED\\u00EE\\u00EF\\u00F0\\u00F1\\u00F2\\u00F3\\u00F4\\u00F5\\u00F6\\u00F9\\u00FA\\u00FB\\u00FC\\u00FD\\u00FF\\u0153])+)$",
        "i");

    $(document).ready(function(){

        $('#modalShare, #modalShareEdit').on('shown.bs.modal', function () {
           $('#commentaire').focus();
        });
        $('#modalNewDir').on('shown.bs.modal', function () {
           $('#repName').focus();
        });


        // ********************************************************************
        // Gestion des breadcrumbs
        // ********************************************************************
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
                    $.post('inc/files/refreshFileList.inc.php', {
                        arborescence: arborescence,
                        directory: ''
                    }, function(resultat){
                        // liste des fichiers disponibles dans ce répertoire
                        $("#listeFichiers").empty().html(resultat);
                        // $("#listeFichiers").empty();
                        var arborescence = crumb.data('dir');
                        $.post('inc/files/getSharesForDir.inc.php', {
                            arborescence: arborescence,
                        },
                        function(resultat){
                            $("#partages").html(resultat);
                            if (arborescence != '/')
                                $('#btn-share').removeClass('disabled');
                                else $('#btn-share').addClass('disabled');
                        })

                    })
                });
            })

        $('#listeFichiers').on('click', '#btn-mkdir', function(){
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            $.post('inc/files/createNewDir.inc.php', {
                arborescence: arborescence
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalNewDir').modal('show');
            })
        })

        $('#modal').on('click', "#createDir", function() {
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            var directory = $("#repName").val().trim();

            if (!(reg.test(directory)))
                alert("Ce nom n'est pas admissible")
            else {
                $.post('inc/files/mkdir.inc.php', {
                        directory: directory,
                        arborescence: arborescence
                    },
                    function(resultat) {
                        // la fonction revient avec un message d'erreur ou "true" si tout s'est bien passé
                        if (resultat != true) {
                            bootbox.alert({
                                title: 'Problème lors de la création du dossier',
                                message: resultat
                            });
                        }
                        else {
                            $.post('inc/files/refreshFileList.inc.php', {
                                arborescence: arborescence,
                                directory: undefined
                            }, function(resultat){
                                $("#listeFichiers").html(resultat);
                            })
                        }
                    });
                }
            $("#modalNewDir").modal('hide');
        })

        $('#listeFichiers').on('click', '#btn-upload', function(){
            $('#myDropZone').toggleClass('hidden');
        })


        // *****************************************************************
        // gestion de la vue
        // *****************************************************************
        $('#listeFichiers').on('click', '#btn-grilleOrListe span', function(){
            if ($(this).hasClass('grille')) {
                $(this).removeClass('grille').addClass('liste');
                var viewMode = 'liste';
            } else {
                $(this).removeClass('liste').addClass('grille');
                var viewMode = 'grille';
            }
            Cookies.set('viewMode', viewMode);
            $('#listeFichiers').data('viewmode', viewMode);
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            $.post('inc/files/refreshFileList.inc.php', {
                arborescence: arborescence
            }, function(resultat){
                $("#listeFichiers").empty().html(resultat);
            })
        })

        // ********************************************************************
        // marquer le fichier "actif" et
        // voir les partages d'un fichier ordinaire ou d'un répertoire
        // en vue "grille"
        // *****************************************************************
        $('#listeFichiers').on('click', '.conteneur', function(){
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
                $('#btn-share').removeClass('disabled');
            })
        })

        // ouvrir un répertoire par un clic sur le nom du répertoire en vue "grille"
        $('#listeFichiers').on('click', '.fileName[data-dirorfile="dir"]', function(){
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

        // ********************************************************************
        // gestion des fichiers en liste (tableau)
        // entrer dans un répertoire d'un tableau liste de fichiers
        // ********************************************************************
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

        // ********************************************************************
        // marquer le fichier "actif" et
        // voir les partages d'un fichier ordinaire ou d'un répertoire
        // en mode "liste"
        $('#listeFichiers').on('click', 'table tr', function(){
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
                $('#btn-share').removeClass('disabled');
            })
        })


        // *******************************************************************
        // Effacement des fichiers et des répertoires

        $('#listeFichiers').on('click', '#btn-del', function(){
            var arborescence = ($('#arborescence').val()=='') ? '/' : $('#arborescence').val();
            if (($('#listeFichiers').data('viewmode')) == 'grille') {
                var dirOrFile = $('.conteneur.active').data('dirorfile');
                var fileName = $('.conteneur.active').data('filename');
            } else {
                var dirOrFile = $('#fichiersListe tr.active').data('dirorfile');
                var fileName = $('#fichiersListe tr.active').data('filename');
            }

            if (dirOrFile == 'file') {
                $.post('inc/files/getModalDelFile.inc.php', {
                    arborescence: arborescence,
                    fileName: fileName
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalDelFile').modal('show');
                    })
                }
                else {
                    $.post('inc/files/getModalDelDir.inc.php', {
                        arborescence: arborescence,
                        fileName: fileName
                    }, function(resultat){
                        $('#modal').html(resultat);
                        $("#modalDelDir").modal('show');
                    })
                }
            })

        // gestion des boîtes modales
        $('#modal').on('click', '#confirmDelFile', function() {
            var viewMode = ($('#listeFichiers').data('viewmode'));
            if (viewMode == 'grille')
                var fileName = $('#listeFichiers .conteneur.active').data('filename');
                else var fileName = $('#listeFichiers tr.active').data('filename');
            var arborescence = $('#arborescence').val();
            $.post('inc/files/delFile.inc.php', {
                    fileName: fileName,
                    arborescence: arborescence
                },
                function(resultat) {
                    if (resultat == 1) {
                        // combien d'éléments dans l'affichage des fichiers?
                        var nbFiles = (viewMode == 'grille') ? $('.conteneur').length : $('#listeFichiers tr').length;
                        // Si plus de 1, on efface l'élément actif
                        if (nbFiles > 1) {
                            if (viewMode == 'grille')
                                $('#listeFichiers .conteneur.active').remove();
                                else $('#listeFichiers tr.active').remove();
                        }

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


        // ********************************************************************
        // gestion des partages
        $('#partages').on('click', '#btn-share', function() {
           // dir ou file?
           var dirOrFile = $(this).data('dirorfile');
           var arborescence = $(this).data('arborescence');
           var fileName = $(this).data('filename');
           if ((arborescence == '') && (dirOrFile == 'dir')){
               bootbox.alert({
                   title: 'Avertissement',
                   message: 'Le partage de la racine de votre répertoire n\'est pas autorisé.<br>Veuillez choisir un sous-répertoire.'
               })
               }
               else {
                   $.post('inc/files/getModalShare.inc.php', {
                       fileName: fileName,
                       path: arborescence,
                       dirOrFile: dirOrFile
                   }, function(resultat){
                       $('#modal').html(resultat);
                       $('#modalShare').modal('show');
                   })
               }
       })

       $('#partages').on('click', '.unShare', function(event) {
           var shareId = $(this).data('shareid');
           $.post('inc/files/getModal2unShare.inc.php', {
               shareId: shareId
               },
               function(resultat){
                   $('#modal').html(resultat);
                   $('#modalUnShareFile').modal('show');
               })
           })

       $('#modal').on('click', "#btnUnShareFile", function() {
           var shareId = $(this).data('shareid');
           $.post('inc/files/unShareFile.inc.php', {
               shareId: shareId
           }, function(resultat) {
               $(".unShare[data-shareid='" + shareId + "']").closest('tr').remove();
           })
           $("#modalUnShareFile").modal('hide');
       })


        $('#partages').on('click', '.shareEdit', function(){
            var shareId = $(this).data('shareid');
            $.post('inc/files/modalEditShare.inc.php', {
                shareId: shareId
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalShareEdit').modal('show');
            })
        })

        $('#modal').on('click', '#saveComment', function() {
            var shareId = $("#shareEditId").val();
            var commentaire = $('#shareEditCommentaire').val();
            $.post('inc/files/saveCommentaire.inc.php', {
                    shareId: shareId,
                    commentaire: commentaire
                },
                function(commentaire) {
                    $('span[data-shareid="' + shareId + '"]').text(commentaire);
                    $('#modalShareEdit').modal('hide');
                })
        })

    })

</script>
