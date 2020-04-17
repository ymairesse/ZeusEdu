<input type="hidden" name="type" id="type" value="{$type}">

{if isset($listeNiveaux)}
    {include file='agenda/include/listeNiveaux.tpl'}
{/if}

{if $type == 'ecole'}
    <p><i class="fa fa-check-square-o fa-2x"></i> Tous les élèves de l'école</p>
{/if}

{if $type == 'profs'}
    {include file='agenda/include/listeProfs.tpl'}
{/if}

<div id="sousNiveau">
</div>


<script type="text/javascript">

    $(document).ready(function(){

        var type = $('#type').val();

        $('#selectNiveau').change(function(){
            var niveau = $('#selectNiveau').val();

            switch (type) {
                case 'cours':
                    $.post('inc/agenda/listeCoursNiveau.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#sousNiveau').html(resultat);
                    });
                    break;
                case 'coursGrp':
                    $.post('inc/agenda/listeCoursGrpNiveau.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#sousNiveau').html(resultat);
                    });
                    break;
                case 'classe':
                    $.post('inc/agenda/listeClassesNiveau.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#sousNiveau').html(resultat);
                    });
                    break;
                case 'niveau':
                    $('#sousNiveau').html('<p><i class="fa fa-check-square-o fa-2x"></i> Tous les élèves de <strong>' + niveau + 'e</strong></p>');
                    break;
                }
        })

        $('#sousNiveau').on('change', '#cours', function(){
            var matiere = $(this).val();
            $.post('inc/agenda/listeElevesMatiere.inc.php', {
                matiere: matiere
            }, function(resultat){
                $('#detailsEleves').html(resultat);
            })
        })

        $('#sousNiveau').on('change', '#classe', function(){
            var classe = $(this).val();
            $.post('inc/agenda/listeElevesClasse.inc.php', {
                classe: classe
            }, function(resultat){
                $('#detailsEleves').html(resultat);
            })
        })

        $('#sousNiveau').on('change', '#coursGrp', function(){
            var coursGrp = $(this).val();
            $.post('inc/agenda/listeElevesCoursGrp.inc.php', {
                coursGrp: coursGrp
            }, function(resultat){
                $('#detailsEleves').html(resultat);
            })
        })
    })

</script>
