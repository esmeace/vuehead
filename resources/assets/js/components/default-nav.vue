<template>
    <button @click="prev" class="carousel__prev" type="button">
      <svg class="carousel__icon" viewBox="0 0 24 24" role="img" aria-label="Arrow pointing to the left">
          <title>Arrow pointing to the left</title>
          <path d="M15.41 16.59L10.83 12l4.58-4.59L14 6l-6 6 6 6 1.41-1.41z"></path>
      </svg>
    </button>
    <button @click="next" class="carousel__next" type="button">
      <svg class="carousel__icon" viewBox="0 0 24 24" role="img" aria-label="Arrow pointing to the right">
            <title>Arrow pointing to the right</title>
            <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"></path>
        </svg>
    </button>
</template>
<script>
/**
 * Serves as the Carousel's default navigation controls.
 */
export default {
  name: "DefaultNav",
  emits: [ "next", "prev" ],
  mounted() {
    document.addEventListener( "keydown", this.keydownHandler );
  },
  beforeUnmount() {
    document.removeEventListener( "keydown", this.keydownHandler );
  },
  methods: {
    /**
		 * Emits "next"
		 */
    next(){
        this.$emit("next");
    },
    /**
		 * Emits "prev"
		 */
    prev(){
        this.$emit("prev");
    },
    /**
		 * Handles keydown
		 */
    keydownHandler( event ) {
      if (event.key == "ArrowLeft") {
        // if left arrow pressed 
        this.prev();
      } else if (event.key == "ArrowRight") {
        // if right arrow pressed 
        this.next();
      }
    }
  },
}
</script>