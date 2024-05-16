import { createApp } from "vue";
import { createRouter, createWebHistory } from "vue-router";

// Import the route component
import Home from "./App.vue";

// Define some routes
const routes = [
    { path: '/', component: Home },
    { path: '/main/print', name: "printPreview", component: Home, props: { isPrintView: true } },
  ]

// Create the router instance and pass the `routes` option
const router = createRouter({
    // Provide the history implementation to use.
    history: createWebHistory(),
    routes, // short for `routes: routes`
})

// Create and mount the root instance.
const app = createApp( {} );
// This config is temporary and will not be needed in the future Vue minor release.
// Unwraps a ref injected property and no longer needs `.value`
app.config.unwrapInjectedRef = true;

// Make sure to _use_ the router instance to make the
// whole app router-aware.
app.use(router)

// Found in layouts/Main.cfm
app.mount( '#app' );
