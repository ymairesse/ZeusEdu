<div class="col-xs-6 col-md-3">

    <p class="notice">Veuillez sélectionner ci-dessous la liste des items à inclure dans le modèle de semaine de cours.</p>

    <div class="panel-body" style="height:25em; overflow: auto;">
        <form id="formCategories">

        <div class="checkbox">
            <label>
                <input type="checkbox" id="cbCategories" style="float: left; margin-right:0.5em">
                TOUT
            </label>
        </div>

        <ul class="list-unstyled">
        {foreach from=$listeCategories key=idCategorie item=categorie}
            <li>
                <div class="checkbox">
                    <label>
                        <input class="selectCategories" type="checkbox" name="categories[]" value="{$idCategorie}">
                        <span style="padding-left:0.5em">{$categorie}</span>
                    </label>
                </div>
            </li>
        {/foreach}
        </ul>
        </form>
    </div>

    <button type="button" class="btn btn-primary btn-block" id="btn-getSemaine">1. Générer la semaine <i class="fa fa-arrow-right"></i> </button>
    <button type="button" class="btn btn-success btn-block" id='btn-createGhost'>2. Créer le modèle</button>

    <input type="hidden" name="laDate" id="laDate" value="">

</div>

<div class="col-xs-6 col-md-6" id="ghost">

    {include file="jdc/ghostCalendar.tpl"}

</div>

<div class="col-xs-12 col-md-3" id="synthese">

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

        $('#cbCategories').change(function(){
            $('.selectCategories').trigger('click');
        })


    })

</script>
