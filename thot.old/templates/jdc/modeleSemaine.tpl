<div class="col-xs-12 col-sm-4 col-md-3">

    <p class="notice">1. Veuillez sélectionner ci-dessous la liste des items à inclure dans le modèle de semaine de cours.</p>

    <div class="panel-body" style="height:25em; overflow: auto;">
        <form id="formCategories">

        <ul class="list-unstyled">
        {foreach from=$listeCategories key=idCategorie item=categorie}
            <li>
                <div class="checkbox">
                    <label>
                        <input class="selectCategories" type="checkbox" name="categories[]" value="{$idCategorie}" checked>
                        <span style="padding-left:0.5em">{$categorie}</span>
                    </label>
                </div>
            </li>
        {/foreach}
        </ul>
        </form>
    </div>

    <input type="hidden" name="laDate" id="laDate" value="">

</div>

<div class="col-xs-12 col-sm-8 col-md-6" id="ghost">

    <p class="notice"><span>2. Sélectionnez ci-dessous le semainier type en parcourant votre journal de classe</span></p>

    {include file="jdc/ghostCalendar.tpl"}

</div>

<div class="col-xs-12 col-sm-12 col-md-3">

    <p class="notice">3. Terminez en confirmant vos choix pour la création du modèle</p>

    <button type="button" class="btn btn-success btn-block" id='btn-createGhost'>Créez le modèle</button>

    <div id="synthese" style="padding-bottom: 2em;">

    </div>

</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-createGhost').click(function(){
            var view = $('#ghostCalendar').fullCalendar('getView');
            var start = view.start.format();
            var end = view.end.format();
            var formulaire = $('#formCategories').serialize();
            $.post('inc/jdc/generateModele.inc.php', {
                formulaire: formulaire,
                start: start,
                end: end
            }, function(nb){
                bootbox.alert({
                    title: 'Enregistrement',
                    message: nb + ' plage(s) horaire(s) enregistrée(s)'
                })
                $.post('inc/jdc/getGhost.inc.php', {
                }, function(resultat){
                    $('#synthese').html(resultat);
                })
            })
        })

        $('#btn-getSemaine').click(function(){
            var laDate = $('#laDate').val();
            $.post('inc/jdc/getModeleSemaine.inc.php', {
            }, function(resultat){
                $('#ghost').html(resultat);
                $('#ghostCalendar').fullCalendar('gotoDate', laDate);
            })
        })

        $('.selectCategories').change(function(){
            var categorie = $(this).val();
            $('.cat_'+categorie).toggleClass('hidden');

            var events = {
                url: 'inc/jdc/events4modele.json.php',
                type: 'POST',
                data: {
                    categories: $('.selectCategories').serialize()
                    }
                };
            $('#ghostCalendar').fullCalendar('removeEventSources');
			$('#ghostCalendar').fullCalendar('addEventSource', events);
        })

    })

</script>
