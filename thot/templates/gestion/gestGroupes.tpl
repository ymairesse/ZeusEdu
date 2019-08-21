<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container-fluid">

        <h2>Gestion des groupes</h2>

    <div class="row">

        <div class="col-md-3 col-sm-6">
            <div class="panel panel-info">
                <div class="panel-heading">
                    Mes groupes
                </div>

                <div class="panel-body" id="listeMesGroupes">

                    {include file='gestion/inc/listeMesGroupes.tpl'}

                </div>

                <div class="panel-footer">
                    <button type="button" class="btn btn-success btn-block" id="btnCreateGroup">Créer un groupe</button>
                </div>

            </div>
        </div>

        <div class="col-md-9 col-sm-6" id="cadrePrincipal">

            <p class="avertissement"> Veuillez sélectionner une action ou créer un groupe dans la colonne de gauche</p>

        </div>
    </div>

</div>

<script type="text/javascript">

    $('document').ready(function(){

        $('#btnCreateGroup').click(function(){
            $.post('inc/gestion/editGroupe.inc.php', {
            }, function(resultat){
                $('#cadrePrincipal').html(resultat);
            })
        })

        $('#cadrePrincipal').on('click', '#btn-save', function(){
            if ($('#formEditGroupe').valid()) {
                var formulaire = $('#formEditGroupe').serialize();
                var description = CKEDITOR.instances.description.getData();
                $.post('inc/gestion/saveGroupe.inc.php', {
                    formulaire: formulaire,
                    description: description
                }, function(resultat){
                    if (resultat == 0) {
                        bootbox.alert({
                            title: 'Erreur',
                            message: 'Ce nom de groupe existe déjà. Veuillez choisir un autre nom.'
                        })
                    }
                    else {
                        $.post('inc/gestion/refreshGroupes.inc.php', {
                        }, function(resultat){
                            $('#listeMesGroupes').html(resultat);
                            $('#nomGroupe').attr('readonly', true);
                            bootbox.alert({
                                title: 'Enregistrement',
                                message: 'Les informations ont été enregistrées'
                            })
                        })
                    }

                })
            }
        })

        $('#cadrePrincipal').on('click', '#btn-reset', function(){
            var groupe = $('#listeMesGroupes').find('.btn.active').data('nomgroupe');
            if (groupe == undefined) {
                groupe = '';
                }
            $.post('inc/gestion/editGroupe.inc.php', {
                groupe: groupe
            }, function(resultat){
                $('#cadrePrincipal').html(resultat);
            })
        })

        $('#listeMesGroupes').on('click', '.btnEditGroupe', function(){
            $('.btnEditGroupe').removeClass('active');
            $(this).addClass('active');
            var groupe = $(this).closest('div').data('nomgroupe');
            $.post('inc/gestion/editGroupe.inc.php', {
                groupe: groupe
            }, function(resultat){
                $('#cadrePrincipal').html(resultat);
            })
        })

        $('#listeMesGroupes').on('click', '.btnEditMembres', function(){
            var nomGroupe = $(this).closest('div').data('nomgroupe');
            var intitule = $(this).prev('button').text();
            $.post('inc/gestion/getMembresGroupe.inc.php', {
                nomGroupe: nomGroupe,
                intitule: intitule
            }, function(resultat){
                $('#cadrePrincipal').html(resultat);
            })
        })

        $('#cadrePrincipal').on('click', '#addMembres', function(){
            var formulaire = $('#formAddMembres').serialize();
            $.post('inc/gestion/addMembres.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var nb = parseInt(resultat);
                bootbox.alert({
                    title: 'Enregistrement',
                    message: nb + ' membre(s) ajouté(s) au groupe'
                });
                if (nb > 0) {
                    $.post('inc/gestion/refreshMembresGroupe.inc.php', {
                        formulaire: formulaire
                    }, function(resultat){
                        $('#listeMembres').html(resultat);
                    })
                }
            })
        })

        $('#cadrePrincipal').on('click', '#btn-delMembres', function(){
            var formulaire = $('#formListeMembres').serialize();
            $.post('inc/gestion/delMembres.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var nb = parseInt(resultat);
                if (nb > 0){
                    $.post('inc/gestion/refreshMembresGroupe.inc.php', {
                        formulaire: formulaire
                    }, function(resultat){
                        $('#listeMembres').html(resultat);
                        bootbox.alert({
                            title: 'Enregistrement',
                            message: nb + ' membre(s) retiré(s) du groupe'
                        });
                    })
                }
            })
        })

    })

</script>
