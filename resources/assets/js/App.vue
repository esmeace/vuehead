<template>
    <div v-if = "!slides.length">
        Loading...
    </div>

    <carousel :items-to-show = "1" ref = "preso" v-else>
        <slide
              v-for = "( slide, slideIdx ) in slides"
            :key    = "slide.contentID"
            :style  = "getSlideStyles( slide )"
        >
            <component
                :is       = "getComponent( slide )"
                :content  = "slide.renderedContent"
                :class    = "getContentClass( slide.slug )"
                :lang     = "lang"
                :slideIdx = "slideIdx"
                :theme    = "theme"
            ></component>
        </slide>

        <template #addons>
			<navigation />
			<pagination />
        </template>
    </carousel>

</template>

<script>
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel';
import slidesApi                                   from "./api/slides";
import Cover                                       from "./components/cover";
import VideoSlide                                  from "./components/video-slide";
import DefaultSlide                                from "./components/default-slide";
import SequenceSlide                               from "./components/sequence-slide";

export default {
    name      : 'App',
    components: {
        Carousel,
        Slide,
        Pagination,
        Navigation,
        Cover,
        VideoSlide,
        DefaultSlide,
        SequenceSlide
    },
    data() {
        return {
            slides: [],
            lang  : "en",
            theme : "itb-2022"
        }
    },

    computed: {
        globalData() { return window.globalData; },
        baseUrl() { return this.globalData.imageBaseUrl; },
        slidesSlug() { return this.lang === 'en' ? this.globalData.presentation : this.globalData.presentation + '-sp' }
    },

    mounted() {
        this.fetchSlides();
    },

    methods: {

        fetchSlides() {
            slidesApi.fetch(
					this.slidesSlug,
					{ "includes" : "children.renderedContent,children.customFields" }
				)
				.then( ( result ) => {
                    this.slides = this.correctMediaURL( result.data.data.children.sort( ( a, b ) => a.order - b.order ) );
                    this.setInitialSlide();
				} )
				.catch( ( e ) => {
					alert( "Error getting slides" + e );
					console.error( e );
				} );
        },

		/**
		 * This is done so that in the CMS the content can have relative images and
		 * the UI then re-links them back to the API
		 * @param {*} slides
		 */
        correctMediaURL( slides ) {
            return slides.map( slide => {
               slide.renderedContent = slide.renderedContent.replaceAll( `src="/__media/`, `src="${this.baseUrl}/__media/` );
			   return slide;
            } );
        },

        getSlugEnd( slug ) {
            let a = slug.split( "/" );
            return a[ a.length - 1 ];
        },

        getContentClass( slug ) {
            return "cb-" + this.getSlugEnd( slug );
        },

        getSlideStyles( slide ){
            let styles  = { "backgroundColor" : "#000048" }
            let bgImage = this.getValuefromFields( slide.customFields, "bgImage" );
            if( bgImage ) {
                styles.backgroundImage    = "url(" + this.baseUrl + "/" + bgImage + ")";
                styles.backgroundSize     = "cover";
                styles.backgroundPosition = "center";
                styles.backgroundRepeat   = "no-repeat";
            }
            return styles;
        },

        getComponent( slide ){
            let type = this.getValuefromFields( slide.customFields, "type" );
            switch( type ) {
                case 'cover':
                    return "Cover";
                case 'video':
                    return "VideoSlide";
                case 'sequence':
                    return "SequenceSlide";
                default:
                    return "DefaultSlide";
            }
        },

        getValuefromFields( customFields, key ){
            let fieldIdx = customFields.map( field => field.key ).indexOf( key );
            if( fieldIdx > -1 ){
                return customFields[ fieldIdx ].value !== " " ?  customFields[ fieldIdx ].value: null;
            } else {
                return null
            }
        },

        setInitialSlide(){
            let self = this;
            if( window.location.hash ) {
              console.log( 'here' );
              let idx = this.slides
			  	.map( slide => "#"+self.getSlugEnd( slide.slug ) )
			  	.indexOf( window.location.hash );
              if( idx > -1 ){
                console.log( this.$refs.preso );
                console.log( idx );
                this.$nextTick( function(){
                    this.$refs.preso.slideTo( idx );
                } );
              }
            }
        }
    }
};
</script>
