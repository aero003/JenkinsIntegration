@isTest
public class OracleHttpCalloutMock implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
    String sobj;

    public OracleHttpCalloutMock(String sobj) {
        this.sobj = sobj;
    }

    public OracleHttpCalloutMock(Integer code, String status, String body, Map<String, String> responseHeaders, String sobj) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
        this.sobj = sobj;
    }

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        if (sobj.equalsIgnoreCase('Account')) {
            res.setBody('{"id" : 1234}');
        } else if (sobj.equalsIgnoreCase('Account Error')) {
            res.setBody('{"id" : "4444"}');
        } else if (sobj.equalsIgnoreCase('Contact')) {
            res.setBody('{"id" : 5555}');
        } else if (sobj.equalsIgnoreCase('Case')) {
            res.setBody('{"id" : 6666}');
        } else if (sobj.equalsIgnoreCase('Attachment')) {
            res.setBody('{"id" : 7777}');
        } else if (sobj.equalsIgnoreCase('Attachment Download')) {
            res.setBody('{"data" : "XYZ", "fileName" : "X Files", "contentType" : "text/html", "description" : "X Desc"}');
        } else if (sobj.equalsIgnoreCase('Email')) {
            res.setBody('{"id" : 8888}');
        }
        
        res.setStatusCode(200);

        if (sobj.equalsIgnoreCase('Error')) {
            res.setBody('{"title" : "Error", "status" : 111}');
            res.setStatusCode(400);
        } 
        //res.setStatus(this.status);
        return res;
    }

}