<div id="listeCBprofs" style="height:15em; overflow: auto" class="col-sm-6">
    <label>Participants à ce sujet</label>
    {include file="forum/modal/listeCBprofs.tpl"}
</div>

<div id="listeCBeleves" class="col-sm-6">
    <select class="form-control" name="choixCibleEleve" id="choixCibleEleve">
        <option value="">Sélection des élèves</option>
        <option value="tous">Tous les élèves</option>
        <option value="niveau">Un niveau d'étude [{$listeAbonnes.niveau|@count|default:''}]</option>
        <option value="classe">Une classe [{$listeAbonnes.classe|@count|default:''}]</option>
        <option value="coursGrp">Un de vos cours [{$listeAbonnes.coursGrp|@count|default:''}]   </option>
    </select>

    <div id="listeNiveaux" style="height:10em; overflow:auto;" class="hidden sousSelection">
        <ul class="list-unstyled">
        {foreach from=$listeNiveaux item=niveau}
            <li>
                <div class="checkbox">
                    <label>
                        <input class="selecteurNiveau"
                            type="checkbox"
                            name="niveau[]"
                            value="{$niveau}"
                            {if isset($listeAbonnes.niveau.$niveau)} checked{/if}>
                        <span style="padding-left:0.5em">{$niveau}e année</span>
                    </label>
                </div>
            </li>
        {/foreach}
        </ul>
    </div>

    <div id="listeClasses" style="height:10em; overflow:auto;" class="hidden sousSelection">
        <ul class="list-unstyled">
        {foreach from=$listeClasses item=uneClasse}
            <li>
                <div class="checkbox">
                    <label>
                        <input class="selecteurClasses"
                            type="checkbox"
                            name="classe[]"
                            value="{$uneClasse}"
                            {if isset($listeAbonnes.classe.$uneClasse)} checked{{/if}}>
                        <span style="padding-left:0.5em">{$uneClasse}</span>
                    </label>
                </div>
            </li>
        {/foreach}
        </ul>
    </div>

    <div id="listeCoursGrp" style="height:10em; overflow:auto;" class="hidden sousSelection">
        <ul class="list-unstyled">
        {foreach from=$listeCoursGrp key=unCoursGrp item=dataCoursGrp}
            <li>
                <div class="checkbox">
                    <label>
                        <input class="selecteurCoursGrp"
                            type="checkbox"
                            name="coursGrp[]"
                            value="{$unCoursGrp}"
                            {if isset($listeAbonnes.coursGrp.$unCoursGrp)} checked{/if}>
                        <span style="padding-left:0.5em">{$unCoursGrp} - {$dataCoursGrp.libelle} {$dataCoursGrp.nomCours}</span>
                    </label>
                </div>
            </li>
        {/foreach}
        </ul>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#choixCibleEleve').change(function() {
            var selection = $('#choixCibleEleve').val();
            $('.sousSelection').addClass('hidden');
            switch (selection) {
                case 'tous':
                    // wtf
                    break;
                case 'niveau':
                    $('#listeNiveaux').removeClass('hidden');
                    break;
                case 'classe':
                    $('#listeClasses').removeClass('hidden');
                    break;
                case 'coursGrp':
                    $('#listeCoursGrp').removeClass('hidden');
                    break;
            }
        })

    })

</script>
