<div class="container-fluid">

    <h1>Gestion des Unités d'Acquis d'Aprentissage</h1>


    <div class="row">

        <div class="col-md-4 col-sm-6">
            <div class="panel panel-success">

                <div class="panel-heading">
                    Liste des UAA
                </div>
                <div class="panel-body" id="selectUAA">
                    {include file="uaa/selectUAA.tpl"}
                </div>

                <div class="panel-footer">
                    <div class="btn-group btn-group-justified">
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" id="modifUAA" title="" disabled data-container="body" data-original-title="Modifier une UAA"><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs " id="delUAA" title="" disabled  data-container="body" data-original-title="Supprimer des UAA"><i class="fa fa-times"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-warning btn-xs" id="addUAA" title="" data-container="body" data-original-title="Ajouter une UAA"><i class="fa fa-plus"></i></a>
                    </div>
                </div>

            </div>
        </div>

        <div class="col-md-4 col-sm-6">

            <div class="panel panel-info">

                <div class="panel-heading">
                    Gestion des grappes de cours
                </div>
                <div class="panel-body" id="listeGrappes">
                    {include file="uaa/selectGrappe.tpl"}
                </div>

                <div class="panel-footer">
                    <div class="btn-group btn-group-justified">
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" id="editGrappe" title="" data-container="body" data-original-title="Modifier une grappe" disabled><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs " id="delGrappe" title="" disabled  data-container="body" data-original-title="Supprimer une grappe"><i class="fa fa-times"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-warning btn-xs" id="addGrappe" title="" data-container="body" data-original-title="Ajouter une grappe"><i class="fa fa-plus"></i></a>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>

<div id="modal"></div>


