<cfoutput>
<!DOCTYPE html>
<html lang="en" data-theme="itb-2022">
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<title>Welcome to Coldbox With VueJS!</title>

	<meta name="description" content="ColdBox Application Template">
    <meta name="author" content="Ortus Solutions, Corp">

	<!---Base URL --->
	<base href="#event.getHTMLBaseURL()#" />

	<!---css --->
	<link rel="stylesheet" type="text/css" href="#html.elixirPath( "css/app.css" )#" />

	<!--- If there are any extracted Vue styles, they will be in this file --->
	<cfscript>
        if ( getCache( "template" ).getOrSet( "vue-styles", function() {
            return fileExists( expandPath( html.elixirPath( "js/app.css" ) ) );
        } ) ) {
            writeOutput( '<link rel="stylesheet" type="text/css" href="#html.elixirPath( "js/app.css" )#" />' );
        }
    </cfscript>
</head>
<body data-spy="scroll">

	<!--- Vue APP --->
	<div id="app"></div>

	<!--- Global Data --->
	<script>
		window[ "globalData" ] = #toJson( prc.globalData )#;
	</script>

	<!--- Assets --->
	<script src="#html.elixirPath( "js/runtime.js" )#"></script>
    <script src="#html.elixirPath( "js/vendor.js" )#"></script>
	<script src="#html.elixirPath( "js/app.js" )#"></script>

</body>
</html>
</cfoutput>
