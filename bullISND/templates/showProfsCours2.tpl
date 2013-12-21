<h3>Attribution des cours aux enseignants</h3>
<form name="supprProfCours" id="supprProfCours" method="POST" action="index.php" style="width:40%; float:left">
	<div style="float:left">
	{if $listeCoursGrp}
	<select name="coursGrp" id="selectCoursGrp">
		{foreach from=$listeCoursGrp key=coursGrp item=unCoursGrp}
		<option value=''>Sélectionner un cours</option>
		<option value="$coursGrp">{$unCoursGrp.coursGrp} {$unCoursGrp.libelle} {$unCoursGrp.nbheures}h</option>
		{/foreach}
	</select>
	{/if}
	</div>

</form>


<script type="text/javascript">
{literal}
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

{/literal}
</script>
