<div class="container">
<h2>Administration des compétences {$cours}</h2>

<form name="adminCompetences" id="adminCompetences" method="POST" action="index.php">
    <h3>Compétences actuelles</h3>
		{if $listeCompetences|@count > 0}
        {assign var=competences value=$listeCompetences.$cours}

        {foreach from=$competences key=idComp item=data}
        <input type="checkBox" name="suppr_{$idComp}" class="supprComp" id="chck_{$idComp}">
        <input type="text" name="libelle_{$idComp}" value="{$data.libelle}" size="50" class="lblComp" id="lbl_{$idComp}">
        <input type="text" name="ordre_{$idComp}" value="{$data.ordre}" size="3">
            <br>
        {/foreach}
		{/if}
        <input type="checkBox" name="toutCocher" id="toutCocher">
            <label for="toutCocher">Tout Cocher</label>
            <button type="button" id="effacer">Effacer</button> <br>

    <h3>Nouvelle(s) compétence(s)</h3>
        <button type="button" id="ajouter">Ajouter</button>
        <div id="newComp">

        </div>
        <hr>
        <div style="float:right">
        <input type="submit" name="submit" value="Enregistrer" class="fauxBouton" id="enregistrer">
        <input type="reset" name="Annuler" value="Annuler" id="annuler">
        <input type="hidden" name="cours" value="{$cours}">
        <input type="hidden" name="niveau" value="{$niveau}">
        <input type="hidden" name="action" value="admin">
        <input type="hidden" name="mode" value="competences">
        <input type="hidden" name="etape" value="enregistrer">
        </div>
</form>

</div>

<script type="text/javascript">

    $(document).ready(function(){
        var nbNewComp = 1;

        $("#toutCocher").click(function(){
            $(".supprComp").click();
            })

        $("#effacer").click(function(){
            $(".supprComp").each(function(no){
                if ($(this).prop('checked')) {
                    $(this).css({ 'opacity' : 0.5});
                    $(this).next().val('').css({ 'opacity' : 0.5});
                    }
                })
            })
        $("#annuler").click(function(){
            if (confirm("Êtes-vous sûr(e) de vouloir annuler?")) {
                $(".lblComp").each(function(no){
                    $(this).css({ 'opacity':1 });
                    $(".blockNewComp").remove();
                    nbNewComp = 1;
                    })
                }
            })

        $("#ajouter").click(function(){
                $('<div class="blockNewComp">'+nbNewComp+'. <input type="text" class="newComp" name="newComp[]" value="" size="50"></div>').fadeIn('slow').appendTo('#newComp');
                $(".newComp").last().focus();
                nbNewComp++;

            })

        $("#adminCompetences").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        })

</script>
