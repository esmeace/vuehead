<template>
    <div >
        <div class="slide-header">
            <img
				:src="`/includes/static/images/ortus-logo.svg`"
				alt="Ortus"
				class="corner-logo position-absolute top-0 end-0"
				style="cursor:pointer"
			/>
        </div>

        <div class="cover-astro">
            <img src="/includes/static/images/astro-head-02.svg" alt="astro-head-2" class="cover-astro-head-02"/>
            <img src="/includes/static/images/astro-head-01.svg" alt="astro-head" class="cover-astro-head"/>
            <img src="/includes/static/images/astro-body.svg" alt="astro" class="cover-astro-body"/>
        </div>

        <slot>
            <div
				v-html="content"
				@click="toggleSound()"
				class="position-relative slide-content"
			></div>
        </slot>

		<!-- Audio Loop -->
        <audio id="audio-intro" loop>
            <source src="/includes/static/audio/outer-space.mp3" type="audio/mpeg">
            Your browser does not support the audio element.
        </audio>
    </div>
</template>
<script>
export default {
    props: {
        content: {
            type: String,
            required: true
        },
        lang: {
            type: String,
            default: "en"
        },
        theme: {
            type: String,
            default: "default"
        }
    },

    data() {
        return {
            isSoundOn: false
        };
    },

    mounted() {
        this.jingle = document.getElementById( "audio-intro" );
    },

    methods: {
        playSound(){
            this.jingle.currentTime = 0;
            this.isSoundOn = true;
            this.jingle.play();
            this.jingle.volume = 0.2;
        },

        pauseSound(){
            this.isSoundOn = false;
            this.jingle.pause();
        },

        toggleSound() {
            if( this.isSoundOn ) {
                this.pauseSound();
            } else {
                this.playSound();
            }
        }
    }
};
</script>
