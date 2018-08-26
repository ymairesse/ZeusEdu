
Inclure le widget visuellement dans le fichier .tpl par l'instruction

{include file="$INSTALL_DIR/widgets/fileTree/templates/treeview4PJ.tpl"}

dans le document template Smarty
$INSTALL_DIR doit être défini comme le répertoire d'installation de l'application.

Les fichiers préalablement sélectionnés figurent dans la variable $smarty $PjFiles sous la forme
$PjFiles[$shareId] => array('path'=> '...', 'fileName' => '...')


L'objet créé contiendra un ul #PjFiles (éventuellement vide) où se trouveront une liste de inputs cachés dont la valeur sera
 * le shareId du fichier (s'il existe déjà, sinon recevra la valeur -1)
 * le path vers le fichier
 * le nom du fichier
les noms des fichiers sélectionnés
<input type="hidden" name="files[]" value="{$data.shareId}|//|{$data.path}|//|{$data.fileName}">

Chacune des trois informations est séparée de la suivante par le marqueur conventionnel "|//|"
