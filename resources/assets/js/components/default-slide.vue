<template>
    <div class="default-slide">
        <template v-if="options.bgVideo && !isPreview">
            <div class="video-bg">
                <video autoplay muted loop id="soyvid">
                    <source :src="options.bgVideo"
                            type="video/mp4">

                    Sorry, your browser doesn't support embedded videos.
                </video>
            </div>
            <div class="overlay"></div>
        </template>
        <slot>
            <div 
                v-html="content" 
                ref="content" 
                class="slide-content"
            ></div>
        </slot>
    </div>
</template>

<script>
export default {
    name: "DefaultSlide",
	inject: [ 'currentSlide' ], // From the Vue3-carousel, injects property that is the current slide index.

    props: {
        content: {
            type: String,
            required: true
        },
        isPreview: {
            type: Boolean,
            default: false
        },
        options: {
            type: Object,
            default: function() {
                return {};
            }
        },
        slideIndex: {
            type: Number,
            required: true
        }
    },

    data() {
        return {};
    },

    computed: {
		// flags if the slide is active
        isActive() {
            return this.slideIndex == this.currentSlide;
        }
    },

    watch: {
		isActive( newVal, oldVal ){
            // initiates the visibility of the elements when the slide becomes active
            if( newVal ) this.initVisibility();
            if( !newVal && oldVal ) {
                this.reset();
            }
        }
    },

    mounted() {
        if ( !this.isPreview ) this.initVisibility();
    },

    methods: {
        /**
		 * Initiates the visibility of the element in the content
		 */
        initVisibility(){
            let aNodes = [ ...this.$refs.content.childNodes ];
            let self = this;
            aNodes.forEach(
                function ( node ) {
                    if( node.tagName && node.tagName === "H2" ){
                        node.classList.add( "js-stage-title" );
                        node.classList.add( "js-stage-title-center" );
                        node.tabIndex = 0;
						node.onclick = () => {
                            node.classList.remove( "js-stage-title-center" );
                            node.classList.add( "js-stage-title-top" );
                            node.removeAttribute( "tabIndex" );
                            self.showElements( aNodes )
                        };
                    } else if ( node.classList && node.classList.contains("animation")) {
                        // TODO: Implement better way to add animations
                        node.style.display = "none";
                    }
                    else if( node.tagName ) {
                        node.classList.add( 'invisible' );
                        node.classList.add( 'trans-opacity' );
                    }
                }
            );
        },
        /**
		 * Shows the hidden elements
		 */
        showElements( nodes ){
            nodes.forEach(  node => { 
                if( node.classList ) node.classList.remove( 'invisible' );
                if ( node.classList && node.classList.contains("animation")) {
                    node.style.display = "block";
                }
            } );
        },
        /**
		 * Resets the H2 position
		 */
        reset() {
            let aNodes = [ ...this.$refs.content.childNodes ];
            let self = this;
            aNodes.forEach(
                function ( node ) {
                    if( node.tagName && node.tagName === "H2" ){
                        node.classList.remove(  "js-stage-title-top" );
                    } 
                }
            );
        }
    }
};
</script>
