<template>
    <div>
        <img src="/includes/static/images/ortus-logo.svg" alt="Ortus Logo" class="corner-logo position-absolute top-0 end-0"/>
        <img src="/includes/static/images/logo-ITB-2022.svg" alt="Into the Box 2022" class="cover-logo" @click="toggleSound()"/>
        <div class="cover-astro">
            <img src="/includes/static/images/astro-head-02.svg" alt="astro-head-2" class="cover-astro-head-02"/>
            <img src="/includes/static/images/astro-head-01.svg" alt="astro-head" class="cover-astro-head"/>
            <img src="/includes/static/images/astro-body.svg" alt="astro" class="cover-astro-body"/>
        </div>
        <slot>
            <div v-html="content" class="position-relative"></div>
        </slot>
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
        }
    },
    data() { 
        return {
            isSoundOn: false
        };
    },
    mounted() {
        this.jingle = document.getElementById("audio-intro"); 
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
