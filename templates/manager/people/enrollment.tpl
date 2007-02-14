{**
 * enrollment.tpl
 *
 * Copyright (c) 2003-2005 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * List enrolled users.
 *
 * $Id$
 *}

{assign var="pageTitle" value="manager.people.enrollment"}
{include file="common/header.tpl"}

<form name="disableUser" method="post" action="{url op="disableUser"}">
	<input type="hidden" name="reason" value=""/>
	<input type="hidden" name="userId" value=""/>
</form>

<script type="text/javascript">
{literal}
<!--
function toggleChecked() {
	var elements = document.people.elements;
	for (var i=0; i < elements.length; i++) {
		if (elements[i].name == 'bcc[]') {
			elements[i].checked = !elements[i].checked;
		}
	}
}

function confirmAndPrompt(userId) {
	var reason = prompt('{/literal}{translate|escape:"javascript" key="manager.people.confirmDisable"}{literal}');
	if (reason == null) return;

	document.disableUser.reason.value = reason;
	document.disableUser.userId.value = userId;

	document.disableUser.submit();
}
// -->
{/literal}
</script>

<h3>{translate key=$roleName}</h3>
<form method="post" action="{url path=$roleSymbolic}">
	<select name="roleSymbolic" class="selectMenu">
		<option {if $roleSymbolic=='all'}selected="selected" {/if}value="all">{translate key="manager.people.allUsers"}</option>

		{if $isConferenceManagement}
			<option {if $roleSymbolic=='managers'}selected="selected" {/if}value="managers">{translate key="user.role.managers"}</option>
		{/if}
		{if $isSchedConfManagement}
			{if $isRegistrationEnabled}
				<option {if $roleSymbolic=='registrationManagers'}selected="selected" {/if}value="registrationManagers">{translate key="user.role.registrationManagers"}</option>
			{/if}

			<option {if $roleSymbolic=='editors'}selected="selected" {/if}value="editors">{translate key="user.role.editors"}</option>
			<option {if $roleSymbolic=='trackDirectors'}selected="selected" {/if}value="trackDirectors">{translate key="user.role.trackDirectors"}</option>
			<option {if $roleSymbolic=='layoutEditors'}selected="selected" {/if}value="layoutEditors">{translate key="user.role.layoutEditors"}</option>
			<option {if $roleSymbolic=='reviewers'}selected="selected" {/if}value="reviewers">{translate key="user.role.reviewers"}</option>

			<option {if $roleSymbolic=='presenters'}selected="selected" {/if}value="presenters">{translate key="user.role.presenters"}</option>
			{*<option {if $roleSymbolic=='invitedPresenters'}selected="selected" {/if}value="invitedPresenters">{translate key="user.role.invitedPresenters"}</option>*}

			{*<option {if $roleSymbolic=='discussants'}selected="selected" {/if}value="discussants">{translate key="user.role.discussants"}</option>*}
			{if $isRegistrationEnabled}
				{*<option {if $roleSymbolic=='registrants'}selected="selected" {/if}value="registrants">{translate key="user.role.registrants"}</option>*}
			{/if}
			<option {if $roleSymbolic=='readers'}selected="selected" {/if}value="readers">{translate key="user.role.readers"}</option>
		{/if}
	</select>
	<select name="searchField" size="1" class="selectMenu">
		{html_options_translate options=$fieldOptions selected=$searchField}
	</select>
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
		<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
	</select>
	<input type="text" size="10" name="search" class="textField" value="{$search|escape}" />&nbsp;<input type="submit" value="{translate key="common.search"}" class="button" />
</form>

<p>{foreach from=$alphaList item=letter}<a href="{url path=$roleSymbolic searchInitial=$letter}">{if $letter == $searchInitial}<strong>{$letters}</strong>{else}{$letter}{/if}</a> {/foreach}<a href="{url path=$roleSymbolic}">{if $searchInitial==''}<strong>{translate key="common.all"}</strong>{else}{translate key="common.all"}{/if}</a></p>

