<link href='../dropzone/dropzone.css' type='text/css' rel='stylesheet'>
<script src='../dropzone/dropzone.js' type='text/javascript'></script>

<div class="container-fluid">

    <div class="row">

        <div class="col-md-6 col-xs-12">

            <div class="panel panel-success">
                <div class="panel-heading">
                    Téléversement des fichiers issus de EDT
                </div>

                <div class="panel-body">
                    <p>Le système accepte les fichiers .ics issus de EDT et les fichiers .zip contenant des fichiers .ics</p>
                    <p>Les fichiers .zip sont automatiquement dézippés en .ics prêts pour la compilation.</p>

                    <div class="dropzone" id="myDropZone"></div>
                </div>
                <div class="panel-footer">
                    <p>Nombre de fichiers .ics (EDT) présents: <strong id="numFiles">{$numFiles}</strong></p>
                </div>
            </div>

            <button type="button" class="btn btn-danger btn-block" id="btn-clearICal">Effacer les fichiers précédents</button>

        </div>

        <div class="col-md-6 col-xs-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    Information sur les fichiers issus de EDT
                </div>
                <div class="panel-body">
                    <p>Téléverser dans le cadre à gauche les fichiers .ics issus de l'exportation depuis EDT.</p>
                    <p>Cliquer/glisser un nombre indéfini de fichiers .ics OU .zip (contenant les fichiers .ics).</p>
                    <p>Il reste ensuite à "compiler" les fichiers .ics pour transférer leur contenu codé au format iCal vers la base de données de la plateforme.</p>
                    <p>Les fichiers .ics homonymes à ceux qui sont téléversés remplacent les fichiers déjà existants. Des mises à jour sont donc possibles.</p>
                </div>

            </div>



        </div>

    </div>

</div>

<script type="text/javascript">

    var maxFileSize = 1;  // 1 Mo
    var n = 0;
    var erreur = 0;

    $(document).ready(function(){

        Dropzone.options.myDropZone = {
            maxFilesize: maxFileSize,
            acceptedFiles: ".zip,.ics",
            url: "inc/upload.inc.php",
            queuecomplete: function() {
                var message = "Le transfert de " + n + " fichiers a réussi <br>";
                if (erreur > 0){
                    message += erreur + " erreur(s) est/sont déplorée(s)"
                }
                $.post('inc/getNumIcs.inc.php', {
                    }, function(resultat){
                        $('#numFiles').html(resultat);
                    })
                bootbox.alert({
                    title: "Transert de fichier",
                    message: message
                })
            },
            accept: function(file, done) {
                done();
            },
            init: function() {
                // this.on("maxfilesexceeded", function(file) {
                //         alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
                //     }),
                this.on('success', function(file, response){
                    n++;
                }),
                this.on('queuecomplete', function() {
                    var dz = this;
                    setTimeout(function() {
                        dz.removeAllFiles();
                        erreur = 0;
                        n = 0;
                    }, 1000);
                }),
                this.on('error', function(res1, res2){
                    erreur++;
                })
            }
        };

        $('#btn-clearICal').click(function(){
            var title = 'Effacement des modèles d\'emplois du temps';
            bootbox.confirm({
                title: title,
                message: 'Veuillez confirmer l\'effacement des fichiers .ics importés de EDT',
                callback: function(result){
                    if (result == true)
                        $.post('inc/clearIcal.inc.php', {
                        }, function(resultat){
                            $.post('inc/getNumIcs.inc.php', {},
                                function(resultat){
                                    $('#numFiles').text(resultat);
                                })
                            bootbox.alert({
                                title: title,
                                message: resultat + ' fichiers .ics supprimés'
                            })
                        })
                    }
                })
            })

    })

</script>