<script type="text/javascript">

    $(document).ready(function(){

        // panneau des grappes --------------------------------------------
        $('#editGrappe').click(function(){
            var grappe = $('#listeGrappes option:selected').text();
            var idGrappe = $('#listeGrappes option:selected').val();
            $.post('inc/uaa/modalEditGrappe.inc.php', {
                idGrappe: idGrappe    
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditGrappe').modal('show');
            })
        })

        $('#listeGrappes').change(function(){
            $('#editGrappe').attr('disabled', false);
            $('#delGrappe').attr('disabled', false);
        })

        $('#modal').on('change', '#modalNiveau', function(){
            var niveau = $(this).val();
            $.post('inc/uaa/getListeCoursNiveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#modal #selectCours').html(resultat);
                $('#sendToGrappe').attr('disabled', true);
            })
        })

        $('#modal').on('change', '#listeCours', function(){
            $('#sendToGrappe').attr('disabled', false);
        })
        $('#modal').on('change', '#coursGrappe', function(){
            $('#btn-delCoursGrappe').attr('disabled', false);
        })

        $('#modal').on('click', '#sendToGrappe', function(){
            var formulaire = $('#form4grappe').serialize();
            var idGrappe = $('#idGrappe').val();
            $.post('inc/uaa/send2grappe.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#modal #coursGrappe').html(resultat);
                $.post('inc/uaa/refreshListeGrappes.inc.php', { 
                    idGrappe: idGrappe
                }, function(resultat){
                    $('#listeGrappes').html(resultat);
                })
            })
        })
        $('#modal').on('click', '#btn-delCoursGrappe', function(){
            var cours = $('#coursGrappe option:selected').val();
            var idGrappe = $('#idGrappe').val();
            $.post('inc/uaa/delCoursGrappe.inc.php', {
                idGrappe: idGrappe,
                cours: cours
            }, function(resultat){
                $('#modal #coursGrappe').html(resultat);
                $.post('inc/uaa/refreshListeGrappes.inc.php', {
                    idGrappe: idGrappe
                }, function(resultat){
                    $('#listeGrappes').html(resultat);
                    $('#btn-delCoursGrappe').attr('disabled', true);
                })
            })
        })

        $('#addGrappe').click(function(){
            var title = 'Création d\'une nouvelle grappe';
            bootbox.prompt({
                title: title,
                callback: function(result){
                    result = result.trim();
                    if (result.length != 0) {
                        $.post('inc/uaa/saveNewGrappe.inc.php', {
                            newGrappe: result
                        }, function(resultatJSON){
                            var resultat = JSON.parse(resultatJSON);
                            var nb = resultat['nb'];
                            if (nb != 0) 
                                $('#listeGrappes').html(resultat['html']);
                                else bootbox.alert({
                                    title: title,
                                    message: "L'enregistrement a échoué. Cette grappe existerait-elle déjà?"
                                })
                        })
                    }
                }
            })
        })

        $('#modal').on('click', '#modalSaveLibelle', function(){
            var title = 'Renommer une grappe';
            var libelle = $(this).closest('.input-group').find('input').val().trim();
            var idGrappe = $('input#idGrappe').val();
            if (libelle != '') {
                $.post('inc/uaa/renameGrappe.inc.php', {
                    libelle: libelle,
                    idGrappe: idGrappe
                    }, function(resultatJSON){
                        var resultat = JSON.parse(resultatJSON);
                        var nb = resultat['nb'];
                        if (nb != 0) {
                            $('#listeGrappes').html(resultat['html']);
                            bootbox.alert({
                                title: title,
                                message: "Modification enregistrée"
                            })
                            }
                            else bootbox.alert({
                                title: title,
                                message: "L'enregistrement a échoué. Cette grappe existerait-elle déjà?"
                            })
                        })
                }
        })

        $('#delGrappe').click(function(){
            var idGrappe = $('#listeGrappes option:selected').val();
            $.post('inc/uaa/delGrappe.inc.php', {
                idGrappe: idGrappe
            }, function(resultat){
                $('#listeGrappes option:selected').remove();
                $('#editGrappe').attr('disabled', true);
                $('#delGrappe').attr('disabled', true);
            })
        })

        // panneau des grappes --------------------------------------------








        // panneau des UAA ------------------------------------------------

        $('#delUAA').click(function(){
            var formulaire = $('#formSelectUAA').serialize();
            $.post('inc/uaa/delUAA.inc.php', {
                formulaire: formulaire
            }, function(resultatJSON){
                var resultat = JSON.parse(resultatJSON);
                var nbDel = resultat['nbDel'];
                var title = "Suppression des UAA";
                if (nbDel > 0) {
                    $('#selectUAA').html(resultat['html']);
                    bootbox.alert({
                        title: title,
                        message: nbDel + " UAA supprimée(s)"
                    });
                    }
                else {
                    bootbox.alert({
                        title: "Suppression des UAA",
                        message: "Aucune UAA n'a pu être supprimée (sans doute encore utilisées)"
                    })
                }
            })
        })

        $('#modifUAA').click(function(){
            var idUAA = $('#listeUAA option:selected').val();
            var libelle = $('#listeUAA option:selected').text();
            bootbox.prompt({
                title: "Modification du texte de l'UAA",
                value: libelle,
                callback: function(newLibelle){
                    $.post('inc/uaa/modifUAA.inc.php', {
                        libelle: newLibelle,
                        idUAA: idUAA
                    }, function(resultatJSON){
                        var resultat = JSON.parse(resultatJSON);
                        var title = "Enregistrement";
                        if (resultat['nb'] == 0)
                            message = "Aucune modification apportée. Cette UAA existerait-elle déjà?";
                            else {
                                message = "Modification enregistrée";
                                $('#listeUAA option[value="' + idUAA + '"]').text(newLibelle);
                            }
                        bootbox.alert({
                            title: title,
                            message: message
                        })
                    })
                }
            })
        })

        $('#addUAA').click(function(){
            bootbox.prompt({
                title: "Nouvelle UAA",
                callback: function(libelle){
                    $.post('inc/uaa/saveUAA.inc.php', {
                        libelle: libelle
                    }, function(resultatJSON){
                        var resultat = JSON.parse(resultatJSON);
                        var title = 'Enregistrement';
                        if (resultat['idUAA'] == 0)
                            message = "Aucune enregistrement possible. Cette UAA existerait-elle déjà?";
                            else message = "Nouvelle UAA enregistrée";
                        $('#selectUAA').html(resultat['html']);
                        bootbox.alert({
                            title: title,
                            message: message
                        })
                    })
                }
            })
        })

        $('#listeUAA').change(function(){
            var nbSelect = $('#listeUAA option:selected').length;
            switch(nbSelect) {
                case 0:
                    $('a.btn').attr('disabled', true);
                    break;
                case 1:
                    $('a.btn').attr('disabled', false);
                    break;
                default:
                    $('#modifUAA').attr('disabled', true);
                    break;
            }
        })
    })

</script>
