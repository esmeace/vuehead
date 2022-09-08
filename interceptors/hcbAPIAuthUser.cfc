component{
    // property name="securityService" inject="securityService@WEATSecurity";
    // property name="authService" inject="AuthenticationService@cbauth";

    /**
    * If a Basic authentication header exists, attempts to log the user in.
    * If the credentials are invalid, logs any currently logged in user out.
    **/
    void function onRequestCapture( event, rc, prc, interceptData, buffer ) {
        
        // prc[ "securityService" ] = variables.securityService;
        
        //processes the authorized user data in to the request context
        // if( variables.securityService.isSessionAuthenticated() ){

            // reset cookie timeout
            // if( reFind(  '^(?!.*(system-notifications|stats|logout|check))', '/' & lcase( event.getCurrentRoute() ) ) ){
            
                // securityService.updateLoginExpiryTime();

                // set cookie to expire if found
                // if( len( getInstance( "CookieStorage@cbstorages" ).get( "hcbAPIAuthUser", "" ) ) ){
                //     getInstance( "CookieStorage@cbstorages" ).set(
                //         name="hcbAPIAuthUser",
                //         value=variables.securityService.getPersistedUserId(),
                //         expires = dateAdd( 'n', 20, now() ),
                //         secure=true
                //     );
                // }
            // }
            
        // }
    }

    /**
    * Processes any current authorized user in to the request context
    * If they aren't found in the database, then we logout and let cbSecurity pick up the relocation 
    **/
    void function preProcess( event, interceptData, buffer, rc, prc ){
        if( variables.authService.check() ){   
            prc[ "authUser" ] = variables.securityService.getAuthorizedUser();
        }
    }

    function postLogin( event, interceptData ){
        var prc = event.getPrivateCollection();

        param prc.authenticationMethod = "form";
        param prc.loginIdentifier = queryExecute(
            "SELECT TOP 1 password from userPasswords WHERE FK_user = :userId",
            {
                "userId" : interceptData.user.getId()
            }
        ).password;
        variables.securityService.setUserLogin( interceptData.user, prc.authenticationMethod, prc.loginIdentifier ).setAuthorizedUser( interceptData.user );

    }
    
}

