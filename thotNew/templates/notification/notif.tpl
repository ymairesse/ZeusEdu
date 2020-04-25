<div class="container-fluid">

    <ul class="nav nav-tabs">
    	<li class="active"><a data-toggle="tab" href="#newAnnonce" id="ongletEdit">Nouvelle annonce</a></li>
    	<li><a data-toggle="tab" href="#historique">Historique</a></li>
    </ul>

    <div class="tab-content">

    	<div id="newAnnonce" class="tab-pane fade in active row">

            <div class="col-md-3 col-sm-12" id="selecteur">
                {include file="notification/selecteurNew.tpl"}
            </div>

    		<div class="col-md-9 col-sm-12" id="editeur">
                {include file="notification/editeur.tpl"}
    		</div>
    	</div>

    	<div id="historique" class="tab-pane fade row">

            <div class="col-md-3 col-sm-12" id="selectHistorique">

                    {include file="notification/inc/selectFromHistorique.tpl"}

            </div>

            <div class="col-md-9 col-sm-12" id="details4type">
                <p class="avertissement">Veuillez sélectionner une catégorie</p>
            </div>

    	</div>

    </div>

</div>

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la lecture des accusés de réception          ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalAccuses.tpl"}


<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
    		$('#ajaxLoader').removeClass('hidden');
    		}).ajaxComplete(function() {
    			$('#ajaxLoader').addClass('hidden');
    		});

        // reconstruire l'onglet "historique" quand il est cliqué
        $('a[href="#historique"]').click(function(){
            $.post('inc/notification/refreshHistorique.inc.php', {
            }, function(resultat){
                $('#selectHistorique').html(resultat);
            })
        })

        // annulation de l'édition en cours
        $('#selecteur').on('click', '#annulEdit', function(){
            bootbox.confirm({
                title: "Attention",
                message: "<i class='fa fa-warning fa-2x' style='color:red'></i> Veuillez confirmer l'abandon de l'édition",
                callback: function(result){
                    if (result == true) {
                        $.post('inc/notification/putEditNotification.inc.php', {
                        }, function(resultat){
                            $('#editeur').html(resultat)
                        })
                        $.post('inc/notification/renewSelecteur.inc.php', {
                        }, function(resultat){
                            $('#selecteur').html(resultat);
                        })
                    }
                }
            })
        })

        // liste des boutons latéraux pour les types d'annonces
        $('#selectHistorique').on('click', '.btn-type', function(){
            var type = $(this).data('type');
            $.post('inc/notification/getDetailsNotif4type.inc.php', {
                type: type
            }, function (resultat){
                $('#details4type').html(resultat);
            })
        })

        $("#formNotification").validate({
            // pour ne pas ignorer le "textarea" qui sera caché
            ignore: [],
            rules: {
                texte: {
                    required: function(){
                        CKEDITOR.instances['texte'].updateElement();
                    },
                    minlength: 20
                },
                objet: {
                    required: true
                    },
                dateDebut: {
                    required: true,
                    minlength: 10
                    },
                dateFin: {
                    required: true,
                    minlength: 10
                    },
                'membres[]': {
                    required: true,
                    minlength: 1
                    },
                },
            messages: {
                'objet': 'Veuillez indiquer un objet pour votre annonce',
                'membres[]': 'Sélectionner au moins un élève',
                'texte': 'Un texte significatif svp',
                },
            errorPlacement: function(error, element) {
                if (element.hasClass('cb')){
                    error.insertBefore(element.closest('ul'));
                    }
                    else {
                        error.insertAfter(element);
                    }
                }
        });

        // Enregistrement d'une annonce
        $('#editeur').on('click', '#submitNotif', function(){
    		if ($('#formNotification').valid()){
    			var formEdit = $('#formNotification').serialize();
                var texte = CKEDITOR.instances.texte.getData();
    			var formSelect = $('#formSelecteur').serialize();
                var type = ($('#TOUS').val() == 'TOUS') ? $('#type').val() : 'eleves';
    			$.post('inc/notification/saveNotification.inc.php', {
    				formEdit: formEdit,
                    texte: texte,
    				formSelect: formSelect
    			}, function(resultat){
                    $('#submitNotif').attr('disabled', true);
                    // réinitialiser le sélecteur principal
                    $('#selectPrincipal').val('').trigger('change');
                    // activer l'onglet "historique"
                    $('a[href="#historique"]').trigger('click');
                    // rafraîchir la liste des notifications pour le type modifié
                    $('.btn-type[data-type="' + type + '"]').trigger('click');
    				bootbox.alert({
    					title: 'Envoi d\'une annonce',
    					message: resultat
    				})
    			})
    		}
    	})

        // quand on change de niveau d'étude
        $('#selecteur').on('change', '#niveau', function(){
            var niveau = $(this).val();
            $('#formEleves').html('');
            if (niveau != '') {
                var type = $('#selectPrincipal').val();
                switch (type) {
                    case 'cours':
                        // $('button[data-type="niveau"]').prop('disabled', true);
                        $('#submitNotif').prop('disabled', true);
                        $('#mail').prop('disabled', true).prop('checked', false);
                        $('#accuse').prop('disabled', true);
                        $('#parent').prop('disabled', true).prop('checked', false);
                        $('#destinataire').val('');
                        $.post('inc/getListeMatieres.inc.php', {
                            niveau: niveau
                        }, function(resultat){
                            $('#formMatieres').html(resultat).removeClass('hidden');
                        })
                        break;
                    case 'niveau':
                        // $('button[data-type="niveau"]').prop('disabled', false);
                        $('#submitNotif').prop('disabled', false);
                        $('#mail').prop('disabled', true).prop('checked', false);
                        $('#accuse').prop('disabled', false);
                        $('#parent').prop('disabled', true).prop('checked', false);
                        $('#destinataire').val(niveau);
                        $('#cible').html(' aux élèves de ' + niveau + 'e année');
                        break;
                    case 'classes':
                        //$('button[data-type="niveau"]').prop('disabled', true);
                        $('#submitNotif').prop('disabled', true);
                        $('#mail').prop('disabled', true).prop('checked', false);
                        $('#accuse').prop('disabled', true);
                        $('#parent').prop('disabled', true).prop('checked', false);
                        $('#selectEleves').hide();
                        $('#destinataire').val('');
                        $.post('inc/getListeClasses.inc.php', {
                            niveau: niveau
                        }, function(resultat){
                            $('#formClasses').html(resultat).removeClass('hidden');
                        });
                        break;
                    }
                }
                else {
                    $('#submitNotif').prop('disabled', true);
                    $('#formClasses').html('');
                    $('#formMatieres').html('');
                    $('#destinataire').val('');
                }
            });

        // le bouton "Inverser" a été cliqué
        $('#selecteur').on('click', '#btnInv', function(){
            var n = 0;
            $('#formEleves input.eleve').each(function(){
                $(this).prop('checked', !$(this).prop('checked'));
                n++;
            });
            var nb = $('.eleve:checkbox:checked').length;
            if (nb == n)
                $('#TOUS').val('TOUS');
                else $('#TOUS').val('');
            $('#nbDestinataires').text(nb + ' destinataire(s)');
            if (nb != 0) {
                $('#formEleves button[data-type="eleve"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                }
                else {
                    $('#formEleves button[data-type="eleve"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                }
        })

        // le bouton "TOUS" a été actionné
        $('#selecteur').on('click', '#btnTous', function(){
            $('#formEleves input.eleve').each(function(){
                $(this).prop('checked', true);
            });
            var nb = $('.eleve:checkbox:checked').length;
            $('#nbDestinataires').text(nb + ' destinataire(s)');
            $('#TOUS').val('TOUS');
            $('#formEleves button[data-type="eleve"]').prop('disabled', false);
            $('#submitNotif').prop('disabled', false);
            $('#cible').html(' à tous les élèves');
        })

        // le checkbox d'un élève précis a été modifié
        $('#selecteur').on('change', '.eleve', function(){
            // combien de cases à cocher disponibles
            var nbCheck = $('.eleve:checkbox').length;
            // combien sont cochées
            var nb = $('.eleve:checkbox:checked').length;
            $('#nbDestinataires').text(nb + ' destinataire(s)');
            if (nb == nbCheck)
                $('#TOUS').val('TOUS');
                else $('#TOUS').val('');
            if (nb != 0){
                $('#formEleves button[data-type="eleve"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                }
                else {
                    $('#formEleves button[data-type="eleve"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                }
        })

        // la sélection du coursGrp a été modifiée
        $('#selecteur').on('change', '#coursGrp', function(){
            var coursGrp = $(this).val();
            $('#destinataire').val(coursGrp);
            $('#TOUS').val('TOUS');
            if (coursGrp != '') {
                $('button[data-type="coursgrp"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                $('#mail').prop('disabled', false);
                $('#accuse').prop('disabled', false);
                $('#parent').prop('disabled', false);
                $('#cible').html(' au cours '+coursGrp);
                }
                else {
                    $('button[data-type="coursgrp"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                    $('#mail').prop('disabled', true);
                    $('#accuse').prop('disabled', true);
                    $('#parent').prop('disabled', true);
                    $('#selectEleves').hide();
                    $('#cible').html('');
                    }
            $.post('inc/getListeEleves.inc.php', {
                type: 'coursGrp',
                coursGrp: coursGrp
            }, function(resultat){
                $('#formEleves').html(resultat).removeClass('hidden');
                })
            })

        // la sélection du groupe a été modifiée
        $('#selecteur').on('change', '#groupe', function(){
            var groupe = $(this).val();
            $('#destinataire').val(groupe);
            $('#TOUS').val('TOUS');
            if (groupe != '') {
                $('button[data-type="groupe"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                $('#accuse').prop('disabled', false);
                $('#mail').prop('disabled', false);
                $('#parent').prop('disabled', true).prop('checked', true);
                $('#cible').html(' au groupe '+ groupe);
                }
                else {
                    $('button[data-type="groupe"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                    $('#mail').prop('disabled', true);
                    $('#accuse').prop('disabled', true);
                    $('#parent').prop('disabled', true);
                    $('#cible').html('');
                    }
            $.post('inc/getListeEleves.inc.php', {
                type: 'groupe',
                groupe: groupe
            }, function(resultat){
                $('#formEleves').html(resultat).removeClass('hidden');
                })
            })

        // la sélection de la classe a été modifiée
        $('#selecteur').on('change', '#selectClasse', function(){
            var classe = $(this).val();
            $('#destinataire').val(classe);
            $('#TOUS').val('TOUS');
            if (classe != '') {
                $('button[data-type="classes"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                $('#accuse').prop('disabled', false);
                $('#mail').prop('disabled', false);
                $('#parent').prop('disabled', false).prop('checked', false);
                $('#cible').html(' à la classe '+ classe);
                }
                else {
                    $('button[data-type="classes"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                    $('#accuse').prop('disabled', true);
                    $('#parent').prop('disabled', true).prop('checked', false);
                    $('#mail').prop('disabled', true);
                    $('#cible').html('');
                    }
            $('#formEleves').removeClass('hidden');
            $.post('inc/getListeEleves.inc.php', {
                type: 'classes',
                classe: classe
            }, function(resultat){
                $('#formEleves').html(resultat).removeClass('hidden');
            })
        })

        // la sélection de la matière a été modifiée
        $('#selecteur').on('change', '#selectMatiere', function(){
            var matiere = $(this).val();
            $('#destinataire').val(matiere);
            $('#TOUS').val('TOUS');
            if (matiere != '') {
                $('button[data-type="matiere"]').prop('disabled', false);
                $('#submitNotif').prop('disabled', false);
                $('#accuse').prop('disabled', false);
                $('#parent').prop('disabled', false).prop('checked', false);
                $('#mail').prop('disabled', false);
                $('#cible').html(' à tous les élèves de ' + matiere);
                }
                else {
                    $('button[data-type="matiere"]').prop('disabled', true);
                    $('#submitNotif').prop('disabled', true);
                    $('#accuse').prop('disabled', true);
                    $('#parent').prop('disabled', true).prop('checked', false);
                    $('#mail').prop('disabled', true);
                    $('#cible').html('');
                    }
            })

        // modification du sélecteur principal de type de destinataire d'annonce
        $('#selecteur').on('change', '#selectPrincipal', function(){
            var type = $(this).val();
            // noter le "type" dans la zone de l'éditeur
            $('#type').val(type);
            $('.sousSelecteur').addClass('hidden').find('select').val('');
            $('#TOUS').val('TOUS');
            // désélectionner les élèves éventuellement déjà sélectionnés antérieurement
            $('#selectEleve').html('');
            switch (type) {
                case 'cours':
                    $('#formNiveau').removeClass('hidden');
                    $('#submitNotif').prop('disabled', true);
                    $('#destinataire').val('');
                    break;
                case 'ecole':
                    $('#submitNotif').prop('disabled', false);
                    $('#accuse').prop('disabled', true).prop('checked', false);
                    $('#parent').prop('disabled', true).prop('checked', false);
                    $('#mail').prop('disabled', true).prop('checked', false);
                    $('#destinataire').val('ecole');
                    $('#cible').html(' tous les élèves');
                    break;
                case 'coursGrp':
                    $('#formCoursGrp').removeClass('hidden');
                    $('#submitNotif').prop('disabled', true);
                    $('#destinataire').val('');
                    break;
                case 'niveau':
                    $('#formNiveau').removeClass('hidden');
                    $('#submitNotif').prop('disabled', true);
                    $('#destinataire').val('');
                    break;
                case 'classes':
                    $('#formNiveau').removeClass('hidden');
                    $('#submitNotif').prop('disabled', true);
                    $('#destinataire').val('');
                    break;
                case 'groupe':
                    $('#formGroupes').removeClass('hidden');
                    $('#submitNotif').prop('disabled', true);
                    $('#destinataire').val('');
                    break;
            }
        })
    })

</script>
