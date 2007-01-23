{**
 * index.tpl
 *
 * Copyright (c) 2003-2006 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Files browser.
 *
 * $Id$
 *}

{assign var="pageTitle" value="director.filesBrowser"}
{include file="common/header.tpl"}
{assign var=displayDir value="/$currentDir"}
<h3>{translate key="director.files.indexOfDir" dir=$displayDir|escape}</h3>

{if $currentDir}
<p><a href="{url op="files" path=$parentDir|explode:"/"}" class="action">&lt; {translate key="director.files.parentDir"}</a></p>
{/if}

<table width="100%" class="listing">
	<tr>
		<td class="headseparator" colspan="6">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td></td>
		<td width="25%">{translate key="common.fileName"}</td>
		<td width="25%">{translate key="common.type"}</td>
		<td width="25%">{translate key="common.dateModified"}</td>
		<td width="5%">{translate key="common.size"}</td>
		<td width="20%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td class="headseparator" colspan="6">&nbsp;</td>
	</tr>
	{foreach from=$files item=file name=files}
	{if $currentDir}
		{assign var=filePath value="$currentDir/`$file.name`"}
	{else}
		{assign var=filePath value=$file.name}
	{/if}
	{assign var=filePath value=$filePath|escape}
	<tr valign="top">
		<td>{if $file.isDir}{icon name="folder"}{else}{icon name="letter"}{/if}</td>
		<td><a href="{url op="files" path=$filePath|explode:"/"}">{$file.name}</a></td>
		<td>{$file.mimetype|escape|default:"&mdash;"}</td>
		<td>{$file.mtime|escape|date_format:$datetimeFormatShort}</td>
		<td>{$file.size|escape|default:"&mdash;"}</td>
		<td align="right" class="nowrap">
			{if !$file.isDir}
				<a href="{url op="files" path=$filePath|explode:"/" download=1}" class="action">{translate key="common.download"}</a>&nbsp;|
			{/if}
			<a href="{url op="fileDelete" path=$filePath|explode:"/"}" onclick="return confirm('{translate|escape:"javascript" key="director.files.confirmDelete"}')" class="action">{translate key="common.delete"}</a>
		</td>
	</tr>
	<tr>
		<td colspan="6" class="{if $smarty.foreach.files.last}end{/if}separator">&nbsp;</td>
	</tr>
{foreachelse}
	<tr>
		<td colspan="6" class="nodata">{translate key="director.files.emptyDir"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{/foreach}
</table>

<form method="post" action="{url op="fileUpload" path=$currentDir|explode:"/"}" enctype="multipart/form-data">
	<input type="file" size="20" name="file" class="uploadField" />
	<input type="submit" value="{translate key="director.files.uploadFile"}" class="button" />
</form>

<form method="post" action="{url op="fileMakeDir" path=$currentDir|explode:"/"}" enctype="multipart/form-data">
	<input type="text" size="20" maxlength="255" name="dirName" class="textField" />
	<input type="submit" value="{translate key="director.files.createDir"}" class="button" />
</form>

<p>{translate key="director.files.note"}</p>

{include file="common/footer.tpl"}