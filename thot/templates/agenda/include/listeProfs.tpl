<div  style="height:20em; overflow:auto">
    <div class="checkbox">
        <label> <input type="checkbox" id="checkListe" name="TOUS" value="tous" checked> TOUS</label>
    </div>

    <ul class="listeMembres list-unstyled">
    {foreach from=$listeProfs key=acro item=prof}
        <li>
            <label class="radio-inline">
            <input type="checkbox" class="cb" name="profs[]" value="{$acro}" checked>
            {$prof.nom|truncate:15:'...'} {$prof.prenom}</label>
        </li>
    {/foreach}
    </ul>
</div>

<script type="text/javascript">

    $('document').ready(function(){

        $('#checkListe').click(function(){
            var checked = $(this).is(':checked');
            $('.cb').prop('checked', checked);
        })

    })

</script>
