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

<page backtop="25mm" backbottom="10mm" backleft="7mm" backright="15mm"  footer="page; date">
     <page_header>
       <img src="../../../images/logoEcole.png" alt="LOGO" style="float:right">
       <p>{$ECOLE}
         <br> {$ADRESSE} {$COMMUNE}
         <br>Téléphone: {$TELEPHONE}</p>
     </page_header>
     <page_footer>
        {$coursGrp}
     </page_footer>

    <h3>Journal de classe de {$coursGrp}<br> {if $dateDebut != ''} du {$dateDebut}{/if}
        {if $dateFin != ''} au {$dateFin}{/if} <br>Année scolaire: {$ANNEESCOLAIRE}</h3>

    <table style="width:100%">
        <tr>
            <th style="width:30%">Date</th>
            <th style="width:70%">Note</th>
        </tr>
        {foreach from=$jdcExtract key=wtf item=data}
        <tr>
            <td style="width:30%"><strong>{$data.libelle} <br> {$data.categorie}</strong><br>
                {$data.startDate}
                {if $data.startHeure != '00:00:00'}{$data.startHeure|truncate:5:''}{/if}
                {if $data.endHeure != $data.startHeure|truncate:5:''} - {$data.endHeure|truncate:5:''}{/if}
            </td>
            <td style="width:70%">{$data.enonce}</td>
        </tr>
        {/foreach}
    </table>

</page>
