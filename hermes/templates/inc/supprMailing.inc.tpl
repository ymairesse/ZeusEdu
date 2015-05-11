{if $listesPerso|count > 0}
	<div class="row">
		
		<div class="col-md-8 col-sm-12">
			
		<form name="deleteList" id="deleteList" action="index.php" method="POST" class="form-vertical" role="form">
		
			<h3>Listes existantes</h3>

			<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="delete">
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default">Annuler</button>
				<button type="submit" class="btn btn-primary" id="resetDel">Supprimer</button>
			</div>
			
			<p>Destinataires sélectionnés <strong id="selectionDest">0</strong></p>
			
				<div class="panel-group" id="accordion">
					
					{foreach from=$listesPerso key=id item=liste}
					
					<div class="panel panel-default">
						
						<div class="panel-heading">
							<h4 class="panel-title">
								<a data-toggle="collapse" data-parent="#accordion" href="#blocMails_{$id}">
								<input type="checkbox" class="checkListe" name="liste-{$id}" id="liste-{$id}" value="{$id}"> 
								{$liste.nomListe} -> {$liste.membres|@count} membres</a>
							</h4>
						</div>  <!-- panel-heading -->
						
						<div id="blocMails_{$id}" class="panel-collapse collapse">
							
							<div class="panel-body">
								{if $liste.membres != Null}
									<table class="table table-condensed table-striped">
										{foreach $liste.membres key=acronyme item=prof}
										<tr>
											<td>
												<input class="selecteur mails mailsSuppr" type="checkbox" name="mailing-{$id}_acronyme-{$prof.acronyme}" value="{$prof.acronyme}">
												<span class="labelProf">{$prof.nom|truncate:15:'...'} {$prof.prenom} {$prof.classe|default:''}</span>
											</td>
										</tr>
										{/foreach}
									</table>
								{/if}
							</div>  <!-- panel-body -->
							
						</div>  <!-- blocMails_{$id} -->

					</div>  <!-- panel-default -->
					
					{/foreach}
				
				</div>  <!-- #accordion -->

		</form>
		
		</div>  <!-- col-md-... -->
		
		<div class="col-md-4 col-sm-12">
			
			<div class="notice">Pour supprimer une liste complète, cocher la case de tête de la liste.<br>Pour supprimer certains membres d'une liste, cliquer sur le titre et cocher les cases correspondantes.</div>
			
		</div>
		
	</div>  <!-- row -->

{else}
<p>Aucune liste définie</p>
{/if}
