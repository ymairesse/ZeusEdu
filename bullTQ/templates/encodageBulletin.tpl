{assign var="ancre" value=$matricule}
<h2 title="{$libelleCours.coursGrp}">Bulletin {$bulletin} - {$libelleCours.cours} {$libelleCours.libelle} {$libelleCours.nbheures}h </h2>

<form name="formBulletin" id="formBulletin" action="index.php" method="POST">
	
	<p id="ouvrirTout" class="fauxBouton noprint" title="Déplier ou replier les Remarques pour tous les élèves"></p>
	<input type="submit" name="submit" value="Enregistrer tout" class="noprint enregistrer" id="enregistrer">
	<input type="reset" name="annuler" id="annuler" value="Annuler">

	<input type="hidden" name="action" value="bulletin">
	<input type="hidden" name="mode" value="enregistrer">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	
	<select name="selectEleve" id="selectEleve">
		<option value=''>Sélectionner un élève</option>
		{foreach from=$listeEleves key=matricule item=unEleve}
		<option value="{$matricule}" class="select">{$unEleve.nom} {$unEleve.prenom}</option>
		{/foreach}
	</select>
	
	<hr>
	{foreach from=$listeEleves key=matricule item=unEleve}
	
		<div class="blocGaucheBulletin photo" style="text-align:center; clear:both;">
		<div style="text-align:right">
		{if isset($listeElevesSuivPrec.$matricule.prev) && ($listeElevesSuivPrec.$matricule.prev != Null)}
			<a href="#el{$listeElevesSuivPrec.$matricule.prev}">
				<img src="images/up.png" alt="^" title="Précédent"></a>
		{/if}
		{if isset($listeElevesSuivPrec.$matricule.next) && ($listeElevesSuivPrec.$matricule.next != Null)}
			<a href="#el{$listeElevesSuivPrec.$matricule.next}">
				<img src="images/down.png" alt="^" title="Suivant"></a>
		{/if}
		</div>
		
		<p id="el{$matricule}"><strong>{$unEleve.nom} {$unEleve.prenom}</strong></p>
		<img class="photoEleve" src="../photos/{$unEleve.photo}.jpg" width="100px" alt="{$matricule}" title="{$unEleve.nom} {$unEleve.prenom} {$matricule}">
		<p><strong>Classe: {$unEleve.classe}</strong></p>
	
		<input type="submit" name="submit" value="Enregistrer tout"
		title="Enregistre l'ensemble des modifications de la page" class="noprint enregistrer"><span></span>
		</div>
	

		<div class="blocDroitBulletin">
			<h3>Mentions Globales</h3>
			<table class="tableauBull">
				<tr style="height:2em; background-color: #FECF69; font-weight:bolder; text-align:right">
					<td style="width:12%">TJ</td>
					<td style="width:12%; text-align: center"><input class="majuscule" type="text" name="TJ-{$matricule}" value="{$cotesGlobales.$matricule.Tj|default:''}" maxlength="4" size="2"></td>
					<td style="width:12%">Examen</td>
					<td style="width:12%; text-align: center"><input class="majuscule" type="text" name="EX-{$matricule}" value="{$cotesGlobales.$matricule.Ex|default:''}" maxlength="4" size="2"></td>
					<td style="width:12%">Période</td>
					<td style="width:12%; text-align: center"><input class="majuscule" type="text" name="PERIODE-{$matricule}" value="{$cotesGlobales.$matricule.periode|default:''}" maxlength="4" size="2"></td>
					<td style="width:12%">Global</td>
					<td style="width:12%; text-align: center"><input class="majuscule" type="text" name="GLOBAL-{$matricule}" value="{$cotesGlobales.$matricule.global|default:''}" maxlength="4" size="2"></td>
				</tr>
			
			</table>
			
			{if isset($listeCompetences)}
			
				<h3>Détails par compétences</h3>
				<table class="tableauBull">
				<tr>
					<th>Compétences</th>
					<th>TJ</th>
					<th>Examen</th>
				</tr>
			
				{foreach from=$listeCompetences key=cours item=lesCompetences}
					{foreach from=$lesCompetences key=idComp item=uneCompetence}
						<tr>
							
							<td style="text-align:right" title="comp_{$idComp}"> {$uneCompetence.libelle}</td>
						
							<td style="width:6em; text-align:center">
							<input type="text" name="coteTJ-{$matricule}-comp_{$idComp}" 
								value="{$cotesCoursGeneraux.$matricule.$coursGrp.$idComp.Tj|default:''}" maxlength="5" size="2" class="cote majuscule">
							</td>
								
							<td style="width:8em; text-align:center">
							<input type="text" name="coteEX-{$matricule}-comp_{$idComp}-Ex" 
								value="{$cotesCoursGeneraux.$matricule.$coursGrp.$idComp.Ex|default:''}" maxlength="5" size="2" class="cote majuscule">
							</td>
			
						</tr>
					{/foreach}
				{/foreach}
	
			</table>
				
		{/if}
		
		<h3>Remarque pour la période {$bulletin}</h3>
			<textarea{if isset($blocage.$coursGrp) && ($blocage.$coursGrp > 0)} readonly="readonly"{/if} class="remarque" rows="8" 
			cols="80" 
			name="COMMENTAIRE-{$matricule}">{$listeCommentaires.$matricule|default:Null}</textarea>

		<p class="ouvrir" style="clear:both">Remarques des autres périodes</p>
			<ul class="commentaires" style="display:none">
			{section name=annee start=1 loop=$nbBulletins+1}
			{assign var="periode" value=$smarty.section.annee.index}
				<li>{$periode} => {$listeCommentaires.$periode.$coursGrp.$matricule|default:Null}
			{/section}
			</ul>
		
		</div>
	<div style="clear:both; padding: 1em 0;"></div>
	
	
	{/foreach}
	
	
