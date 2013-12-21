{if isset($coursGrp)}
<h3>Attribution des cours aux enseignants</h3>

<form name="supprProfCours" id="supprProfCours" method="POST" action="index.php" style="width:40%; float:left">
    <div style="float:left">
    {if (isset($coursGrp))}
	{$coursGrp}
	{/if}
    <h4>Titulaire(s) du cours</h4>
    {foreach from=$listeProfsTitulaires key=acronyme item=prof}
        <input type="checkbox" name="supprProf[]" value="{$acronyme}" title="Cochez pour supprimer">{$prof}<br>
    {/foreach}

    <input type="hidden" name="coursGrp" value="{$coursGrp}">
    <input type="hidden" name="action" value="admin">
    <input type="hidden" name="mode" value="attributionsProfs">
    <input type="hidden" name="etape" value="supprProfs">
    <input type="submit" name="Envoyer" value="Supprimer >>">
    <input type="hidden" name="niveau" value="{$niveau}">
        
    <h4>Élèves inscrits</h4>
    <select size="15" name="eleves" id="eleves">
        {foreach from=$listeEleves key=matricule item=eleve}
            <option value="{$matricule}">{$eleve.classe} - {$eleve.nom} {$eleve.prenom}</option>
        {/foreach}
    </select>
    </div>

</form>

<form name="addProfCours" id="addProfCours" method="POST" action="index.php" style="width:40%; float:right">
    
    <div style="float:left">
        <h4>Professeurs à affecter au cours</h4>
        <select multiple="multiple" size="15" name="addProf[]" value="">
        {foreach from=$listeTousProfs key=acronyme item=prof}
            <option value="{$acronyme}">{$prof.acronyme}: {$prof.nom} {$prof.prenom}</option>
        {/foreach}            
        </select>
    </div>
    <input type="hidden" name="coursGrp" value="{$coursGrp}">
    <input type="hidden" name="action" value="admin">
    <input type="hidden" name="mode" value="attributionsProfs">
    <input type="hidden" name="etape" value="addProfs">
    <input type="submit" name="Envoyer" value="<< Ajouter">
    <input type="hidden" name="niveau" value="{$niveau}">
</form>
{/if}

<script type="text/javascript">
{literal}
    $(document).ready(function(){
        $("#supprProfCours").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        
        $("#addProfCours").submit(function(){
			$.blockUI();
            $("#wait").show();
            })

        
        })

{/literal}
</script>
