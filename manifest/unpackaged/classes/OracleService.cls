public class OracleService {

	public static String send(HttpRequest request) {
		//HttpRequest request = OracleService.createHttpRequest('https://j2global.custhelp.com/services/rest/connect/v1.3/organizations', 'POST');
		//request.setBody(s);
		Http h = new Http();
		HttpResponse response = h.send(request);

        System.debug('status = ' + response.getStatus());
        System.debug('status code = ' + response.getStatusCode());
		System.debug('body = ' + response.getBody());

        if (response.getStatusCode() >= 400) { //bad request
            throw new OracleException(response.getBody());
        }
		return response.getBody();
	}


    public static HttpRequest createHttpRequest(String requestMethod) {
        HTTPRequest req = new HTTPRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization',  getAuthorizationHeader());
        req.setMethod(requestMethod);

        return req;
    }

    public static HttpRequest createHttpRequest(String endpoint, String requestMethod) {
        HTTPRequest req = createHttpRequest(requestMethod);
        OracleSettings__c oracleSettings = getOracleSettings();
        req.setEndpoint(oracleSettings.Base_URL__c + oracleSettings.Service_URL__c + endpoint);
        return req;
    }

    public static String getAuthorizationHeader() {
        OracleSettings__c oracleSettings = getOracleSettings();
        Blob b = Blob.valueOf(oracleSettings.Username__c + ':' + oracleSettings.Password__c);
        return 'Basic ' + EncodingUtil.base64Encode(b);
    }

    public static OracleSettings__c getOracleSettings() {
        OracleSettings__c oracleSettings = OracleSettings__c.getInstance();
		return oracleSettings;    	
    }

    public class OracleException extends Exception {}
    
}