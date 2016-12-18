<style>
  td,
  th {
    border: inset 1px #555;
    padding: 5px;
    font-size: 9pt;
  }
</style>

<page backtop="25mm" backbottom="7mm" backleft="7mm" backright="10mm"  footer="page; date">
     <page_header>
       <img src="../../images/logoEcole.png" alt="LOGO" style="float:right">
       <p>{$ECOLE}
         <br> {$ADRESSE} {$COMMUNE}
         <br>Téléphone: {$TELEPHONE}</p>
     </page_header>
     <page_footer>
        {$nomCoach.prenom} {$nomCoach.nom}
     </page_footer>

     <table style="width:100%">
         <thead>
             <tr>
                 <th style="width: 60%">Nom</th>
                 <th style="width: 40%">Date et heure</th>
             </tr>
         </thead>
         <tbody>
             {foreach from=$elevesSuivis key=matricule item=unEleve}
                 {assign var=n value=1}
                 {foreach from=$unEleve key=date item=uneVisite}

                 <tr {if $n == 1}style="background:#555; color: #fff"{/if}>
                     <td>
                         {$n} - {$uneVisite.prenom} {$uneVisite.nom}
                     </td>
                     <td>Le {$date} à {$uneVisite.heure}</td>
                 </tr>
                 {assign var=n value=$n+1}
                 {/foreach}
             {/foreach}

         </tbody>
     </table>

</page>
