<script type="text/javascript">
{literal}
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var modifie = false;
{/literal}
</script>

<h2>Carnet de cotes de {$coursGrp} Période {$bulletin} tri: {$tri}</h2>
<div id="test"></div>
<div id="barreOutils" class="noprint">
	<span class="fauxBouton" id="boutonPlus" title="Ajouter une cote">Ajouter une cote <img src="images/iconPlusB.png" alt="+"></span>
</div>
<form name="cotes" action="index.php" method="POST" id="formCotes">
<table class="tableauBulletin carnetCotes" id="carnet">
	<thead>
	<tr>
		<th width="20">Classe</th>
		<th style="text-align:left; padding-left:1em">Nom</th>
		{assign var=counter value=1}
		{foreach from=$listeTravaux key=idCarnet item=travail}
			{assign var=idComp value=$travail.idComp}
			<th class="{$travail.formCert} idCarnet{$idCarnet}" style="width:4em">
				<div class="tooltip">
					<div class="tip" style="display:none">
						<h3>C{$travail.ordre} {$listeCompetences.$idComp.libelle}</h3>
						<p>
						Libellé: {$travail.libelle}<br>
						Remarque: {$travail.remarque}<br>
						Neutralisé: {if $travail.neutralise == 1}O{else}N{/if}<br>
						Form/Cert: {if $travail.formCert == 'cert'}Certificatif{else}Formatif{/if}<br>
						Max: <strong>{$travail.max}</strong>
						</p>
					</div>
					<strong>[{$counter++}]</strong><br>
					{$travail.date|substr:0:5}<br>
					<span class="micro">C{$travail.ordre}</span> / <strong>{$travail.max}</strong><input type="hidden" name="max{$idCarnet}" value="{$travail.max}">
				</div>
				<div class="noprint">
					<input type="hidden" name="coursGrp" value="{$coursGrp}" class="inputCoursGrp">
					<input type="hidden" name="idCarnet" value="{$travail.idCarnet}" class="inputIdCarnet">
					<input type="hidden" name="bulletin" value="{$bulletin}" class="inputBulletin">
					<input type="hidden" name="date" value="{$travail.date}" class="inputDate">
					<input type="hidden" name="libelle" value="{$travail.libelle}" class="inputLibelle">
					<input type="hidden" name="remarque" value="{$travail.remarque}" class="inputRemarque">
					<input type="hidden" name="neutralise" value="{$travail.neutralise}" class="inputNeutralise">
					<input type="hidden" name="formCert" value="{if $travail.formCert == 'cert'}cert{else}form{/if}" class="inputFormCert">
					<input type="hidden" name="max" value="{$travail.max}" class="inputMax">
					<input type="hidden" name="idComp" value="{$travail.idComp}" class="inputIdComp">
					<input type="hidden" name="comp" value="{$listeCompetences.$idComp.libelle}" class="inputComp">
					<img src="images/iconMoins.png" class="boutonSuppr" title="Supprimer" alt="X">
						<span class="idCarnet" style="display:none">{$travail.idCarnet}</span>
					<img src="images/iconEdit.png" class="boutonEdit" title="Modifier" alt="V">
						<span class="idCarnet" style="display:none">{$travail.idCarnet}</span>
					<img src="images/lock.png" class="verrou" title="Déverrouiller" alt="v">
				</div>
			</th>
		{/foreach}
	</tr>
	</thead>
	<tbody>
	{assign var=tabIndex value=1}
	{assign var=nbEleves value=$listeEleves|@count}
	{assign var=nbTravaux value=$listeTravaux|@count}
	{foreach from=$listeEleves key=matricule item=unEleve}
	<tr>
	<td>{$unEleve.classe}</td>
	{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
	<td>
		<span class="tooltip">{$nomPrenom|truncate:20}
		<div class="tip" style="display:none">
			<img src="../photos/{$unEleve.photo}.jpg" alt="{$matricule}" style="width:100px"><br>
			{$nomPrenom|truncate:15}<br><span class="micro">[{$matricule}]</span></div>
		</span>
	</td>
	
	{foreach from=$listeTravaux key=idCarnet item=travail}
		{assign var=couleur value=$travail.idComp|substr:-1}
		<td class="{$travail.formCert} couleur{$couleur} idCarnet{$idCarnet} 
			{if $listeCotes.$matricule.$idCarnet.echec} echec{/if} cote">
			<input type="text" size="3" maxlength="5" name="cote-{$idCarnet}_eleve-{$matricule}"
				tabIndex="{$tabIndex}" class="coteCarnet" 
				value="{$listeCotes.$matricule.$idCarnet.cote|default:''}"
				disabled="disabled" style="font-size:8pt; display:none">
				<span class="{if $listeCotes.$matricule.$idCarnet.erreurEncodage} erreurEncodage{/if}">
					{$listeCotes.$matricule.$idCarnet.cote|default:'&nbsp;'}
				</span>
			{assign var=tabIndex value=$tabIndex+$nbEleves}
		</td>
	{/foreach}
	{assign var=tabIndex value=$tabIndex-($nbTravaux*$nbEleves)+1}
	</tr>
	{/foreach}
	<tr>
		<th style="text-align:right; padding-right:1em" colspan="2">Moyennes</th>
		{foreach from=$listeTravaux key=idCarnet item=travail}
			<th class="{$travail.formCert}"><strong>
				{if $listeMoyennes}
				{$listeMoyennes.$idCarnet|@round:1|default:'&nbsp;'}
				{else}
				&nbsp;
				{/if}</strong></th>
		{/foreach}
	</tr>
	</tbody>
</table>
<input type="submit" name="Submit" value="Enregistrer" id="submit" class="noprint">
<input type="reset" name="reset" value="Annuler" id="reset" class="noprint">
<input type="hidden" name="tri" value="{$tri}">
<input type="hidden" name="action" value="carnet">
<input type="hidden" name="mode" value="gererCotes">
<input type="hidden" name="etape" value="recordCotes">
<input type="hidden" name="coursGrp" value="{$coursGrp}" class="inputCoursGrp">
<input type="hidden" name="bulletin" value="{$bulletin}" class="inputBulletin">
<span class="tooltip">
	<span class="infoSup">Mentions admises</span>
	<div class="tip">
	<p>Mentions neutres: <strong>{$COTEABS}</strong><br>Mentions valant pour "0": <strong>{$COTENULLE}</strong></p>
	</div>
</span>


</form>

{if isset($listeErreurs) && ($listeErreurs|@count > 0)}
<div style="border: 2px solid red" id="erreurs"	>
<p>Vos cotes contiennent des erreurs</p>
<ol>
{foreach from=$listeErreurs key=idCarnet item=matricules}
	<li>
		<ul>
			{foreach from=$matricules key=matricule item=wtf}
			<li> Cote du <strong>{$listeTravaux.$idCarnet.date}</strong> pour <strong>{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</strong>: cote = <strong class="erreurEncodage">{$listeCotes.$matricule.$idCarnet.cote|trim:'!'}/{$listeTravaux.$idCarnet.max}</strong></li>
			{/foreach}
		</ul>
	</li>
{/foreach}
</ol>
</div>
{/if}

<ol>
{foreach from=$listeTravaux key=idCarnet item=travail}
{assign var=idComp value=$travail.idComp}
	<li>{$travail.date|substr:0:5}: {$travail.libelle|truncate:50:'...'} {$travail.formCert} <strong>/{$travail.max}</strong> : <strong>C{$travail.ordre}</strong> {$listeCompetences.$idComp.libelle}</li>
{/foreach}
</ol>
<ul class="noprint">
{foreach from=$listeCompetences key=idComp item=competence}
	<li class="couleur{$idComp|substr:-1}">{$competence.libelle}</li>
{/foreach}
</ul>

<!-- ........................................................................... -->
<!-- .............. FORMULAIRES CACHÉS POUR L'EDITION  DES COTES ............... -->
<!-- ........................................................................... -->
	<div id="editCote" style="display:none; width:25em; background-color: white" class="draggable popup">
		<div class="editTitle">
			<span class="title"></span>
			<span id="closeAjout" style="float:right">X</span>
		</div>
		<div class="editBody">
	<form name="formEdit" action="index.php" method="POST" id="formEdit">
		<input type="hidden" name="coursGrp" value="{$coursGrp}" class="inputCoursGrp">
		<input type="hidden" name="bulletin" value="{$bulletin}" class="inputBulletin">
		<input type="hidden" name="action" value="carnet">
		<input type="hidden" name="mode" value="gererCotes">
		<input type="hidden" name="tri" value="{$tri}">
		<input type="hidden" name="etape" value="recordEnteteCote">
		<input type="hidden" name="idCarnet" value="" class="inputIdCarnet effacer required">
		<span title="Date de l'évaluation">Date&nbsp;
			<input type="text" name="date" value="" class="ladate inputDate effacer" size="8" maxlength="10" id="date"></span>
		<span title="N° du bulletin">Bulletin
			<select name="bulletin" id="bulletin">
			{section name=boucleBulletin start=1 loop=$nbBulletins+1}
				<option value="{$smarty.section.boucleBulletin.index}" {if $smarty.section.boucleBulletin.index == $bulletin}selected{/if}>{$smarty.section.boucleBulletin.index}</option>
			{/section}
			</select><br>
		</span>
		<span title="Compétence exercée"><select name="idComp" size="1" id="idComp" class="effacer">
			<option value="">Compétence</option>
			{foreach from=$listeCompetences key=idComp item=uneCompetence}
				<option value="{$idComp}">{$uneCompetence.libelle}</option>
			{/foreach}
		</select></span><br>
		Formatif <input type="radio" name="formCert" value="form" class="inputForm" checked="checked">
		Certificatif <input type="radio" name="formCert" value="cert" class="inputCert"><br>
		<span  title="La cote ne sera pas comptabilisée">Neutralisé&nbsp;
			<input type="checkBox" name="neutralise" value="1" class="inputNeutralise"></span><br>
		<span title="titre du travail">Libellé&nbsp;
			<input type="text" name="libelle" value="" size="30" maxlength="50" class="inputLibelle effacer"></span><br>
		<span title="Remarque libre">Remarque&nbsp;
			<input type="text" name="remarque" value="" class="inputRemarque effacer" size="30" maxlength="30"></span><br>
		<span title="Cote maximale pour le travail">Max 
			<input type="text" name="max" value="" class="inputMax effacer" size="3" maxlength="3"></span><br>
		<input type="submit" value="Enregistrer" name="submit" style="float:right">
	</form>
	</div>
	<p class="micro formFooter">{$coursGrp} / Bull. {$bulletin}</p>
	</div>

<!-- ........................................................................... -->
<!-- .............. FORMULAIRE  CACHÉ  POUR L'EFFACEMENT DES COTES ............- -->
<!-- ........................................................................... -->

	<div id="delCote" style="display:none; width:25em; background-color: white" class="draggable popup">
		<div class="editTitle">Confirmez l'effacement définitif<span id="closeSuppr" style="float:right">X</span></div>
		<div class="editBody">
			<form name="formDel" action="index.php" method="POST" id="formDel">
				Date: <span class="spDate"></span><br>
				Comp: <span class="spComp"></span><br>
				Libellé: <span class="spLibelle"></span><br>
				Remarque: <span class="spRemarque"></span><br>
				Neutralisé: <span class="spNeutralise"></span><br>
				Form/Cert: <span class="spFormCert"></span><br>
				Max: <span class="spMax"></span><br>
				<input type="submit" name="effacer" value="Effacer" style="float:right">
				<input type="hidden" name="coursGrp" value="{$coursGrp}" class="coursGrp">
				<input type="hidden" name="bulletin" value="{$bulletin}" class="bulletin">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				<input type="hidden" name="etape" value="delCote">
				<input type="hidden" name="tri" value="{$tri}">
				<input type="hidden" name="idCarnet" value="" class="inputIdCarnet">
				<input type="hidden" name="idComp" value="" class="inputIdComp">
			</form>
		</div>
	<p class="micro formFooter">{$coursGrp} / Bull. {$bulletin}</p>
	</div>


<!-- ............................................................................. -->

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$("input").tabEnter();
		
		$(".coteCarnet").keyup(function(){
			modifie=true;
			window.onbeforeunload = function(){
				if (confirm (confirmationBeforeUnload))
					return true;
					else {
						$("#wait").hide();
						return false;
						}
				};
			})
		
		$(".boutonSuppr").click(function(){
			var coursGrp = $(this).siblings(".inputCoursGrp").val();
			var bulletin = $(this).siblings(".inputBulletin").val();
			var date = $(this).siblings(".inputDate").val();
			var libelle = $(this).siblings(".inputLibelle").val();
			var remarque = $(this).siblings(".inputRemarque").val();
			var neutralise = $(this).siblings(".inputNeutralise").val();
			var formCert = $(this).siblings(".inputFormCert").val();
			var max = $(this).siblings(".inputMax").val();
			var idComp = $(this).siblings(".inputIdComp").val();						
			var comp = $(this).siblings(".inputComp").val();
			var idCarnet = $(this).siblings(".inputIdCarnet").val();
			
			$("#formDel .spDate").text(date);
			$("#formDel .spComp").text(comp);
			$("#formDel .spLibelle").text(libelle);
			$("#formDel .spRemarque").text(remarque);
			if (neutralise == 1)
				$("#formDel .spNeutralise").text("O");
				else $("#formDel .spNeutralise").text("N");
			$("#formDel .spFormCert").text(formCert);
			$("#formDel .spMax").text(max);
			$("#formDel .inputIdCarnet").val(idCarnet);
			
			var pos = $(this).position();
			var width = $("#delCote").outerWidth();
			$("#delCote").css({
				position: "absolute",
				top: pos.top + "px",
				left: (pos.left-width) + "px"
				}).fadeIn("slow");
			return false;
			})
		
		$("#boutonPlus").click(function(){
			var pos = $(this).position();
			var width = $("#editCote").outerWidth();
			var coursGrp = $(this).siblings(".inputCoursGrp").val();
			var bulletin = $(this).siblings(".inputBulletin").val();

			$("#formEdit .erreurEncodage").text('');
			$("#editCote .editTitle .title").text("Création d'une cote");
			$("#formEdit .effacer").val('');
			$("#formEdit .inputForm").attr("checked",true);
			$("#formEdit .inputNeutralise").attr("checked",false);
			// $("#formEdit .inputCoursGrp").val(coursGrp);
			// $("#formEdit .inputBulletin").val(bulletin);
			$("#editCote").css({
				position: "absolute",
				top: pos.top + "px",
				left: (pos.left+20) + "px"
				}).fadeIn("slow");
			return false;
			})
			
		$(".boutonEdit").click(function(){
			var pos = $(this).position();
			var width = $("#editCote").outerWidth();
			var coursGrp = $(this).siblings(".inputCoursGrp").val();
			var bulletin = $(this).siblings(".inputBulletin").val();
			var date = $(this).siblings(".inputDate").val();
			var idComp = $(this).siblings(".inputIdComp").val();
			var idCarnet = $(this).siblings(".inputIdCarnet").val();
			var libelle = $(this).siblings(".inputLibelle").val();
			var remarque = $(this).siblings(".inputRemarque").val();
			var neutralise = $(this).siblings(".inputNeutralise").val();
			var formCert = $(this).siblings(".inputFormCert").val();
			var max = $(this).siblings(".inputMax").val();
			
			$("#editCote .editTitle .title").text("Modification d'une cote");
			$("#formEdit .erreurEncodage").text('');
			$("#formEdit .inputCoursGrp").val(coursGrp);
			$("#formEdit .inputBulletin").val(bulletin);
			$("#formEdit .inputDate").val(date);
			$("#formEdit #idComp").val(idComp);
			$("#formEdit .inputIdCarnet").val(idCarnet);
			if (formCert == 'form')
				$("#formEdit .inputForm").attr("checked", true);
			if (formCert == 'cert')
				$("#formEdit .inputCert").attr("checked", true);
			if (neutralise == 1)
				$("#formEdit .inputNeutralise").attr("checked", true);
				else $("#formEdit .inputNeutralise").attr("checked", false);
			$("#formEdit .inputLibelle").val(libelle);
			$("#formEdit .inputRemarque").val(remarque);
			$("#formEdit .inputMax").val(max);

			$("#editCote").css({
				position: "absolute",
				top: pos.top + "px",
				left: (pos.left-width) + "px"
				}).fadeIn("slow");
			return false;
			})

		$("#closeAjout").click(function(){
			$("#editCote").fadeOut();
			})
		$("#closeSuppr").click(function(){
			$("#delCote").fadeOut();
			})
		

		$( "#date").datepicker({ 
			dateFormat: "dd-mm-yy",
			prevText: "Avant",
			nextText: "Après",
			monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
			dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
			firstDay: 1
			});

		// -------------------------------------------------------------------------------------
		// pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
		// de webkit, il ne faut pas utiliser la règle "date" du validateur jquery.validate.js
		// Elle sera remplacée par la règle "uneDate" dont le fonctionnement n'est pas basé sur
		// le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
		// exclusivement les dates au format américain mm-dd-yyyy
		// sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
		// https://github.com/jzaefferer/jquery-validation/issues/20
		// -------------------------------------------------------------------------------------
		jQuery.validator.addMethod('uneDate', function(value, element) { 
			var reg=new RegExp("-", "g");
			var tableau=value.split(reg);
			jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2],10);
			nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
			var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
			console.log(parseInt(jour));
			condMois = ((mois >= 1) && (mois <= 12));
			if (!(condMois)) return false;
			condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
			condAnnee = ((annee > 1900) && (annee < 2100));
			var testDateOK = (condMois && condJour && condAnnee);
			return this.optional(element) || testDateOK; 
			}, "Date incorrecte");
						

		$("#formEdit").validate({
			errorElement: "em",
			errorClass: "erreurEncodage",
			rules: {
				date: {
					required: true,
					uneDate: true
					},
				idComp: {required: true},
				max: {
					required: true,
					range: [0,1000]
					}
				} 
			});
			
		$("#formEdit").submit(function(){
			// $.blockUI();
			// $("#wait").show();
			
			})

		$(document).keydown(function(e){
			if (e.keyCode == 27)
				$(".popup").fadeOut();
			})

		// fonction qui retourne le numéro de la colonne cliquée
		$.fn.column = function(i) {
			return $('tr td:nth-child('+(i+1)+')', this);
		}

		$(".coteCarnet").click(function(){
			var col = $(this).closest("td").index();
			$('.carnetCotes').column(col).find("input").attr("readonly",false);
			})
			
		$(".verrou").click(function(){
			var col = $(this).parents('th').index();
			$('.carnetCotes').column(col).find("input").attr("disabled",false).show();
			$('.carnetCotes').column(col).find("span").hide();
			$(this).fadeOut();
			})
			
		$("#reset").click(function(){
			if (modifie && confirm(confirmationReset)) {
				$('.carnetCotes input').attr('disabled', true).hide().next("span").show();
				$('.verrou').fadeIn();
				modifie = false;
				window.onbeforeunload = function(){};
				}
			})

		$("#submit").click(function(){
			$.blockUI();
			modifie = false;
			window.onbeforeunload = function(){};
			})

			
		 $("input.coteCarnet").focusin(function(){
			if (($(this).attr("disabled")) != "disabled")
				$(this).closest('tr').addClass("eleveSelectionne");
			})
		$(".coteCarnet").focusout(function(){
			$(this).closest('tr').removeClass("eleveSelectionne");
		}) 

		$(".infoSup").click(function(){
			var test = $(this);
			$(this).find(".lesInfos").toggle();
			})


	})

{/literal}
</script>
