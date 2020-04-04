<style media="screen">
    .overflow {
        height:35em;
        overflow: auto;
    }
</style>

<div class="table-responsive">

<h2>
    Liste des présences du {$date} [{$listeParDate|@count} élèves sélectionnés]
    <button type="button" class="btn btn-lightBlue btn-xs pull-right" id="btn-print" name="button"><i class="fa fa-print"></i> Imprimer</button>
</h2>

<div class="overflow">

<table>
    <tr>
    {foreach from=$statuts item=justification key=justif}
        <td style="width:100px; padding-right: 0.5em; color:{$justification.color}; background:{$justification.background}; text-align:center; border:1px solid black;"
            title="{$justification.libelle}">
            {$justification.shortJustif}
        </td>
    {/foreach}
    </tr>
</table>

<table class="tableauPresences table table-striped table-condensed">
	<tr>
		<th>Matricule</th>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$listePeriodes key=periode item=limitesPeriode}
		<th style="width:3.5em"><strong>{$periode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
		<td>&nbsp;</td>
	</tr>

	{foreach from=$listeParDate key=matricule item=unEleve name=boucle}
    	<tr style="font-size:1.3em">
    	<td>{$matricule}</td>
    	<td>{$unEleve.identite.classe}</td>
        <td class="pop"
            data-toggle="tooltip"
            data-html="true"
            data-content="<img src='../photos/{$unEleve.identite.photo}.jpg' alt='{$matricule}' style='width:100px'>"
            data-html="true"
            data-container="body"
            data-original-title="{$unEleve.identite.nom|truncate:15}">
            {$unEleve.identite.nom}
        </td>

    	{foreach from=$listePeriodes key=laPeriode item=wtf}
    		{if isset($unEleve.presences.$laPeriode)}
    			{assign var=p value=$unEleve.presences.$laPeriode}
    			{assign var=statut value=$p.statut}
    			{assign var=titre value=$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'}
    			<td>
    				<span
    					style="display:block; width:100%; color:{$listeJustifications.$statut.color|default:'#f00'}; background:{$listeJustifications.$statut.background|default:'#666'}"
    					class="periode pop micro"
    					data-toggle="tooltip"
    					data-content="{$listeJustifications.$statut.libelle|default:'!!!'|cat:'<br>'|cat:$p.parent|cat:'<br>'|cat:$p.media}"
    					data-html="true"
    					data-container="body"
                        data-original-title="{$titre}">
    					{$listeJustifications.$statut.shortJustif|default:'!!!'}
    				</span>
    			</td>
    		{else}
    			<td title="indetermine" data-container="body" data-html="true">
    				<span style="display:block; width:2em" class="periode indetermine">
    				-
    				</span>
    			</td>
    		{/if}
    	{/foreach}
    	<td class="micro">{$smarty.foreach.boucle.iteration}</td>
    	</tr>
	{/foreach}
</table>

{include file="listes/legendeAbsences.tpl"}

</div>

<script type="text/javascript">

    // nécessaire pour Ajax
    $('document').ready(function(){
        $("*[title]").tooltip();

    	$(".pop").popover({
    		trigger:'hover'
    		});
    	$(".pop").click(function(){
    		$(".pop").not(this).popover("hide");
    		})

        $('#btn-print').click(function(){
            window.print();
            // var formulaire = $('#formSelecteur').serialize();
            // $.post('inc/printListeParDate.inc.php', {
            //     formulaire: formulaire
            // }, function(resultat){
            //     $('#listeAbsences').html(resultat);
            // })
        })

    })

</script>
