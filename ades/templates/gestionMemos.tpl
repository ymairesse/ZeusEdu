<table class="tableauAdmin">
	
	{foreach from=$listeMemos key=titre item=listeTextes}
		<tr>
			<th colspan="3"><strong>{$titre}</strong></th>
		<tr>
		<tr>
			<th style="width:4em">Proprio</th>
			<th>Texte</th>
			<th style="width:2em">&nbsp</th>
		</tr>		
		{foreach from=$listeTextes key=id item=lesItems}
		<tr>
			<td>{$lesItems.user}
			</td>
			<td>
				{if $acronyme == $lesItems.user}
				<input type="hidden" name="id_{$titre}_{$id}" value="{$id}" class="id">
				<input type="hidden" name="user_{$lesItems.user}" value="{$lesItems.user}" class="user">
				<input type="hidden" name="champ_{$titre}_{$id}" value="{$titre}" class="champ">
				<input type="text" name="texte_{$titre}_{$id}" value="{$lesItems.texte}" maxlength="150" size="100" class="texte" style="width:95%">
				<img src="images/ok.png" alt="OK" style="display:none; height:1em" class="oki">
				{else}
				{$lesItems.texte}
				{/if}
			</td>
			<td class="delete">
				{if $acronyme == $lesItems.user}<img src="images/suppr.png" alt="X" style="height:1em" class="suppr">{else}&nbsp;{/if}
			</td>
		</tr>
		{/foreach}
	{/foreach}
</table>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
	
	$(".texte").click(function(){
		$(this).nextAll(".oki").fadeIn();
		})
	
	$(".oki").click(function(){
		var oki = $(this);
		var texte = $(this).prevAll("input.texte").val();
		var id=$(this).prevAll("input.id").val();
		var champ = $(this).prevAll("input.champ").val();
		var user = $(this).prevAll("input.user").val();
		
		if (texte != '') {
			$.post("inc/saveTexte.inc.php",
				{'texte': texte,
				 'qui': user,
				 'champ': champ,
				 'id': id,
				 'user': user
				 },
					function (resultat) {
						oki.fadeOut();
						}
					);
			}
		})

	$(".suppr").click(function(){
		var sup = $(this);
		var id=$(this).parent().parent().find(".id").val();
		if (id != '' && confirm('Voulez-vous vraiment supprimer ce texte?')) {
			$.post('inc/delTexte.inc.php',
					{'id': id},
					function (resultat) {
						sup.parent().parent().remove();
						}
				   )
			}
		})
		
	})
{/literal}
</script>