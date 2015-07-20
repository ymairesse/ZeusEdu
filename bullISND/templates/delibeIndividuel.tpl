<div class="container">

<h2>{$eleve.nom} {$eleve.prenom}</h2>

	<div class="row">
		
		<div class="col-md-10 col-sm-12">

				<form name="form" method="POST" action="index.php" id="formulaire" role="form" class="form-inline">
				<input type="hidden" name="action" value="delibes">
				<input type="hidden" name="mode" value="individuel">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="classe" value="{$classe}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="mailEleve" value="{$decision.user}@{$decision.mailDomain}">
					
				<div class="table-responsive">
					
				<table class="table table-hover table-condensed">
					<tr>
						<thead>
							<th>Cours</th>
							<th>&nbsp;</th>
							<th style="width:4em">Déc.</th>
							<th style="width:4em">Juin</th>
							<th style="width:30%">Remarque Déc</th>
							<th style="width:30%">Remarque Juin</th>
						</thead>
					</tr>
				
					{foreach from=$listeCours key=coursGrp item=unCours}
						<tr class="{$unCours.statut}">
						<td style="width:30%"
							class="pop"
							data-container="body"
							data-original-title="{$unCours.prenom} {$unCours.nom}"
							data-content="{$unCours.libelle}"
							data-html="true">
							{$unCours.statut}: {$unCours.libelle}
						</td>
						
						<td>{$unCours.nbheures}h</td>
						{foreach from=$listePeriodes item=periode}
							{if isset($listeSituations.$coursGrp.$periode)}
							<td class="cote {if ($listeSituations.$coursGrp.$periode.sitDelibe < 50)
									&& ($listeSituations.$coursGrp.$periode.sitDelibe|trim != '')
									&& ($listeSituations.$coursGrp.$periode.attributDelibe != 'hook')}echec{/if}"
								{* si on a connaissance d une cote interne, en plus, on l indique en infobulle *}
								{if isset($listeSituations.$coursGrp.$periode.sitInterne)}
									title="Cote interne {$listeSituations.$coursGrp.$periode.sitInterne}%"
									data-container="body"
								{/if}>
								{if $listeSituations.$coursGrp.$periode.attributDelibe == 'hook'}[{$listeSituations.$coursGrp.$periode.sitDelibe|default:'&nbsp;'}]
									{else}
									{$listeSituations.$coursGrp.$periode.sitDelibe|default:'&nbsp;'}{$listeSituations.$coursGrp.$periode.symbole}
								{/if}
							</td>
							{else}
							<td>&nbsp;</td>
							{/if}
						{/foreach}
						
						<td class="remarqueDelibe pop"
							data-container="body"
							data-original-title="{$unCours.prenom} {$unCours.nom}"
							data-content="{$listeRemarques.$matricule.$coursGrp.2|default:''}"
							data-placement="top"
							data-html="true">
							{$listeRemarques.$matricule.$coursGrp.2|default:'&nbsp;'|truncate:80}
						</td>
						<td class="remarqueDelibe pop"
							data-container="body"
							data-original-title="{$unCours.prenom} {$unCours.nom}"
							data-content="{$listeRemarques.$matricule.$coursGrp.5|default:''}"
							data-html="true"
							data-placement="top">
							{$listeRemarques.$matricule.$coursGrp.5|default:'&nbsp;'|truncate:80}
							</td>
						</tr>
					{/foreach}
					
					<tr class="conclusionDelibe">
						<td>Moyennes</td>
						<td>&nbsp;</td>
						<td class="cote {if {$delibe[2].moyenne} && {$delibe[2].moyenne} < 50}echec{/if}">
							<strong>{$delibe[2].moyenne|default:'&nbsp;'}</strong>
						</td>
						<td class="cote {if {$delibe[5].moyenne} && {$delibe[5].moyenne} < 50}echec{/if}">
							<strong>{$delibe[5].moyenne|default:'&nbsp;'}</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="conclusionDelibe">
						<td>Nb Echecs</td>
						<td>&nbsp;</td>
						<td class="cote">
						{if $delibe[2].nbEchecs > 0}
							<strong>{$delibe[2].nbEchecs}</strong>
							{else}
							&nbsp;
						{/if}	
						</td>
						<td class="cote">
						{if $delibe[5].nbEchecs > 0}
							<strong>{$delibe[5].nbEchecs}</strong>
							{else}
							&nbsp;
						{/if}
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="conclusionDelibe">
						<td>Nb Heures Echec</td>
						<td>&nbsp;</td>
						<td class="cote">
						{if $delibe[2].nbHeuresEchec > 0}
							<strong>{$delibe[2].nbHeuresEchec}h</strong>
						{else}
						&nbsp;
						{/if}
						</td>
						<td class="cote">
						{if $delibe[5].nbHeuresEchec > 0}
							<strong>{$delibe[5].nbHeuresEchec}h</strong>
						{else}
						&nbsp;
						{/if}
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="conclusionDelibe">
						<td>Cours en échec (déc)</td>
						<td>&nbsp;</td>		
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="2" style="font-size:0.8em">{if $delibe[2].nbHeuresEchec > 0}{$delibe[2].cours}{else}&nbsp;{/if}</td>
					</tr>
					<tr class="conclusionDelibe">
						<td>Cours en échec (juin)</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="2" style="font-size:0.8em">{if $delibe[5].nbHeuresEchec > 0}{$delibe[5].cours}{else}&nbsp;{/if}</td>
					</tr>
					<tr class="conclusionDelibe">
						<td>Mention Initiale</td>
						<td>&nbsp;</td>
						<td class="cote"><strong>{$mentions.2|default:'&nbsp;'}</strong></td>
						<td class="cote"><strong>{$mentions.5|default:'&nbsp;'}</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="decisionDelibe">
						<td>Mention Finale</td>
						<td>&nbsp;</td>
						
						{foreach from=$listePeriodes item=periode}
							<td class="cote {if isset($mentionsAttribuees.$matricule.$ANNEESCOLAIRE.$annee.$periode) &&
												$mentionsAttribuees.$matricule.$ANNEESCOLAIRE.$annee.$periode == 'I'} echec{/if}">
								{if $estTitulaire}
								<input type="text"
										name="mentions_{$periode}"
										value="{$mentionsAttribuees.$matricule.$ANNEESCOLAIRE.$annee.$periode|default:''}" 
										class="inputMention" maxlength="6" size="3"
										{if !($estTitulaire)} disabled{/if}>
								{else}
									<strong>{$mentionsAttribuees.$matricule.$ANNEESCOLAIRE.$annee.$periode|default:'&nbsp;'}</strong>
								{/if}
							</td>
						{/foreach}
				
						<td colspan="2">
							{if $estTitulaire}
								<div class="pull-right pop"
									 data-container="body"
									 data-content="Dé/verrouiller"
									 data-placement="top"
									 style="font-size:2em">
									<i class="fa fa-lock" id="lock"></i>
								</div>
							{else}
							&nbsp;
							{/if}
						</td>
					</tr>
			{*-------------------- décision de délibé  --------------------*}
					<tr class="decisionDelibe">
						<td colspan="2">
							<div class="form-group pull-right">
								<label for="decision" class="sr-only">Décision</label>
								<select name="decision" id="decision" class="form-control"{if !($estTitulaire)} disabled{/if}>
									<option value="">Choisir une décision</option>
									<option value="Réussite"{if $decision.decision == 'Réussite'} selected{/if}>Réussite</option>
									<option value="Échec"{if $decision.decision == 'Échec'} selected{/if}>Échec</option>
									<option value="Ajournement"{if $decision.decision == 'Ajournement'} selected{/if}>Ajournement</option>
									<option value="Restriction"{if $decision.decision == 'Restriction'} selected{/if}>Restriction avec accès en</option>
									<!-- <option value="TEST"{if $decision.decision == 'TEST'} selected{/if}>TEST</option> -->									
								</select>
							</div>				
						</td>
						<td colspan="4">
							<div class="form-group">
								<label for="restriction" class="sr-only">Accès en</label>
								<input type="text"
									   name="restriction"
									   maxlength="40"
									   {if !($estTitulaire)} disabled{/if}
									   id="restriction"
									   value="{$decision.restriction|default:''}"
									   class="form-control"
									   placeholder="Accès en">
							</div>

						</td>
					</tr>
					{if $estTitulaire}
					<tr class="decisionDelibe">
						<td colspan="3">
							<div class="form-group">
								<label for="envoiMail">Envoi du mail</label>
								<input type="checkbox"
									   value="true"
									   name="mail"
									   id="envoiMail"
									   {if (!(isset($decision.mail)) || (isset($decision.mail) && ($decision.mail==1)))}checked{/if}
									   {if !($estTitulaire)} disabled{/if}
									   class="form-control">
							</div>
							<div class="form-group">
								<label class="sr-only" for="adresseMail">Email</label>
								<input type="text"
									{if isset($decision.adresseMail) && ($decision.adresseMail != '')}
										value="{$decision.adresseMail}"
									{else}
										value="{$decision.user}@{$decision.mailDomain}"
									{/if}"
									name="adresseMail"
									id="adresseMail"
									maxlength="30"
									{if !($estTitulaire)} disabled{/if}
									placeholder="Adresse mail"
									class="form-control">
							</div>
						</td>
						<td colspan="3">
							<div class="form-group">
								<label> Notification isnd.be/eleve</label>
								<input type="checkbox"
									   value="true"
									   name="notification"
									   id="notification"
									   {if !($estTitulaire)} disabled{/if}
									   {if !(isset($decision.notification)) || (isset($decision.notification) && ($decision.notification==1))}checked{/if}
									   class="form-control">
							</div>
				
							<div class="btn-group pull-right" id="submitGroup">
								<button type="reset" class="btn btn-default" id="annuler">Annuler</button>
								<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>								
							</div>
						</td>
					</tr>
					{/if}
				</table>
				
				</div>  <!-- table-responsive -->
				
				</form>
				
				<p>Symbolique:</p>
				<ul class="symbolique fdelibe">
				<li>² => réussite degré</li>
				<li><i class="fa fa-star"></i> => cote étoilée</li>
				<li><i class="fa fa-magic"></i> => baguette magique</li>
				<li><i class="fa fa-graduation-cap"></i> => épreuve externe</li>
				<li>[xx] => non significatif</li>
				</ul>

		</div>  <!-- col-md-... -->
		
		<div class="col-md-2 col-sm-12">

			<p id="photoEleve"><img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" title="{$eleve.nom }{$matricule}" class="photo img-responsive"></p>			
			
		</div>

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

