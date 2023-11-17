<template>
    <div class="default-slide">
        <slot>
            <div v-html="content" ref="content" class="slide-content"></div>
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
        }
    },

    mounted() {
        this.initVisibility();
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
						node.style.cursor = "pointer";
                        node.onclick = () => self.showElements( aNodes );
                    } else if( node.tagName ) {
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
            nodes.forEach(  node => { if( node.classList ) node.classList.remove( 'invisible' ) } );
        }
    }
};
</script>
