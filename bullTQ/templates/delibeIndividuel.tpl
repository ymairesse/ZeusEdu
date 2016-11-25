<div class="container">

	{assign var=inputOK value=in_array($classe,$tituTQ)}

	<div class="row">

		{if $estTitulaire}

		<form action="index.php" id="cotesCours" name="cotesCours" method="POST" role="form" class="form-vertical">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="{$etape}">
			<input type="hidden" value="{$matricule}" name="matricule" id="matricule">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="mailEleve" value="{$decision.user}@{$decision.mailDomain}">
			{/if}

			{* ------------------------------------------------------------------ *}
			{* moitié gauche de l'écran ------------------------------------------*}
			{* ------------------------------------------------------------------ *}
			<div class="col-md-6 col-sm-12">

				<div class="row">
					<div class="col-xs-10">

						<table style="width: 80%;" class="table table-condensed table-hover">
							<thead>
								<tr>
									<td>Année scolaire</td>
									<td colspan="2"><strong>{$anneeScolaire}</strong></td>
								</tr>
							</thead>
							<tr>
								<td>Nom</td>
								<td class="pop"
									data-toggle="popover"
									data-content="<img src='../photos/{$nomPrenomClasse.photo}.jpg' alt='{$matricule}' height='140px'><br>
									<span class='micro'>{$nomPrenomClasse.prenom} {$nomPrenomClasse.nom}<br>{$matricule}</span>"
									data-container="body"
									data-html="true"
									data-placement="right">

									<strong>{$nomPrenomClasse.nom} {$nomPrenomClasse.prenom}</strong>

								</td>
							</tr>
							<tr>
								<td>Classe</td>
								<td><strong>{$nomPrenomClasse.classe}</strong></td>
							</tr>
							</tbody>
						</table>

					</div>

					<div class="col-xs-2">
						<img src="../photos/{$nomPrenomClasse.photo}.jpg" alt="{$matricule}" class="img-responsive">
						{if $estTitulaire}
							<button type="button" name="button" class="btn btn-xs btn-danger btn-block pull-right" id="lock">
								<i class="fa fa-lock"></i>
							</button>
						{/if}
					</div>

					<div id="boutonsTitu" class="hidden">
						<div class="col-xs-3">
							<button type="reset" class="btn btn-default btn-sm btn-block">Annuler</button>
						</div>

						<div class="col-xs-9">
							<button type="submit" class="btn btn-primary btn-sm btn-block" id="save">Enregistrer</button>
						</div>
					</div>
				</div>


				<table class="table table-condensed tableauBull">
					<tr>
						<th>Cours</th>
						<th>h</th>
						{foreach from=$listePeriodes key=periode item=nomPeriode}
							<th>{$nomPeriode}</th>
						{/foreach}
					</tr>

					{foreach from=$listeCours key=type item=lesCours}
						{foreach from=$lesCours key=coursGrp item=dataCours}
							{assign var=nomProfs value=implode(', ', $listeCours[$type][$coursGrp]['profs'])}

							<tr class="{$dataCours.statut}" data-container="body" data-html="true" title="{$nomProfs}">
								<td>{$dataCours.libelle}</td>
								<td>{$dataCours.nbheures}</td>
								{foreach from=$listePeriodes key=periode item=wtf}
									<td class="cote">{$listeCotes[$type][$coursGrp]['global'][$periode]|default:''}</td>
								{/foreach}
							</tr>
						{/foreach}
					{/foreach}

{*
ANCIEN
					{foreach from=$listeCotes item=type}
						{foreach from=$type item=unCours}
						<tr class="{$unCours.statut}" data-container="body" data-html="true" title="{$unCours.nomProf}<br>[{$unCours.acronyme}]">
							{assign var="nomProf" value=$unCours.nomProf}
							<td>{$unCours.libelle}</td>
							<td>{$unCours.nbheures} h</td>
							{foreach from=$listePeriodes key=periode item=nomPeriode}
								<td class="cote">{$unCours.global.$periode|default:'&nbsp;'}</td>
							{/foreach}
						</tr>
					{/foreach}



					<tr>
						<td colspan="4" style="background-color: #ddd; height: 0.5em"></td>
					</tr>
					{/foreach} *}
				</table>

				<table class="table table-condensed tableauBull">
					<tr>
						<th colspan="6">Qualification</th>
					</tr>
					<tr>
						<th>Ev. St.</th>
						<th>Rap. St.</th>
						<th>Ev. St.</th>
						<th>Rap. St.</th>
						<th>Jury</th>
						<th>Total</th>
					</tr>
					<tr style="background-color: #fdd; height:3em">
						<td class="cote evStage">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_E1" value="{$qualification.E1|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.E1|default:'&nbsp;'} {/if}
						</td>
						<td class="cote rapStage">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_E2" value="{$qualification.E2|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.E2|default:'&nbsp;'} {/if}
						</td>
						<td class="cote evStage">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_E3" value="{$qualification.E3|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.E3|default:'&nbsp;'} {/if}
						</td>
						<td class="cote rapStage">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_E4" value="{$qualification.E4|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.E4|default:'&nbsp;'} {/if}
						</td>
						<td class="cote jury">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_JURY" value="{$qualification.JURY|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.JURY|default:'&nbsp;'} {/if}
						</td>
						<td class="cote FinalStage">
							{if $estTitulaire}
							<input type="text" name="qualif-epreuve_TOTAL" value="{$qualification.TOTAL|default:''}" maxlength="5" class="form-control input-sm majuscules"> {else} {$qualification.TOTAL|default:'&nbsp;'} {/if}
						</td>
					</tr>

				</table>
			</div>
			<!-- col-md-... -->

			{* ------------------------------------------------------------------ *}
			{* moitié droite de l'écran ------------------------------------------*}
			{* ------------------------------------------------------------------ *}

			<div class="col-md-6 col-sm-12">
				{* on passe les périodes en revue *} {foreach from=$listePeriodes key=periode item=nomPeriode}

				<table class="tableauBull" style="width:100%">
					<tr>
						<th colspan="6">{$nomPeriode}</th>
					</tr>
					<tr>
						<th style="width:16%">&nbsp;</th>
						<th style="width:16%">Stage</th>
						<th style="width:16%">Option</th>
						<th style="width:16%">h</th>
						<th style="width:16%">Global</th>
						<th style="width:16%">h</th>
					</tr>
					{foreach from=$mentions item=uneMention key=num}
					<tr>
						<td class="cote">{$uneMention}</td>
						<td class="cote STAGE">{assign var='nbh' value=$statStage.$periode.$uneMention.nbheures|default:''} {if $nbh > 0}{$nbh} h{else}-{/if}
						</td>
						<td class="cote OG">{assign var='nbc' value=$statOG.$periode.$uneMention.nbCotes|default:''} {if $nbc > 0}{$nbc}{else}-{/if}
						</td>
						<td class="cote OG">{assign var='nbh' value=$statOG.$periode.$uneMention.nbheures|default:''} {if $nbh > 0}{$nbh} h{else}-{/if}
						</td>
						<td class="cote FC">{assign var='nbc' value=$statGlobales.$periode.$uneMention.nbCotes|default:''} {if $nbc > 0}{$nbc}{else}-{/if}
						</td>
						<td class="cote FC">{assign var='nbh' value=$statGlobales.$periode.$uneMention.nbheures|default:''} {if $nbh > 0}{$nbh} h{else}-{/if}
						</td>
					</tr>
					{/foreach}
					<tr>
						<td>Mention départ</td>
						<td class="cote">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-stage_depart-periode_{$periode}" id="stage_depart_{$periode}" value="{$mentionsManuelles.$periode.stage_depart|default:''}"> {else} {$mentionsManuelles.$periode.stage_depart|default:'&nbsp;'} {/if}
						</td>
						<td class="cote" colspan="2">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-option_depart-periode_{$periode}" id="option_depart_{$periode}" value="{$mentionsManuelles.$periode.option_depart|default:''}"> {else} {$mentionsManuelles.$periode.option_depart|default:'&nbsp;'} {/if}
						</td>
						<td class="cote" colspan="2">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-global_depart-periode_{$periode}" id="global_depart_{$periode}" value="{$mentionsManuelles.$periode.global_depart|default:''}"> {else} {$mentionsManuelles.$periode.global_depart|default:'&nbsp;'} {/if}
						</td>
					</tr>
					<tr>
						<td>Echec</td>
						{assign var='nb' value=$statStage.$periode.nbEchecs|default:''}
						<td class="cote{if $nb > 0} echec{/if}">
							{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
						{assign var='nb' value=$statOG.$periode.nbEchecs|default:''}
						<td class="cote{if $nb > 0} echec{/if}">
							{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
						{assign var='nbh' value=$statOG.$periode.nbheuresEchecs|default:''}
						<td class="cote{if $nbh > 0} echec{/if}">
							{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
						{assign var='nb' value=$statGlobales.$periode.nbEchecs|default:''}
						<td class="cote{if $nb > 0} echec{/if}">
							{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
						{assign var='nbh' value=$statGlobales.$periode.nbheuresEchecs|default:''}
						<td class="cote{if $nbh > 0} echec{/if}">
							{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
					</tr>
					<tr>
						<td>Mention finale</td>
						<td class="cote">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-stage_final-periode_{$periode}" id="stage_final_{$periode}" value="{$mentionsManuelles.$periode.stage_final|default:''}"> {else} {$mentionsManuelles.$periode.stage_final|default:'&nbsp;'} {/if}
						</td>
						<td class="cote" colspan="2">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-option_final-periode_{$periode}" id="option_final_{$periode}" value="{$mentionsManuelles.$periode.option_final|default:''}"> {else} {$mentionsManuelles.$periode.option_final|default:'&nbsp;'} {/if}
						</td>
						<td class="cote" colspan="2">
							{if $estTitulaire}
							<input type="text" class="form-control input-sm majuscules" maxlength="4" style="text-align:center" name="synthese-global_final-periode_{$periode}" id="global_final_{$periode}" value="{$mentionsManuelles.$periode.global_final|default:''}"> {else} {$mentionsManuelles.$periode.global_final|default:'&nbsp;'} {/if}
						</td>
					</tr>
				</table>

				{/foreach}

				{if ($PERIODEENCOURS == $NBPERIODES)}
				<h3>Décision du Conseil de Classe</h3>
				<table class="table table-condensed" style="margin-top:1em; border: 2px solid red">

					<tr>
						<td>

							<div class="form-group pull-right">
								<label for="decision" class="sr-only">Décision</label>
								<select name="decision" id="decision" class="form-control" disabled>
									<option value="">Choix de décision</option>
									<option value="Réussite" {if $decision.decision=='Réussite' } selected{/if}>Réussite</option>
									<option value="Échec" {if $decision.decision=='Échec' } selected{/if}>Échec</option>
									<option value="Ajournement" {if $decision.decision=='Ajournement' } selected{/if}>Ajournement</option>
									<option value="Restriction" {if $decision.decision=='Restriction' } selected{/if}>Restriction avec accès en</option>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<label for="restriction" class="sr-only">Accès en</label>
								<input type="text" name="restriction" maxlength="40" disabled id="restriction" value="{$decision.restriction|default:''}" class="form-control" placeholder="Accès à">
							</div>

						</td>
					</tr>
					{if $estTitulaire}
					<tr>
						<td>
							<div class="form-group">
								<label for="envoiMail">Envoi du mail</label>
								<input type="checkbox" value="true" name="mail" id="envoiMail" {if (!(isset($decision.mail)) || (isset($decision.mail) && ($decision.mail==1)))}checked{/if} disabled>
							</div>
							<div class="form-group">
								<label class="sr-only" for="adresseMail">Email</label>
								<input type="text" {if isset($decision.adresseMail) && ($decision.adresseMail !='' )} value="{$decision.adresseMail}" {else} value="{$decision.user}@{$decision.mailDomain}" {/if} name="adresseMail" id="adresseMail" maxlength="30" disabled placeholder="Adresse mail"
												class="form-control">
							</div>
						</td>
						<td>
							<div class="form-group">
								<label> Notification Thot</label>
								<input type="checkbox" value="true" name="notification" id="notification" disabled {if !(isset($decision.notification)) || (isset($decision.notification) && ($decision.notification==1))}checked{/if}>
							</div>

						</td>
					</tr>


					{/if}

				</table>
				{/if}
			</div>
			{if $estTitulaire}
			<div class="clearfix"></div>
		</form>
		{/if}

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e)."
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page."
	var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
	var modifie = false;
	var locked = true;

	function modification() {
		if (!(modifie)) {
			modifie = true;
			$("#selectClasse").attr("disabled", true).attr("title", desactive);
			$("#selectEleve").attr("disabled", true).attr("title", desactive);
			window.onbeforeunload = function() {
				return confirm(confirmationBeforeUnload);
			};
		}
	}

	$(document).ready(function() {

		$("input:text").each(
			function(index) {
				$(this).attr("disabled", true).attr("tabIndex", index + 1);
			}
		)
		$("input").tabEnter();

		$("#lock").click(function() {
			if (locked) {
				$('#boutonsTitu').removeClass('hidden');
				$(this).removeClass('btn-danger').addClass('btn-success');
				$('input, select').removeAttr('disabled');
				$('#lock i').removeClass('fa-lock').addClass('fa-unlock');
				$('input.majuscules').addClass('border');
				$(this).attr('title', 'Verrouiller');
			} else {
				$('#boutonsTitu').addClass('hidden');
				$(this).removeClass('btn-success').addClass('btn-danger');
				$('input, select').attr('disabled', true);
				$('#lock i').removeClass('fa-unlock').addClass('fa-lock');
				$('input.majuscules').removeClass('border');
				$(this).attr('title', 'Déverrouiller');
			}
			locked = !(locked);
		})


		$("#decision").change(function() {
			if ($(this).val() != 'Restriction') {
				$("#restriction").val('');
			} else $("#restriction").focus();
		});

		$("#restriction").focus(function() {
			if ($("#decision").val() != 'Restriction')
				$("#decision").val('Restriction');
		})

		$("input").keyup(function(e) {
			if (!(locked)) {
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
				if ((key > 31) || (key == 8)) {
					// modification();
					if ($(this).hasClass('majuscules')) {
						$(this).val($(this).val().toUpperCase());
					}
				}
			}
		})

		$("#cancel").click(function() {
			if (confirm(confirmationReset))
				$("#cotesCours")[0].reset();
			modifie = false;
		})


		$("#coteCours").submit(function() {
			$.blockUI();
			$("#wait").show();
		})

	})
</script>
