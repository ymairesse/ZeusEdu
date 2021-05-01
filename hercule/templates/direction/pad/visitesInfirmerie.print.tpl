<style>

td, th {
	font-size: 7pt;
}

.mentionI {
	background-color: #FEA2A0;
}

.mentionF {
	background-color: #F7D29D;
	color: black;
}

.mentionS {
	background-color: #EBF79D;
}

.mentionAB {
	background-color: #9DF7A1;
}

.mentionB {
	background-color: #9EF8DB;
	color: black;
}

.mentionBplus {
	background-color: #26F8B6;
	color: black
}

.mentionTB {
	background-color: #7290E2;
	color: white
}

.mentionTBplus {
	background-color: #2558E2;
	color: white
}

.mentionE {
	background-color: #D2AAE6;
}

td.cote {
	border: 1px solid black;
	padding: 1mm;
	border-collapse: collapse;
}

.break {
	 page-break-before: always
}
h1 {
	font-size:14pt;
	padding-bottom: 3pt;
}
h2, h3 {
	font-size:12pt;
	padding-bottom: 0;
}

td, th {
	border: 1px solid black;
	padding: 1mm;
	border-collapse: collapse;
	font-size: 8pt;
}

th {
	background-color: #FFA621;
}

.important {
	color: red;
}
</style>


<page backtop="7mm" backbottom="7mm" backleft="15mm" backright="10mm">

    <page_header>
		<span style="margin-left: 20mm">[[page_cu]]/[[page_nb]]</span>
    </page_header>
    <page_footer>
       <span style="margin-left: 20mm">{$nomEleve}</span>
    </page_footer>

<h1>Médical: {$nomEleve}</h1>

{if isset($medicEleve.info) && ($medicEleve.info != '')}
	<div class="important">
		<h3>Information médicale importante</h3>
		<p style="font-weight:bold;"><i class="fa fa-warning"></i> {$medicEleve.info|default:''}</p>
	</div>
{/if}

<h3>Visites à l'infirmerie</h3>

<table class="tableauAdmin table table-striped table-condensed" style="width:100%">
	<thead>
		<tr style="width:100%">
			<th style="width:5%">&nbsp;</th>
			<th style="width:5%">Prof</th>
			<th style="width:10%">Date</th>
			<th style="width:5%">Heure</th>
			<th style="width:25%">Motifs</th>
			<th style="width:25%">Traitements</th>
			<th style="width:25%">A suivre</th>
		</tr>
	</thead>
{foreach from=$consultEleve key=ID item=uneVisite name="tour"}
	<tr>
		<th style="width:5%">{$smarty.foreach.tour.iteration}</th>
		<td style="width:5%">{$uneVisite.acronyme|default:'&nbsp;'}</td>
		<td style="width:10%">{$uneVisite.date|default:'&nbsp;'}</td>
		<td style="width:5%">{$uneVisite.heure|default:'&nbsp;'|truncate:5:''}</td>
		<td style="width:25%">
			{$uneVisite.motif|truncate:70:"..."|default:'&nbsp;'}
		</td>
		<td style="width:25%">
			{$uneVisite.traitement|truncate:40:"..."|default:'&nbsp;'}
		</td>
		<td style="width:25%">
			{$uneVisite.aSuivre|truncate:30:"..."|default:'&nbsp;'}
		</td>
	</tr>
{/foreach}
</table>

<h3>Informations médicales</h3>

<table style="width:100%">

	<tr>
		<th style="width:33%">Médecin traitant</th>
		<th style="width:33%">Situation personnelle</th>
		<th style="width:33%">Particularités</th>
	</tr>
	<tr>
		<td style="width:33%">
			<ul>
				<li>Nom: {$medicEleve.medecin|default:'non disponible'}</li>
				<li>Téléphone: {$medicEleve.telMedecin|default:'non disponible'}</li>
			</ul>
		</td>

		<td style="width:33%">
			<ul>
				<li>Situation de famille: {$medicEleve.sitFamiliale|default:'NA'}</li>
				<li>Anamnèse: {$medicEleve.anamnese|default:'NA'}</li>
			</ul>
		</td>

		<td style="width:33%">
			<ul>
				<li>Médicales: {$medicEleve.medical|default:'néant'}</li>
				<li>Traitement: {$medicEleve.traitement|default:'néant'}</li>
				<li>Psy: {$medicEleve.psy|default:'néant'}</li>
			</ul>
		</td>

	</tr>

</table>


</page>
