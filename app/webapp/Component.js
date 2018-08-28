jQuery.sap.declare("app.Component");
sap.ui.getCore().loadLibrary("sap.ui.generic.app");
jQuery.sap.require("sap.ui.generic.app.AppComponent");

sap.ui.generic.app.AppComponent.extend("app.Component", {
	metadata: {
		"manifest": "json"
	}
});