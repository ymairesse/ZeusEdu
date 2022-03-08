<div class="container-fluid">

    <div class="row">

        <div class="col-md-2 col-xs-12">

            <form id="formulaire" style="padding:0; border: 0">

                <h1>Trombinoscope</h1>

                <select name="classe" id="selectClasse" class="form-control">
                    <option value="">Classe</option>
                    {foreach from=$listeClasses item=uneClasse}
                        <option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
                    {/foreach}
                </select>

                <span id="ajaxLoader" class="hidden pull-right">
        			<img src="images/ajax-loader.gif" alt="loading" class="img-responsive">
        		</span>

                <button type="button" class="btn btn-primary btn-block" id="envoi">OK</button>

            </form>

        </div>

        <div class="col-md-10 col-xs-12">

            <div id="trombi">
                <p class="avertissement">Sélectionner une classe à gauche</p>
            </div>

            <div id="ficheEleve">

            </div>

        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

    var message = "<p class='avertissement'>Sélectionner une classe à gauche</p>";

    function generateFicheEleve(classe, matricule){
        $.post('inc/eleves/generateFicheEleve.inc.php', {
            classe: classe,
            matricule: matricule,
        }, function(resultat){
            $('#ficheEleve').html(resultat);
            var onglet = Cookies.get('onglet');
            if (onglet != undefined){
                $('ul#tabs a[href="' + onglet +'"]').trigger('click');
                }
        })
    }

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        var classe = Cookies.get('classe');
        var onglet = Cookies.get('onglet');

        $('#selectClasse').val(classe);

        if (classe != '') {
            $.post('inc/eleves/generateTrombi.inc.php', {
                classe: classe
            }, function(resultat){
                $('#trombi').html(resultat).show();
            })
        }

        $('body').on('click', '.unePhoto', function(){
            var matricule = $(this).data('matricule');
            var classe = $(this).data('classe');
            $('#trombi').hide();
            $('#ficheEleve').show();
            generateFicheEleve(classe, matricule);
        })

        $('#selectClasse').change(function(){
            var classe = $('#selectClasse').val();
            if (classe != '') {
                Cookies.set('classe', classe);
                $.post('inc/eleves/generateTrombi.inc.php', {
                    classe: classe
                }, function(resultat){
                    $('#trombi').html(resultat).show();
                    $('#ficheEleve').hide();
                })
            }
            else {
                $('#trombi').html(message).show();
                $('#ficheEleve').hide();
                }
        })

        $('#envoi').click(function(){
            $('#selectClasse').trigger('change');
        })

        $('body').on('click', '#saveEditedFait', function(){
            var classe = $('#editFaitDisc #classe').val();
            var formulaire = $("#editFaitDisc").serialize();
            if ($('#editFaitDisc').valid()) {
                $.post('inc/faits/saveFait.inc.php', {
                    formulaire: formulaire
                }, function (resultat) {
                    var resultatJSON = JSON.parse(resultat);
                    generateFicheEleve(resultatJSON['classe'], resultatJSON['matricule']);
                    $('#modalEditFait').modal('hide');
                })
            }
        })

        $('body').on('click', '.delete', function() {
            var idfait = $(this).data('idfait');
            $.post('inc/faits/delFaitDisc.inc.php', {
                idfait: idfait
            }, function(resultat) {
                $("#modalDel .modal-body").html(resultat);
                // désactivation des champs sauf les "hidden"
                $("#modalDel input:text").prop('disabled', true);
                $("#modalDel textarea").prop('disabled', true);
                $("#modalDel select").prop('disabled', true);
                $('.motif').hide();
                $("#modalDel").modal('show');
            })
        })

        $('body').on('click', '#btn-confDel', function(){
            var idfait = $(this).data('idfait');
            $.post('inc/faits/supprEffectiveFait.inc.php', {
                idfait: idfait
                },
            function (resultat){
                if (resultat == 1) {
                    // suppression de la ligne (tr) dans le tableau
                    $('body').find('td [data-idfait="' + idfait + '"]').closest('tr').remove();
                    $("#modalDel").modal('hide');
                }
            })
        })

        $('body').on('click', '.edit', function() {
            var idfait = $(this).data('idfait');
            var matricule = $(this).data('matricule');
            var type = $(this).data('typefait');
            $.post('inc/faits/editFaitDisc.inc.php', {
                type: type,
                matricule: matricule,
                idfait: idfait
            }, function(resultat) {
                $('#modal').html(resultat);
                $('#modalEditFait').modal('show');
            })
        })

        $('body').on('click', '.print', function() {
            var idfait = $(this).data('idfait');
            $.post('inc/retenues/printRetenue.inc.php', {
                    idfait: idfait
                },
                function(resultat) {
                }
            )
        })

        $('body').on('click', '.newFait', function() {
            var type = $(this).data('typefait');
            var matricule = $('#selectEleve').val();
            $.post('inc/faits/editFaitDisc.inc.php', {
                type: type,
                matricule: matricule
            }, function(resultat) {
                $('#modal').html(resultat);
                $('#modalEditFait').modal('show');
            })
        })



    })

</script>
