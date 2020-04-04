<div class="container-fluid">

    <div class="row">

        <div class="col-md-4 col-sm-12">
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

                    {include file="forum/treeviewCategories.tpl"}

                </div>

                <input type="hidden" name="categorie" id="laCategorie" value="0">
                <input type="hidden" name="userStatus" id="userStatus" value="racine">


                <div class="panel-footer">
                    <a href="javascript:void(0)" type="button" class="btn btn-primary btn-block btn-xs" id="addSubject" title="Ajouter un sujet" data-container="body" disabled><i class="fa fa-plus"></i> Créer un sujet dans la catégorie sélectionnée ci-dessus</a>
                    Sélectionnez une catégorie ci-dessus pour créer un sujet
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="btn-group btn-group-justified">
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" id="modifSubject" title="Modifier le sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs " id="delSubject" title="Supprimer un sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-times"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-warning btn-xs" id="infoSubject" title="Informations" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-info"></i></a>
                    </div>
                </div>
                <div class="panel-body" id="listeSujets" style="max-height:20em; overflow:auto;">

                    {include file="forum/listeSujets.tpl"}

                </div>

                <div class="panel-footer">

                </div>
            </div>

        </div>

        <div class="col-md-8 col-sm-12">

            <div class="panel panel-info">
                <div class="panel-heading" id="libelle" data-defaulttext="Liste des contributions">
                    <span>Liste des contributions</span>
                    <button type="button" class="btn btn-success btn-xs pull-right" id="btn-hideRepondre">Cacher les boutons</button>
                </div>

                <div class="panel-body" id="listePosts" style="height:35em; overflow:auto;">

                </div>

            </div>

        </div>


    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">


    $(document).ready(function(){

        // effacement d'un post
        $('#listePosts').on('click', '.btn-delPost', function(){
            var postId = $(this).data('postid');
            var idCategorie = $(this).data('idcategorie');
            var idSujet = $(this).data('idsujet');
            $.post('inc/forum/modalDelPost.inc.php', {
                postId: postId,
                idCategorie: idCategorie,
                idSujet: idSujet
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalDelPost').modal('show');
            })
        })

        $('#modal').on('click', '#btn-confirmDelPost', function(){
            var postId = $(this).data('postid');
            var formulaire = $('#formModalDelPost').serialize();
            $.post('inc/forum/delPost.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                if (resultat == 1) {
                    $('.postForum[data-postid="' + postId + '"]').html("<span class='supprime'>Cette contribution a été supprimée</span>");
                    $('.repondre [data-postid="' + postId + '"].btn-forum').attr('disabled', true);
                    $('#modalDelPost').modal('hide');
                }
            })
        })

        // clic sur un bouton .repondre
        $('#listePosts').on('click', '.btn-repondre', function(){
            var postId = $(this).data('postid');
            var idCategorie = $(this).data('idcategorie');
            var idSujet = $(this).data('idsujet');
            $.post('inc/forum/getModalAnswer.inc.php', {
                postId: postId,
                idCategorie: idCategorie,
                idSujet: idSujet
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalAnswerPost').modal('show');
            })
        })

    function goToByScroll(postId){
        $('html,body').animate({
            scrollTop: $("#"+postId).offset().top,
            },
            'slow'
        )}

    $('#listePosts').on('click', '#racinePosts', function(){
        var postId = $(this).data('postid');
        var idCategorie = $(this).data('idcategorie');
        var idSujet = $(this).data('idsujet');
        $.post('inc/forum/getModalAnswer.inc.php', {
            postId: postId,
            idCategorie: idCategorie,
            idSujet: idSujet
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalAnswerPost').modal('show');
        })
    })

    // enregistrement d'une nouvelle contribution par l'utilisateur courant
    $('#modal').on('click', '#saveNewPost', function(){
        if ($('#formModalAnswer').valid()) {
            var formulaire = $('#formModalAnswer').serialize();
            $.post('inc/forum/saveNewPost.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                var postId = parseInt(resultatJS.postId);
                $('#listePosts').html(resultatJS.html);
                $('#modalAnswerPost').modal('hide');
                goToByScroll("post_" + postId);
            })
        }
    })

    $('#listePosts').on('click', '.btn-edit', function(){
        var postId = $(this).data('postid');
        var idCategorie = $(this).data('idcategorie')
        var idSujet = $(this).data('idsujet');
        $.post('inc/forum/getModalEditPost.inc.php', {
            postId: postId,
            idCategorie: idCategorie,
            idSujet: idSujet
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalModify').modal('show');
        })
    })

    $('#modal').on('click', '#saveEditedPost', function(){
        if ($('#formModalModify').valid()){
            var formulaire = $('#formModalModify').serialize();
            $.post('inc/forum/saveEditedPost.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                var postId = parseInt(resultatJS.postId);
                $('#listePosts').html(resultatJS.html);
                $('#modalModify').modal('hide');
                goToByScroll("post_" + postId);
            })
        }
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
        })


    $('#addCategorie').click(function(){
        var idParent = $('#laCategorie').val();
        var libelle = $('a[data-idcategorie="'+ idParent +'"]').text();
        var userStatus = $('#userStatus').val();
        $.post('inc/forum/addCategorie.inc.php', {
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
            $.post('inc/forum/modalSaveCategorie.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var idCategorie = resultat;
                if (idCategorie > 0) {
                    $('#modalAddCategorie').modal('hide');
                    $.post('inc/forum/refreshTreeviewCategories.inc.php', {
                    },
                    function(resultat){
                        $('#treeviewCategories').html(resultat);
                        // activer l'item qui vient d'être créé
                         $('li a[data-idcategorie="' + idCategorie + '"').trigger('click');
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
        $.post('inc/forum/modalRenameCategorie.inc.php', {
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
        $.post('inc/forum/renameCategorie.inc.php', {
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
                $('#treeviewCategories li a[data-idcategorie="' + idCategorie + '"]').text(libelle);
            }
            $('#modalEditCategorie').modal('hide');
        })
    })

    $('#btn-delCategorie').click(function(){
        var idCategorie = $('#laCategorie').val();
        $.post('inc/forum/verifNoChildren.inc.php', {
            idCategorie
        }, function(resultat){
            var titre = 'Effacement de cette catégorie';
            if (resultat == 0) {
                bootbox.confirm({
                    'title': titre,
                    'message': 'Veuillez confirmer la <strong>suppression définitive</strong> de cette catégorie et de toutes les contributions des utilisateurs',
                    callback: function(result){
                        if (result == true) {
                            $.post('inc/forum/delCategorie.inc.php', {
                                idCategorie:idCategorie
                            }, function(resultat){
                                var resultatJS = JSON.parse(resultat);
                                var nbPosts = parseInt(resultatJS.nbPosts);
                                var nbSujets = parseInt(resultatJS.nbSujets)
                                bootbox.alert({
                                    'title': titre,
                                    'message': nbSujets + " sujet(s) et " + nbPosts + " contribution(s) effacé(s)"
                                });
                                $('#titreCategorie').text('');
                                $('#treeviewCategories ul li[data-idcategorie="' + idCategorie + '"]').remove();
                                var titrePosts = $('#libelle').data('defaulttext');
                                $('#libelle span').text(titrePosts);
                                $('#listePosts').html('');
                            })
                        }
                    }
                })
            }
            else {
                bootbox.alert({
                    'title': titre,
                    message: 'Cette catégorie possède des catégories "filles". Elle ne peut être effacée.'
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
        $.post('inc/forum/addSubject.inc.php', {
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
        $.post('inc/forum/modifSubject.inc.php', {
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
            var idCategorie = $('#modalIdCategorie').val();
            var formulaire = $('#formAddSubject').serialize();
            $.post('inc/forum/modalSaveSubject.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var idSujet = resultat;
                if (idSujet > 0) {
                    $('#modalAddSubject').modal('hide');
                    $.post('inc/forum/listeSujets.inc.php', {
                        idCategorie: idCategorie
                    }, function(resultat){
                        $('#listeSujets').html(resultat);
                        $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').trigger('click');
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
                    $.post('inc/forum/delSubject.inc.php', {
                        idSujet: idSujet,
                        idCategorie: idCategorie
                    }, function(resultat){
                        $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').remove();
                        $('#modifSubject').data('idcategorie','').data('idsujet','').data('sujet','').attr('disabled', true);
                        $('#delSubject').data('idcategorie','').data('idsujet','').data('sujet','').attr('disabled', true);
                        $('#listePosts').html('');
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
        $('#libelle span').html(sujet);
        $.post('inc/forum/verifProprio.inc.php', {
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
        $('#infoSubject').attr('disabled', false).data('idcategorie', idCategorie).data('idsujet', idSujet);
        $.post('inc/forum/getListePosts.inc.php', {
            idCategorie: idCategorie,
            idSujet: idSujet,
            sujet: sujet
        }, function(resultat){
            $('#listePosts').html(resultat);
        })
    })

    $('#infoSubject').click(function(){
        var idSujet = $(this).data('idsujet');
        var idCategorie = $(this).data('idcategorie');
        $.post('inc/forum/getModalInfoSubject.inc.php', {
            idSujet: idSujet,
            idCategorie: idCategorie
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalInfoSubject').modal('show');
        })
    })

    $('#btn-hideRepondre').click(function(){
        $('.repondre').toggleClass('hidden');
    })

    })


</script>
