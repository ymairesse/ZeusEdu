<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<div  style="clear:both">
	<form enctype="multipart/form-data" name="mailing" id="mailing" method="POST" action="index.php">

	<div class="selectMail gauche">
	<h3>Destinataires</h3>
	{foreach from=$listes key=nomListe item=liste}
		<ul>
			<li style="font-weight:bold"><input type="checkbox" class="checkListe" title="cliquer pour tout sélectionner">
				<span title="cliquer pour ouvrir" class="teteListe">{$nomListe}</span></li>
			<li>
				<ul style="display:none">
				{foreach from=$liste key=acronyme item=prof}
					<li><input class="selecteur" type="checkbox" name="mails[]" value="{$prof.mail}"> {$prof.nom|truncate:15:'...'} {$prof.prenom} {$prof.classe|default:''}
					</li>
				{/foreach}
				</ul>
			</li>
		</ul>
	{/foreach}
	</div>

	<div class="droit">
		<h3>Votre mail</h3>
		<p><strong>Expéditeur:</strong>
		{if $userStatus == 'direction' || $userStatus == 'admin'}
			<input type="radio" class="expediteur" name="mailExpediteur" value="{$identite.mail}" checked="checked">
			<span class="nomExpediteur" style="font-weight:bold" title="{$identite.mail}">{$identite.prenom} {$identite.nom}</span>
			<input type="radio" class="expediteur" name="mailExpediteur" value="{$NOREPLY}">
			<span class="nomExpediteur" style="font-weight:bold" title="{$NOREPLY}">Ne pas répondre</span>
		{else}
			<input type="hidden" name="mailExpediteur" value="{$identite.mail}">
			<span style="font-weight:bold">{$identite.prenom} {$identite.nom}</span>
		{/if}
		</p>
		<p><strong>Objet:</strong> <input type="text" name="objet" id="objet" maxlength="80" size="75" placeholder="Objet de votre mail"></p>
		<textarea id="texte" name="texte" cols="80" rows="15" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true"></textarea>
		<input type="hidden" name="MAX_FILE_SIZE" value="4000000">
		{foreach from=$nbPJ key=n item=wtf}
			<div class="labelpj" id="pj{$n}" style="text-align:right;">Pièce jointe <input class="pj" type="file" name="PJ_{$n}" id="PJ_{$n}"></div>
		{/foreach}
		<input type="hidden" id="nomExpediteur" name="nomExpediteur" value="{$identite.prenom} {$identite.nom}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="action" value="{$action}">
		<input type="Submit" name="submit" value="Envoyer" class="fauxBouton">
	</div>

	</form>
</div>

<script type="text/javascript">
$(document).ready(function(){
	$(".teteListe").click(function(){
		$(this).parent().next().find('ul').fadeToggle('slow');
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
		if ($(".selectMail").find("input:checkbox:checked").length == 0) {
			okMail = false;
			message += 'Veuillez sélectionner au moins une adresse mail.\n';
			}
		value = CKEDITOR.instances['texte'].getData();
		if (value.trim() == '') {
			okTexte = false;
			message += 'Votre mail est vide';
			}

		if (okObjet && okMail && okTexte)
			return true
			else {
				alert(message);
				return false;
				}

			});

	})
</script>
