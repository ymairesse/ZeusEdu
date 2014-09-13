<div style="width:750px; float:left; clear:both">
<h2>Dernières nouvelles {$userStatus}</h2>
{if $userStatus == 'admin'}
	<a href="index.php?action=news&amp;mode=edit" style="float:right" class="newInfo fauxBouton"><img src="../images/iconPlus.png" alt="+">Ajouter une nouvelle</a>
{/if}
{if $flashInfos|@count > 0}
<div>
{foreach from=$flashInfos item="uneInfo"}
	<div id="flashInfo{$uneInfo.id}">
		<h3 style="clear:both">Ce {$uneInfo.date|date_format:"%d/%m/%Y"} - <span id="titre{$uneInfo.id}">{$uneInfo.titre}</span></h3>
		{if $userStatus == 'admin'}
			<a style="float:left" href="index.php?action=news&amp;mode=edit&amp;id={$uneInfo.id}" class="editInfo"><img src="../images/edit-icon.png" alt="Éditer"></a>
			<a style="float:right" href="index.php?action=news&amp;mode=del&amp;id={$uneInfo.id}" class="delInfo"><img src="../images/iconMoins.png" alt="Supprimer"></a>
		{/if}
		<div class="flashInfo"><p>{$uneInfo.texte}</p></div>
	</div>
{/foreach}
</div>
{/if}

	<div id="dialog-confirm" title="Suppression de la nouvelle">
	<p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
	La nouvelle "<span id="titreNews">x</span>" sera supprimée. Veuillez confirmer.</p>
	</div>

</div>

<div style="float:right; width:200px;">
	<h3>Table des matières</h3>
	<ul>
	{foreach from=$flashInfos item="uneInfo"}
	<li><a href="#flashInfo{$uneInfo.id}">{$uneInfo.titre}</a></li>
	{/foreach}
	</ul>
</div>

<script type="text/javascript">

var id;
var titre
{literal}

$(document).ready(function(){

	$("a.delInfo").click(function(e){
		e.preventDefault();
		var url=$(this).attr("href");
		id=url.substring(url.indexOf("id=")+3);
		titre = $("#titre"+id).text();
		$("#titreNews").html(titre);
		$("#dialog-confirm").dialog("open");
		return false;
		})

	$( "#dialog-confirm" ).dialog({
		resizable: false,
		height:200,
		width: 400,
		modal: true,
		autoOpen: false,
		buttons : {
			"Effacer" : function() {
				$(this).dialog("close");
				$.post("inc/deleteFlashInfo.inc.php",
					{'id': id,
					 'titre': titre},
					function (resultat) {
						$("#flashInfo"+id).html(resultat);
						}
					);
					},
			"Annuler" : function() {
				$(this).dialog("close");
				}
			}
		});

})

{/literal}
</script>
