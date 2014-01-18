<h2 class="tooltip" style="clear:both"><div class="tip">
	<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" width="100px"><br><span class="micro">{$eleve.matricule}</span></div>
	{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>
	
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Données personnelles</a></li>
		<li><a href="#tabs-2">Parents et responsables</a></li>
		<li><a href="#tabs-3">Informations médicales {if $medicEleve}<span style="color:red">V</span>{/if}</a></li>
		<li><a href="#tabs-4">Visites à l'infirmerie [<span style="color:red">{$consultEleve|@count}</span>]</a></li>
	</ul>
	
	<div id="tabs-1">
		<p><img src="../photos/{$eleve.photo}.jpg" class="photo draggable" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.matricule}" 
			id="photo" style="width:100px; top:-60px; position: relative" /> </p>
		<h3>{$eleve.nom} {$eleve.prenom}</h3>
		<p><label>Classe</label> {$eleve.groupe} {if $titulaires} [{", "|implode:$titulaires}]{/if}</p>
		<p><label>Date de naissance</label> {$eleve.DateNaiss} 
		<small>[Âge approx. {$eleve.age.Y} ans {if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if} 
			{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></p>
		<p><label>Sexe</label>{$eleve.sexe}</p>
		<p><label>Adresse</label>{$eleve.adresseEleve}</p>
		<p><label>Code Postal</label>{$eleve.cpostEleve} <label>Commune</label>{$eleve.localiteEleve}</p>
	</div>
	
	<div id="tabs-2">
			<ul class="detailsEleve">
			<li>Coordonnées de la personne responsable
				<ul>
					<li><label>Responsable</label>{$eleve.nomResp|default:''}</li>
					<li><label>e-mail</label>&nbsp;<a href="mailto:{$eleve.courriel|default:''}">{$eleve.courriel|default:''}</a></li>
					<li><label>Téléphone</label>&nbsp;{$eleve.telephone1|default:''}</li>
					<li><label>GSM</label>&nbsp;{$eleve.telephone2|default:''}</li>
					<li><label>Téléphone bis</label>&nbsp;{$eleve.telephone3|default:''}</li>
					<li><label>Adresse</label>{$eleve.adresseResp|default:''}</li>
					<li><label>Code Postal</label>{$eleve.cpostResp|default:''} <label>Commune</label>{$eleve.localiteResp|default:''}</li>
				</ul>
			</li>
			<li>Coordonnées du père de l'élève
				<ul>
					<li><label>Nom</label>{$eleve.nomPere|default:''}</li>
					<li><label>e-mail</label><a href="mailto:{$eleve.mailPere|default:''}">{$eleve.mailPere|default:''}</a></li>
					<li><label>Téléphone</label>{$eleve->telPere|default:''}</li>
					<li><label>GSM</label>{$eleve.gsmPere|default:''}</li>
				</ul>
			</li>
			<li>Coordonnées de la mère de l'élève
				<ul>
					<li><label>Nom</label>{$eleve.nomMere|default:''}</li>
					<li><label>e-mail</label><a href="mailto:{$eleve.mailMere|default:''}">{$eleve.mailMere|default:''}</a></li>
					<li><label>Téléphone</label>{$eleve->telMere|default:''}</li>
					<li><label>GSM</label>{$eleve.gsmMere|default:''}</li>
				</ul>
			</li>
		</ul>
		</div>
		
	<div id="tabs-3">
		<form name="modifMedical" method="POST" action="index.php" class="microForm">
		<input type="submit" name="submit" value="Modifier">
		<input type="hidden" name="action" value="modifier">
		<input type="hidden" name="mode" value="medical">
		<input type="hidden" name="classe" value="{$eleve.classe}">
		<input type="hidden" name="matricule" value="{$matricule}">
			
		<h3>Médecin</h3>
		<fieldset style="float:left; width:15em">
			<legend>Medecin traitant</legend>
			<p>{$medicEleve.medecin|default:'&nbsp;'}</p>
		</fieldset>
		<fieldset style="float:left; width:15em">
			<legend>Téléphone</legend>
			<p>{$medicEleve.telMedecin|default:'&nbsp;'}</p>
		</fieldset>
		<h3 style="clear:both">Situation personnelle</h3>	

		<fieldset style="float:left; width: 45%">
			<legend>Situation de famille</legend>
			<p>{$medicEleve.sitFamiliale|default:'&nbsp;'}</p>
		</fieldset>
		
		<fieldset style="float:right; width: 45%">
			<legend>Anamnèse</legend>
			<p>{$medicEleve.anamnese|default:'&nbsp;'}</p>
		</fieldset>

		<h3 style="clear:both">Particularités</h3>
		<fieldset style="float:left; width: 45%">
			<legend>Médicales</legend>
			<p>{$medicEleve.medical|default:'&nbsp;'}</p>
		</fieldset>
		
		<fieldset style="float:right; width: 45%">
			<legend>Traitement</legend>
			<p>{$medicEleve.traitement|default:'&nbsp;'}</p>
		</fieldset>
		
		<fieldset>
			<legend>Psy</legend>
			<p>{$medicEleve.psy|default:'&nbsp;'}</p>
		</fieldset>
		</form>

	</div>
	
	<div id="tabs-4">
		
		<form name="modifVisite" method="POST" action="index.php" class="microForm">
			<input type="hidden" name="action" value="modifier">
			<input type="hidden" name="mode" value="visite">
			<input type="hidden" name="matricule" value="{$matricule}">
			<input type="submit" name="submit" value="Nouvelle visite">
		</form>

		<table class="tableauAdmin">
			<tr>
				<th>Prof</th>
				<th>Date</th>
				<th>Heure</th>
				<th>Motifs</th>
				<th>Traitements</th>
				<th>A suivre</th>
				<th style="width:32px">&nbsp;</th>
				<th style="width:32px">&nbsp;</th>
			</tr>
		{foreach from=$consultEleve key=ID item=uneVisite}
			<tr>
				<td>{$uneVisite.acronyme|default:'&nbsp;'}</td>
				<td>{$uneVisite.date|default:'&nbsp;'}</td>
				<td>{$uneVisite.heure|default:'&nbsp;'|truncate:5:''}</td>
				<td class="tooltip"><span class="tip">{$uneVisite.motif}</span>
					{$uneVisite.motif|truncate:70:"..."|default:'&nbsp;'}</td>
				<td class="tooltip"><span class="tip">{$uneVisite.traitement}</span>
					{$uneVisite.traitement|truncate:40:"..."|default:'&nbsp;'}</td>
				<td class="tooltip"><span class="tip">{$uneVisite.aSuivre}</span>
					{$uneVisite.aSuivre|truncate:30:"..."|default:'&nbsp;'}</td>
				<td title="Modifier">
					<form name="modifier" method="POST" action="index.php" class="microForm noborder">
						<input type="hidden" name="consultID" value="{$uneVisite.consultID}">
						<input type="hidden" name="matricule" value="{$eleve.matricule}">
						<input type="hidden" name="classe" value = "{$eleve.classe}">
						<input type="hidden" name="action" value="modifier">
						<input type="hidden" name="mode" value="visite">
						<input type="image" src="images/pencil.png" name="submit">
					</form>
				</td>
				<td title="Supprimer">
					<form name="modifier" method="POST" action="index.php" class="microForm noborder">
						<input type="hidden" name="consultID" value="{$uneVisite.consultID}">
						<input type="hidden" name="matricule" value="{$eleve.matricule}">
						<input type="hidden" name="classe" value = "{$eleve.classe}">
						<input type="hidden" name="action" value="supprimer">
						<input type="hidden" name="mode" value="visite">
						<input type="image" src="images/suppr.png" name="submit" class="delete">
					</form>
				</td>
			</tr>
		{/foreach}
		</table>
		</div>
		
</div> <!-- tabs -->

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$("#tabs").tabs();
		
		$(".delete").click(function(){
			if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
				return false;
			})
		
	})
{/literal}
</script>