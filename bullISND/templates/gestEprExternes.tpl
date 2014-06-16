<h2>Gestion des cotes des épreuves externes</h2>
<h3>{$coursGrp}</h3>
{assign var="tabIndexCotes" value="1"}
<form name="eprExterne" id="eprExterne" method="POST" action="index.php">
<table class="tableauBull">
	<tr>
		<th>Classe</th>
		<th>Nom</th>
		<th style="width:10em">Épreuve externe</th>
		<th style="width:10em">Réussite<br>Conseil de Classe</th>
		<th style="width:10em">Cote de situation</th>
	</tr>
	{foreach from=$listeEleves key=matricule item=data}
	<tr{if isset($tableErreurs[$matricule])} class="erreurEncodage"{/if}>
		<td>{$listeEleves.$matricule.classe}</td>
		<td title="{$matricule}">{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</td>
		<td>
			<input type="text" size="6" maxlength="6" name="cote_{$matricule}" class="cote c{$matricule}{if $listeCotes.$matricule.choixCote == 'coteExterne'}  enabled{else}disabled{/if}"
				   value="{$listeCotes.$matricule.coteExterne}"
				   tabIndex="{$tabIndexCotes}">
			<input type="radio" name="choix_{$matricule}" class="c{$matricule}" value="coteExterne" {if $listeCotes.$matricule.choixCote == 'coteExterne'} checked="checked"{/if}>
		</td>

		<td class="cote">
			{if ($listeCotes.$matricule.choixCote == 'reussite') || ($userStatus == 'admin')}
			<span class="c{$matricule} {if $listeCotes.$matricule.choixCote == 'reussite'}enabled{else}disabled{/if}">50</span>
			{/if}
			{if $userStatus == 'admin'}
			<input type="radio" name="choix_{$matricule}" class="c{$matricule}" value="reussite" {if $listeCotes.$matricule.choixCote == 'reussite'} checked="checked"{/if}>
			{/if}
		</td>

		<td class="cote">
			<span class="c{$matricule} {if $listeCotes.$matricule.choixCote == 'sitDelibe'}enabled{else}disabled{/if}">{$listeSituations.$matricule.$coursGrp.$NBPERIODES.sitDelibe|default:'&nbsp;'}</span>
			<input type="radio" name="choix_{$matricule}" class="c{$matricule}" value="sitDelibe" {if $listeCotes.$matricule.choixCote == 'sitDelibe'} checked="checked"{/if}>
		</td>
		
	</tr>
	{assign var="tabIndexCotes" value=$tabIndexCotes+1}
	{/foreach}
</table>
{if $tableErreurs != Null}
<p class="erreurEncodage">Les cotes contiennent une ou plusieurs erreurs. Veuillez corriger.</p>
{/if}
<span class='tooltip' style='float:right'>
	<span class='infoSup'>Mentions admises</span>
	<div class="tip" style="display: none;">Mentions neutres:
		<strong>{$COTEABS}</strong>
</div>
</span>
<input type="hidden" name="coursGrp" value="{$coursGrp}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="{$etape}">
<input type="hidden" name="niveau" value="{$niveau}">
<input type="submit" name="submit" value="Enregistrer" id="enregistrer">
<input type="reset" name="annuler" value="Annuler" id="annuler">
</form>

<script type="text/javascript">
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var modifie = false;
	var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";	
	{literal}
	$(document).ready(function(){
		
	function modification () {
		if (!(modifie)) {
			modifie = true;
			$(".enregistrer, #annuler").show();
			$("#bulletin").attr("disabled","disabled").attr("title",desactive);
			$("#coursGrp").attr("disabled","disabled").attr("title",desactive);
			$("#envoi").hide();
			$(".totaux input").css("color","white");
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
				};
			}
		}

	$("input").tabEnter();
	
	$("input, checkbox").keyup(function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			modification();
			}
		}
	})
	
	// le copier/coller provoque aussi  une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});
	
	// gestion de l'annulation du formulaire
	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			this.form.reset();
			$(".acquis").each(function(numero){
				var checked = $(this).next().attr("checked");
				if (checked)
					$(this).parent().removeClass("echecEncodage");
					else $(this).parent().addClass("echecEncodage")
				});
			$("#bulletin").attr("disabled", false);
			$("#coursGrp").attr("disabled", false);
			$(".totaux input").css("color","black");
			modifie = false;
			$(".enregistrer, #annuler").hide();
			window.onbeforeunload = function(){};
			return false
		}
		else return false;
		})
	
	// gestion de l'enregistrement du formulaire
	$("#enregistrer").click(function(){
		$(this).val("Un moment").addClass("patienter");
		$.blockUI();
		$("#wait").show();
		var ancre = $(this).attr("id");
		$("#matricule").val(ancre);
		window.onbeforeunload = function(){};
	})
	
	$("input:radio").click(function(){
		var test = $(this);
		$(this).parent().parent().find('input').not(this).prev().attr('class','disabled');
		$(this).prev().attr('class','enabled');
		})


	
	})
	{/literal}
</script>