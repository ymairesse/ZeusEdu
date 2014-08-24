<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<div  style="clear:both">
	<form enctype="multipart/form-data" name="mailing" id="mailing" method="POST" action="index.php">

	<div class="selectMail gauche">
	<h3>Destinataires</h3>

	<!--	tous les utilisateurs -->
	<h4 class="teteListe" title="Cliquer pour ouvrir"><input type="checkbox" class="checkListe">{$listeProfs.nomListe}</h4>
	<ul class="listeMails" style="display:none">
	{assign var=membresProfs value=$listeProfs.membres}
	{foreach from=$membresProfs key=acro item=prof}
		<li><input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
			<span class="label">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
		</li>
	{/foreach}
	</ul>

	<!--	tous les titulaires (profs principaux) -->
	<h4 class="teteListe" title="Cliquer pour ouvrir"><input type="checkbox" class="checkListe">{$listeTitus.nomListe}</h4>
	<ul class="listeMails" style="display:none">
	{assign var=membresProfs value=$listeTitus.membres}
	{foreach from=$membresProfs key=acro item=prof}
		<li><input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
			<span class="label">{$prof.classe} {$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
		</li>
	{/foreach}
	</ul>

	<!-- 	toutes les autres listes personnelles ou publiées -->
	{foreach from=$listesAutres key=idListe item=listePerso}
	{assign var=membresProfs value=$listePerso.membres}
	<h4 class="teteListe" title="{if $membresProfs == Null}Liste vide{else}Cliquer pour ouvrir{/if} :
		{if $listePerso.statut == 'publie'}Publié{elseif $listePerso.statut == 'abonne'}Abonné{else}Personnel{/if}">
		<input type="checkbox" class="checkListe">{$listePerso.nomListe}
		<img src="../images/{if $listePerso.statut == 'publie'}shared{elseif $listePerso.statut == 'abonne'}abonne{else}personal{/if}.png" alt="{$listePerso.statut}"></h4>
	{if $membresProfs != Null}
	<ul class="listeMails" style="display:none">
			{foreach from=$membresProfs key=acro item=prof}
			<li><input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
			<span class="label">{$prof.nom|truncate:15:'...'} {$prof.prenom} {$prof.classe|default:''}</span>
		</li>
		{/foreach}
	</ul>
	{/if}
	{/foreach}
	</div>

	<div class="droit">
		<h3>Votre mail</h3>
		<p><strong>Expéditeur:</strong>
		{if $userStatus == 'direction' || $userStatus == 'admin'}
			<select name="mailExpediteur">
				<option value="{$NOREPLY}">{$NOMNOREPLY}</option>
			{foreach from=$listeDirection key=acro item=someone}
				<option value="{$someone.mail}"{if $acronyme == $acro} selected="selected"{/if}>{$someone.nom}</option>
			{/foreach}
			</select>
		{else}
			<input type="hidden" name="mailExpediteur" value="{$identite.mail}">
			<span style="font-weight:bold">{$identite.prenom} {$identite.nom}</span>
		{/if}
		</p>
		<p><span id="grouper" title="créer un groupe" style="display:none"><img src="images/groupe.png" alt="grouper"></span>
			<strong>Destinataire(s):</strong> <span style="font-weight:bold" id="destinataires"></span></p>
		<p id="nomGroupe" style="display: none"> <strong>Nom du groupe: </strong> <input type="text" id="groupe" name="groupe" maxlength="30" size="30" placeholder="Nom du groupe"></p>
		<p><strong>Objet:</strong> <input type="text" name="objet" id="objet" maxlength="80" size="75" placeholder="Objet de votre mail"></p>
		<textarea id="texte" name="texte" cols="80" rows="15" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true"></textarea>
		<input type="hidden" name="MAX_FILE_SIZE" value="4000000">
		{foreach from=$nbPJ key=n item=wtf}
			<div class="labelpj" id="pj{$n}" style="text-align:right;">Pièce jointe <input class="pj" type="file" name="PJ_{$n}" id="PJ_{$n}"></div>
		{/foreach}
		Ajout de disclaimer: <input type="checkbox" name="disclaimer" value="1" checked="checked">
		<input type="hidden" id="nomExpediteur" name="nomExpediteur" value="{$identite.prenom} {$identite.nom}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="action" value="{$action}">
		<input type="Submit" name="submit" value="Envoyer" class="fauxBouton">
	</div>

	</form>
</div>

<script type="text/javascript">
$(document).ready(function(){
	$("h4.teteListe").click(function(){
		$(this).next(".listeMails").fadeToggle('slow');
		})

	$(".checkListe").click(function(event){
		event.stopPropagation();
		})

	$(".checkListe").click(function(){
		$(this).parent().next().find('.selecteur').trigger('click');
		})

	$(".labelpj").hide();
	$("#pj0").show();

	$(".pj").change(function(){
		if ($(this).val() != '') {
			var numero = eval($(this).attr('id').substr(3,1))+1;
			$("#pj"+numero).fadeIn('slow');
			}
		})

	$(".expediteur").click(function(){
		$(".expediteur").next().css('fontWeight','normal');
		$(this).next().css('fontWeight','bold');
		var nom = $(this).next().text();
		$("#nomExpediteur").val(nom);
		})

	$("#mailing").submit(function(){
		var okObjet = true; var okMail = true; var okTexte = true;
		var message = '';
		if ($("#objet").val() == '') {
			okObjet = false;
			message = 'Votre message n\'a pas d\'objet\n';
			}
		if ($("#destinataires").text() == '') {
			okMail = false;
			message += 'Veuillez sélectionner au moins une adresse mail.\n';
			}
		value = CKEDITOR.instances['texte'].getData();
		if (value.trim() == '') {
			okTexte = false;
			message += 'Votre mail est vide';
			}

		if (okObjet && okMail && okTexte) {
			$("#wait").show();
			return true
			}
			else {
				alert(message);
				return false;
				}
			});

	$(".selecteur").click(function(){
		var nb = $(".selecteur:input:checked").length;
		if (nb > 0) $("#grouper").show();
			else $("#grouper").hide();
		if (nb < 4) {
			var checkedValues = $('.selecteur:input:checkbox:checked').map(function() {
				destinataire = this.value.split('#');
				return destinataire[0];
			}).get();
			$("#destinataires").text(checkedValues);
			}
			else $("#destinataires").text(nb+" destinataires");
		})

	$(".label").click(function(){
		$(this).prev().trigger('click');
		})


	$("#grouper").click(function(){
		var listeMails = $(".mails:input:checkbox:checked");
		$("#nomGroupe").fadeIn(1000);
		$("#groupe").focus();
		})

	})
</script>
