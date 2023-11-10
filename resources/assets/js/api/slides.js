import Axios from "axios";

const urlRoot = `${window.globalData.apiRoot}/sites/default/contentStore`;

const defaultAPI = Axios.create( {
	baseURL : urlRoot,
	headers : { "Content-Type": "application/json", "Authorization" :  "Bearer " + window.globalData.jwt  }
} );

export const finalAPI = {
	apiInstance : defaultAPI,
	fetch 		: ( slug, params, token ) => defaultAPI.get( '/' + slug, { params : params || {} } ),
};

export default finalAPI;