{if not $roleId}
<ul>
	{if $isConferenceManagement}
		<li><a href="{url path="managers"}">{translate key="user.role.managers"}</a></li>
	{/if}
	{if $isSchedConfManagement}
		{if $isRegistrationEnabled}
			<li><a href="{url path="registrationManagers"}">{translate key="user.role.registrationManagers"}</a></li>
		{/if}
	
		<li><a href="{url path="editors"}">{translate key="user.role.editors"}</a></li>
		<li><a href="{url path="trackDirectors"}">{translate key="user.role.trackDirectors"}</a></li>
		<li><a href="{url path="layoutEditors"}">{translate key="user.role.layoutEditors"}</a></li>
		<li><a href="{url path="reviewers"}">{translate key="user.role.reviewers"}</a></li>
	
		<li><a href="{url path="presenters"}">{translate key="user.role.presenters"}</a></li>
		{*<li><a href="{url path="invitedPresenters"}">{translate key="user.role.invitedPresenters"}</a></li>*}
	
		{*<li><a href="{url path="discussants"}">{translate key="user.role.discussants"}</a></li>*}
		{if $isRegistrationEnabled}
			{*<li><a href="{url path="registrants"}">{translate key="user.role.registrants"}</a></li>*}
		{/if}
		<li><a href="{url path="readers"}">{translate key="user.role.readers"}</a></li>
	{/if}
</ul>

<br />
{else}
<p><a href="{url path="all"}" class="action">{translate key="manager.people.allUsers"}</a></p>
{/if}

<form name="people" action="{url page="user" op="email"}" method="post">
<input type="hidden" name="redirectUrl" value="{url path=$roleSymbolic}"/>

<a name="users"></a>

<table width="100%" class="listing">
	<tr>
		<td colspan="5" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="5%">&nbsp;</td>
		<td width="12%">{translate key="user.username"}</td>
		<td width="20%">{translate key="user.name"}</td>
		<td width="23%">{translate key="user.email"}</td>
		<td width="40%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td colspan="5" class="headseparator">&nbsp;</td>
	</tr>
	{iterate from=users item=user}
	{assign var=userExists value=1}
	<tr valign="top">
		<td><input type="checkbox" name="bcc[]" value="{$user->getEmail()|escape}"/></td>
		<td><a class="action" href="{url op="userProfile" path=$user->getUserId()}">{$user->getUsername()|escape|wordwrap:15:" ":true}</a></td>
		<td>{$user->getFullName()|escape}</td>
		<td class="nowrap">
			{assign var=emailString value="`$user->getFullName()` <`$user->getEmail()`>"}
			{url|assign:"redirectUrl" path=$roleSymbolic}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$redirectUrl}
			{$user->getEmail()|truncate:15:"..."|escape}&nbsp;{icon name="mail" url=$url}
		</td>
		<td align="right">
			{if $roleId}
			<a href="{url op="unEnroll" path=$roleId userId=$user->getUserId()}" onclick="return confirm('{translate|escape:"javascript" key="manager.people.confirmUnenroll"}')" class="action">{translate key="manager.people.unenroll"}</a>&nbsp;|
			{/if}
			<a href="{url op="editUser" path=$user->getUserId()}" class="action">{translate key="common.edit"}</a>
			{if $thisUser->getUserId() != $user->getUserId()}
				|&nbsp;<a href="{url op="signInAsUser" path=$user->getUserId()}" class="action">{translate key="manager.people.signInAs"}</a>
				{if !$roleId}|&nbsp;<a href="{url op="removeUser" path=$user->getUserId()}" onclick="return confirm('{translate|escape:"javascript" key="manager.people.confirmRemove"}')" class="action">{translate key="manager.people.remove"}</a>{/if}
				{if $user->getDisabled()}
					|&nbsp;<a href="{url op="enableUser" path=$user->getUserId()}" class="action">{translate key="manager.people.enable"}</a>
				{else}
					|&nbsp;<a href="javascript:confirmAndPrompt({$user->getUserId()})" class="action">{translate key="manager.people.disable"}</a>
				{/if}
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="5" class="{if $users->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $users->wasEmpty()}
	<tr>
		<td colspan="5" class="nodata">{translate key="manager.people.noneEnrolled"}</td>
	</tr>
	<tr>
		<td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$users}</td>
		<td align="right">{page_links anchor="users" name="users" iterator=$users searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth roleSymbolic=$roleSymbolic searchInitial=$searchInitial}</td>
	</tr>
{/if}
</table>

{if $userExists}
	<p><input type="submit" value="{translate key="email.compose"}" class="button defaultButton"/>&nbsp;<input type="button" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" /></p>
{/if}
</form>

<a href="{url op="enrollSearch" path=$roleId}" class="action">{translate key="manager.people.enrollExistingUser"}</a> | <a href="{if $roleId}{url op="createUser" roleId=$roleId}{else}{url op="createUser"}{/if}" class="action">{translate key="manager.people.createUser"}</a> | <a href="{url op="enrollSyncSelect" path=$rolePath}" class="action">{translate key="manager.people.enrollSync"}</a>

{include file="common/footer.tpl"}
