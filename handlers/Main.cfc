component extends="coldbox.system.EventHandler" {

	/**
	 * Default Action
	 */
	function index( event, rc, prc ) {
		prc.welcomeMessage = "Welcome to ColdBox!";
		event.setView( "main/index" );
	}
	/**
	 * Default Action
	 */
	function print( event, rc, prc ) {
		event.setView( view="main/index", layout="print" );
	}

	/**
	 * Produce some restfulf data
	 */
	function data( event, rc, prc ) {
		return [
			{ "id" : createUUID(), name : "Luis" },
			{ "id" : createUUID(), name : "JOe" },
			{ "id" : createUUID(), name : "Bob" },
			{ "id" : createUUID(), name : "Darth" }
		];
	}

	/**
	 * Relocation example
	 */
	function doSomething( event, rc, prc ) {
		relocate( "main.index" );
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit( event, rc, prc ) {
	}

	function onRequestStart( event, rc, prc ) {
		param prc.globalData = {};

		cfhttp(
			method="POST",
			charset="utf-8",
			url="#getSystemSetting( "HCMS_URL" )#/cbapi/v1/login",
			result="local.result"
		) {
			cfhttpparam( name="username", type="formfield", value=getSystemSetting( "HCMS_USERNAME" ) );
			cfhttpparam( name="password", type="formfield", value=getSystemSetting( "HCMS_PASSWORD" ) );
		}

		if( result.status_code != 200 ) {
			throw(
				message : "Unable to login to API : #result.filecontent#",
				detail: result.errordetail,
				type: "ConnectionFailure"
			);
		}

		prc.globalData[ "presentation" ]	= getSystemSetting( "HCMS_PRESENTATION" );
		prc.globalData[ "jwt" ] 			= deserializeJSON( result.filecontent ).data.tokens.access_token;
		prc.globalData[ "apiUrl" ] 			= getSystemSetting( "HCMS_URL" );
		prc.globalData[ "imageBaseUrl" ] 	= getSystemSetting( "HCMS_URL" );
	}

	function onRequestEnd( event, rc, prc ) {
	}

	function onSessionStart( event, rc, prc ) {

	}

	function onSessionEnd( event, rc, prc ) {
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function onException( event, rc, prc ) {
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
