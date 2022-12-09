<template>
    <div v-if="!slides.length">
        Loading...
    </div>
    <carousel :items-to-show="1" ref="preso" v-else>
        <slide 
            v-for="( slide, slideIdx ) in slides" 
            :key="slide.contentID" 
            :style="getSlideStyles( slide )"
        >
            <component
                :is="getComponent( slide )" 
                :content="slide.renderedContent" 
                :class="getContentClass( slide.slug )"
                :lang="lang"
                :slideIdx="slideIdx"
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
import slidesApi from "./api/slides";
import Cover from "./components/cover";
import VideoSlide from "./components/video-slide";
import DefaultSlide from "./components/default-slide";
import SequenceSlide from "./components/sequence-slide";

export default {
    name: 'App',
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
            lang: "es"
        }
    },
    computed: {
        globalData() { return window.globalData; },
        baseUrl() { return "http://127.0.0.1:61670/" },
        slidesSlug() { return this.lang === 'en' ? 'headlesscb-slides' : 'headlesscb-slides-sp' }
    },
    mounted() {
        console.log( window.location.hash );
        this.fetchSlides();
    },
    methods: {
        fetchSlides() {
            slidesApi.fetch( this.slidesSlug, { "includes" : "children.renderedContent,children.customFields" } )
				.then( ( result ) => {
                    this.slides = result.data.data.children.sort((a, b) => a.order - b.order) ;
                    this.setInitialSlide();
				} )
				.catch( ( e ) => {
					console.error( e );
				} );
        },
        getSlugEnd( slug ) {
            var a =  slug.split( "/" );
            return a[ a.length - 1 ];
        },
        getContentClass( slug ) {
            return "cb-" + this.getSlugEnd( slug );
        },
        getSlideStyles( slide ){
            var styles = { "backgroundColor" : "#000048" }
            var bgImage = this.getValuefromFields( slide.customFields, "bgImage" );
            if( bgImage ) {
                styles.backgroundImage = "url(" + this.baseUrl + bgImage + ")";
                styles.backgroundSize = "cover";
                styles.backgroundPosition = "center";
                styles.backgroundRepeat = "no-repeat";
            }
            return styles;
        },
        getComponent( slide ){
            var type = this.getValuefromFields( slide.customFields, "type" );
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
            var fieldIdx = customFields.map( field => field.key ).indexOf( key );
            if( fieldIdx > -1 ){
                return customFields[ fieldIdx ].value !== " " ?  customFields[ fieldIdx ].value : null; 
            } else {
                return null
            }
        },
        setInitialSlide(){
            var self = this;
            if( window.location.hash ) {
              console.log( 'here' );
              var idx = this.slides.map( slide => "#"+self.getSlugEnd( slide.slug ) ).indexOf( window.location.hash );
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