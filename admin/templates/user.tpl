<script type="text/javascript">
{literal}
$(document).ready(function(){
	$(".fromDroits").click(function(){
		var parent = $(this).parent();
		var selecteur = $(this).parent().find("select");
		// alert(parent.attr("id"));
		// alert(parent.find(".divUser").html());
		alert(selecteur);
		});
		
	$(".fleches").hover(function(){
		$(this).addClass("hover");
		},function(){
		$(this).removeClass("hover");
		});
	})
{/literal}
</script>

<h3 style="clear:both">Gestion des utilisateurs</h3>

<p><label for="nom">Nom:</label>{$qui.nom}</p>
<p><label for="prenom">Prénom:</label>{$qui.prenom}</p>
<div class="divUser" style="width:100%">
{$none.nomStatut}:<br>
	<select multiple="multiple" size="6" class="divUser" name="{$none.userStatus}">
	{foreach from=$none.applications item=appli}
	<option value="{$appli}">{$appli}</option>
	{/foreach}
</select>
</div>

{foreach from=$autres item=unDroit}
	<div class="divUser" style="float:left" id="{$unDroit.userStatus}">
	<div class="fromDroits fleches">^</div><br />
	<div class="fromNone fleches">v</div>
	<select multiple="multiple" size="6" class="divUser" name="{$unDroit.userStatus}">
	{foreach from=$unDroit.applications item=uneAppli}
	<option>{$uneAppli}</option>
	{/foreach}
	</select>
	<p style="background-color:{$unDroit.color}">{$unDroit.nomStatut}</p>
	</div>
{/foreach}
