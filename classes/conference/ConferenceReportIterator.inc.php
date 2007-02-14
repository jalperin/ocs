<?php

/**
 * ConferenceReportIterator.inc.php
 *
 * Copyright (c) 2003-2007 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @package conference
 *
 * Wrapper around DBRowIterator providing "factory" features for conference
 * reports.
 *
 * $Id$
 */

import('db.DBRowIterator');

class ConferenceReportIterator extends DBRowIterator {
	/** @var $locale Name of report's locale */
	var $locale;

	/** @var $altLocaleNum int 1 iff current locale is conference's alt locale 1, 2 iff current locale is conference's alt locale 2 */
	var $altLocaleNum;

	/** @var $conferenceStatisticsDao object */
	var $conferenceStatisticsDao;

	/** @var $presenterDao object */
	var $presenterDao;

	/** @var $userDao object */
	var $userDao;

	/** @var $countryDao object */
	var $countryDao;

	/** @var $presenterSubmissionDao object */
	var $presenterSubmissionDao;

	/** @var $editAssignmentDao object */
	var $editAssignmentDao;

	/** @var $maxPresenterCount int The most presenters that can be expected for an paper. */
	var $maxPresenterCount;

	/** @var $maxReviewerCount int The most reviewers that can be expected for a submission. */
	var $maxReviewerCount;

	/** @var $maxEditorCount int The most editors that can be expected for a submission. */
	var $maxEditorCount;

	/** @var $reportType int The report type (REPORT_TYPE_...) */
	var $type;

