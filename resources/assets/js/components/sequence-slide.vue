<!--
	TODO: What is this for?
 -->
<template>
    <div class = "sequence-slide">
        <slot>
            <div v-html = "content" class = "position-relative" ref = "content"></div>
        </slot>
    </div>
</template>
<script>
export default {
    props: {
        content: {
            type    : String,
            required: true
        }
    },

    data() {
        return {};
    },

    mounted() {
        let seqs = [ ...this.$refs.content.getElementsByClassName( "sequence" ) ];
        for( var i in seqs ){
            this.initSequence( seqs[ i ] );
        }
    },

    methods: {

        initSequence( seq ) {
            var self        = this;
            let aNodes      = [ ...seq.childNodes ]
            let firstNode   = null;
            let hiddenNodes = [];
            //console.log( aNodes );
            aNodes.forEach(
                function ( node ) {
                    if( node.tagName && !firstNode ){
                        firstNode = node;
                    } else if( node.tagName ){
                        node.classList.add( 'invisible' );
                        node.classList.add( 'trans-opacity' );
                        hiddenNodes.push( node );
                    }
                }
            );
            firstNode.onclick = function() { self.showElement( hiddenNodes[ 0 ] ) };
            for( let i = 0; i < hiddenNodes.length-1; i++  ){
                hiddenNodes[ i ].onclick = function() { self.showElement( hiddenNodes[ i + 1 ]) };
            }

        },

        showElement( node ){
            if( node.classList ){
				node.classList.remove( 'invisible' );
			}
        }
    }
};
</script>
