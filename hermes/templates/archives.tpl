<div  style="clear:both">
<div class="gauche">

{if $nbArchives}
<form name="prevNext" id="prevNext" action="index.php" method="POST" class="microForm">
	<input type="hidden" name="debut" id="debut" value="{$debut}">
	<input type="hidden" name="nbArchives" value="{$nbArchives}">

	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if $debut+$nb < $nbArchives}
		<input type="button" name="prev" value="<" id="prev" title="Plus anciens">
	{/if}
	<input type="submit" name="submit" id="rafraichir" value="Rafraîchir">
	{if $debut != 0}
		<input type="button" name="next" value=">" id="next" title="Plus récents">
	{/if}
</form>
{/if}

<ul id="listeMails">
{foreach from=$listeArchives key=id item=unMail}
	<li id="select_{$id}" title="{$unMail.objet|truncate:30:'...'}|{$unMail.destinataires|truncate:40:'...'}">
		{$unMail.date} {$unMail.heure} <br>
		{$unMail.objet|truncate:30:'...'}
		{if $unMail.PJ.0 != ''}
		<img src="images/pj.gif" alt="pj">
		{/if}
		</li>
{/foreach}
</ul>
</div>

<div class="droit">
{if $listeArchives|count > 0}
	{foreach from=$listeArchives key=id item=unMail}
		<div id="cadre_{$id}" class="cadreCache" style="display:none">
		<div class="fauxBouton suppr" style="float:right" id="suppr_{$id}"><img src="../images/suppr.png" alt="x">Effacer</div>
		<p><strong>Date: {$unMail.date} à {$unMail.heure}</strong></p>
		<p><strong>Expéditeur:</strong> <span class="champ">{$unMail.prenom} {$unMail.nom} [{$unMail.mailExp}]</span> </p>
		<p><strong>Objet:</strong> <span class="champ">{$unMail.objet}</span></p>
		<p><strong>Destinataire(s):</strong> <span class="champ">{$unMail.destinataires}</span></p>
		<strong>Texte</strong><br>
		<div class="champ">{$unMail.texte}</div>
		<br>
		<strong>Fichiers joints:</strong><br>
		{assign var=n value=0}
		{foreach from=$unMail.PJ key=wtf item=nomFichier}
			{if $nomFichier != ''}{assign var=n value=$n+1}{/if}
			<a href="upload/{$acronyme}/{$nomFichier}" target="_blank">{$nomFichier}</a>
		{/foreach}
		{if $n == 0}Aucun{/if}
		</div>
	{/foreach}
{else}
	Aucune archive pour l'instant
{/if}
</div>

</div>

<div id="dialogDelete">
<p><span id="nbArchives"></span> archive supprimée</p>
</div>

<div id="confirmDelete" title="Confirmation">
<p>Veuillez confirmer la suppression de l'archive</p>
</div>

<div style="display:none" id="acronyme">{$acronyme}</div>
<div style="display:none" id="id"></div>



<script type="text/javascript">
	var CONFIRMSUPPR = "Veuillez confirmer la suppression de cet item."
$(document).ready(function(){

	$("#listeMails li").click(function(){
		var id=$(this).attr("id").split('_')[1];
		$(".cadreCache").hide();
		$("#cadre_"+id).fadeIn(1000);
		})

	$(".cadreCache").first().fadeIn(1000);

	$("#listeMails li").mouseover(function(){
		$(this).css('backgroundColor','orange')
		})

	$("#listeMails li").mouseout(function(){
		$(this).css('backgroundColor','white')
		})


	$("#dialogDelete").dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			OK: function(){ $(this).dialog("close"); }
			}
		});

	$("#confirmDelete").dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			"OUI": function() {
				$( this ).dialog( "close" );
				var archive = $("#id").text();
				var acronyme = $("#acronyme").text();
                $.post( "inc/delArchive.inc.php", {
					archive: archive,
					acronyme: acronyme
					},
					function (resultat){
						$("#nbArchives").text(resultat);
						$("#dialogDelete").dialog("open");
						});
				$("#select_"+archive).fadeOut().remove();
				$("#cadre_"+archive).fadeOut().remove();
				$(".cadreCache").first().fadeIn(1000);
            },
            "NON": function() {
                $( this ).dialog("close");
            }
        }
		});

	$(".suppr").click(function(){
		var id=$(this).attr("id").split('_')[1];
		var acronyme = $("#acronyme").text();
		$("#id").text(id);
		$("#acronyme").text(acronyme);
		$("#confirmDelete").dialog("open");
		});


	$("#prev").click(function(){
		var debut = eval($("#debut").val())+10;
		$("#debut").val(debut);
		$("#rafraichir").trigger('click');
		})

	$("#next").click(function(){
		var debut = eval($("#debut").val())-10;
		$("#debut").val(debut);
		$("#rafraichir").trigger('click');
		})

	})
</script>
