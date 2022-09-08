<template>
    <div class="default-slide">
        <slot>
            <div v-html="content" ref="content" class="slide-content"></div>
        </slot>
    </div>
</template>
<script>
export default {
    inject: ['currentSlide'],
    props: {
        content: {
            type: String,
            required: true
        },
        slideIdx: {
            type: Number,
            required: true
        }
    },
    data() { 
        return {};
    },
    computed: {
        isActive() {
            console.log( this.slideIdx );
            console.log( this.currentSlide.value );
            return this.slideIdx == this.currentSlide.value;
        }
    },
    watch: {
        isActive( newVal, oldVal ){
            console.log( newVal );
            if( newVal ) this.initVisibility();
        }
    },
    mounted() {
        this.initVisibility();
    },
    methods: {
        initVisibility(){
            let aNodes = [...this.$refs.content.childNodes];
            let self = this;
            aNodes.forEach(
                function ( node ) {
                    if( node.tagName && node.tagName === "H2" ){
                        node.onclick = function() { self.showElements( aNodes) };
                    } else if( node.tagName ) {
                        node.classList.add( 'invisible' );
                        node.classList.add( 'trans-opacity' );
                    }
                }
            );
        },
        showElements( nodes ){
            nodes.forEach(
                function ( node ) {
                    if( node.classList ) node.classList.remove( 'invisible' );
                }
            );
        }
    }
};
</script>