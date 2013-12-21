<h3>Dates et modification des dates de retenues</h3>
<h4>Type: {$infosRetenue.titreFait} Nombre: {$listeRetenues|@count}</h4>
<form name="editRetenues" id="editRetenues" method="POST" action="index.php">
	<span class="fauxBouton" id="cache">Cacher/Montrer</span>
<table class="tableauAdmin">
	<tr>
	<th>&nbsp;</th>
	<th>Date</th>
	<th>Heure</th>
	<th>Durée</th>
	<th>Local</th>
	<th>Places</th>
	<th>Occupation</th>
	<th>Visible</th>
	<th>&nbsp;</th>
	</tr>
	{foreach from=$listeRetenues key=id item=uneRetenue}
	<tr class="{if $uneRetenue.occupation < $uneRetenue.places}libre {else}rempli {/if}{if $uneRetenue.affiche == 'N'}cache{/if}">
		<td><a href="index.php?action=retenues&amp;mode=del&amp;idretenue={$uneRetenue.idretenue}">{if $uneRetenue.occupation == 0}<img src="images/suppr.png" alt="x">{/if}&nbsp;</a></td>
		<td>{$uneRetenue.dateRetenue}</td>
		<td>{$uneRetenue.heure}</td>
		<td>{$uneRetenue.duree}h</td>
		<td>{$uneRetenue.local}</td>
		<td>{$uneRetenue.places}</td>
		<td>{$uneRetenue.occupation}</td>
		<td style="text-align:center; cursor:pointer" id="vis_{$uneRetenue.idretenue}" class="visible" title="cliquer pour changer l'état">
			<a href="javascript:void(0)"><strong>{if $uneRetenue.affiche == 'O'}O{else}N{/if}</strong></a></td>
		<td title="Modifier"><a href="index.php?action=retenues&amp;mode=edit&amp;idretenue={$uneRetenue.idretenue}"><img src="images/editer.png" alt="O"></a></td>
	</tr>
	
	{/foreach}
</table>

</form>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$(".cache").hide();
		
		$("#cache").click(function(){
				$('.cache').toggle();
			})
		
		$(".visible").click(function(){
			var visible = $(this);
			var id=$(this).attr('id');
			var texte = $(this).find('strong').text();
			$.post('inc/visibleInvisible.inc.php',
			   {'id': id,
			   'texte': texte},
			   function (resultat) {
				visible.find('strong').text(resultat);
				if (resultat == 'N')
					visible.parents('tr').fadeOut();
			   }
			)
			})
		})
	{/literal}
</script>