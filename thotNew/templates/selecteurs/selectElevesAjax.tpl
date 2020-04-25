<div class="input-group">
	<input type="text" value="Sélection d'élèves" class="form-control" readonly>
	<span class="input-group-btn">
		<button type="button" class="btn btn-primary" data-type="eleve" disabled>
			<i class="fa fa-arrow-right"></i>
		</button>
	</span>
</div>

<div id="cbEleves" style="height:20em; overflow:auto;">

	<div class="btn-group btn-block">
	  <button type="button" id="btnTous" class="btn btn-success btn-sm btn-select" style="width:50%">Tous</button>
	  <button type="button" id="btnInv" class="btn btn-info btn-sm btn-select" style="width:50%">Inverser</button>
	</div>

	{foreach from=$listeEleves key=matricule item=unEleve}
	<div class="checkbox">
	  <label>
		  <input type="checkbox" class="eleve" name="matricules[]" value="{$matricule}" checked>
		  {$unEleve.groupe} {$unEleve.nom} {$unEleve.prenom}
	  </label>
	</div>
	{/foreach}

</div>

<div class="discret" id="nbDestinataires">
	{$listeEleves|count} destinataire(s)
</div>
