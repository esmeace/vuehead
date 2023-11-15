import { createApp } from "vue";
// Import the root component
import App from "./App.vue";

const app = createApp( App );
// This config is temporary and will not be needed in the future Vue minor release.
// Unwraps a ref injected property and no longer needs `.value`
app.config.unwrapInjectedRef = true;
// Found in layouts/Main.cfm
app.mount( '#app' );
