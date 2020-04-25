<!-- introduction des cotes -->

	{if isset($listeVerrous.$matricule.$coursGrp) && ($listeVerrous.$matricule.$coursGrp >= 1)}
	<div class="alert alert-danger" role="alert">
		<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
		Les cotes et mentions de la période <strong>{$bulletin}</strong> de <strong>{$unEleve.prenom} {$unEleve.nom}</strong> ne sont plus modifiables. Contactez le titulaire ou le coordinateur.
	</div>
	{/if}

	{assign var=formExiste value=(isset($ponderations.$coursGrp.all.$bulletin.form) && ($ponderations.$coursGrp.all.$bulletin.form != '')) ||
				(isset($ponderations.$coursGrp.$matricule.$bulletin.form) && ($ponderations.$coursGrp.$matricule.$bulletin.form != ''))}
	{assign var=certExiste value=(isset($ponderations.$coursGrp.all.$bulletin.cert) && ($ponderations.$coursGrp.all.$bulletin.cert != '')) ||
				(isset($ponderations.$coursGrp.$matricule.$bulletin.cert) && ($ponderations.$coursGrp.$matricule.$bulletin.cert != ''))}

	<table class="table tableauBull table-condensed table-bordered">
		<tr>
			<th>Compétences</th>

			{if $formExiste}
				<th style="width:4em">TJ /
					<span class="ponderation">
						<span class="pull-right smallNotice pop"
							data-content="Pondération &laquo;formatif&raquo; pour cette période<br>Le bulletin électronique reportera automatiquement tous les notes sur <strong>{$ponderations.$coursGrp.$matricule.$bulletin.form|default:$ponderations.$coursGrp.all.$bulletin.form}</strong> points"
							data-html="true"
							data-container="body"
							data-placement="left"></span>
					{$ponderations.$coursGrp.$matricule.$bulletin.form|default:$ponderations.$coursGrp.all.$bulletin.form}
					</span>
				</th>
				<th style="width:8em">Max</th>{/if}
			{if $certExiste}
				<th style="width:4em">C /
					<span class="ponderation">
						<span class="pull-right smallNotice pop"
							data-content="Pondération &laquo;certificatif&raquo; pour cette période<br>Le bulletin électronique reportera automatiquement tous les notes sur <strong>{$ponderations.$coursGrp.$matricule.$bulletin.cert|default:$ponderations.$coursGrp.all.$bulletin.cert}</strong> points"
							data-html="true"
							data-container="body"
							data-placement="left"></span>
					{$ponderations.$coursGrp.$matricule.$bulletin.cert|default:$ponderations.$coursGrp.all.$bulletin.cert}
					</span>
				</th>
				<th style="width:8em">Max</th>{/if}

		</tr>
		{assign var=cotes value=$listeCotes.$matricule.$coursGrp|default:Null}

		{foreach from=$listeCompetences key=cours item=lesCompetences}
			{foreach from=$lesCompetences key=idComp item=uneCompetence}
				<tr{if isset($tableErreurs.$matricule.$idComp)} class="erreurEncodage"{/if}>
					<td style="text-align:right" data-container="body"> {$uneCompetence.libelle}</td>

					{if $formExiste}
						{* Il y a, au moins, une pondération pour le "Formatif" durant cette période *}
						<td style="text-align:center; width:6em"
						{if $cotes.$idComp.form.echec}class="echec"{/if}>
						<div class="input-group input-group-sm">
								<input
								tabIndex="{$tabIndexForm}"
								type="text"
								{if $blocage > 0}readonly="readonly"{/if}
								name="cote-eleve_{$matricule}-comp_{$idComp}-form"
								value="{$cotes.$idComp.form.cote}"
								maxlength="5"
								class="cote form-control coteTJ">
							</div>
						</td>

						{* Le max de Formatif pour cette compétence *}
						<td style="text-align:center; width:8em">
						<div class="input-group input-group-sm">
							<input
								tabIndex="{$tabIndexForm+1}"
								type="text"
								{if $blocage > 0}readonly="readonly"{/if}
								name="cote-eleve_{$matricule}-comp_{$idComp}-maxForm"
								value="{$cotes.$idComp.form.maxForm}"
								maxlength="4"
								data-id="maxForm-comp_{$idComp}"
								class="cote form-control maxTJ">
								<span class="input-group-addon">
									{if $blocage == 0}
									<span class="glyphicon glyphicon-resize-vertical report noprint"
											data-placement="left"
											data-html="true">
									</span>
									{/if}
								</span>
							</div>
						</td>
						{assign var="tabIndexForm" value=$tabIndexForm+2 scope="global"}
					{/if}

					{if $certExiste}
						{* Il y a, au moins, une pondération générale pour le "Certificatif" durant cette période *}
						<td style="text-align:center; width:6em"
						{if $cotes.$idComp.cert.echec}class="echec"{/if}>
							<div class="input-group input-group-sm">
								<input
									tabIndex="{$tabIndexCert}"
									type="text"
									{if $blocage > 0}readonly="readonly"{/if}
									name="cote-eleve_{$matricule}-comp_{$idComp}-cert"
									value="{$cotes.$idComp.cert.cote}"
									maxlength="5"
									class="cote form-control coteCert">
						</div>
						</td>

						{* Le max de Certificatif pour cette compétence *}
						<td style="text-align:center; width:8em">
							<div class="input-group input-group-sm">
							<input
								tabIndex="{$tabIndexCert+1}"
								type="text"
								{if $blocage > 0}readonly="readonly"{/if}
								name="cote-eleve_{$matricule}-comp_{$idComp}-maxCert"
								value="{$cotes.$idComp.cert.maxCert}"
								maxlength="4"
								data-id="maxCert-comp_{$idComp}"
								class="cote form-control maxCert">
								<span class="input-group-addon">
									{if $blocage == 0}
										<span class="glyphicon glyphicon-resize-vertical report noprint"
												data-placement="left"
												data-html="true">
										</span>
									{/if}
								</span>
							</div>
						</td>
						{assign var="tabIndexCert" value=$tabIndexCert+2 scope="global"}
					{/if}
				</tr>
			{/foreach}
		{/foreach}

		{assign var="totaux" value=$listeSommesFormCert.$matricule|default:Null}
		<tr>
			<th><span class="pull-right">Totaux</span></th>

			{if $formExiste}
				<td class="totaux">
					<span class="totalForm" data-value="{$totaux.totalForm}" id="totalForm-{$matricule}">{$totaux.totalForm}</span>
				</td>
				<td class="totaux">
					<span class="totalMaxForm" data-value="{$totaux.maxForm}" id="totalMaxForm-{$matricule}">{$totaux.maxForm}</span>
				</td>
			{/if}
			{if $certExiste}
				<td class="totaux">
					<span class="totalCert" data-value="{$totaux.totalCert}" id="totalCert-{$matricule}">{$totaux.totalCert}</span>
				</td>
				<td class="totaux">
					<span class="totalMaxCert" data-value="{$totaux.maxCert}" id="totalMaxCert-{$matricule}">{$totaux.maxCert}</span>
				</td>
			{/if}

		</tr>
	</table>

	<span class="pull-right smallNotice pop"
			data-content="Mentions admises: <strong>{$COTEABS}</strong> <br>Toutes ces mentions sont neutres"
			data-html="true"
			data-container="body"
			data-placement="left">
	</span>
