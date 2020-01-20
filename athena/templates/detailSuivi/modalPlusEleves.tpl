<div class="row">

    <div class="col-xs-4">

        <select class="form-control" name="listeClasses" id="listeClasses" size="10" style="float:left;">
            {foreach from=$listeClasses item=uneClasse}
            <option value="{$uneClasse}"{if $classe == $uneClasse} selected{/if}>{$uneClasse}</option>
            {/foreach}
        </select>

    </div>

    <div id="listeElevesClasse" style="max-height: 15em; overflow: auto;" class="col-xs-8" >

        {include file='detailSuivi/ulListeEleves.tpl'}

    </div>

</div>
