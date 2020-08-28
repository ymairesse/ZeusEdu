<tr data-matricule="{$matricule}">
    <td>{$jdcDe}</td>
    <td><a href="inc/download.php?type=pfN&amp;f=/{$module}/{$nomFichier}">{$nomFichier}</a></td>
    <td><button type="button"
            class="btn btn-xs btn-danger btn-delFile"
            title="Effacer cette archive"
            data-filename="{$nomFichier}"
            data-module="{$module}">
                <i class="fa fa-times"></i>
        </button>
    </td>
</tr>
