<template>
    <div class="default-slide">
        <slot>
            <div v-html="content" ref="content" class="slide-content"></div>
        </slot>
    </div>
</template>

<script>
export default {
	// TODO: What is this?
    inject: [ 'currentSlide' ],

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
		// TODO: What is this for?
        isActive() {
            // console.log( this.slideIndex );
            // console.log( this.currentSlide.value );
            return this.slideIndex == this.currentSlide.value;
        }
    },

    watch: {
		// TODO: What is this for?
        isActive( newVal, oldVal ){
            //console.log( newVal );
            if( newVal ) this.initVisibility();
        }
    },

    mounted() {
        this.initVisibility();
    },

    methods: {
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

        showElements( nodes ){
            nodes.forEach(  node => { if( node.classList ) node.classList.remove( 'invisible' ) } );
        }
    }
};
</script>
