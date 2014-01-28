<h3>Dates et modification des dates de retenues</h3>
<h4>Type: {$infosRetenue.titreFait} Nombre: {$listeRetenues|@count}</h4>
<form name="editRetenues" id="editRetenues" method="POST" action="index.php">
	<span class="fauxBouton" id="cache">Cacher/Montrer</span>
<table class="tableauAdmin" id="tableRetenues">
	<tr>
	<th>&nbsp;</th>
	<th>Date</th>
	<th>Heure</th>
	<th>Durée</th>
	<th>Local</th>
	<th>Places</th>
	<th>Occupation</th>
	<th>Visible</th>
	<th style="display:none">&nbsp;</th>
	<th>&nbsp;</th>
	<th>&nbsp;</th>

	</tr>
	{foreach from=$listeRetenues key=id item=uneRetenue}
	<tr id="{$id}" class="{if $uneRetenue.occupation < $uneRetenue.places}libre {else}rempli {/if}{if $uneRetenue.affiche == 'N'}cache{/if}">
		<td class="del"><a href="javascript:void(0)">{if $uneRetenue.occupation == 0}<img src="images/suppr.png" alt="x">{/if}&nbsp;</a></td>
		<td class="date">{$uneRetenue.dateRetenue}</td>
		<td class="heure">{$uneRetenue.heure}</td>
		<td class="duree">{$uneRetenue.duree}h</td>
		<td class="local">{$uneRetenue.local}</td>
		<td class="places">{$uneRetenue.places}</td>
		<td class="occupation">{$uneRetenue.occupation}</td>
		<td style="text-align:center; cursor:pointer" id="vis_{$uneRetenue.idretenue}" class="visible" title="cliquer pour changer l'état">
			<a href="javascript:void(0)"><strong>{if $uneRetenue.affiche == 'O'}O{else}N{/if}</strong></a></td>
		<td class="typeRetenue" style="display:none">{$infosRetenue.typeRetenue}</td>
		<td title="Modifier"><a href="index.php?action=retenues&amp;mode=edit&amp;idretenue={$uneRetenue.idretenue}"><img src="images/editer.png" alt="O"></a></td>
		<td title="Cloner" class="cloner"><a href="javascript:void(0)"><img src="images/clone.png" alt="Clone"></a></td>
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
		
		$("#tableRetenues").on("click", ".visible", function(){
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

		// clonage d'une retenue existante
		$("#tableRetenues").on("click", ".cloner", function(){
			var moi = $(this);
			var ligne = $(this).parent().clone(true);

			var id = ligne.attr("id");
			var date = ligne.find(".date").text();
			var heure = ligne.find(".heure").text();
			var duree = ligne.find(".duree").text();
			var local = ligne.find(".local").text();
			var places = ligne.find(".places").text();
			var typeRetenue = ligne.find(".typeRetenue").text();

			$.post(
				'inc/saveCloneRetenue.inc.php',
				{
				'ligne': ligne.html(),
				'date': date,
				'heure': heure,
				'duree': duree,
				'local': local,
				'places': places,
				'typeRetenue': typeRetenue
				},
				function(resultat) {
					var newId=resultat.id;
					var newDate=resultat.date;
					ligne.attr("id",newId);
					ligne.find(".occupation").text(0);
					ligne.html(ligne.html().split(id).join(newId));
					ligne.html(ligne.html().split(date).join(newDate));
					moi.closest('tr').after(ligne).fadeIn();	
					},
				"json"
				)
			// 
				}
			)
		
		$("#tableRetenues").on("click", ".del", function(){
			if (confirm('Veuillez confirmer la suppression de cette retenue')) {
			var moi = $(this);
			var idretenue = $(this).parent().attr("id");
			$.post('inc/delRetenue.inc.php',
				{'idretenue': idretenue},
				function(resultat) {
					if (resultat == 1) {
						moi.parent().fadeOut().remove();
						}
					}
				);

			}
			})
	
	})
	

	{/literal}
</script>

