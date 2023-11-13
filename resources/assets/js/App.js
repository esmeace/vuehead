import { createApp } from "vue";
// Import the root component
import App from "./App.vue";

const app = createApp( App );
// Found in layouts/Main.cfm
app.mount( '#app' );
