{**
 * metadata.tpl
 *
 * Copyright (c) 2003-2004 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission metadata table.
 *
 * $Id$
 *}

<a name="metadata"></a>
<table class="data">
	<tr valign="middle">
		<td><h3>{translate key="submission.metadata"}</h3></td>
		<td>&nbsp;<br/><a href="{url op="viewMetadata" path=$submission->getPaperId()}" class="action">{translate key="submission.editMetadata"}</a></td>
	</tr>
</table>

<h4>{translate key="paper.presenters"}</h4>
	
<table width="100%" class="data">
	{foreach name=presenters from=$presenters item=presenter}
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.name"}</td>
		<td width="80%" class="value">
			{assign var=emailString value="`$presenter->getFullName()` <`$presenter->getEmail()`>"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getPaperTitle|strip_tags paperId=$submission->getPaperId()}
			{$presenter->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	{if $presenter->getEmail()}<tr valign="top">
		<td class="label">{translate key="user.url"}</td>
		<td class="value"><a href="{$presenter->getUrl()|escape:"quotes"}">{$presenter->getUrl()|escape}</a></td>
	</tr>{/if}
	<tr valign="top">
		<td class="label">{translate key="user.affiliation"}</td>
		<td class="value">{$presenter->getAffiliation()|escape|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="common.country"}</td>
		<td class="value">{$presenter->getCountryLocalized()|escape|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="user.biography"}</td>
		<td class="value">{$presenter->getBiography()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	{if $presenter->getPrimaryContact()}
	<tr valign="top">
		<td colspan="2" class="label">{translate key="presenter.submit.selectPrincipalContact"}</td>
	</tr>
	{/if}
	{if !$smarty.foreach.presenters.last}
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{/foreach}
</table>

<h4>{translate key="submission.titleAndAbstract"}</h4>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.title"}</td>
		<td width="80%" class="value">{$submission->getTitle()|escape|default:"&mdash;"}</td>
	</tr>
	{if $alternateLocale1}
	<tr valign="top">
		<td class="label">{translate key="paper.title"}<br />({$languageToggleLocales.$alternateLocale1})</td>
		<td class="value">{$submission->getTitleAlt1()|escape|default:"&mdash;"}</td>
	</tr>
	{/if}
	{if $alternateLocale2}
	<tr valign="top">
		<td class="label">{translate key="paper.title"}<br />({$languageToggleLocales.$alternateLocale2})</td>
		<td class="value">{$submission->getTitleAlt2()|escape|default:"&mdash;"}</td>
	</tr>
	{/if}

	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.abstract"}</td>
		<td class="value">{$submission->getAbstract()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	{if $alternateLocale1}
	<tr valign="top">
		<td class="label">{translate key="paper.abstract"}<br />({$languageToggleLocales.$alternateLocale1})</td>
		<td class="value">{$submission->getAbstractAlt1()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	{/if}
	{if $alternateLocale2}
	<tr valign="top">
		<td class="label">{translate key="paper.abstract"}<br />({$languageToggleLocales.$alternateLocale2})</td>
		<td class="value">{$submission->getAbstractAlt2()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	{/if}
</table>

<h4>{translate key="submission.indexing"}</h4>
	
<table width="100%" class="data">
	{if $conferenceSettings.metaDiscipline}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.discipline"}</td>
		<td width="80%" class="value">{$submission->getDiscipline()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $conferenceSettings.metaSubjectClass}
	<tr valign="top">
		<td width="20%"  class="label">{translate key="paper.subjectClassification"}</td>
		<td width="80%" class="value">{$submission->getSubjectClass()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $conferenceSettings.metaSubject}
	<tr valign="top">
		<td width="20%"  class="label">{translate key="paper.subject"}</td>
		<td width="80%" class="value">{$submission->getSubject()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $conferenceSettings.metaCoverage}
	<tr valign="top">
		<td width="20%"  class="label">{translate key="paper.coverageGeo"}</td>
		<td width="80%" class="value">{$submission->getCoverageGeo()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.coverageChron"}</td>
		<td class="value">{$submission->getCoverageChron()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.coverageSample"}</td>
		<td class="value">{$submission->getCoverageSample()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $conferenceSettings.metaType}
	<tr valign="top">
		<td width="20%"  class="label">{translate key="paper.type"}</td>
		<td width="80%" class="value">{$submission->getType()|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.language"}</td>
		<td width="80%" class="value">{$submission->getLanguage()|escape|default:"&mdash;"}</td>
	</tr>
</table>

<h4>{translate key="submission.supportingAgencies"}</h4>
	
<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="presenter.submit.agencies"}</td>
		<td width="80%" class="value">{$submission->getSponsor()|escape|default:"&mdash;"}</td>
	</tr>
</table>