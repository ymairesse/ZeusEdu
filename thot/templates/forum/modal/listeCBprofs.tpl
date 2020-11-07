<div class="btn-group  btn-group-justified">
    <a href="#" type="button" class="btn btn-success btn-xs" id="btn-tous">Tous</a>
    <a href="#" type="button" class="btn btn-danger btn-xs" id="btn-none">Aucun</a>
    </div>

<ul class="list-unstyled">
{foreach from=$listeProfs key=acronyme item=unProf}
    <li>
        <div class="checkbox">
            <label>
                <input class="selecteurProfs"
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

        $('#btn-tous').click(function(){
            $('.selecteurProfs').prop('checked', true);
        })

        $('#btn-none').click(function(){
            $('.selecteurProfs').prop('checked', false);
        })

    })

</script>
