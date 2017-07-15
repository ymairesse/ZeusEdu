<div class="row">

    <div class="col-md-3 col-xs-12">
        <div class="form-group">
            <label for="titreFait">Dénomination</label>
            <input type="text" class="form-control" value="{$fait.titreFait|default:''}" id="titreFait" required id="titreFait" name="titreFait" placeholder="Intitulé du fait disciplinaire">
            <span class="help-block">&nbsp;</span>
        </div>
    </div>

    <div class="col-md-3 col-xs-12">
        <div class="form-group">
            <label for="print">Imprimable par défaut</label>
            <div class="checkbox" style="text-align:center">
                <label>
                    <input type="checkbox" name="print" value="1"{if $fait.print == 1}checked{/if}>
                </label>
            </div>
        </div>
    </div>

    <div class="col-md-3 col-xs-12">
        <div class="form-group">
            <label for="color">Couleur du texte</label>
            <input type="color" class="form-control" name="color" id="color" value="{$fait.couleurTexte|default:'#000000'}" required>
        </div>
    </div>

    <div class="col-md-3 col-xs-12">
        <div class="form-group">
            <label for="background">Couleur de fond</label>
            <input type="color" class="form-control" name="background" id="background" value="{$fait.couleurFond|default:'#ffffff'}" required>
        </div>
    </div>

</div>

<div class="col-md-6 col-xs-12">
    <h4>Champs obligatoires</h4>

    {foreach from=$champsObligatoires key=champ item=dataChamp}
    <div class="checkbox">
        <input type="hidden" name="champs[]" value="{$champ}" class="obligatoires">
        <label>
            <input type="checkbox" value="{$champ}" checked disabled><span title="{$listeTousChamps.$champ.info}">{$dataChamp.label}</span>
        </label>
    </div>
    {/foreach}

</div>

<div class="col-md-6 col-xs-12">

    <h4>Champs optionnels</h4>
    {foreach from=$disponibles item=champ}
        <div class="checkbox">
            <label>
                <input type="checkbox"
                        name="champs[]"
                        value="{$champ}"
                        {if in_array($champ, $fait.listeChamps)} checked{/if}>
                <span title="{$listeChamps.$champ.info}">{$listeTousChamps.$champ.label}</span>
            </label>
        </div>
    {/foreach}

</div>

<input type="hidden" name="typeRetenue" value="{$fait.typeRetenue|default:0}">
<input type="hidden" name="ordre" value="{$fait.ordre|default:Null}">
<input type="hidden" name="type" value="{$fait.type|default:Null}">

<div class="clearfix"></div>
