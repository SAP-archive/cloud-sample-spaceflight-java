//Load the fake lrep connector
jQuery.sap.require("sap.ui.fl.FakeLrepConnector");
jQuery.extend(sap.ui.fl.FakeLrepConnector.prototype, {
	create: function (oChange) {
		return Promise.resolve();
	},
	stringToAscii: function (sCodeAsString) {
		if (!sCodeAsString || sCodeAsString.length == 0) {
			return "";
		}
		let sAsciiString = "";
		for (var i = 0; i < sCodeAsString.length; i++) {
			sAsciiString += sCodeAsString.charCodeAt(i) + ','
		}
		if (sAsciiString != null && sAsciiString.length > 0 && sAsciiString.charAt(sAsciiString.length - 1) == ',') {
			sAsciiString = sAsciiString.substring(0, sAsciiString.length - 1);
		}
		return sAsciiString;
	},
	/*
	 * Get the content of the sap-ui-cachebuster-info.json file
	 * to get the paths to the changes files
	 * and get their content
	 */
	loadChanges: function () {
		var oResult = {
			"changes": [],
			"settings": {
				"isKeyUser": true,
				"isAtoAvailable": false,
				"isProductiveSystem": false
			}
		};

		//Get the content of the changes folder.
		var aPromises = [];
		var sCacheBusterFilePath = "/sap-ui-cachebuster-info.json";

		return new Promise(function (resolve, reject) {
			$.ajax({
				url: window.location.origin + sCacheBusterFilePath,
				type: "GET",
				cache: false
			}).then(function (oCachebusterContent) {
				var aChangeFilesPaths = Object.keys(oCachebusterContent);
				// go over all files listed in the sap-ui-cachebuster-info.json and
				// get the content only of the files that are under the 'changes' folder
				$.each(aChangeFilesPaths, function (index, sFilePath) {
					//now as we support MTA projects we need to take only changes which are relevant for 
					//the current HTML5 module
					//sap-ui-cachebuster-info.json for MTA doesn't start with "webapp/changes" but as
					//<MTA-HTML5-MODULE-NAME>/webapp/changes/<change-file>
					var sChangesRelativePathIndex = sFilePath.indexOf("webapp/changes");
					if (sChangesRelativePathIndex != -1 && sFilePath.endsWith(".change")) {
						if (sChangesRelativePathIndex != 0 && !sFilePath.startsWith("app")) {
							return true;
						}
						sFilePath = sFilePath.slice(sChangesRelativePathIndex);
						aPromises.push(
							$.ajax({
								url: window.location.origin + "/" + sFilePath,
								type: "GET",
								cache: false
							}).then(function (sChangeContent) {
								return JSON.parse(sChangeContent);
							})
						);
					}
				});
			}).always(function () {
				return Promise.all(aPromises).then(function (aChanges) {
					var aChangePromises = [],
						aProcessedChanges = [];
					aChanges.forEach(function (oChange) {
						var sChangeType = oChange.changeType;
						if (sChangeType == "addXML" || sChangeType == "codeExt") {
							var sPath = sChangeType == "addXML" ? oChange.content.fragmentPath : sChangeType == "codeExt" ? oChange.content.codeRef :
								"";
							var sWebappPath = sPath.match(/webapp(.*)/);
							var sUrl = "/" + sWebappPath[0];
							aChangePromises.push(
								$.ajax({
									url: sUrl,
									type: "GET",
									cache: false
								}).then(function (oFileDocument) {
									if (sChangeType == "addXML") {
										oChange.content.fragment = sap.ui.fl.FakeLrepConnector.prototype.stringToAscii(oFileDocument.documentElement.outerHTML);
										oChange.content.selectedFragmentContent = oFileDocument.documentElement.outerHTML;
									} else if (sChangeType == "codeExt") {
										oChange.content.code = sap.ui.fl.FakeLrepConnector.prototype.stringToAscii(oFileDocument);
										oChange.content.extensionControllerContent = oFileDocument;
									}
									return oChange;
								})
							);
						} else {
							aProcessedChanges.push(oChange);
						}
					});
					// aChanges holds the content of all change files from the project (empty array if no such files)
					// sort the array by the creation timestamp of the changes
					if (aChangePromises.length > 0) {
						return Promise.all(aChangePromises).then(function (aUpdatedChanges) {
							aUpdatedChanges.forEach(function (oChange) {
								aProcessedChanges.push(oChange);
							});
							aProcessedChanges.sort(function (change1, change2) {
								return new Date(change1.creation) - new Date(change2.creation);
							});
							oResult.changes = aProcessedChanges;
							var oLrepChange = {
								changes: oResult,
								componentClassName: "app"
							};
							resolve(oLrepChange);
						});
					} else {
						aProcessedChanges.sort(function (change1, change2) {
							return new Date(change1.creation) - new Date(change2.creation);
						});
						oResult.changes = aProcessedChanges;
						var oLrepChange = {
							changes: oResult,
							componentClassName: "app"
						};
						resolve(oLrepChange);
					}
				});
			});
		});
	}
});
sap.ui.fl.FakeLrepConnector.enableFakeConnector();