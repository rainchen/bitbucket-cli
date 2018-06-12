// ==UserScript==
// @name         Jira: helper
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  features: 1. copy issue key and title for creating git branch
// @author       Rain Chen
// @match        https://*.atlassian.net/secure/*
// @match        https://*.atlassian.net/browse/*
// @grant        none

// @require      https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js
// @require      https://rawgit.com/notifyjs/notifyjs/master/dist/notify.js

// ==/UserScript==

(function($, JIRA) {
    'use strict';

    function addCopyButton() {
      // console.info('addCopyButton');

      if(!$('#clipboardBtn').next().length) {
        $('#clipboardBtn').remove();
        var container = $("#THIRD_PARTY_TAB .call-to-actions, .toolbar-split-left");
        container.append("<a id='clipboardBtn' class='btn aui-button aui-button-primary aui-style'>Copy issue title</a>");
      }
    }

    function getIssueFullTitle () {
      var issueKey = "";
      var issueTitle = $('#summary-val').text();
      if($('#issuekey-val').length){
        issueKey = $('#issuekey-val').text();
      }
      if($('#key-val').length){
        issueKey = $('#key-val').text();
      }

      return issueKey + ' ' + issueTitle;
    }

    function handleCopyButton () {
      // console.info('handleCopyButton');

      var clipboard = new Clipboard('#clipboardBtn', {
        text: function(trigger) {
          return getIssueFullTitle();
        }
      });

      clipboard.on('success', function(e) {
        $.notify("Copied to clipboard", "success");
        $.notify(getIssueFullTitle(), "success");
      });

      clipboard.on('error', function(e) {
        $.notify("Access granted", "error");
      });
    }

    function init() {
      // console.info("init");
      updateHandlers();
      handleCopyButton();
      addCopyButton();

      JIRA.bind(JIRA.Events.NEW_CONTENT_ADDED, function() {
        updateHandlers();
      });
    }

    function updateHandlers() {
      // console.info('updateHandlers');
      addCopyButton();
    }

    // init when page ready
    document.onreadystatechange = function() {
      if (document.readyState == "complete") {
        init();
      }
    };


})(window.$, window.JIRA);
