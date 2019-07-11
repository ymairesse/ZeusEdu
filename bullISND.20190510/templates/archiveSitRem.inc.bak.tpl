<div class="row">
	
	<div class="col-md-8 col-sm-6">
		<div class="accordion-group">
			<div class="accordion-heading">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#leftMenu" href="#collapseRem{$matricule}" title="Cliquer pour ouvrir">
					<span class="glyphicon glyphicon-play"></span> Remarques de toutes les périodes
				</a>
			</div>  <!-- accordion-heading -->
			<div id="collapseRem{$matricule}" class="accordion-body collapse" style="height: 0px; ">
				<div class="accordion-inner">
					<ul>
					{section name=annee start=1 loop=$nbBulletins+1}
					{assign var="periode" value=$smarty.section.annee.index}
						<li>{$periode} => {$listeCommentaires.$matricule.$periode|default:Null}
					{/section}
					</ul>
				</div>  <!-- accordion-inner -->
			</div>  <!-- accordion-body -->
		</div>  <!-- accordion-group -->
	</div>  <!-- col-md-... -->
	
	<div class="col-md-4 col-sm-6">
		<div class="accordion-group">
			<div class="accordion-heading">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#leftMenu" href="#collapseSit{$matricule}" title="Cliquer pour ouvrir">
					<span class="glyphicon glyphicon-play"></span> Situations des autres périodes
				</a>
			</div>  <!-- accordion-heading -->
			<div id="collapseSit{$matricule}" class="accordion-body collapse" style="height: 0px; ">
				<div class="accordion-inner">
					<ul>
					{section name=annee start=1 loop=$nbBulletins+1}
						{assign var="periode" value=$smarty.section.annee.index}
						{assign var="situation" value=$listeSituations.$matricule.$coursGrp.$periode|default:Null}
						<li>{$periode} => {if $situation.sit}<strong>{$situation.sit}/{$situation.max}</strong> soit {$situation.pourcent}%{/if}</li>
					{/section}
					</ul>
				</div>  <!-- accordion-inner -->
			</div>  <!-- accordion-body -->
		</div>  <!-- accordion-group -->
	</div>  <!-- col-md... -->
	
</div>  <!-- row -->