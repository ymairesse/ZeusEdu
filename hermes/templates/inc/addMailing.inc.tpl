<div class="container">

	<div class="row">

		<div class="col-md-3 col-sm-12">
			
			<h3>Création d'une liste</h3>
			<form role="form" name="creation" id="creation" method="POST" action="index.php" class="form-vertical" role="form">
			<input type="text" placeholder="Nom de la liste à créer" maxlenght="32" id="nomListe" name="nomListe" class="form-control">
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default">Annuler</button>				
				<button type="submit" class="btn btn-primary">Créer la liste</button>
			</div>
			<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="creationListe">
			{if $listesPerso|count > 0}
				<h4>Listes existantes</h4>
				<table class="table table-condensed table-striped">
				<tr>
					<thead>
					<th>Listes</th>
					<th>Membres</th>
					</thead>
				</tr>
				{foreach from=$listesPerso key=idListe item=liste}
				<tr>
					<td class="pop"
						data-container="body"
						data-original-title="{$liste.nomListe}: {$liste.membres|count|default:0} membres"
						data-content="{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}"
						data-placement="top">
						{$liste.nomListe}
					</td>
					<td>{$liste.membres|count}</td>
				</tr>
				{/foreach}
				</table>
			{/if}
			</form>
			
		</div>  <!-- col-md-... -->
			
		<div class="col-md-9 col-sm-12">
			<h3>Ajout de membres à une liste</h3>
			{if $listesPerso|count > 0}
				
				<div class="row">
					
					<form name="ajoutMembres" id="ajoutMembres" method="POST" action="index.php" class="form-vertical" role="form">
							
					<div class="col-md-5 col-sm-5">
					
						<h4>Listes existantes</h4>
						
							<select name="idListe" id="selectListe" size="5" class="form-control">
								<option value=''>Veuillez choisir une liste</option>
								{foreach from=$listesPerso key=idListe item=liste}
									<option value="{$idListe}">{$liste.nomListe} -> {$liste.membres|count} membres</li>
								{/foreach}
							</select>

							<div id="listeExistants" style="max-height:20em; overflow: auto">
				
						</div>
					
					</div>  <!-- col-md-... -->
				
					<div class="col-md-5 col-sm-5">
						
						<h4>Destinataires à ajouter</h4>
						
						<div class="selectMail" style="max-height: 20em">
							<!--	tous les utilisateurs -->
							<ul class="listeMails">
							{assign var=membresProfs value=$listeProfs.membres}
							{foreach from=$membresProfs key=acronyme item=prof}
								<li><input class="selecteur mails mailsAjout" type="checkbox" name="mails[]" value="{$acronyme}">
									<span class="labelProf">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
								</li>
							{/foreach}
							</ul>
						</div>

					<p style="clear:both">Sélections: <strong id="selectionAdd">0</strong> destinataire(s)</p>
					
					</div>  <!-- col-md-... -->
					
					<div class="col-md-2 col-sm-2">
						
						<div class="btn-group-vertical">
							<button type="reset" class="btn btn-default" id="resetAdd">Annuler</button>
							<button type="submit" class="btn btn-primary">Ajouter</button>
						</div>
						<input type="hidden" class="onglet" name="onglet" value="{$onglet|default:0}">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="ajoutMembres"><br>
						
					</div>
					
					<div class="clearfix"></div>
					</form>
				
				</div>  <!-- row -->
			
			{else}
				<p>Aucune liste définie</p>
			{/if}
			</div>
			
			<div class="clearfix"></div>

	</div>  <!-- row -->

</div>  <!-- container -->