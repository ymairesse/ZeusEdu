<div class="container-fluid">

    <div id="trombinoscope">

    </div>
    <div id="ficheEleve">

    </div>


</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('body').on('click', '#saveEditedFait', function(){
            var formulaire = $("#editFaitDisc").serialize();
            $.post('inc/faits/saveFait.inc.php', {
                formulaire: formulaire
            }, function (matricule) {
                $.post('inc/eleves/generateFicheEleve.inc.php', {
                    matricule: matricule
                    },
                function(resultat){
                    $("#ficheEleve").show().html(resultat);
                    bootbox.alert('Fait disciplinaire enregistré');
                })
            })
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
                $("#formFait").html(resultat);
                $("#editFait").modal('show');
            })
        })

        $('body').on('click', '.print', function() {
            var idfait = $(this).data('idfait');
            $.post('inc/retenues/printRetenue.inc.php', {
                    idfait: idfait
                },
                function(resultat) {}
            )
        })

        $('body').on('click', '.newFait', function() {
            var type = $(this).data('typefait');
            var matricule = $(this).data('matricule');
            $.post('inc/faits/editFaitDisc.inc.php', {
                type: type,
                matricule: matricule
            }, function(resultat) {
                $("#formFait").html(resultat);
                $("#editFait").modal('show');
            })
        })

        $("#trombinoscope").on('click', '.unePhoto', function(){
            var matricule = $(this).data('matricule');
            $.post('inc/eleves/generateFicheEleve.inc.php', {
                matricule: matricule
                },
            function(resultat){
                $("#trombinoscope").hide();
                $("#ficheEleve").html(resultat).show();
            })
        })
    })
</script>
