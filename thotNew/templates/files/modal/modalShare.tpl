<div class="modal fade" id="modalShare" tabindex="-1" role="dialog" aria-labelledby="titleModalShare" aria-hidden="true">

    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="titleModalShare">Partager un document</h4>
            </div>
            <div class="modal-body">

                <form id="formShare" action="index.php" method="POST" class="form-vertical" role="form">
                    
                    <p>Dossier: <i class="fa fa-folder-open-o"></i> <strong id="shareDirName"></strong> Fichier:&nbsp;<i class="fa fa-file-o"></i>&nbsp;<strong id="shareFileName"></strong></p>

                    <p id="forDirOnly" class="help-text"><i class="fa fa-info-circle"></i> Tous les fichiers actuels et futurs des <strong>dossiers partagés</strong> sont automatiquement accessibles aux destinataires</p>

                    <div class="form-group">
                        <label for="Commentaire">Veuillez commenter ce partage</label>
                        <input type="text" class="form-control" id="commentaire" name="commentaire" placeholder="Commentaire pour ce document">
                    </div>
                    <div class="alert alert-danger hidden" id="commentairesvp">
                        <p>Veuillez commenter votre partage</p>
                    </div>

                    <div class="form-group">

                        <fieldset id="type" style="border: 1px solid #aaa; padding: 5px; margin: 0 0 10px">
                            <label for="type">Partager avec</label>

                            <label class="radio-inline typePartage" title="Partage avec des collègues" data-container="body">
                                <input type="radio" name="type" id="prof" value="prof"> Profs</label>

                            <label class="radio-inline typePartage" title="Partage avec une classe ou des élèves d'une classe" data-container="body">
                                <input type="radio" name="type" id="classes" value="classes"> Classe</label>

                            <label class="radio-inline typePartage" title="Partage avec un cours ou des élèves d'un cours" data-container="body">
                                <input type="radio" name="type" id="cours" value="coursGrp"> Cours</label>

                                <label class="radio-inline typePartage" title="Partage avec les élèves pour une matière" data-container="body">
                                    <input type="radio" name="type" id="matiere" value="cours"> Matière</label>

                            <label class="radio-inline typePartage" title="Partage avec un niveau d'étude" data-container="body">
                                <input type="radio" name="type" id="niveau" value="niveau"> Niveau</label>

                            <label class="radio-inline typePartage" title="Partage avec un groupe arbitraire" data-container="body" for="groupe">
                                <input type="radio" name="type" id="groupe" value="groupe"> Groupe</label>

                            <label class="radio-inline typePartage" title="Partage avec tous les élèves de l'école" data-container="body">
                                <input type="radio" name="type" id="ecole" value="ecole"> École</label>

                        </fieldset>
                    </div>

                    <div id="selection" style="height:25em; overflow:auto">

                        <!-- la sélection des destinataires ici -->

                    </div>

                    <div class="alert alert-danger hidden" id="partagesvp">
                        <p>Veuillez préciser avec qui vous souhaitez partager</p>
                    </div>

                    <input type="hidden" name="fileName" id="inputFileName" value="">
                    <input type="hidden" name="path" id="inputPath" value="">
                    <input type="hidden" name="type" id="inputType" value="">
                    <input type="hidden" name="dirOrFile" id="dirOrFile" value="">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="button" class="btn btn-primary" id="partager">Partager</button>
                    </div>
                    <div class="clearfix"></div>

                </form>

            </div>

            <div class="modal-footer">
                <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
            </div>
        </div>

    </div>

</div>

<script type="text/javascript">
    var memType = '';

    $(document).ready(function() {

        $("#partager").click(function() {
            var erreur = false;
            // des partages ont-ils été définis?
            if ($("#inputType").val() == '') {
                erreur = true;
                $("#partagesvp").removeClass('hidden');
            }
            // un commentaire a-t-il été fourni?
            if ($("#commentaire").val() == '') {
                erreur = true;
                $("#commentairesvp").removeClass('hidden');
                $("#commentaire").focus();
            }
            // donc, tout va bien: on poursuit
            if (erreur == false) {
                var post = $("#formShare").serialize();
                $.post('inc/files/share.inc.php', {
                        post: post
                    },
                    function(resultat) {
                        $("#modalShare").modal('hide');
                        var fileName = $("#inputFileName").val();
                        var arborescence = $("#inputPath").val();
                        var type = $('#dirOrFile').val();

                        $.post('inc/files/getSharesForFile.inc.php', {
                            fileName: fileName,
                            arborescence: arborescence,
                            type: type
                        },
                        function(resultat){
                            $("#partages").html(resultat);
                        })

                    })
            }
        })

        $(".typePartage").click(function() {
            $("#partagesvp").addClass('hidden');
        })
        $("#commentaire").keydown(function() {
            $("#commentairesvp").addClass('hidden');
        })

        $("#selection").on('change', '#checkListe', function() {
            var checked = $(this).prop('checked');
            $(".cb").prop('checked', checked);
        })

        $("#selection").on('change', '.cb', function() {
            $("#checkListe").prop('checked', false);
        })

        $("#selection").on('change', '.classe', function() {
            var classe = $(this).val();
            $.post('inc/files/listeEleves.inc.php', {
                    classe: classe
                },
                function(resultat) {
                    $("#listeEleves").html(resultat);
                })
        })

        $("#selection").on('change', '.coursGrp', function() {
            var coursGrp = $(this).val();
            $.post('inc/files/listeEleves.inc.php', {
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#listeEleves").html(resultat);
                })
        })

        $('#selection').on('change', '.niveauMatiere', function(){
            var niveau = $(this).val();
            $.post('inc/files/listeMatieres.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#listeMatieres').html(resultat);
            })
        })

        $('#selection').on('change', '.groupe', function(){
            var groupe = $(this).val();
            $.post('inc/files/listeEleves.inc.php', {
                    groupe: groupe
                },
                function(resultat) {
                    $("#listeEleves").html(resultat);
                })
        })

        $("#type input:radio").change(function() {
            var type = $(this).val();
            // montrer la zone qui convient et cacher les autres
            if (memType != type) {
                $("#selection").html('');
                $("#inputType").val(type);
                memType = type;
            }
            switch (type) {
                case 'prof':
                    $.post('inc/files/selectProfs.inc.php', {},
                        function(resultat) {
                            $("#selection").html(resultat);
                        })
                    break;

                case 'classes':
                    $.post('inc/files/selectClasses.inc.php', {},
                        function(resultat) {
                            $("#selection").html(resultat);
                        })
                    break;

                case 'coursGrp':
                    $.post('inc/files/selectCours.inc.php', {},
                        function(resultat) {
                            $("#selection").html(resultat);
                        })
                    break;

                case 'cours':
                    $.post('inc/files/selectNiveauxMatiere.inc.php', {},
                        function(resultat){
                            $('#selection').html(resultat);
                        })
                    break;

                case 'niveau':
                    $.post('inc/files/selectNiveaux.inc.php', {},
                        function(resultat) {
                            $("#selection").html(resultat);
                        })
                    break;

                case 'groupe':
                    $.post('inc/files/selectGroupe.inc.php', {},
                        function(resultat){
                            $("#selection").html(resultat);
                        });
                    break;

                case 'ecole':
                    $.post('inc/files/ecole.inc.php', {},
                        function(resultat) {
                            $("#selection").html(resultat);
                        })
                    break;
                case 'groupe':

            }
        })

    })
</script>
