<div class="container-fluid">

    <div class="row">

        <div class="col-md-2 col-xs-12">

            <form id="formulaire" style="padding:0; border: 0">

                <h1>Choix d'élève</h1>

                <input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control">
                <input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">

                <select name="classe" id="selectClasse" class="form-control">
                    <option value="">Classe</option>
                    {foreach from=$listeClasses item=uneClasse}
                        <option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
                    {/foreach}
                </select>

                <span id="choixEleve">
                    {* include file="selecteurs/listeEleves.tpl" *}
                </span>

                <span id="ajaxLoader" class="hidden pull-right">
        			<img src="images/ajax-loader.gif" alt="loading" class="img-responsive">
        		</span>

                <button type="button" class="btn btn-primary btn-block" id="envoi">OK</button>

            </form>

        </div>

        <div class="col-xs-10 col-xs-12" id="ficheEleve">

            <p class="avertissement">Veuillez sélectionner un·e élève à gauche</p>

        </div>

    </div>

</div>

<div id="modal"></div>


<script type="text/javascript">

    function showListeEleves(classe){
        $.post('inc/listeEleves.inc.php',{
            classe: classe
            },
            function (resultat){
                $("#choixEleve").html(resultat);
                var matricule = Cookies.get('matricule');
                var test = $('#selectEleve option[value="'+matricule+'"]');
                if ($('#selectEleve option[value="' + matricule + '"]').val() == matricule)
                    $('#selectEleve').val(matricule);
            }
        )
    }

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

    message = "<p class=\"avertissement\">Veuillez sélectionner un·e élève à gauche</p>";

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        var classe = Cookies.get('classe');
        var matricule = Cookies.get('matricule');

        $('#selectClasse').val(classe);
        $('#selectEleve').val(matricule);

        showListeEleves(classe);
        generateFicheEleve(classe, matricule);

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

        $('#envoi').click(function(){
            var classe = $('#selectClasse').val();
            var matricule = $('#selectEleve').val();
            if (matricule != ''){
                generateFicheEleve(classe, matricule);
            }
            else $('#ficheEleve').html(message)
        })

        $("#selectClasse").change(function(){
            $('#nom').val('');
            // on a choisi une classe dans la liste déroulante
            var classe = $(this).val();
            if (classe != '') {
                Cookies.set('classe', classe);
                // la fonction showListeEleves renvoie la liste déroulante des élèves de la classe sélectionnée
                showListeEleves(classe);
                }
                else showListeEleves(' ');
        });

        $('body').on('change','#selectEleve', function(){
            $('#nom').val('');
            var matricule = $(this).val();
            if (matricule != ''){
                Cookies.set('matricule', matricule);
                var classe = $('#selectClasse').val();
                generateFicheEleve(classe, matricule);
                }
                else $('#ficheEleve').html(message);
            })

        $('#nom').on('keydown', function(){
			$('#selectEleve').val('');
			// $("#choixEleve").html('');
			$('#selectClasse').val('');
			})

		$('#nom').typeahead({
			minLength: 2,
			updater: function (item) {
				return item;
			},
			afterSelect: function(item){
				$.ajax({
					url: 'inc/searchMatricule.php',
					type: 'POST',
					data: 'query=' + item,
					dataType: 'text',
					async: true,
					success: function(matricule){
						if (matricule != '') {
							// var matricule = data;
							$.post('inc/eleves/detailsEleve.inc.php', {
								matricule: matricule
							}, function(resultat){
								var resultatJSON = JSON.parse(resultat);
                                var classe = resultatJSON['groupe'];
                                Cookies.set('classe', classe);
                                var matricule = resultatJSON['matricule'];
                                Cookies.set('matricule', matricule);
                                $('#selectClasse').val(classe);
                                $.post('inc/listeEleves.inc.php',{
                                    classe: classe
                                    },
                                    function (resultat){
                                        $("#choixEleve").html(resultat);
                                        $('#selectEleve').val(matricule);
                                        generateFicheEleve(classe, matricule)
                                    }
                                )
							})
							}
						}
					})
				},
			source: function(query, process){
				$.ajax({
					url: 'inc/searchNom.php',
					type: 'POST',
					data: 'query=' + query,
					dataType: 'JSON',
					async: true,
					success: function (data) {
						process(data);
						}
					}
					)
				}
			})

    })

</script>
