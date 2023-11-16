<template>
    <div v-if = "!slides.length">
        Loading...
    </div>

    <carousel 
        v-else :items-to-show = "1" 
        ref="preso"
        @slide-start="onSlideStart"
    >
        <template #slides>
            <slide
                v-for = "( slide, slideIndex ) in slides"
                :key    = "slide.contentID"
                :style  = "getSlideStyles( slide )"
            >
                <component
                    :is       = "getComponent( slide )"
                    :content  = "slide.renderedContent"
                    :class    = "getContentClass( slide.slug )"
                    :lang     = "lang"
                    :slideIndex = "slideIndex"
                    :theme    = "theme"
                ></component>
            </slide>
        </template>
        <template #addons="{ slidesCount }">
            <default-navigation 
                v-if="slidesCount > 1" 
                @next="onNext"
                @prev="onPrev"
            />
			<pagination v-if="slidesCount > 1" />
        </template>
    </carousel>

</template>

<script>
import { Carousel, Slide, Pagination }  from 'vue3-carousel';
import slidesApi                        from "./api/slides";
import { settings }                     from "./settings/presentation.js";
import DefaultNavigation                from "./components/default-nav";
import Cover                            from "./components/cover";
import VideoSlide                       from "./components/video-slide";
import DefaultSlide                     from "./components/default-slide";
import SequenceSlide                    from "./components/sequence-slide";

export default {
    name      : 'App',
    components: {
        Carousel,
        Slide,
        Pagination,
        DefaultNavigation,
        Cover,
        VideoSlide,
        DefaultSlide,
        SequenceSlide
    },

    data() {
        return {
            slides: [],
            lang  : "en",
            slideBackgroundColor : "#000048"
        }
    },

    computed: {
        globalData() { return window.globalData; },
        baseUrl() { return this.globalData.imageBaseUrl; },
        slidesSlug() { return this.lang === 'en' ? this.globalData.presentation : this.globalData.presentation + '-sp' },
        theme() {
            return settings[ this.globalData.presentation ] ? settings[ this.globalData.presentation ].theme : "default";
        }
    },
    created() {
        // sets the theme (data-theme on root)
        document.documentElement.dataset.theme = this.theme;
    },
    mounted() {
        this.fetchSlides();
    },
    methods: {
		/**
		 * Get the slides from the CMS
		 */
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
		 *
		 * @param {*} slides The slides to correct
		 */
        correctMediaURL( slides ) {
            return slides.map( slide => {
               slide.renderedContent = slide.renderedContent.replaceAll( `src="/__media/`, `src="${this.baseUrl}/__media/` );
			   return slide;
            } );
        },

		/**
		 * Get the last part of the slug (the part after the last /)
		 *
		 * @param {string} slug The name of the slide
		 */
        getSlugEnd( slug ) {
            let parts = slug.split( "/" );
            return parts[ parts.length - 1 ];
        },

		/**
		 * The content class is used to style the content of the slide
		 * It is based on the name of the slide in the CMS
		 *
		 * @param {string} slug The slug of the slide
		 */
        getContentClass( slug ) {
            return "cb-" + this.getSlugEnd( slug );
        },

		/**
		 * Get the styles for the slide
		 *
		 * @param {object} slide The CMS slide content object
		 */
        getSlideStyles( slide ){
            let styles  = { "backgroundColor" : this.slideBackgroundColor }
            let bgImage = this.getValuefromFields( slide.customFields, "bgImage" );
            if( bgImage ) {
                styles.backgroundImage    = "url(" + this.baseUrl + "/" + bgImage + ")";
                styles.backgroundSize     = "cover";
                styles.backgroundPosition = "center";
                styles.backgroundRepeat   = "no-repeat";
            }
			return styles;
        },

		/**
		 * Get the component to use for the slide based on the type custom field
		 *
		 * @param {*} slide The CMS slide content object
		 */
        getComponent( slide ){
            switch( this.getValuefromFields( slide.customFields, "type" ) ) {
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

		/**
		 * Get a value from the custom field. If not found, return null
		 *
		 * @param {*} customFields The custom fields array
		 * @param {*} key The key to look for
		 * @param {*} defaultValue The default value to return if not found
		 */
        getValuefromFields( customFields, key, defaultValue = null ){
            let fieldIdx = customFields.map( field => field.key ).indexOf( key );
            if( fieldIdx > -1 ){
                return customFields[ fieldIdx ].value.trim().length > 0 ?  customFields[ fieldIdx ].value : defaultValue;
            }
            return defaultValue;
        },
        /**
		 * Moves to next slide
		 */
        onNext() {
            this.$refs.preso.next();
        },
        /**
		 * Moves to previous slide
		 */
        onPrev() {
            this.$refs.preso.prev();
        },
        /**
		 * Handles on slide start
		 */
        onSlideStart( data ) {
            // sets the url hash
            window.location.hash = `#${this.getSlugEnd( this.slides[ data.slidingToIndex ].slug )}`;
        },
		/**
		 * Set the initial slide based on the location hash
		 */
        setInitialSlide(){
            let self = this;
            if( window.location.hash ) {
            	let index = this.slides
			  		.map( slide => "#" + self.getSlugEnd( slide.slug ) )
			  		.indexOf( window.location.hash );
              	if( index > -1 ){
					this.$nextTick( () => this.$refs.preso.slideTo( index ) );
              	}
            }
        }
    }
};
</script>
