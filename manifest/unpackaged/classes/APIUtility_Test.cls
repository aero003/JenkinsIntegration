@isTest
public class APIUtility_Test {

private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            
        String Username = 'user12344';
        String password = 'passcode';   
            
        String jsonData;
        jsonData = JSON.serialize(
        new Map<String, String> {
            'username' => String.valueOf(Username),
            'password' => String.valueOf(password)
         });
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(jsonData);
            res.setStatusCode(200);
            return res;
        }
    }
    static testMethod void service_call() {
		String endpoint = 'http://test.sf.com';
        String httpMethod = 'POST';
        String contentType = 'Content-Type';
        String application = 'application-json';
        String Username = 'user12344';
        String password = 'passcode';
        Map<String, String> headerDetails = new Map<String, String>();
        headerDetails.put(contentType,application);
        
        String jsonData;
        jsonData = JSON.serialize(
        new Map<String, String> {
            'username' => String.valueOf(Username),
            'password' => String.valueOf(password)
         });
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();

        APIUtility.makeHTTPRequest(endpoint, httpMethod, headerDetails, jsonData);

        Test.StopTest();
    }
}