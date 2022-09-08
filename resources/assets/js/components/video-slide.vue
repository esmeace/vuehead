<template>
    <div class="video-slide">
        <div class="video-bg">
            <video autoplay muted loop id="soyvid">
                <source src="/includes/static/video/space.mp4"
                        type="video/mp4">

                Sorry, your browser doesn't support embedded videos.
            </video>
        </div>
        <div class="overlay"></div>
        <slot>
            <div v-html="content" class="position-relative"></div>
        </slot>
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
        return {};
    }
};
</script>