var modifie = false;
var locked = true;
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
	
	function modification () {
	if (!(modifie)) {
		modifie = true;
		window.onbeforeunload = function(){
			return confirm (confirmationBeforeUnload);
		}}
	}
	
$(document).ready(function(){
	
	$(".decisionDelibe input, .decisionDelibe select").attr("disabled","disabled");
	$("#submitGroup button").attr('didabled','disabled').hide();
	var locked=true;
	
		
	$(".inputMention").keyup(function(e){
	var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
	if ((key > 31) || (key == 8)) {
		modification();
		$(this).val($(this).val().toUpperCase());
		}
	})
	
	$("#lock").click(function(){
		if (locked) {
			$("#submitGroup button").attr('disabled',false).fadeIn();
			$(".decisionDelibe input, .decisionDelibe select").attr("disabled",false);
			}
			else {
			$("#submitGroup button").attr('disabled',false).fadeOut();
			$(".decisionDelibe input, .decisionDelibe select").attr("disabled",true);
			};
		locked = !(locked);
		})
	
	$("#decision").change(function(){
		if ($(this).val() != 'Restriction') {
			$("#restriction").val('');
			}
			else $("#restriction").focus();
		});
	
	$("#restriction").focus(function(){
		if ($("#decision").val() != 'Restriction')
			$("#decision").val('Restriction');
		})

	$("#formulaire").submit(function(){
		if (($("#decision").val() == 'restriction') && $("#restriction").val().trim() == '' ) {
			alert('Vous n\'avez pas indiqué les restrictions');
			$("#restriction").focus();
			return false;
			}
		else {
			$.blockUI();
			$("#wait").show();
			}
		});
	
	$("#annuler").click(function(){
	if (confirm(confirmationReset)) {
		$("#formulaire")[0].reset();
		modifie = false;
		window.onbeforeunload = function(){};
		return false
	}
	})
	
})

</script>
