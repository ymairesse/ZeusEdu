<h2>{$eleve.nom} {$eleve.prenom} | {$eleve.groupe}</h2>

{assign var=contexte value='formulaire'}

<h3 style="color:#{$prototype.structure.couleurTexte}; background-color:#{$prototype.structure.couleurFond}">{$prototype.structure.titreFait}</h3>
{strip}
<form name="editFaitDisc" id="editFaitDisc" action="index.php" method="POST">
	<img style="float:right; width:100px" src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo draggable" title="{$eleve.prenom} {$eleve.nom}">

	{foreach from=$prototype.champs key=unChamp item=data}
	{if in_array($contexte, explode(',',$data.contextes))}
	
		{if $data.typeChamp != 'hidden'}
			<label for="{$unChamp}">{$data.label}</label>
		{/if}
		
		{strip}
		{if $data.typeChamp == 'text'}
		<input type="{$data.typeChamp}" name="{$unChamp}" id="{$unChamp}" class="
				{$data.classCSS} 
				{if ($data.typeDate == 1)} uneDate{/if}
				{if ($data.autocomplete == 'O')} autocomplete{/if}
				" value="{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
			{if $data.size > 0} size="{$data.size}"{/if}
			{if $data.maxlength > 0} maxlength="{$data.maxlength}"{/if}
			{if $data.colonnes > 0} cols="{$data.colonnes}"{/if}
			{if $data.lignes > 0} rows="{$data.lignes}"{/if}>
			{if $unChamp == 'professeur'} <span id="nomPrenom"></span>{/if}
			<br>
		{/if}
		{/strip}
		
		{strip}
		<span class="textEtMemo">
		{if $data.typeChamp == 'textarea'}
			<textarea {if $data.colonnes > 0}cols="{$data.colonnes}" {/if}
				{if $data.lignes > 0}rows="{$data.lignes}" {/if}
				name="{$unChamp}">{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}</textarea>

				<span class="saveMotif" id="{$unChamp}" title="Enregistrer"><img src="../images/disk.png" alt="xx"></span>
				<span class="saveOK_{$unChamp}"></span><br>

				{if isset($listeMemos.$unChamp)}
				<label for="memos_{$unChamp}">^^^^^^^</label>
				{assign var=liste value=$listeMemos.$unChamp}
					<select name="memos" class="memos" id="memos_{$unChamp}" style="width:40em">
						<option value="">Sélectionner un texte</option>
						{foreach from=$liste key=k item=unMemo}
						<option value="{$k}">{$unMemo.texte}</option>
						{/foreach}
					</select>
				<a href="javascript:void(0)" class="copier" title="copier le texte"><span ><img src="../images/up.png" alt="^"></span></a>
				{/if}
				
			<br>
		{/if}
		</span>
		{/strip}
		
		{strip}
		{if $data.typeChamp == 'select'}
			{if $unChamp == 'idretenue'}
			<input type="hidden" name="oldIdretenue" value="{$fait.idretenue|default:''}">
			<select name="{$unChamp}" id="{$unChamp}">
				<option value=''>Choisir une date</option>
				{foreach from=$listeRetenues key=unidretenue item=uneRetenue}
					{if $uneRetenue.affiche == 'O'}
						<option value="{$unidretenue}"{if $uneRetenue.places <= $uneRetenue.occupation} disabled="disabled"{/if}
						{if isset($fait.idretenue) && ($fait.idretenue == $unidretenue)} selected="selected"{/if}>
						{$uneRetenue.jourSemaine} {$uneRetenue.dateRetenue} [durée: {$uneRetenue.duree}h à {$uneRetenue.heure}] : {$uneRetenue.occupation}/{$uneRetenue.places}</option>
					{/if}
				{/foreach}
			</select>
			{/if}
			<br>
		{/if}
		{/strip}
		
		{strip}
		{if $data.typeChamp == hidden}
		<input type="hidden" name="{$unChamp}" id="{$unChamp}" {if $unChamp == 'qui'}
				value="{$identite.acronyme}"
				{elseif $unChamp == 'matricule'}
				value="{$eleve.matricule}"
				{elseif $unChamp == 'type'}
				value="{$prototype.structure.type}"
				{else} value="{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
			   {/if}>
		{/if}
		{/strip}
		
	{/if}
	
	{/foreach}
	<input type="submit" name="submit" value="Enregistrer">
	<input type="reset" name="reset" value="Annuler">
	<a href="index.php?action=eleves&amp;classe={$classe}&amp;matricule={$matricule}" style="float:right"><span class="fauxBouton">Retour sans enregistrer</span></a>
	<input type="hidden" name="classe" value="{$eleve.groupe}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">

</form>

<script type="text/javascript">
{literal}
$.validator.addMethod(
    "dateFr",
    function(value, element) {
        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "date au format jj/mm/AAAA svp"
);

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
		var reg=new RegExp("/", "g");
		var tableau=value.split(reg);
		// ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
		// au risque que les numéros des jours et des mois commençant par "0" soient
		// considérés comme de l'octal
		// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
		jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2], 10);
		nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
		var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		condMois = ((mois >= 1) && (mois <= 12));
		if (!(condMois)) return false;
		condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
		condAnnee = ((annee > 1900) && (annee < 2100));
		var testDateOK = (condMois && condJour && condAnnee);
		return this.optional(element) || testDateOK;
		}, "Date incorrecte");

$(document).ready(function(){

	$("#editFaitDisc").validate({
			rules: {
				idretenue: {
					required:true
					},
				uneDate: {
					required:true,
					uneDate: true
					},
				motif: {
					required: true
					}
				},
			errorElement: "span"
			}
	)
	
	$("#ladate").datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "",
		nextText: "",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNames: [ "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" ],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	
		});

	$('#timepicker').timepicker({
		hourText: 'Heures',
		minuteText: 'Minutes',
		amPmText: ['AM', 'PM'],
		timeSeparator: ':',
		nowButtonText: 'Maintenant',
		showNowButton: true,
		closeButtonText: 'OK',
		showCloseButton: true,
		deselectButtonText: 'Désélectionner',
		showDeselectButton: true,
		hours: {starts: 8, ends: 17},
		showDeselectButton: false
		});

	$(".saveMotif").css("cursor","pointer");
	
	$(".saveMotif").click(function(){
		var test = $(this);
		var texte = $(this).prev().val();
		var qui = $("form").find("input#qui").val();
		var champ = $(this).attr("id");
		
		if (texte != '') {
			$.post("inc/saveTexte.inc.php",
				{'texte': texte,
				 'qui': qui,
				 'champ': champ},
					function (resultat) {
						$(this).next().html(resultat).show();
						}
					);
		}
		$(this).hide();
		})
	
	$(".textEtMemo textarea").keyup(function(){
		$(this).parent().find(".saveMotif").show();
		})
	
	$(".copier").click(function(){
		var test = $(this);
		var ajout = $(this).parent().find("select option:selected").text();
		var texte = $(this).parent().find("textarea").val();
		texte = texte + " " + ajout;
		$(this).parent().find("textarea").val(texte);
		$(this).parent().find(".saveMotif").show();	
		})
	
	$("#professeur").blur(function(){
		var acronyme = $(this).val().toUpperCase();
		$(this).val(acronyme);
		if (acronyme != '') {
			$.post("inc/nomPrenom.inc.php",
				{'acronyme': acronyme},
				function(resultat) {
					$("#nomPrenom").html(resultat)
					});
			}
			})
})
{/literal}
</script>