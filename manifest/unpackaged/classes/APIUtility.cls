public class APIUtility {

    public static HttpResponse makeHTTPRequest(String endpoint, String httpMethod, Map<String,String> headerDetails, String requestBody){
        
        Http http = new Http();
		HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
		request.setMethod(httpMethod);
        request.setTimeout(120000);
        if(!headerDetails.isEmpty()){
            for(String header : headerDetails.keySet()){
            	request.setHeader(header, headerDetails.get(header));
        	}
        }
        
        request.setBody(requestBody);
        System.debug('response '+request);
        HttpResponse response = http.send(request);
       	System.debug('response '+response);
		return response;
    }
}