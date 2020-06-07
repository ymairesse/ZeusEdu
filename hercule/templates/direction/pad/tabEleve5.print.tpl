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


<page backtop="7mm" backbottom="7mm" backleft="20mm" backright="0mm">
    <page_header>
		<span style="margin-left: 20mm">[[page_cu]]/[[page_nb]]</span>
    </page_header>
    <page_footer>
       <span style="margin-left: 20mm">{$nomEleve}</span>
    </page_footer>

<h1>Athéna: {$nomEleve}</h1>

<table class="table table-condensed">

    <thead>
        <tr>
            <th style="width:1em">&nbsp;</th>
            <th>Propr.</th>
            <th>Abs</th>
            <th>Envoyé par</th>
            <th>Date</th>
            <th>Heure</th>
            <th syle="width:15%">Motif</th>
            <th syle="width:15%">Traitement</th>
            <th syle="width:15%">À suivre</th>
        </tr>
    </thead>

    <tbody>
        {foreach from=$listeSuivi item=unItem name=tour}
        <tr>
            <th>{$smarty.foreach.tour.iteration}</th>
            {assign var=id value=$unItem.id}

			<td>{$listeSuivi.$id.proprietaire}</td>
            <td>{if $unItem.absent == 1}<i class="fa fa-question fa-lg text-danger"></i>{else}-{/if}</td>
            {assign var=leProf value=$unItem.envoyePar}
            <td>{if isset($dicoProfs.$leProf)}{$dicoProfs.$leProf}{else}{$unItem.envoyePar} (?){/if}</td>
            <td>{$unItem.date}</td>
            <td>{$unItem.heure}</td>
            <td>
                {$unItem.motif|truncate:35}
            </td>
            <td> {if ($unItem.prive == 1)}<i class="fa fa-user-secret"></i>
                    Confidentiel
                {else}
                    {$unItem.traitement|truncate:35}
                {/if}
            </td>
            <td>
                {$unItem.aSuivre|truncate:35}
            </td>
        </tr>
        {/foreach}
    </tbody>
</table>

</page>
