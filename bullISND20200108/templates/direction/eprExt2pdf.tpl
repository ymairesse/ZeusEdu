<style type="text/css">
    table.cours { border: solid 1px #ccc; border-collapse: collapse; width: 100% }
    table.cours td { border: solid 1px #ccc; font-size: 8pt;}
    table.cours tr.title { background-color: #ccc; font-size: 9pt; text-align:center; }
	p { font-size: 10pt; }
    h1 { font-size: 24pt; font-weight: normal; }
    .unCours { border: 2px solid black; margin-bottom: 10px; padding: 5px 20px; }
</style>

<page backtop="10mm" backbottom="10mm" backleft="10mm" backright="15mm">

    {include file="../direction/ext/titreExterne.tpl"}

    <p style="font-size:14pt">Synthèse des résultats de: <strong>{$nomEleve}</strong></p>
    <p>Classe: <strong>{$classe}</strong></p>

	 {foreach from=$unEleve key=matricule item=unCours}

        <div class="unCours">

            <h4>Épreuve de: <strong>{$unCours.libelle}</strong></h4>

            <p style="font-size: 12pt; text-align:center;">Note globale:
                <strong>
                    {if $unCours.coteExterne != ''}
                        {$unCours.coteExterne} %
                    {else}
                        Non présenté
                    {/if}
                </strong></p>

        </div>

     {/foreach}

     {if $signature == 1}
     {include file="../direction/ext/signature.tpl"}
     {/if}

</page>
