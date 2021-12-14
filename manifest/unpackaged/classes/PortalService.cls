public class PortalService {
  /*
  // Pass in the endpoint to be used using the string url
  public String getContent(String url, String postData) {

// Instantiate a new http object
    Http h = new Http();

// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(PortalServiceHelper.config.PortalServiceUrl__c + url);
    req.setMethod('POST');
    req.setBody(postData);
    req.setTimeout(PortalServiceHelper.config.PortalServiceTimeout__c.intValue());
    //req.setCompressed(true); // otherwise we hit a limit of 32000
    req.setHeader('Content-Type', 'application/json');  
    req.setHeader('user', PortalServiceHelper.config.PortalServiceUser__c);
    req.setHeader('token', PortalServiceHelper.config.PortalServiceToken__c);
    
    // Send the request, and return a response
    if(!Test.isRunningTest()) {
        system.debug('Sending item to the portal.');  
        HttpResponse res = h.send(req);
        String body = res.getBody();
        System.debug(body);
        return body;
    } else  {
        system.debug('Skipping call since we are testing.');  
        return 'success';
    }
    
  }
 */ 
}