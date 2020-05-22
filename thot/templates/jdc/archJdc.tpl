<div class="container-fluid">

    <h2>Archives du journal de classe</h2>

<div class="row">

    <div class="col-md-3 col-sm-6 col-xs-12">

        <div id="ajaxLoader" class="hidden">
            <img src="images/ajax-loader.gif" alt="loading" class="center-block">
        </div>

        <div class="panel panel-danger">
            <div class="panel-heading">
                Archivage de l'année en cours
            </div>
            <div class="panel-body">
                <button type="button" class="btn btn-primary btn-block" id="btn-archive">
                    Archiver l'année {$ANNEESCOLAIRE}
                </button>
                <p class="discret">L'archivage n'efface aucune information. L'initialisation du JDC efface toutes les mentions existantes.</p>
                <button type="button" class="btn btn-danger btn-block" id="btn-resetJDC">
                    Initialiser le JDC
                </button>
                <p class="discret">L'initialisation supprime toutes les informations du JDC pour l'année scolaire courante</p>
            </div>

        </div>

        <div class="panel panel-info">
            <div class="panel-heading">
                Archives existantes
            </div>
            <div class="panel-body" id="listeArchives">

                {include file="jdc/inc/listeArchives.tpl"}

            </div>
            <div class="panel-footer">
                En cours {$ANNEESCOLAIRE}
            </div>
        </div>

    </div>

    <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="panel panel-success">
            <div class="panel-heading">
                Impression des archives
            </div>
            <div class="panel-body">
                <form id="printJdc">

                    <div class="form-group">
                        <label for="anScol">Année scolaire</label>
                        <select class="form-control" name="anScol" id="anScol">
                            <option value="">Année scolaire</option>
                            {foreach from=$listeArchives key=wtf item=anScol}
                            <option value="{$anScol}">{$anScol}</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="input-group input-daterange hidden">
                        <input type="text" class="form-control" value="" id="debut" name="debut">
                        <div class="input-group-addon">au</div>
                        <input type="text" class="form-control" value="" id="fin" name="fin">
                    </div>

                    <div class="form-group">
                        <label for="niveau">Niveau</label>
                        <select class="form-control" name="niveau" id="niveau">
                            <option value="">Niveau d'étude</option>
                            {foreach from=$listeNiveaux key=wtf item=niveau}
                            <option value="{$niveau}">{$niveau}e année</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="form-group" id="classe">

                    </div>

                    <div class="form-group" id="choixEleve">

                    </div>

                    <div class="form-group" id="categories">
                        <label for="cbCategories">Catégories</label>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" id="cbCategories" checked>
                                TOUTES (inv. la sélection)
                            </label>
                        </div>
                        <ul class="list-unstyled"  style="height:15em; overflow: auto;">
                            {foreach from=$listeCategories key=idCategorie item=categorie}
                            <li>
                                <div class="checkbox">
                                <label>
                                    <input type="checkbox" class="selecteurCategorie" name="idCategories[]" value="{$idCategorie}" checked>
                                    <span style="padding-left:0.5em">{$categorie}</span>
                                </label>
                                </div>
                            </li>
                            {/foreach}
                        </ul>
                    </div>

                    <button type="button" class="btn btn-primary btn-block" id="generateJdc" disabled>Générer le JDC</button>

                </form>

            </div>

        </div>


    </div>

    <div class="col-md-6 col-sm-6 col-xs-12">

        <div class="panel panel-success">
            <div class="panel-heading">
                Journaux de classe générés
            </div>

            <div class="panel-body" style="max-height:25em; overflow: auto">
                <table class="table table-condensed">
                    <thead>
                        <th>Élève</th>
                        <th>Archives générées à télécharger</th>
                        <th style="width:2em">
                            <button type="button"
                                class="btn btn-danger btn-xs"
                                id="delAllJdc"
                                title="Effacer tout">
                                    <i class="fa fa-times"></i>
                            </button>
                        </th>
                    </thead>
                    <tbody id="bodyJdc">

                    </tbody>

                </table>
            </div>

            <div class="panel-footer">
                Tous les documents générés sont enregistrés <a href="index.php?action=files&mode=mydocs"> dans le répertoire {$module} de "Mes Documents"</a>
            </div>

        </div>

    </div>

