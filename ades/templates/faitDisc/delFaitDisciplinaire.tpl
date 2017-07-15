<h2>{$Eleve.nom} {$Eleve.prenom} | {$Eleve.groupe}</h2>

{assign var=contexte value='formulaire'}
{assign var="tabIndex" value="1" scope="global"}

<h3 style="color:{$prototype.structure.couleurTexte}; background-color:{$prototype.structure.couleurFond}">{$prototype.structure.titreFait}</h3>

<form name="editFaitDisc" id="editFaitDisc" class="form-vertical">

    {foreach from=$prototype.champs key=unChamp item=data}

        {if in_array($contexte, explode(',',$data.contextes))}

            {* -----------------------  gestion des champs de type "text" --------------------------------- *}
            {if $data.typeChamp == 'text'}
            {include file="faitDisc/champTexte.inc.tpl"}
            {/if}

            {* -----------------------  gestion des champs de type "textarea" --------------------------------- *}
            {if $data.typeChamp == 'textarea'}
            {include file="faitDisc/champTextarea.inc.tpl"}
            {/if}

            {* -----------------------  gestion des champs de type "select" --------------------------------- *}
            {if $data.typeChamp == 'select'}
            {include file="faitDisc/champSelect.inc.tpl"}
            {/if}

            {* -----------------------  gestion des champs de type "hidden" --------------------------------- *}
            {if $data.typeChamp == hidden}
            {include file="faitDisc/champHidden.inc.tpl"}
            {/if}

        {/if}  {*  in_array *}

    {/foreach}

    {assign var="tabIndex" value=$tabIndex+1 scope="global"}
    <div class="clearfix"></div>

        <button class="btn btn-danger pull-right" type="button" id="btn-confDel" name="delete" data-idfait="{$fait.idfait}">
            <i class="fa fa-times"></i> Effacer
        </button>

    <div class="clearfix"></div>

    <input type="hidden" name="idfait" value="{$fait.idfait|default:''}">
    <input type="hidden" name="oldIdretenue" value="{$fait.idretenue}">

</form>

<script type="text/javascript">

    $(document).ready(function(){
        $("input").attr('readonly', true);
    })

    if ($("#professeur").length > 0) {
        var acronyme = $("#professeur").val().toUpperCase();
        $.post("inc/nomPrenom.inc.php", {
            acronyme: acronyme
            },
            function(resultat) {
                $("#nomPrenom").html(resultat)
                });
        }

</script>