</form>

<hr>
<script type="text/javascript">

{if isset($ancre)}
	window.location.href="index.php#{$ancre}"
{/if}

{literal}
var show = "Cliquer pour voir";
var hide = "Cliquer pour cacher";
var showAll = "Déplier Remarques";
var hideAll = "Replier Remarques";
var hiddenAll = true;
var modifie = false;
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var noAccess = "Attention|Les cotes et mentions de ce bulletin ne sont plus modifiables.<br>Contactez l'administrateur ou le/la titulaire.";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";


$(document).ready(function(){

	$("input").tabEnter();
	
	$().UItoTop({ easingType: 'easeOutQuart' });
	
	$(".ouvrir").prepend("[+]").next().hide();
	$(".ouvrir").css("cursor","pointer").attr("title",show);
	$("#ouvrirTout").css("cursor","pointer");

	
	$(".ouvrir").click(function(){
		$(this).next().toggle("fast");
		var texte = $(this).text();
		if ($(this).text().substring(1,2) == '+') {
			$(this).text(texte.replace('+','-'));
			$(this).attr("title",hide)
			}
			else {
				$(this).text(texte.replace('-','+'));
				$(this).attr("title",show);
			}
		})
	
	
	// le copier/coller provoque aussi  une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});
	
	$("#ouvrirTout").html(function(){
		texte = hiddenAll?showAll:hideAll;
		$(this).html(texte);
	});
	
	$("#ouvrirTout").click(function(){
		$(".ouvrir").click();
		hiddenAll = !(hiddenAll);
		var texte = hiddenAll?showAll:hideAll;
		$(this).html(texte);
	})
	
	function modification () {
		if (!(modifie)) {
			modifie = true;
			$(".enregistrer, #annuler").show();
			$("#bulletin").attr("disabled","disabled").attr("title",desactive);
			$("#cours").attr("disabled","disabled").attr("title",desactive);
			$("#envoi").hide();
			$(".totaux input").css("color","white");
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
			};
			}
		}

	$("input, textarea").keyup(function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			modification();
			}
		}
	})
	
	
	$(".enregistrer, #annuler").hide();
	
	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			this.form.reset();

			$("#bulletin").attr("disabled", false);
			$("#cours").attr("disabled", false);

			modifie = false;
			$(".enregistrer, #annuler").hide();
			window.onbeforeunload = function(){};
			return false
		}
		})
	
	$(".enregistrer").click(function(){
		$(this).val("Un moment").addClass("patienter");
		$.blockUI();
		$("#wait").show();
		var ancre = $(this).attr("id");
		$("#matricule").val(ancre);
		window.onbeforeunload = function(){};
	})

	
	$(".remarque").focus(function(){
		var center = $(window).height()/2;
		var top = $(this).offset().top ;
		if (top > center){
			$(window).scrollTop(top-center);
		}
	});

	function goToByScroll(id){
		var adresse = "#"+id;
		var offset = $(adresse).offset();
     	$('html,body').animate({scrollTop: $("#"+id).offset().top-100},'slow');
	}

	$("#selectEleve").change(function(){
		var matricule = $(this).val();
		goToByScroll("el"+matricule);
		})
	
	$(".majuscule").change(function(){
		var texte = $(this).val();
		$(this).val(texte.toUpperCase());
		})

});

{/literal}

{if isset($tableErreurs)} alert(erreursEncodage){/if}
</script>