	/**
	 * Constructor.
	 * Initialize the ConferenceReportIterator
	 * @param $conferenceId int ID of conference this report is generated on
	 * @param $records object ADO record set
	 * @param $dateStart string optional
	 * @param $dateEnd string optional
	 * @param $reportType int REPORT_TYPE_...
	 */
	function ConferenceReportIterator($conferenceId, &$records, $dateStart, $dateEnd, $reportType) {
		$this->presenterDao =& DAORegistry::getDao('PresenterDAO');
		$this->presenterSubmissionDao =& DAORegistry::getDAO('PresenterSubmissionDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->conferenceStatisticsDao =& DAORegistry::getDAO('ConferenceStatisticsDAO');
		$this->countryDao =& DAORegistry::getDAO('CountryDAO');
		$this->reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$this->editAssignmentDao =& DAORegistry::getDAO('EditAssignmentDAO');

		parent::DBRowIterator($records);

		$this->altLocaleNum = Locale::isAlternateConferenceLocale($conferenceId);
		$this->type = $reportType;

		$this->maxPresenterCount = $this->conferenceStatisticsDao->getMaxPresenterCount($conferenceId, $dateStart, $dateEnd);
		$this->maxReviewerCount = $this->conferenceStatisticsDao->getMaxReviewerCount($conferenceId, $dateStart, $dateEnd);
		if ($this->type !== REPORT_TYPE_EDITOR) {
			$this->maxEditorCount = $this->conferenceStatisticsDao->getMaxEditorCount($conferenceId, $dateStart, $dateEnd);
		}
	}

	/**
	 * Return the object representing the next row.
	 * @return object
	 */
	function &next() {
		$row =& parent::next();
		if ($row == null) return $row;

		$ret = array(
			'paperId' => $row['paper_id']
		);

		$ret['dateSubmitted'] = $this->conferenceStatisticsDao->dateFromDB($row['date_submitted']);
		$ret['title'] = $row['paper_title'];

		$ret['track'] = null;
		switch ($this->altLocaleNum) {
			case 1: $ret['track'] = $row['track_title_alt1']; break;
			case 2: $ret['track'] = $row['track_title_alt2']; break;
		}
		if (empty($ret['track'])) $ret['track'] = $row['track_title'];

		// Presenter Names & Affiliations
		$maxPresenters = $this->getMaxPresenters();
		$ret['presenters'] = $maxPresenters==0?array():array_fill(0, $maxPresenters, '');
		$ret['affiliations'] = $maxPresenters==0?array():array_fill(0, $maxPresenters, '');
		$ret['countries'] = $maxPresenters==0?array():array_fill(0, $maxPresenters, '');
		$presenters =& $this->presenterDao->getPresentersByPaper($row['paper_id']);
		$presenterIndex = 0;
		foreach ($presenters as $presenter) {
			$ret['presenters'][$presenterIndex] = $presenter->getFullName();
			$ret['affiliations'][$presenterIndex] = $presenter->getAffiliation();
			
			$country = $presenter->getCountry();
			if (!empty($country)) {
				$ret['countries'][$presenterIndex] = $this->countryDao->getCountry($country);
			}
			$presenterIndex++;
		}

		if ($this->type === REPORT_TYPE_EDITOR) {
			$user = null;
			if ($row['editor_id']) $user =& $this->userDao->getUser($row['editor_id']);
			$ret['editor'] = $user?$user->getFullName():'';
		} else {
			$editAssignments =& $this->editAssignmentDao->getEditAssignmentsByPaperId($row['paper_id']);
			$maxEditors = $this->getMaxEditors();
			$ret['editors'] = $maxEditors==0?array():array_fill(0, $maxEditors, '');

			$editorIndex = 0;
			while ($editAssignment =& $editAssignments->next()) {
				$ret['editors'][$editorIndex++] = $editAssignment->getEditorFullName();
			}
		}

		// Reviewer Names
		$ratingOptions =& ReviewAssignment::getReviewerRatingOptions();
		if ($this->type === REPORT_TYPE_REVIEWER) {
			$user = null;
			if ($row['reviewer_id']) $user =& $this->userDao->getUser($row['reviewer_id']);
			$ret['reviewer'] = $user?$user->getFullName():'';

			if ($row['quality']) {
				$ret['score'] = Locale::translate($ratingOptions[$row['quality']]);
			} else {
				$ret['score'] = '';
			}
			$ret['affiliation'] = $user?$user->getAffiliation():'';
		} else {
			$maxReviewers = $this->getMaxReviewers();
			$ret['reviewers'] = $maxReviewers==0?array():array_fill(0, $maxReviewers, '');
			$ret['scores'] = $maxReviewers==0?array():array_fill(0, $maxReviewers, '');
			$ret['recommendations'] = $maxReviewers==0?array():array_fill(0, $maxReviewers, '');
			$reviewAssignments =& $this->reviewAssignmentDao->getReviewAssignmentsByPaperId($row['paper_id']);
			$reviewerIndex = 0;
			foreach ($reviewAssignments as $reviewAssignment) {
				$reviewerId = $reviewAssignment->getReviewerId();
				$ret['reviewers'][$reviewerIndex] = $reviewAssignment->getReviewerFullName();
				$rating = $reviewAssignment->getQuality();
				if ($rating != '') {
					$ret['scores'][$reviewerIndex] = Locale::translate($ratingOptions[$rating]);
				}
				$recommendation = $reviewAssignment->getRecommendation();
				if ($recommendation != '') {
					$recommendationOptions =& $reviewAssignment->getReviewerRecommendationOptions();
					$ret['recommendations'][$reviewerIndex] = Locale::translate($recommendationOptions[$recommendation]);
				}
				$reviewerIndex++;
			}
		}

		// Fetch the last editorial decision for this paper.
		$editorDecisions = $this->presenterSubmissionDao->getEditorDecisions($row['paper_id']);
		$lastDecision = array_pop($editorDecisions);

		if ($lastDecision) {
			import('submission.trackDirector.TrackDirectorSubmission');
			$decisionOptions =& TrackDirectorSubmission::getEditorDecisionOptions();
			$ret['decision'] = Locale::translate($decisionOptions[$lastDecision['decision']]);
			$ret['dateDecided'] = $lastDecision['dateDecided'];

			$decisionTime = strtotime($lastDecision['dateDecided']);
			$submitTime = strtotime($ret['dateSubmitted']);
			if ($decisionTime === false || $decisionTime === -1 || $submitTime === false || $submitTime === -1) {
				$ret['daysToDecision'] = '';
			} else {
				$ret['daysToDecision'] = round(($decisionTime - $submitTime) / 3600 / 24);
			}
		} else {
			$ret['decision'] = '';
			$ret['daysToDecision'] = '';
			$ret['dateDecided'] = '';
		}

		$ret['daysToPublication'] = '';
		if ($row['pub_id']) {
			$submitTime = strtotime($ret['dateSubmitted']);
			$publishTime = strtotime($this->conferenceStatisticsDao->dateFromDB($row['date_published']));
			if ($publishTime > $submitTime) {
				// Imported documents can be published before
				// they were submitted -- in this case, ignore
				// this metric (as opposed to displaying
				// negative numbers).
				$ret['daysToPublication'] = round(($publishTime - $submitTime) / 3600 / 24);
			}
		}

		$ret['status'] = $row['status'];

		return $ret;
	}

	/**
	 * Return the next row, with key.
	 * @return array ($key, $value)
	 */
	function &nextWithKey() {
		// We don't have keys with rows. (Row numbers might become
		// valuable at some point.)
		return array(null, $this->next());
	}

	function _cleanup() {
		parent::_cleanup();
	}

	/**
	 * Return the maximum number of presenters that can be expected for a
	 * single paper in this report.
	 */
	function getMaxPresenters() {
		return $this->maxPresenterCount;
	}

	/**
	 * Return the maximum number of reviewers that can be expected for a
	 * single paper in this report.
	 */
	function getMaxReviewers() {
		return $this->maxReviewerCount;
	}

	/**
	 * Return the maximum number of editors that can be expected for a
	 * single paper in this report. This call can be used for all
	 * report types EXCEPT, of course, REPORT_TYPE_EDITOR.
	 */
	function getMaxEditors() {
		return $this->maxEditorCount;
	}
}

?>
