<form name="form" id="formVerrous" action="index.php" method="POST">
<input type="hidden" name="action" value="titu">
<input type="hidden" name="mode" value="verrous">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="bulletin" value="{$bulletin}">
<input type="hidden" name="classe" value="{$classe}">
<table class="tableauBull">
<tr>
    <th colspan="3">
		<h2>Classe: {$classe}</h2>
		<input type="submit" name="submit" value="Enregistrer" id="submit" style="display:none; color:red;"><br>
		Bloquer toutes les cotes et commentaires <img id="lockAll" src="images/lock.png" alt="0" title="Bloquer/débloquer TOUTES LES COTES ET COMMENTAIRES"><br>
		Bloquer toutes les cotes <img id="lockCotes" src="images/lockCotes.png" alt="1" title="Bloquer/débloquer les COTES SEULEMENT">
    </th>
	{foreach from=$listeCoursGrpClasse key=coursGrp item=unCours}
		{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
		{assign var=coursGrpPROT value=$coursGrp|replace:' ':'~'}
		<th>
		<img src="imagesCours/{$unCours.cours}.png" title="{$unCours.libelle} ({$coursGrp}) {$unCours.nbheures}h" alt="{$unCours.libelle}"><br>
		<img class="lockCoursComment" id="coursComment_{$coursGrpPROT}" src="images/lock.png" alt="0" title="Verrouiller/déverrouiller le cours et les commentaires de {$unCours.acronyme}">
		<img class="lockCours" id="cours_{$coursGrpPROT}" src="images/lockCotes.png" alt="1" title="Verrouiller/déverrouiller le cours de {$unCours.acronyme}">
		</th>
	{/foreach}
</tr>
{foreach from=$listeEleves key=matricule item=unEleve}
<tr>
    <td title="matr. {$matricule}">{$unEleve.nom} {$unEleve.prenom}</td>
    <td>
		<img class="lockEleve" id="eleve_{$matricule}" src="images/lock.png" 
		alt="1" title="Verrouiller/déverrouiller les cotes et les commentaires pour {$unEleve.nom} {$unEleve.prenom}">
	</td>
	<td>
		<img class="lockEleveCotes" id="eleve_Cotes{$matricule}" src="images/lockCotes.png" 
		alt="1" title="Verrouiller/déverrouiller les cotes seulement pour {$unEleve.nom} {$unEleve.prenom}">
	</td>
	{* on prend un à un la liste de tous les cours de cette classe *}
	{foreach from=$listeCoursGrpClasse key=coursGrp item=unCours}
		{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
		{assign var=coursGrpPROT value=$coursGrp|replace:' ':'~'}
		<td class="cellVerrou cote">
			{* L'élève a-t-il ce cours? *}
			{if isset($listeCoursGrpEleves.$matricule.$coursGrp) && $listeCoursGrpEleves.$matricule.$coursGrp != Null}
				<select name="lock#{$coursGrpPROT}#{$matricule}" class="eleve_{$matricule} cours_{$coursGrpPROT} selVerrou" style="display:none">
					<option value="0" 
					{if ($listeVerrous.$matricule.$coursGrp == Null) || $listeVerrous.$matricule.$coursGrp == 0}
					selected="selected"
					{/if}
					>0</option>
					<option value="1"
					{if $listeVerrous.$matricule.$coursGrp == 1}
					selected="selected"
					{/if}
					>1</option>
				</select>
			{else}
				&nbsp;
			{/if}
		</td>
	{/foreach}
</tr>
{/foreach}
</table>
</form>
<script type="text/javascript">
{literal}
$(document).ready(function(){
	
	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	
	$(".selVerrou").hide().each(function(index){
		var verrou = $(this);
		var myClass = $(this).attr("class");
		if ($(this).val() == 1) {
			$(this).parent().append("<img src='images/lock.png' alt='1'>").addClass(myClass)
				.addClass("unlock").removeClass("selVerrou");
			}
			else {
				$(this).parent().append("<img src='images/unlock.png' alt='0'>").addClass(myClass)
				.addClass("lock").removeClass("selVerrou");
				}
	});
	
	$(".cellVerrou").click(function(){
		if ($(this).hasClass("unlock")) {
			$(this).children("select").val(0);
			$(this).children("img").attr("src", "images/unlock.png");
			$(this).removeClass("unlock").addClass("lock");
			}
			else {
			$(this).children("select").val(1);
			$(this).children("img").attr("src", "images/lock.png");
			$(this).removeClass("lock").addClass("unlock");
			}
		modification();
	})
	
	$(".lockCours").click(function(){
		var leCours = $(this).attr("id");
		$(".cellVerrou").each(function(index){
			if ($(this).hasClass(leCours))
				$(this).trigger("click");
			});
		modification();
		})
		
	$(".lockEleve").click(function(){
		var eleve = $(this).attr("id");
		$(".cellVerrou").each(function(index){
			if ($(this).hasClass(eleve)) {
				$(this).trigger("click");
				}
			});
		modification();
		})
	
	$("#lockAll").click(function(){
		$(".cellVerrou").each(function(index){
			$(this).trigger("click");
		})
		modification();
	})
	
	$("#formVerrous").submit(function(){
		window.onbeforeunload = function(){};
		$("#wait").show();
		$.blockUI();
	})


	function modification () {
		if (!(modifie)) {
			modifie = true;
			$("#bulletin").attr("disabled","disabled");
			$("#classe").attr("disabled","disabled");
			$("#submit").fadeIn();
			window.onbeforeunload = function(){
				if (!confirm(confirmationBeforeUnload)) 
					return false;
				};
			};
		}
	
})
{/literal}
</script>
