<style>
  td,
  th {
    border: inset 1px #555;
    padding: 5px;
    font-size: 9pt;
  }
  p {
      margin: 3px;
  }
  h1, h2, h3 {
      font-size: 12pt;
  }
</style>

<page backtop="25mm" backbottom="10mm" backleft="7mm" backright="45mm"  footer="page; date">
     <page_header>
       <img src="../../images/logoEcole.png" alt="LOGO" style="float:right">
       <p>{$ECOLE}
         <br> {$ADRESSE} {$COMMUNE}
         <br>Téléphone: {$TELEPHONE}</p>
     </page_header>
     <page_footer>
        {$userName}
     </page_footer>

    <h3>Journal de classe: {if $dateDebut != ''} du {$dateDebut}{/if}
        {if $dateFin != ''} au {$dateFin}{/if} <br>Année scolaire: [{$ANNEESCOLAIRE}]</h3>
    <h4>Cours: {$coursGrp}</h4>

    <table>
        <tr>
            <th style="width:10%">Date</th>
            <th style="width:30%">Note</th>
        </tr>
        {foreach from=$jdcExtract key=id item=data}
        <tr>
            <td><strong>{$data.categorie}</strong><br>
                {$data.startDate}<br>
                {if $data.startHeure != '00:00:00'}{$data.startHeure}{/if}
                {if $data.endHeure != $data.startHeure} - {$data.endHeure}{/if}
                {if $coursGrp == 'Tous les cours'}<br>{$data.destinataire}{/if}
            </td>
            <td>{$data.enonce}</td>
        </tr>
        {/foreach}
    </table>

</page>
