<style media="screen">
    blockquote {
        color: #333;
        border-left: 5px solid #ccc;
        font-size: 10pt;
        padding: 10px;
    }

    h1 {
    	color: #333;
    	background-color: pink;
    	text-align: left;
        padding: 0.2em 0em 0.2em 0.5em;
    }

    h2 {
    	color: #663;
    	background-color: #b6b6f0 !important;
    	background-image: unset;
    	padding: 0.2em 0em 0.2em 1em;
    }

</style>

<div class="container-fluid">

    <div class="row">

        <div class="col-md-4 col-xs-12">

            <div id="ajaxLoader" class="hidden">
                <img src="images/ajax-loader.gif" alt="loading" class="center-block">
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    Gestion des sujets
                </div>

                <div class="panel-body">

                    {if $userStatus == 'admin'}
                        <!-- Seuls les admins peuvent créer des catégories -->
                        <button type="button" class="btn btn-danger btn-block" id="btn-categories">Gestion des catégories</button>
                    {/if}
                    <button type="button" class="btn btn-success btn-block" id="btn-createSubject">Créer un sujet</button>

                    <div id="listeSujets" style="max-height:35em; overflow:auto;">
                        {include file="forum/listeSujets.tpl"}
                    </div>

                </div>

                <div class="panel-footer">
                    <div class="btn-group btn-group-justified">
                        <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs" id="modifSubject" title="Modifier le sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-edit"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs " id="delSubject" title="Supprimer un sujet" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-times"></i></a>
                        <a href="javascript:void(0)" type="button" class="btn btn-warning btn-xs" id="infoSubject" title="Informations" data-container="body" data-idsujet="" data-idcategorie="" disabled><i class="fa fa-info"></i></a>
                    </div>
                </div>

            </div>

        </div>

        <div class="col-md-8 col-xs-12">

            <div class="panel panel-info">
                <div class="panel-heading" id="libelle" data-defaulttext="Liste des contributions">
                    <span id="titreSujet">Liste des contributions</span>
                        <button type="button" tabindex=2" class="btn btn-danger btn-xs pull-right" name="button" id="findPostId" title="Chercher le postId"><i class="fa fa-search"></i></button>
                        <input type="text" tabindex=1" name="postId" id="postId" value="" style="font-size:8pt;width:5em;" maxlength="6" class="pull-right" placeholder="postId">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-success btn-xs" id="btn-hideRepondre" title="Cacher les boutons"><i class="fa fa-eye-slash"></i></button>
                        <button type="button" class="btn btn-warning btn-xs" id="btn-allText" title="Texte continu"><i class="fa fa-text-height"></i></button>
                        <button type="button" class="btn btn-info btn-xs" id="btn-date" disabled><i class="fa fa-calendar"></i> <span id="laDate">Date</span></button>
                    </div>
                    <div class="clearfix"></div>
                </div>

                <div class="panel-body" id="listePosts" style="height:45em; overflow:auto;">
                    <p class="avertissement">Veuillez choisir parmi vos sujets ou créer un nouveau sujet ci-contre</p>
                </div>

            </div>

        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        // pour les boîtes de dialogue modales de gestion des sujets et des catégories
        $('#modal').on('click', '.treeview a', function(e){
            var noeud = $(this).closest('li');
            noeud.find('a').eq(0).next('ul').toggleClass('hidden');
            noeud.find('a').eq(0).prev('i').toggleClass('fa-caret-down').toggleClass('fa-caret-right');
        })

        // recherche du post $postId
        $('#findPostId').click(function(){
            var postId = $('#postId').val();
            $.post('inc/forum/getCatSubject.inc.php', {
                postId: postId
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                var idCategorie = resultatJS.idCategorie;
                var idSujet = resultatJS.idSujet;

                // ouverture du panneau conenant le bouton si nécessaire
                if (!$('#listeSujets button[data-idsujet="'+idSujet+'"][data-idcategorie="'+idCategorie+'"]').closest('.collapse').hasClass('in'))
                    $('#listeSujets button[data-idsujet="'+idSujet+'"][data-idcategorie="'+idCategorie+'"]').closest('.collapse').prev().find('a').trigger('click');
                // clic virtuel sur le bouton pour ouvrir le sujet
                $('.btn-sujet').removeClass('active');
                $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').addClass('active');
                // affichage asynchrone pour être sûr que le panneau est ouvert avant la mise en évidence du post
                $.post('inc/forum/getListePosts.inc.php', {
                    idCategorie: idCategorie,
                    idSujet: idSujet
                }, function(resultat){
                    $('#listePosts').html(resultat);
                    $('#post_' + postId).addClass('active');
                })
            })
        })

        // pour le 1/3 bouton "Création de sujet"
        $('#btn-createSubject').click(function(){
            $.post('inc/forum/gestSujets.inc.php', {},
                function(resultat){
                    $('#modal').html(resultat);
                    $('#modalGestSujets').modal('show');
                })
        })
        // boîte modale de création effective du sujet
        $('#modal').on('click', '#btn-createSubject', function(){
            if ($('#formCreateSubject').valid()){
                var sujet = $('#formCreateSubject #sujet').val();
                var categorie = $('#formCreateSubject #categorie').val();
                var idCategorie = $('#formCreateSubject #idCategorie').val();
                var formulaire = $('#formCreateSubject').serialize();
                $.post('inc/forum/modalSaveSubject.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    resultatJS = JSON.parse(resultat);
                    var nbAcces = resultatJS.nbAcces;
                    var idSujet = resultatJS.idSujet;
                    bootbox.alert({
                        title: 'Création d\'un sujet',
                        message: 'Création du sujet <strong>' + sujet + '</strong> ['+ categorie +']<br>avec ' + nbAcces + ' accès créé(s)'
                    });
                    $('#modalGestSujets').modal('hide');
                    $.post('inc/forum/listeSujets.inc.php', {
                        idCategorie: idCategorie
                    }, function(resultat){
                        $('#listeSujets').html(resultat);
                        $('a[data-toggle="collapse"]').trigger('click')
                        $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').trigger('click');
                    })
                })
            }
        })

        // ouverture de la boîte modale pour la gestion des catégories
        $('#btn-categories').click(function(){
            $.post('inc/forum/gestCategories.inc.php', {},
                function(resultat){
                    $('#modal').html(resultat);
                    $('#modalGestCategories').modal('show')
                })
            })

        $('#modal').on('click', '#btn-delCategorie', function(){
            var title = 'Supprimer une catégorie';
            var nomCategorie = $('#categorie').val();
            bootbox.confirm({
                title: title,
                message: 'La suppression de la catégorie <strong>' + nomCategorie + '</strong> sera définitive',
                callback: function(resultat){
                    if (resultat == true){
                        var idCategorie = $('#idCategorie').val();
                        $.post('inc/forum/tryDeleteCategorie.inc.php', {
                            idCategorie: idCategorie
                        }, function(resultat){
                            var resultatJS = JSON.parse(resultat);
                            var nb = resultatJS.nb;
                            var message = resultatJS.message;
                            bootbox.alert({
                                title: title,
                                message: message,
                            });
                            if (nb == 1) {
                                $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"]').remove();
                                }
                        })
                    }
                }
            })
        })

        // renommer une catégorie
        $('#modal').on('click', '#btn-renameCategorie', function(){
            bootbox.prompt({
                title: 'Nouveau nom pour cette catégorie',
                value: $('#categorie').val(),
                maxlength: 40,
                callback: function(resultat){
                    if (resultat != null){
                        var newName = resultat;
                        var idCategorie = $('#idCategorie').val();
                        var userStatus = $('#userStatus').val();
                        $.post('inc/forum/tryRenameCategorie.inc.php', {
                            name: newName,
                            idCategorie: idCategorie,
                            userStatus: userStatus
                        }, function(resultat){
                            if (resultat == 1){
                                $('a[data-idcategorie="' + idCategorie + '"]').text(newName);
                                $('#categorie').val(newName);
                            }
                            bootbox.alert({
                                title: 'Enregistrement',
                                message: ((resultat == 0) ? 'Aucune' : resultat) + ' modification',
                                })
                            })
                        }
                    }
                })
            })
        // création effective de la nouvelle catégorie
        $('#modal').on('click', '#btnNewCategorie', function(){
            var newCategorie = $('#sousCategorie').val().trim();
            if (newCategorie != '') {
                var userStatus = $('#userStatus').val();
                var idCategorie = $('#idCategorie').val();
                // est-ce un nœud dans l'arborescence?
                var noeud = $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"').hasClass('tree-branch');
                $.post('inc/forum/tryCreateCategorie.inc.php', {
                    newCategorie: newCategorie,
                    parentId: idCategorie,
                    userStatus: userStatus,
                    noeud: noeud
                }, function(resultat){
                    resultatJS = JSON.parse(resultat);
                    var OK = resultatJS.OK;
                    if (OK == true) {
                        console.log(resultatJS.li);
                        if (noeud == true) {
                            $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"]').find('ul').append(resultatJS.li);
                            }
                            else {
                                $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"]').addClass('tree-branch');
                                $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"]').prepend('<i class="tree-indicator fa fa-lg fa-caret-right"></i>');
                                $('#modalListeCategories .treeview li[data-idcategorie="' + idCategorie + '"]').append(resultatJS.li)
                            }
                        }
                        else {
                            bootbox.alert({
                                title: 'Nouvelle catégorie',
                                message: 'Cette catégorie existe déjà'
                            })
                        }
                })
            }

        })

        var dateForum = Cookies.get('dateForum');
        $('#btn-date #laDate').text(dateForum);

        $('#btn-date').click(function(){
            var laDate = $(this).text();
            $.post('inc/forum/modalChoixDate.inc.php', {
                laDate: laDate
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalDate').modal('show');
            })
        })

        $('#btn-allText').click(function(){
            $('.postForum').toggleClass('em8');
            if ((Cookies.get('texteSuivi') == undefined) || (Cookies.get('texteSuivi') == "false"))
                Cookies.set('texteSuivi', "true", { expires : 7 })
                else Cookies.set('texteSuivi', "false", { expires : 7 })
        })

        $('#modal').on('click', '#btn-confirmDate', function(){
            var laDate = $('#dateForum').val();
            $('.postForum').removeClass('active');
            if (laDate != '') {
                Cookies.set('dateForum', laDate, { expires: 7 });
                $('#btn-date #laDate').text(laDate);
                var laDate = laDate.substr(0,5);
                $('.postForum[data-date="' + laDate +'"]').addClass('active');
                }
                else {
                    $('#btn-date #laDate').text('Date');
                }
            $('#modalDate').modal('hide');
        })
        // mise en évidence d'un post par clic
        $('#listePosts').on('click', '.postForum', function(){
            $(this).toggleClass('active');
        })

        // boîte modale pour l'effacement d'un post
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
                }
                else {
                    $('.postForum[data-postid="' + postId + '"]').remove();
                    $('.repondre[data-postid="' + postId + '"]').remove();
                }
                $('#modalDelPost').modal('hide');
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
            scrollTop: $("#postId_"+postId).offset().top,
            },
            'slow'
        )}

    // initialisation d'un sujet à sa racine
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
                $.post('inc/forum/mail4NewPost.inc.php', {
                    formulaire: formulaire,
                    postId: postId
                }, function(){
                });
                $('#modalAnswerPost').modal('hide');
                goToByScroll(postId);
            })
        }
    })

    // boîte modale pour la modification d'un post
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
    // enregistrement effectif d'un post
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
                goToByScroll(postId);
            })
        }
    })

    // sélection d'une catégorie avec présentation du choix des sujets existants
    // pour la catégorie
    // $('#treeviewCategories').on('click', '.treeview li a', function(){
    //     $('.treeview li a').removeClass('active');
    //     $(this).addClass('active');
    //     var idCategorie = $(this).data('idcategorie');
    //     if (idCategorie != 0) {
    //         $('#btn-renameCategorie').attr('disabled', false);
    //         $('#btn-delCategorie').attr('disabled', false);
    //         $('#addSubject').attr('disabled', false);
    //         }
    //         else {
    //             $('#btn-renameCategorie').attr('disabled', true);
    //             $('#btn-delCategorie').attr('disabled', true);
    //             $('#addSubject').attr('disabled', true);
    //             $('#modifSubject').attr('disabled', true);
    //             $('#delSubject').attr('disabled', true);
    //         }
    //     var libelleCategorie = $(this).html();
    //     var userStatus = $(this).data('userstatus');
    //     $('#userStatus').val(userStatus);
    //     $('#laCategorie').val(idCategorie);
    //     })


    // $('#addCategorie').click(function(){
    //     var idParent = $('#laCategorie').val();
    //     var libelle = $('a[data-idcategorie="'+ idParent +'"]').text();
    //     var userStatus = $('#userStatus').val();
    //     $.post('inc/forum/addCategorie.inc.php', {
    //         idParent: idParent,
    //         libelle: libelle,
    //         userStatus: userStatus
    //     }, function(resultat){
    //         $('#modal').html(resultat);
    //         $('#modalAddCategorie').modal('show');
    //     })
    // })

    // $('#modal').on('click', '#btnModalSaveCategorie', function(){
    //     if($('#formAddCategorie').valid()) {
    //         var libelle = $('#modalLibelle').val();
    //         var formulaire = $('#formAddCategorie').serialize();
    //         var idCategorie;
    //         var title = 'Enregistrement d\'une catégorie';
    //         $.post('inc/forum/modalSaveCategorie.inc.php', {
    //             formulaire: formulaire
    //         }, function(resultat){
    //             var idCategorie = resultat;
    //             if (idCategorie > 0) {
    //                 $('#modalAddCategorie').modal('hide');
    //                 $.post('inc/forum/refreshTreeviewCategories.inc.php', {
    //                 },
    //                 function(resultat){
    //                     $('#treeviewCategories').html(resultat);
    //                     // activer l'item qui vient d'être créé
    //                      $('li a[data-idcategorie="' + idCategorie + '"').trigger('click');
    //                 });
    //                 bootbox.alert({
    //                     'title': title,
    //                     'message': 'Enregistrement de la catégorie "' + libelle +'" réussi'
    //                     })
    //                 }
    //             else bootbox.alert({
    //                 'title': title,
    //                 'message': 'La catégorie "' + libelle + '" existe déjà'
    //             });
    //             })
    //         }
    //     })

    // $('#btn-renameCategorie').click(function(){
    //     var idCategorie = $('#laCategorie').val();
    //     var libelle = $('a[data-idcategorie="'+ idCategorie +'"]').text();
    //     $.post('inc/forum/modalRenameCategorie.inc.php', {
    //         idCategorie: idCategorie,
    //         libelle: libelle,
    //     }, function(resultat){
    //         $('#modal').html(resultat);
    //         $('#modalEditCategorie').modal('show');
    //     })
    // })
    //
    // $('#modal').on('click', '#btnModalRenameCategorie', function(){
    //     var formulaire = $('#formRenameCategorie').serialize();
    //     var libelle = $('#modalLibelle').val();
    //     var idCategorie;
    //     $.post('inc/forum/renameCategorie.inc.php', {
    //         formulaire: formulaire
    //     }, function(idCategorie){
    //         // le résultat est idCategorie (c'est OK) ou -1 (pas de changement effectué)
    //         if (idCategorie == -1) {
    //         bootbox.alert({
    //             title: 'Changement de nom',
    //             message: 'Le nouveau nom "<strong>' + libelle+ '</strong>" pour cette catégorie n\'a pas été accepté. Est-il déjà utilisé?',
    //             })
    //         }
    //         else {
    //             $('#treeviewCategories li a[data-idcategorie="' + idCategorie + '"]').text(libelle);
    //         }
    //         $('#modalEditCategorie').modal('hide');
    //     })
    // })

    // $('#btn-delCategorie').click(function(){
    //     var idCategorie = $('#laCategorie').val();
    //     $.post('inc/forum/verifNoChildren.inc.php', {
    //         idCategorie
    //     }, function(resultat){
    //         var titre = 'Effacement de cette catégorie';
    //         if (resultat == 0) {
    //             bootbox.confirm({
    //                 'title': titre,
    //                 'message': 'Veuillez confirmer la <strong>suppression définitive</strong> de cette catégorie et de toutes les contributions des utilisateurs',
    //                 callback: function(result){
    //                     if (result == true) {
    //                         $.post('inc/forum/delCategorie.inc.php', {
    //                             idCategorie:idCategorie
    //                         }, function(resultat){
    //                             var resultatJS = JSON.parse(resultat);
    //                             var nbPosts = parseInt(resultatJS.nbPosts);
    //                             var nbSujets = parseInt(resultatJS.nbSujets)
    //                             bootbox.alert({
    //                                 'title': titre,
    //                                 'message': nbSujets + " sujet(s) et " + nbPosts + " contribution(s) effacé(s)"
    //                             });
    //                             $('#titreCategorie').text('');
    //                             $('#treeviewCategories ul li[data-idcategorie="' + idCategorie + '"]').remove();
    //                             var titrePosts = $('#libelle').data('defaulttext');
    //                             $('#libelle span').text(titrePosts);
    //                             $('#listePosts').html('');
    //                         })
    //                     }
    //                 }
    //             })
    //         }
    //         else {
    //             bootbox.alert({
    //                 'title': titre,
    //                 message: 'Cette catégorie possède des catégories "filles". Elle ne peut être effacée.'
    //             })
    //         }
    //     })
    // })

    // $('.btn-cat').click(function(){
    //     var userStatus = $(this).data('userstatus');
    //     switch (userStatus) {
    //         case 'all':
    //             $('#treeviewCategories ul li.profs').show('slow');
    //             $('#treeviewCategories ul li.eleves').show('slow');
    //             break;
    //         case 'eleves':
    //             $('#treeviewCategories ul li.eleves').toggle('slow');
    //             break;
    //         case 'profs':
    //             $('#treeviewCategories ul li.profs').toggle('slow');
    //             break;
    //     }
    // })

    // ajout d'un nouveau sujet dans la catégorie sélectionnée
    // $('#addSubject').click(function(){
    //     var idCategorie = $('#laCategorie').val();
    //     $.post('inc/forum/addSubject.inc.php', {
    //         idCategorie
    //     }, function(resultat){
    //         $('#modal').html(resultat);
    //         $('#modalAddSubject').modal('show');
    //     })
    // })

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
            $('#modalGestSujets').modal('show');
        })
    })

    // $('#modal').on('click', '#btnModalSaveSubject', function(){
    //     if ($('#formAddSubject').valid()) {
    //         var sujet = $('#modalSubject').val();
    //         var idCategorie = $('#modalIdCategorie').val();
    //         var formulaire = $('#formAddSubject').serialize();
    //         $.post('inc/forum/modalSaveSubject.inc.php', {
    //             formulaire: formulaire
    //         }, function(resultat){
    //             var idSujet = resultat;
    //             if (idSujet > 0) {
    //                 $('#modalAddSubject').modal('hide');
    //                 $.post('inc/forum/listeSujets.inc.php', {
    //                     idCategorie: idCategorie
    //                 }, function(resultat){
    //                     $('#listeSujets').html(resultat);
    //                     $('.btn-sujet[data-idcategorie="' + idCategorie +'"][data-idsujet="' + idSujet +'"]').trigger('click');
    //                 })
    //             }
    //         })
    //     }
    // })

    // suppression d'un sujet après action sur le bouton 1/3 #delSubect
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
                        $('#titreSujet').text($('#libelle').data('defaulttext'));
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

        $('#titreSujet').html(sujet);
        $('#btn-date').attr('disabled', false);
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
            idSujet: idSujet
        }, function(resultat){
            $('#listePosts').html(resultat);
            var dateForum = Cookies.get('dateForum');
            if (dateForum != undefined) {
                var dateForum = dateForum.substr(0,5);
                $('.postForum[data-date="' + dateForum +'"]').addClass('active');
            }
            var texteSuivi = Cookies.get('texteSuivi');
            if (texteSuivi == "false"){
                $('.postForum').addClass('em8');
            }
        })
    })

    // bouton 1/3 informations sur le sujet
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
