<!-- ........................................................................... -->
<!-- ............... FORMULAIRE MODAL POUR L'EDITION  DES COTES ................ -->
<!-- ........................................................................... -->

<div class="modal fade noprint" id="modalEditCote" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	 <div class="modal-dialog">
		 <div class="modal-content">
			<div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Notification ou modification des cotes</h4>
            </div>

			<div class="modal-body">
				<form name="formEdit" id="formEdit" class="form-vertical">
				<div class="row">

					<div class="col-md-6 col-xs-8">
						<div class="form-group">
							<label for="date">Date</label>
							<input type="text" name="date" id="date" value="{$entete.date}" class="ladate form-control" maxlength="10" id="date">
							<div class="help-block">Date de l'évaluation</div>
						</div>
					</div>

					<div class="col-md-6 col-xs-4">
						<div class="form-group">
							<label for="bulletin">Bulletin</label>
							<select name="bulletin" class="form-control">
								{section name=boucleBulletin start=1 loop=$nbBulletins+1}
									<option value="{$smarty.section.boucleBulletin.index}" {if $smarty.section.boucleBulletin.index == $entete.bulletin} selected{/if}>{$smarty.section.boucleBulletin.index}</option>
								{/section}
							</select>
							<div class="help-block">N° du bulletin</div>
						</div>
					</div>

				</div>  <!-- row -->

				<div class="row">

					<div class="col-xs-9">
						<div class="form-group">
							<label for="idComp">Compétence</label>
							<select name="idComp" size="1" id="idComp" class="form-control">
							<option value="">Compétence</option>
							{foreach from=$listeCompetences key=id item=uneCompetence}
								<option value="{$id}" {if $entete.idComp == $id}selected{/if}>{$uneCompetence.libelle}</option>
							{/foreach}
							</select>
							<div class="help-block">Compétence exercée pour cette évaluation</div>
						</div>
					</div>

					<div class="col-xs-3">
						<div class="form-group">
							<label for="max">Cote maximale</label>
							<input type="text" name="max" value="{$entete.max|default:''}" class="form-control" maxlength="4">
							<div class="help-block">Cote maximale pour ce travail</div>
						</div>
					</div>

				</div>

					<div class="radio-inline">
						<label>
							<input type="radio" name="formCert" value="form" {if $entete.formCert == 'form'}checked{/if}> Formatif
						</label>
						<div class="help-block">Cote formative</div>
					</div>

					<div class="radio-inline">
						<label>
							<input type="radio" name="formCert" value="cert" {if $entete.formCert == 'cert'}checked{/if}> Certificatif
						</label>
						<div class="help-block">Cote Certificative</div>
					</div>

					<div class="checkbox-inline">
						<label>
						<input type="checkBox" name="neutralise" id="neutralise" value="1" {if $entete.neutralise == 1}checked{/if}> Neutralisé
						</label>
						<div class="help-block">Cote non comptabilisée</div>
					</div>

					<div class="form-group">
						{assign var=libelle value=$entete.libelle|replace:"\'":"'"}
						<label for="libelle">Libellé</label>
						<input type="text" name="libelle" value="{$libelle|default:''}" maxlength="50" class="form-control">
						<div class="help-block">Titre du travail</div>
					</div>

					<div class="row">
						<div class="col-xs-8">
							<div class="form-group">
								{assign var=remarque value=$entete.remarque|replace:"\'":"'"}
								<label for="remarque">Remarque privée</label>
								<input type="text" name="remarque" id="remarque" value="{$remarque|default:''}" class="form-control" maxlength="30">
								<div class="help-block">Remarque libre</div>
							</div>
						</div>

						<div class="col-xs-4">
							<div class="checkbox-inline">
								<label for="publie">
									<input type="checkbox"
										name="publie"
										id="publie"
										value="1"
										class="{if $entete.neutralise == 1}disabled{/if}"
										{if ($entete.publie == 1)}checked{/if}
										>
									Publié</label>
								<div class="help-block">
									Visible sur Thot
								</div>
							</div>
						</div>
					</div>

					<button class="btn btn-primary pull-right" type="button" id="btn-saveCote" data-idcarnet="{$entete.idCarnet}">Enregistrer</button>
					<button class="btn btn-default pull-right" data-dismiss="modal" type="reset">Annuler</button>
				</form>
			</div>  <!-- modal-body -->

			{assign var=coursGrp value=$entete.coursGrp}

			<div class="modal-footer">
				<p>{$listeCours.$coursGrp.libelle} -> {$listeCours.$coursGrp.nomCours} [{$coursGrp}] / Bulletin n° {$entete.bulletin}</p>
            </div>  <!-- modal-footer -->
		 </div>  <!-- modal-content -->
	 </div>  <!-- modal-dialog -->
</div>  <!-- modal -->

<script type="text/javascript">

	$(document).ready(function(){

		$('#neutralise').change(function(){
			if ($('#neutralise').is(':checked'))
				$('#publie').attr('checked', false).addClass('disabled');
				else $('#publie').removeClass('disabled');
		})

		$("#date").datepicker({
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$("#formEdit").validate({
			errorElement: "em",
			errorClass: "erreurEncodage",
			rules: {
				date: {
					required: true,
					uneDate: true
					},
				idComp: {
					required: true
					},
				max: {
					required: true,
					number: true
				},
				libelle: {
					required: true
				}
				}
			});

	})

</script>
