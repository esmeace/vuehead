const elixir 	= require( "coldbox-elixir" );
const webpack 	= require( "webpack" );

elixir.config.mergeConfig({
	resolve: {
        alias: {
          vue: 'vue/dist/vue.esm-bundler.js'
		}
    },
	plugins : [
        new webpack.DefinePlugin( {
            __VUE_OPTIONS_API__ : true
        } )
    ]
});


/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your ColdBox application. By default, we are compiling the Sass
 | file for our application, as well as publishing vendor resources.
 |
 */

module.exports = elixir( function( mix ) {
	// Mix App styles
	mix.sass( "App.scss" );
	// Mix JS and VueJS components
	mix.vue( "App.js" );
		
} );
