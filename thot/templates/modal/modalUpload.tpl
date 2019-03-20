<div class="modal fade" id="modalUpload" tabindex="-1" role="dialog" aria-labelledby="uploadTitle" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="uploadTitle">Téléverser des fichiers</h4>
            </div>
            <div class="modal-body">
                <h3><i class="fa fa-folder-open-o text-warning fa-2x"></i>
                    <span id='uploadDir'></span>
                </h3>

                <div id="myDropZone" class="dropzone"></div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

        var nbFichiersMax = 5;
        var maxFileSize = 25;

        Dropzone.options.myDropZone = {
            maxFilesize: maxFileSize,
            maxFiles: nbFichiersMax,
            acceptedFiles: "image/jpeg,image/png,image/gif,application/pdf,.psd,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.odg,.csv,.txt,.pdf,.zip,.7z,.ggb,.mm,.xcf,.xmind,.mp3",
            url: "inc/files/upload.inc.php",
            queuecomplete: function() {
                // raffraichissement de la liste des fichiers
                //


                // raffraîchissement du treeview
                // var activeDir = $("#activeDir").text();
                // $.post('inc/files/getTreeView.inc.php', {}, function(resultat) {
                //     $("#treeView").html(resultat);
                //     var listeDir = $("#activeDir").text();
                //     // ouvrir chacune des branches de l'arborescence
                //     while (listeDir != '/') {
                //         $(".dirLink[data-dir='" + listeDir + "']").trigger('click');
                //         listeDir = listeDir.substr(0, listeDir.substr(0, listeDir.length-1).lastIndexOf('/')+1);
                //     }
                //
                //     // la branche active est celle de 'activeDir'
                //     var dernierDirClique = activeDir.substr(0, activeDir.substr(1).indexOf('/')+2);
                //     $(".dirLink[data-dir='" + dernierDirClique + "']").removeClass('activeDir');
                //     $(".dirLink[data-dir='" + activeDir + "']").addClass('activeDir');
                //     $("#activeDir").text(activeDir);
                //
                //     // remise en ordre des infos de la zone fileInfo
                //     $("#diDir").text(activeDir);
                //     var nbFiles = $(".dirLink[data-dir='" + activeDir + "']").data('nbfiles');
                //     $("#diNb").text(nbFiles);
                //     $("#dirInfo").fadeIn();
                // });

            },
            accept: function(file, done) {
                done();
            },
            init: function() {
                this.on("maxfilesexceeded", function(file) {
                        alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
                    }),
                    this.on("sending", function(file, xhr, formData) {
                        formData.append("activeDir", $("#activeDir").text());
                    }),
                    this.on('queuecomplete', function() {
                        var ds = this;
                        setTimeout(function() {
                            ds.removeAllFiles();
                        }, 3000);
                    })
            }
        };


</script>
