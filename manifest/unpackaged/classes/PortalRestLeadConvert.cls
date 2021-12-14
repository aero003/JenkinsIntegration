@RestResource(urlMapping='/LeadConvert/*')
global with sharing class PortalRestLeadConvert {            
/*
@HttpPost
global static String doPost() {
    RestRequest req = RestContext.request;
    String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);   
    return JSON.serialize(PortalServiceHelper.ConvertLead(leadId));           
}*/
}