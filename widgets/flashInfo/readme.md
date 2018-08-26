# intégration du widget flashInfo

 Dans le fichier index.php du module, définir la variable $smarty INSTALL_DIR
```
$smarty->assign('INSTALL_DIR', INSTALL_DIR);
```

 Dans le template où le widget doit apparaître, insérer le code

```
{assign var=module value="flashInfo"}
{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
```
à l’endroit où les annonces doivent apparaître.

Dans le fichier PHP qui demande l'affichage de flashInfo, la liste des annonces se trouve dans la variable $listeFlashInfos
```
$listeFlashInfos = $FlashInfo->listeFlashInfos($module);
```
et
```
$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('listeFlashInfos', $listeFlashInfos);
```