</div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        })

        $('#btn-resetJDC').click(function(){
            bootbox.confirm({
                title: 'ATTENTION!!!',
                message: '<strong style="color:red; font-size: 2em;"><i class="fa fa-exclamation-triangle fa-2x"></i> Veuillez confirmer la réinitialisation définitive et irrécupérable du JDC de l\'annnée scolaire.<br>AVEZ VOUS ARCHIVÉ CETTE ANNÉE SCOLAIRE?</strong>',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/jdc/resetJDCanScol.inc.php', {
                        }, function(resultat){
                            bootbox.alert({
                                title: 'Information',
                                message: resultat + ' enregistrements effacés'
                            })
                        })
                    }
                }
            })
        })

        $('#bodyJdc').on('click', '.btn-delFile', function(){
            var fileName = $(this).data('filename');
            var arborescence = '{$module}';
            var btn = $(this);
            $.post('inc/files/delFile.inc.php', {
                fileName: fileName,
                arborescence: arborescence
            }, function(resultat){
                if (resultat == 1) {
                    btn.closest('tr').remove();
                }
            })
        })

        $('#delAllJdc').click(function(){
            $('.btn-delFile').each(function(){
                $(this).trigger('click');
            })
        })

        $('#generateJdc').click(function(){
            var formulaire = $('#printJdc').serialize();
            $.post('inc/jdc/jdcEleves4PDF.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#bodyJdc').html(resultat);
            })

        })

        $('#listeArchives').on('click', '.btn-delArchive', function(){
            var anScol = $(this).data('anscol');
            bootbox.confirm({
                title: 'Attention!!',
                message: 'Voulez-vous vraiment supprimer <strong style="color:red">définitivement</strong> l\'archive de ' + anScol + '?',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/jdc/delArchiveJDC.inc.php', {
                            anScol: anScol
                        }, function(){
                            $.post('inc/jdc/listeArchives.inc.php', {
                            }, function(resultat){
                                $('#listeArchives').html(resultat);
                            })
                        })
                    }
                }
            })
        })

        $('#btn-archive').click(function(){
            $.post('inc/jdc/saveArchiveJDC.inc.php', {
            }, function(resultat){
                $.post('inc/jdc/listeArchives.inc.php', {
                }, function(resultat){
                    $('#listeArchives').html(resultat);
                })
                bootbox.alert({
                    title: 'Information',
                    message: '<strong style="color:red"> ' + resultat + '</strong> enregistrement(s) transféré(s)'
                    });
            })
        })

        $('.input-daterange input').each(function() {
            $(this).datepicker({
                format: "dd/mm/yyyy",
                clearBtn: true,
                language: "fr",
                calendarWeeks: false,
                autoclose: true,
                todayHighlight: true,
            });
        });

        $('#anScol').change(function(){
            var anScol = $(this).val();
            if (anScol != '') {
                var debut = anScol.substr(0,4);
                var fin = anScol.substr(5,4);
                $('#debut').datepicker('setDate', new Date(debut,8,01));
                $('#fin').datepicker('setDate', new Date(fin,5,30));
                $('.input-daterange').removeClass('hidden');
            }
        })

        $('#niveau, #anScol').change(function(){
            var niveau = $('#niveau').val();
            var anScol = $('#anScol').val();
            if ((niveau != '') && (anScol != '')) {
                $.post('inc/jdc/listeClassesArchive.inc.php', {
                    anScol: anScol,
                    niveau: niveau
                }, function(resultat){
                    $('#classe').html(resultat);
                });
                $.post('inc/jdc/listeElevesNiveauArchive.inc.php', {
                    anScol: anScol,
                    niveau: niveau
                }, function(resultat) {
                    $('#choixEleve').html(resultat);
                })
            }
            else {
                $('#choixEleve').html('');
                $('#classe').html('');
            }
        })

        $('#classe').on('change', '#selectClasse', function(){
            var classe = $('#selectClasse').val();
            var anScol = $('#anScol').val();
            var niveau = $('#niveau').val();
            if ((anScol != '') && (classe != '')) {
            $.post('inc/jdc/listeElevesClasseArchive.inc.php', {
                classe: classe,
                anScol: anScol
            }, function(resultat) {
                $('#choixEleve').html(resultat);
                })
            } else {
                $('#choixEleve').html('');
                $.post('inc/jdc/listeElevesNiveauArchive.inc.php', {
                    anScol: anScol,
                    niveau: niveau
                }, function(resultat) {
                    $('#choixEleve').html(resultat);
                })
            }
        })

        $('#choixEleve').on('change', '#selectEleve', function(){
            var falseTrue = ($(this).val() == '');
            $('#generateJdc').attr('disabled', falseTrue);
            if (falseTrue == false)
                $('#categories').removeClass('hidden');
                else $('#categories').addClass('hidden');
        })

        $('#cbCategories').change(function(){
            $('.selecteurCategorie').trigger('click');
        })

        $('.selecteurCategorie').change(function(){
            if ($('.selecteurCategorie').length != $('.selecteurCategorie:checked').length)
                $('#cbCategories').prop('checked', false);
                else $('#cbCategories').prop('checked', true);
        })
    })

</script>
