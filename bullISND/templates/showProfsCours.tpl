<div class="container">
	
	{if isset($coursGrp)}
	<h3>Attribution des cours aux enseignants</h3>
	<div class="row">
		<div class="col-md-6 col-sm-12">
			<form name="supprProfCours" id="supprProfCours" method="POST" action="index.php">

				<h4>Titulaire(s) du cours {if (isset($coursGrp))}{$coursGrp}{/if}</h4>
				
				{foreach from=$listeProfsTitulaires key=acronyme item=prof}
					<input type="checkbox" name="supprProf[]" value="{$acronyme}" title="Cochez pour supprimer">{$prof}<br>
				{/foreach}
			
				<input type="hidden" name="coursGrp" value="{$coursGrp}">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="attributionsProfs">
				<input type="hidden" name="etape" value="supprProfs">
				<button class="btn btn-primary" type="submit" name="Envoyer">Supprimer <span class="glyphicon glyphicon-arrow-right"></span></button>
				<input type="hidden" name="niveau" value="{$niveau}">
					
				<h4>Élèves inscrits</h4>
				<select size="15" name="eleves" id="eleves">
					{foreach from=$listeEleves key=matricule item=eleve}
						<option value="{$matricule}">{$eleve.classe} - {$eleve.nom} {$eleve.prenom}</option>
					{/foreach}
				</select>
			
			</form>
		</div>  <!-- col-md... -->
		
		<div class="col-md-6 col-sm-12">
	
		<form name="addProfCours" id="addProfCours" method="POST" action="index.php">
			
			<h4>Professeurs à affecter au cours</h4>
			<select multiple="multiple" size="15" name="addProf[]" value="">
				{foreach from=$listeTousProfs key=acronyme item=prof}
					<option value="{$acronyme}">{$prof.acronyme}: {$prof.nom} {$prof.prenom}</option>
				{/foreach}
			</select>
			<hr class="clear-fix">
			<input type="hidden" name="coursGrp" value="{$coursGrp}">
			<input type="hidden" name="action" value="admin">
			<input type="hidden" name="mode" value="attributionsProfs">
			<input type="hidden" name="etape" value="addProfs">
			<button button class="btn btn-primary" name="Envoyer" type="submit"><span class="glyphicon glyphicon-arrow-left"></span>Ajouter</button>
			<input type="hidden" name="niveau" value="{$niveau}">
		</form>
	
		</div> <!-- col-md-... -->
	
	</div>  <!-- row -->
	{/if}

</div>

<script type="text/javascript">

    $(document).ready(function(){
        $("#supprProfCours").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        
        $("#addProfCours").submit(function(){
			$.blockUI();
            $("#wait").show();
            })

        
        })

</script>
