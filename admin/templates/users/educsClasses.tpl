<div class="container">
    <h2>{if $identite.sexe == 'M'}M.{else}Mme{/if} {$identite.prenom} {$identite.nom}{if $classes|@count > 0}: éducateur référent pour {$classes|@count} classe(s){/if}</h2>

    <form name="educsClasses" id="educsClasses">
        <input type="hidden" name="acronyme" value="{$acronyme}" id="acronyme">
        <h3>Liste des classes</h3>
        <div class="row" id="listeClasses">

            {include file="users/listeGroupes.tpl"}

        </div>

        <button type="button" class="btn btn-lightBlue" name="buttonAdd" id="buttonAdd"><i class="fa fa-plus"></i> Ajouter une classe</button>

        <div class="btn-group pull-right">
            <button type="reset" name="buttonReset" id="btnReset" class="btn btn-default">Annuler</button>
            <button type="button" name="buttonSave" id="btnSave" class="btn btn-primary">Enregistrer</button>

        </div>
    </form>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#btnSave').click(function(){
            var acronyme = $('#acronyme').val();
            var formulaire = $('#educsClasses').serialize();
            $.post('inc/users/saveEducsClasses.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                bootbox.alert({
                    'title': 'Enregistrement',
                    'message': resultat,
                    'callback': function(){
                        $.post('inc/users/getClasses.inc.php', {
                            acronyme: acronyme
                        }, function(resultat){
                            $('#listeClasses').html(resultat);
                        })
                    }});
            })
        })

        $('#btnReset').click(function(){
            $('.input-group').each(function(){
                $(this).show();
            })
            $('input').attr('disabled', false);
        })

        $('#listeClasses').on('click', '.delGroupe', function(){
            $(this).closest('.input-group').hide().find('select').attr('disabled', true);
        })

        $('#buttonAdd').click(function(){
            $.post('inc/users/addClasseEduc.inc.php',
            {},
            function(resultat){
                $('#listeClasses').append(resultat);
            })
        })
    })

</script>
