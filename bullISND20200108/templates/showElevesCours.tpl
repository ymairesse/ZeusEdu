<h2>Attribution des cours aux élèves {$coursGrp}</h2>
{if $listeEleves}
    <p>Titulaire(s) du cours</p>
    <ul>
        {foreach from=$listeProfs key=acronyme item=nomProf}
        <li>{$nomProf}</li>
        {/foreach}
    </ul>
{/if}
<div style="float:left">
    {if $listeEleves}
    <form name="supprimeEleves" id="supprimeEleves" action="index.php" method="POST">
    <h3 style="clear:both">Élèves déjà inscrits ({$listeEleves|@count})</h3>
    <select multiple="multiple" size="15" name="supprEleves[]" id="supprEleves">
        {foreach from=$listeEleves key=matricule item=eleve}
        <option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
        {/foreach}
    </select>
    <br>
    <input type="hidden" name="coursGrp" value="{$coursGrp}">
    <input type="hidden" name="action" value="admin">
    <input type="hidden" name="mode" value="attributionsEleves">
    <input type="hidden" name="etape" value="supprEleves">
    <input type="submit" name="Envoyer" value="Supprimer >>">
    <input type="hidden" name="niveau" value="{$niveau}">
    <input type="hidden" name="niveauEleves" value="{$niveauEleves}">
    </form>
    {/if}
</div>

<div style="float:left">
    {if $listeElevesNiveau}
    <form name="ajouteEleves" id="ajouteEleves" action="index.php" method="POST">
    <h3>Élèves du niveau {$niveauEleves}e</h3>
    <select multiple="multiple" size="15" name="addEleves[]" id="addEleves">
        {foreach from=$listeElevesNiveau key=matricule item=eleve}
        <option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
        {/foreach}
    </select>
    <br>
    <input type="hidden" name="coursGrp" value="{$coursGrp}">
    <input type="hidden" name="action" value="admin">
    <input type="hidden" name="mode" value="attributionsEleves">
    <input type="hidden" name="etape" value="addEleves">
    <input type="submit" name="Envoyer" value="<< Ajouter au cours">
    <input type="hidden" name="niveau" value="{$niveau}">
    <input type="hidden" name="niveauEleves" value="{$niveauEleves}">
    </form>
    {/if}
</div>



<script type="text/javascript">
{literal}
    $(document).ready(function(){
        $("#supprimeEleves").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        $("#ajouteEleves").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        })
{/literal}
</script>
