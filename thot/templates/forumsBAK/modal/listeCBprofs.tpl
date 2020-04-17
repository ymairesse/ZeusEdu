<div class="checkbox">
    <label>
        <input type="checkbox" id="cbProfs" style="float: left; margin-right:0.5em">
        TOUS
    </label>
</div>

<ul class="list-unstyled">
{foreach from=$listeProfs key=acronyme item=unProf}
    <li>
        <div class="checkbox">
            <label>
                <input class="selecteurEleve"
                    type="checkbox"
                    name="acronyme[]"
                    value="{$acronyme}"
                    {if isset($listeAbonnes.prof.$acronyme)} checked{/if}>
                <span style="padding-left:0.5em">{$unProf.nom|truncate:15:'...'} {$unProf.prenom}</span>
            </label>
        </div>
    </li>
{/foreach}
</ul>

<script type="text/javascript">

    $(document).ready(function(){

        $('#cbProfs').change(function(){
            $('.selecteurEleve').trigger('click');
        })

    })

</script>
