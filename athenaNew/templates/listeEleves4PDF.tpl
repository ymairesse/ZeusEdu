<style>
  td,
  th {
    border: inset 1px #555;
    padding: 5px;
    font-size: 9pt;
  }
</style>

<page backtop="25mm" backbottom="7mm" backleft="7mm" backright="20mm"  footer="page; date">
     <page_header>
       <img src="../../images/logoEcole.png" alt="LOGO" style="float:right">
       <p>{$ECOLE}
         <br> {$ADRESSE} {$COMMUNE}
         <br>Téléphone: {$TELEPHONE}</p>
     </page_header>
     <page_footer>
        {$nomCoach.prenom} {$nomCoach.nom}
     </page_footer>

    <h3>Période: {if $dateDebut != ''} depuis le {$dateDebut}{/if}
                {if $dateFin != ''} jusqu'au {$dateFin}{/if} [{$anneeScolaire}]</h3>

     <table style="width:100%">
             <tr>
                 <td style="width: 5%">&nbsp;</td>
                 <td style="width: 60%">Nom de l'élève</td>
                 <td style="width: 40%">Date et heure</td>
             </tr>

             {foreach from=$elevesSuivis key=matricule item=unEleve}
                 {assign var=n value=1}
                 {foreach from=$unEleve key=date item=uneVisite}

                 <tr {if $n == 1}style="background:#777; color: #fff"{/if}>
                     <td>{if $unEleve|@count > 1}{$n}{else}&nbsp;{/if}</td>
                     <td>
                         {if $n == 1}
                           {$uneVisite.groupe} - {$uneVisite.prenom} {$uneVisite.nom}
                         {/if}
                     </td>
                     <td>Le {$date} à {$uneVisite.heure}</td>
                 </tr>
                 {assign var=n value=$n+1}
                 {/foreach}
             {/foreach}

     </table>

</page>
