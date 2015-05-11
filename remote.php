<?php
$rows = 25;
$str  = '';
while (list($k, $v) = each($_GET)) {
	$str .= $k . '=' . $v . ', ';
}
?>
<table>
<tbody>
<?php
for ($i=0; $i<$rows; $i++) {
?>
<tr>
<td><?= $_GET['pg']; ?>:<?= $i; ?>:1 [GETs: <?= $str; ?>]</td>
<td><?= $_GET['pg']; ?>:<?= $i; ?>:2</td>
<td><?= $_GET['pg']; ?>:<?= $i; ?>:3</td>
<td><?= $_GET['pg']; ?>:<?= $i; ?>:4</td>
</tr>
<?php
}
?>
</tbody>
</table>