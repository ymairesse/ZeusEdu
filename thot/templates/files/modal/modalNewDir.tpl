<!-- boîte modale pour la création d'un nouveau dossier -->
<div class="modal fade" id="modalNewDir" tabindex="-1" role="dialog" aria-labelledby="titleNewDir" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleNewDir">Création d'un nouveau dossier</h4>
            </div>
            <div class="modal-body">

                <p>Création d'un nouveau dossier dans le dossier
                    <br><strong id="father" data-father="">{$arborescence}</strong></p>
                <form role="form">
                    <div class="form-group">
                        <label for="repName">Nom du nouveau dossier</label>
                        <input type="text" class="form-control" id="repName" placeholder="Nom de ce dossier">
                        <p class="help-block">Utilisez uniquement des lettres, des chiffres et les symboles _ & -. 1 caractère "espace" toléré</p>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="createDir">Créer le dossier</button>
                </div>

            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    // var reg = new RegExp(
    //     "^((?:\\w|[\\-_ ](?![\\-_ ])|[\\u00C0\\u00C1\\u00C2\\u00C3\\u00C4\\u00C5\\u00C6\\u00C7\\u00C8\\u00C9\\u00CA\\u00CB\\u00CC\\u00CD\\u00CE\\u00CF\\u00D0\\u00D1\\u00D2\\u00D3\\u00D4\\u00D5\\u00D6\\u00D8\\u00D9\\u00DA\\u00DB\\u00DC\\u00DD\\u00DF\\u00E0\\u00E1\\u00E2\\u00E3\\u00E4\\u00E5\\u00E6\\u00E7\\u00E8\\u00E9\\u00EA\\u00EB\\u00EC\\u00ED\\u00EE\\u00EF\\u00F0\\u00F1\\u00F2\\u00F3\\u00F4\\u00F5\\u00F6\\u00F9\\u00FA\\u00FB\\u00FC\\u00FD\\u00FF\\u0153])+)$",
    //     "i");

    $(document).ready(function() {

        $('#repName').keydown(function(event) {
            if (event.which == 13) {
                event.preventDefault();
                $("#createDir").trigger('click');
            }
        })

        // $("#createDir").click(function() {
        //     var arborescence = $("#father").data('father');
        //     var directory = $("#repName").val().trim();
        //
        //     if (!(reg.test(directory)))
        //         alert("Ce nom n'est pas admissible")
        //     else {
        //         $.post('inc/files/mkdir.inc.php', {
        //                 directory: directory,
        //                 arborescence: arborescence
        //             },
        //             function(resultat) {
        //                 // la fonction revient avec un message d'erreur ou "true" si tout s'est bien passé
        //                 if (resultat != true) {
        //                     bootbox.alert({
        //                         title: 'Problème lors de la création du dossier',
        //                         message: resultat
        //                     });
        //                 }
        //                 else
        //                 {
        //                     $.post('inc/files/refreshFileList.inc.php', {
        //                         arborescence: arborescence,
        //                         directory: undefined
        //                     }, function(resultat){
        //                         $("#listeFichiers").html(resultat);
        //                     })
        //                 }
        //             });
        //         }
        //     $("#modalNewDir").modal('hide');
        // })

        $("#repName").keypress(function(event) {
            var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;;
            if (key == 8 || key == 9 || key == 13 || key == 35 || key == 36 || key == 37 || key == 39 || key == 46) {
                if (event.charCode == 0 && event.keyCode == key) {
                    return true;
                }
            }
            var char = String.fromCharCode(key);
            if (!(reg.test(char))) {
                return false;
            }
        })
    })
</script>
