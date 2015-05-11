<div class="container">
	
<h2>{$eleve.nom} {$eleve.prenom}</h2>

	<div class="row">
		
		<div class="col-md-10 col-sm-12">

				<form name="form" method="POST" action="index.php" id="formulaire" role="form" class="form-vertical">
				<input type="hidden" name="action" value="delibes">
				<input type="hidden" name="mode" value="individuel">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="classe" value="{$classe}">
				<input type="hidden" name="matricule" value="{$matricule}">
					
				<div class="table-responsive">
					
				<table class="tableauAdmin table table-hover table-condensed">
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
							<td class="cote 
								{if ($listeSituations.$coursGrp.$periode.sitDelibe < 50)
									&& ($listeSituations.$coursGrp.$periode.sitDelibe|trim != '')
									&& ($listeSituations.$coursGrp.$periode.attribut != 'hook')}echec{/if}"
								{* si on a connaissance d une cote interne, en plus, on l indique en infobulle *}
								{if isset($listeSituations.$coursGrp.$periode.sitInterne)}
									title="Cote interne {$listeSituations.$coursGrp.$periode.sitInterne}%"
									data-container="body"
								{/if}>
								{if $listeSituations.$coursGrp.$periode.attribut == 'hook'}[{$listeSituations.$coursGrp.$periode.sitDelibe|default:'&nbsp;'}]
									{else}
									{$listeSituations.$coursGrp.$periode.sitDelibe|default:'&nbsp;'}<sup>{$listeSituations.$coursGrp.$periode.symbole|default:''}</sup>
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
							</span>
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
						<td class="cote"><strong>{$mentions[2]|default:'&nbsp;'}</strong></td>
						<td class="cote"><strong>{$mentions[5]|default:'&nbsp;'}</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="conclusionDelibe" style="background-color:#FCD97D">
						<td>Mention Finale</td>
						<td>
						{if $estTitulaire}
							<span class="glyphicon glyphicon-lock pull-right" id="lock" style="cursor:pointer"></span>
						{else}
							&nbsp;
						{/if} 
						</td>
						{foreach from=$listePeriodes item=periode}
							<td class="cote {if isset($mentionsAttribuees.$periode) && $mentionsAttribuees.$periode == 'I'} echec{/if}">
								{if $estTitulaire}
								<input type="text" name="mentions_{$periode}" value="{$mentionsAttribuees.$periode|default:''}" 
										class="inputMention" maxlength="6" size="3">
								{else}
									<strong>{$mentionsAttribuees.$periode|default:'&nbsp;'}</strong>
								{/if}
							</td>
						{/foreach}
				
						<td colspan="2">
						{if $estTitulaire}
							<div class="btn-group" id="submitGroup">
								<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
								<button type="reset" class="btn btn-default" id="annuler">Annuler</button>
							</div>
						{else}
							&nbsp; 
						{/if}
						</td>
					</tr>
				</table>
				
				</div>  <!-- table-responsive -->
				
				</form>
				
				<p>Symbolique:</p>
				<ul class="symbolique">
				<li>² => réussite degré</li>
				<li>* => cote étoilée</li>
				<li>↗ => baguette magique</li>
				<li>← => reussite 50%</li>
				<li>$ => épreuve externe</li>
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
	
	$(".inputMention").each(function(index){
			$(this).attr("readonly",true);
		});
	$("#submitGroup").hide();
		
	$(".inputMention").keyup(function(e){
	var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
	if ((key > 31) || (key == 8)) {
		modification();
		$(this).val($(this).val().toUpperCase());
		}
	})
	
	$("#lock").click(function(){
		if (locked) {
			$(".inputMention").attr("readonly",false);
			$(this).attr("src", "images/unlock.png");
			$("#submitGroup").show();
			}
			else {
			$(".inputMention").attr("readonly",true);
			$(this).attr("src", "images/lock.png");
			$("#submitGroup").show();
			};
		locked = !(locked);
		})

	
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
