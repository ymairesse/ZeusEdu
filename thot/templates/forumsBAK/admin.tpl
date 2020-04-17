<div class="container-fluid">

    <div class="row">

        <div class="col-md-3 col-sm-6">
            <div class="panel panel-default">
                <div class="panel-heading">
                    Liste des catégories
                    {if $userStatus == 'admin'}
                    <div class="btn-group pull-right">
                        <a href="javascript:void(0)" type="button" class="btn btn-primary btn-xs" id="addCategorie" title="Ajouter une catégorie" data-container="body"><i class="fa fa-plus"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" disabled id="btn-renameCategorie" title="Modifier cette catégorie" data-container="body"><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs" disabled id="btn-delCategorie" title="Supprimer cette catégorie" data-container="body"><i class="fa fa-times"></i></a>
                    </div>
                    {/if}

                </div>

                <div class="panel-body" id="treeviewCategories" style="max-height:20em;overflow:auto;">

                    {include file="forums/treeviewCategories.tpl"}

                </div>

                <input type="hidden" name="categorie" id="laCategorie" value="0">
                <input type="hidden" name="userStatus" id="userStatus" value="racine">


                <div class="panel-footer">
                    Sélectionnez une catégorie ci-dessus pour créer un sujet
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="btn-group btn-group-justified">
                        <a href="javascript:void(0)" type="button" class="btn btn-primary btn-xs" id="addSubject" title="Ajouter un sujet" data-container="body" disabled><i class="fa fa-plus"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" id="modifSubject" title="Modifier le sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs " id="delSubject" title="Supprimer un sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-times"></i></a>
                    </div>
                </div>
                <div class="panel-body" id="listeSujets" style="max-height:20em; overflow:auto;">
                    {include file="forums/listeSujets.tpl"}
                </div>

                <div class="panel-footer">

                </div>
            </div>

        </div>

        <div class="col-md-3 col-sm-6">

            <div class="panel panel-info">
                <div class="panel-heading" id="libelle">
                    Liste des contributions
                </div>

                <div class="panel-body" id="listePosts">

                </div>

            </div>

        </div>

        <div class="col-md-6 col-sm-12">

            <div id="postViewer">
                <p class="avertissement">Veuillez sélectionner une catégorie et un sujet dans la première colonne</p>
            </div>

        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

    $(document).ready(function(){

    // enregistrement d'une nouvelle contribution par l'utilisateur courant
    $('#postViewer').on('click', '#btn-saveAnswer', function(){
        if ($('#formNewPost').valid()) {
            var formulaire = $('#formNewPost').serialize();
            $.post('inc/forums/saveNewPost.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                var postId = parseInt(resultatJS.postId);
                $('#listePosts').html(resultatJS.html);
                $.post('inc/forums/listPostAncestors.inc.php', {
                    postId: postId
                }, function(liste){
                    var listeJSON = JSON.parse(liste);
                    // ouverture de l'arbre jusqu'au nœud parent de la nouvelle catégorie
                    $.each(listeJSON, function(index, value){
                        $('#listePosts li a[data-postid="' + value + '"').trigger('click')
                     })
                })
            })
        }
    })

    $('#postViewer').on('click', '#btn-saveEditedPost', function(){
        if ($('#formEditPost').valid()){
            var formulaire = $('#formEditPost').serialize();
            $.post('inc/forums/saveEditedPost.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                var postId = parseInt(resultatJS.postId);
                $('#listePosts').html(resultatJS.html);
                $.post('inc/forums/listPostAncestors.inc.php', {
                    postId: postId
                }, function(liste){
                    // console.log(postId, liste);
                    var listeJSON = JSON.parse(liste);
                    // ouverture de l'arbre jusqu'au nœud parent de la nouvelle catégorie
                    $.each(listeJSON, function(index, value){
                        $('#listePosts li a[data-postid="' + value + '"').trigger('click')
                     })
                    // cliquer sur l'item modifié
                    $('#listePosts li a[data-postid="' + postId + '"').trigger('click');
                    $('#btn-saveEditePost').addClass('hidden');
                })
            })
        }
    })

    $('#postViewer').on('click', '#btn-edit', function(){
        $('#post').attr('readOnly', false);
        $('#btn-saveEditedPost').removeClass('hidden');
        });

    $('#postViewer').on('click', '#btn-answer', function(){
        $('#formNewPost').removeClass('hidden');
    })

    // sélection d'une catégorie avec présentation du choix des sujets existants
    // pour la catégorie
    $('#treeviewCategories').on('click', '.treeview li a', function(){
        $('.treeview li a').removeClass('active');
        $(this).addClass('active');
        var idCategorie = $(this).data('idcategorie');
        if (idCategorie != 0) {
            $('#btn-renameCategorie').attr('disabled', false);
            $('#btn-delCategorie').attr('disabled', false);
            $('#addSubject').attr('disabled', false);
            }
            else {
                $('#btn-renameCategorie').attr('disabled', true);
                $('#btn-delCategorie').attr('disabled', true);
                $('#addSubject').attr('disabled', true);
                $('#modifSubject').attr('disabled', true);
                $('#delSubject').attr('disabled', true);
            }
        var libelleCategorie = $(this).html();
        var userStatus = $(this).data('userstatus');
        $('#userStatus').val(userStatus);
        $('#laCategorie').val(idCategorie);
        $('#titreCategorie').html(libelleCategorie);
        $.post('inc/forums/listeSujets.inc.php', {
            idCategorie: idCategorie
        }, function(resultat){
            $('#listeSujets').html(resultat);
            $('#listePosts').html('');
            $('#postViewer').html('<p class="avertissement">Veuillez sélectionner une catégorie et un sujet dans la première colonne</p>');
            $('#libelle').text('Liste des contributions');
            })
        })


    // sélection d'un post dans la liste des posts déjà existants
    $('#listePosts').on('click', '.treeviewPost li a', function(){
        var postId = $(this).data('postid');
        var idCategorie = $(this).data('idcategorie')
        var idSujet = $(this).data('idsujet');
        $('.treeviewPost li a').removeClass('active');
        $(this).addClass('active');
        $('#postViewer').fadeOut(200, 'linear');
        $.post('inc/forums/getPost4postId.inc.php', {
            postId: postId,
            idCategorie: idCategorie,
            idSujet: idSujet
        }, function(resultat){
            $('#postViewer').html(resultat).fadeIn(100, 'linear');
        })
    })

    $('#addCategorie').click(function(){
        var idParent = $('#laCategorie').val();
        var libelle = $('a[data-idcategorie="'+ idParent +'"]').text();
        var userStatus = $('#userStatus').val();
        $.post('inc/forums/addCategorie.inc.php', {
            idParent: idParent,
            libelle: libelle,
            userStatus: userStatus
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalAddCategorie').modal('show');
        })
    })

    $('#modal').on('click', '#btnModalSaveCategorie', function(){
        if($('#formAddCategorie').valid()) {
            var libelle = $('#modalLibelle').val();
            var formulaire = $('#formAddCategorie').serialize();
            var idCategorie;
            var title = 'Enregistrement d\'une catégorie';
            $.post('inc/forums/modalSaveCategorie.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var idCategorie = resultat;
                if (idCategorie > 0) {
                    $('#modalAddCategorie').modal('hide');
                    $.post('inc/forums/refreshTreeviewCategories.inc.php', {
                    },
                    function(resultat){
                        $('#treeviewCategories').html(resultat);
                        $.post('inc/forums/listAncestors.inc.php', {
                            idCategorie: idCategorie
                        }, function(liste){
                            // la fonction revient avec la liste des nœuds à réactiver
                            var listeJSON = JSON.parse(liste);
                            // ouverture de l'arbre jusqu'au nœud parent de la nouvelle catégorie
                            $.each(listeJSON, function(index, value){
                                 $('li a[data-idcategorie="' + value + '"]').trigger('click');
                             })
                             // réactiver l'item qui vient d'être créé
                             $('li a[data-idcategorie="' + idCategorie + '"').trigger('click');
                        })
                    });
                    bootbox.alert({
                        'title': title,
                        'message': 'Enregistrement de la catégorie "' + libelle +'" réussi'
                        })
                    }
                else bootbox.alert({
                    'title': title,
                    'message': 'La catégorie "' + libelle + '" existe déjà'
                });
                })
            }
        })

    $('#btn-renameCategorie').click(function(){
        var idCategorie = $('#laCategorie').val();
        var libelle = $('a[data-idcategorie="'+ idCategorie +'"]').text();
        $.post('inc/forums/modalRenameCategorie.inc.php', {
            idCategorie: idCategorie,
            libelle: libelle,
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalEditCategorie').modal('show');
        })
    })

    $('#modal').on('click', '#btnModalRenameCategorie', function(){
        var formulaire = $('#formRenameCategorie').serialize();
        var libelle = $('#modalLibelle').val();
        var idCategorie;
        $.post('inc/forums/renameCategorie.inc.php', {
            formulaire: formulaire
        }, function(idCategorie){
            // le résultat est idCategorie (c'est OK) ou -1 (pas de changement effectué)
            if (idCategorie == -1) {
            bootbox.alert({
                title: 'Changement de nom',
                message: 'Le nouveau nom "<strong>' + libelle+ '</strong>" pour cette catégorie n\'a pas été accepté. Est-il déjà utilisé?',
                })
            }
            else {
            $.post('inc/forums/refreshTreeviewCategories.inc.php', {
                idCategorie: idCategorie
            },
            function(resultat){
                $('#treeviewCategories').html(resultat);
                $.post('inc/forums/listAncestors.inc.php', {
                    idCategorie: idCategorie
                }, function(liste){
                    var listeJSON = JSON.parse(liste);
                    // ouverture de l'arbre jusqu'au nœud parent de la nouvelle catégorie
                    $.each(listeJSON, function(index, value){
                         $('li a[data-idcategorie="' + value + '"]').trigger('click');
                         })
                    // réactiver l'item qui vient d'être renommé
                    $('li a[data-idcategorie="' + idCategorie + '"').trigger('click');
                    })
                });
            }
            $('#modalEditCategorie').modal('hide');
        })
    })

    $('#btn-delCategorie').click(function(){
        var idCategorie = $('#laCategorie').val();
        $.post('inc/forums/verifNoChildren.inc.php', {
            idCategorie
        }, function(resultat){
            var titre = 'Effacement de cette catégorie';
            if (resultat == 0) {
                bootbox.confirm({
                    'title': titre,
                    'message': 'Veuillez confirmer la <strong>suppression définitive</strong> de cette catégorie et de toutes les contributions des utilisateurs',
                    callback: function(result){
                        if (result == true) {
                            $.post('inc/forums/delCategorie.inc.php', {
                                idCategorie:idCategorie
                            }, function(resultat){
                                var resultatJS = JSON.parse(resultat);
                                var nbPosts = parseInt(resultatJS.nbPosts);
                                var nbSujets = parseInt(resultatJS.nbSujets)
                                bootbox.alert({
                                    'title': titre,
                                    'message': nbSujets + " sujet(s) et " + nbPosts + " contribution(s) effacés"
                                });
                                $('#postViewer').html('');
                                $('#listeSujets').html('');
                                $('#titreCategorie').text('');
                                $('#treeviewCategories ul li[data-idcategorie="' + idCategorie + '"]').remove();
                            })
                        }
                    }
                })
            }
            else {
                bootbox.alert({
                    'title': titre,
                    message: 'Cette catégorie possède des "fils". Elle ne peut être effacée'
                })
            }
        })
    })

    $('.btn-cat').click(function(){
        var userStatus = $(this).data('userstatus');
        switch (userStatus) {
            case 'all':
                $('#treeviewCategories ul li.profs').show('slow');
                $('#treeviewCategories ul li.eleves').show('slow');
                break;
            case 'eleves':
                $('#treeviewCategories ul li.eleves').toggle('slow');
                break;
            case 'profs':
                $('#treeviewCategories ul li.profs').toggle('slow');
                break;
        }
    })

    // ajout d'un nouveau sujet dans la catégorie sélectionnée
    $('#addSubject').click(function(){
        var idCategorie = $('#laCategorie').val();
        $.post('inc/forums/addSubject.inc.php', {
            idCategorie
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalAddSubject').modal('show');
        })
    })

    // Modification d'un sujet après action sur le bouton #modifSubject
    $('#modifSubject').click(function(){
        var idCategorie = $(this).data('idcategorie');
        var idSujet = $(this).data('idsujet');
        var sujet = $(this).data('sujet');
        $.post('inc/forums/modifSubject.inc.php', {
            idCategorie: idCategorie,
            idSujet: idSujet,
            sujet: sujet
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalAddSubject').modal('show');
        })
    })

    $('#modal').on('click', '#btnModalSaveSubject', function(){
        if ($('#formAddSubject').valid()) {
            var sujet = $('#modalSubject').val();
            var idCategorie = $('#laCategorie').val();
            var formulaire = $('#formAddSubject').serialize();
            $.post('inc/forums/modalSaveSubject.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var idSujet = resultat;
                if (idSujet > 0) {
                    $('#modalAddSubject').modal('hide');
                    $.post('inc/forums/listeSujets.inc.php', {
                        idCategorie: idCategorie
                    }, function(resultat){
                        $('#listeSujets').html(resultat);
                    })
                }
            })
        }
    })

    // suppression d'un sujet après action sur le bouton #delSubect
    $('#delSubject').click(function(){
        var idCategorie = $(this).data('idcategorie');
        var idSujet = $(this).data('idsujet');
        var sujet = $(this).data('sujet');
        bootbox.confirm({
            title: 'Suppression du sujet',
            message: 'Vous allez supprimer définitivement le sujet <strong>' + sujet +'</strong> et toutes les contributions liées. Veuillez confirmer.',
            callback: function(result){
                if (result == true) {
                    $.post('inc/forums/delSubject.inc.php', {
                        idSujet: idSujet,
                        idCategorie: idCategorie
                    }, function(resultat){
                        $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').remove();
                        var nb = parseInt($('#treeviewCategories li a[data-idcategorie="' + idCategorie + '"]').next('.badge').text())-1;
                        $('#treeviewCategories li a[data-idcategorie="' + idCategorie + '"]').next('.badge').text(nb);

                    })
                }
            }
        })
    })

    // sélection d'un sujet dans la liste de gauche
    $('#listeSujets').on('click', '.btn-sujet', function(){
        $('#listeSujets button').removeClass('active');
        $(this).addClass('active');
        var idSujet = $(this).data('idsujet');
        var idCategorie = $(this).data('idcategorie');
        var sujet = $(this).data('sujet');
        $('#libelle').html(sujet);
        $.post('inc/forums/verifProprio.inc.php', {
            idSujet: idSujet,
            idCategorie: idCategorie
        }, function(resultat){
            if (resultat != '') {
                $('#modifSubject').attr('disabled', false).data('idcategorie', idCategorie).data('idsujet', idSujet).data('sujet', sujet);
                $('#delSubject').attr('disabled', false).data('idcategorie', idCategorie).data('idsujet', idSujet).data('sujet', sujet);
            }
            else {
                $('#modifSubject').attr('disabled', true).data('idcategorie', 0).data('idsujet', 0).data('sujet', '');
                $('#delSubject').attr('disabled', true).data('idcategorie', 0).data('idsujet', 0).data('sujet', '');
            }
        })

        $.post('inc/forums/getListePosts.inc.php', {
            idCategorie: idCategorie,
            idSujet: idSujet,
            sujet: sujet
        }, function(resultat){
            $('#listePosts').html(resultat);
            $('#postViewer').html('<p class="avertissement">Veuillez sélectionner une contribution</p>');
        })
    })

    })


</script>
