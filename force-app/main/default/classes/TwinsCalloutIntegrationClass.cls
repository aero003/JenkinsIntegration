public class TwinsCalloutIntegrationClass{
    
    public static TwinsCalloutIntegrationClass tci = new TwinsCalloutIntegrationClass ();
    
    public String buildRequest(String reqType, Account acc,Contact con){
        String body; 
        
        /*if(reqType == 'Version'){
            body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://zintelcogent.co.nz/xmlschemas/TwinsService">';
            body += '<soapenv:Header/>';
            body += '<soapenv:Body>';
            body += ' <twin:GetSystemInfo>';
            body += ' <twin:InfoItem>Version</twin:InfoItem>';
            body += ' </twin:GetSystemInfo>';
            body += '</soapenv:Body>';
            body += '</soapenv:Envelope>';
        }*/
        
        if(reqType == 'UpdateInsertAccount'){
            body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://zintelcogent.co.nz/xmlschemas/TwinsService">';
            body += '<soapenv:Header/>';
            body += '<soapenv:Body>';
            body += '<twin:UpdatePerorg>';
            body += '<twin:RequestXml><![CDATA[';
            body += '<Perorg>';
            body += '<CrmGuid>'+acc.Id+'</CrmGuid>';
            if(acc.TWINS_ID__c == null){
                body += '<TwinsId></TwinsId>';
            }else{
                body += '<TwinsId>'+acc.TWINS_ID__c+'</TwinsId>';
            }
            
            body += '<AlternateId></AlternateId>';
            body += '<Name>'+acc.Name+'</Name>' ;
            body += '<Type>'+acc.Relationship_Type_Communications__c+'</Type>';
            body += '<AccountManager>';
            body += '<Name>'+acc.Account_Manager_Communications__r.Name+'</Name>';
            body += '</AccountManager>';
            body += '<Address>';
            body += '<Address1>'+acc.Twins_Street__c+'</Address1>';
            body += '<Address2>'+acc.Twins_Suburb__c+'</Address2>';
            body += '<Address3>'+acc.Twins_City__c+'</Address3>';
            body += '<PostCode>'+acc.Twins_Postcode__c+'</PostCode>';
            body += '<Country></Country>';
            body += '<Province></Province>';
            body += '</Address>';
            body += '<Phone>';
            body += '<Number>'+acc.Phone+'</Number>';
            body += '<Extension></Extension>';
            body += '<PhoneType>Business</PhoneType>';
            body += '</Phone>';
            body += '</Perorg>';
            body += ']]></twin:RequestXml>';
            body += '</twin:UpdatePerorg>';
            body += '</soapenv:Body>';
            body += '</soapenv:Envelope>';
            
        }
        
        if(reqType == 'InsertContact'){
            String role = con.Contact_Roles__c;
            List <String> rolelist = new List <String> ();
            if(role != null){
                 rolelist = role.split(';',3);
            }
            body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://zintelcogent.co.nz/xmlschemas/TwinsService">';
            body+= '<soapenv:Header/>';
            body+= '<soapenv:Body>';
            body+= '<twin:UpdatePerorg>';
            body+= '<twin:RequestXml><![CDATA[';
            body+= '<Perorg>';
            body+= '<CrmGuid>'+con.Id+'</CrmGuid>';
            body+= '<Honorific></Honorific>';
            body+= '<GivenName>'+con.FirstName +'</GivenName>';
            body+= '<Surname>'+con.LastName +'</Surname>';
            body+= '<EmailAddress>'+con.email+'</EmailAddress>';
            body+= '<TwinsId></TwinsId>';
            body+= '<Type>contact</Type>';
            body+= '<Roles>';
            if(!rolelist.isEmpty()){
                for(String s : rolelist){
                    if(s != null){
                        body+= '<Role>'+s+'</Role>';
                    }
                }
            }
            body+= '</Roles>';
            body+= '<Parent>';
            body+= '<TwinsId></TwinsId>';
            body+= '<CrmGuid>'+con.Account.Id+'</CrmGuid>';
            body+= '<Name>'+con.Account.Name+'</Name>';
            body+= '</Parent>';
            body+= '</Perorg>]]>';
            body+= '</twin:RequestXml>';
            body+= '</twin:UpdatePerorg>';
            body+= '</soapenv:Body>';
            body+= '</soapenv:Envelope>';
        }
        return body;
    }
    
    @future(callout = true)
    public static void updateAccountCallout(ID accId){
        Account acc = [select id,Name,TWINS_ID__c,Account_Manager_Communications__r.Name,Owner.Name,Phone,Twins_Street__c,Twins_Postcode__c,Twins_Suburb__c,Twins_City__c,Relationship_Type_Communications__c  from Account where Id =: accId];
        
        Contact c = new Contact ();
        
        String username = 'svc_twinsapi_sf';
        String password = 'HajcuHupsEl6%aj$KamIv6';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        http h = new http ();
        httpRequest req = new httpRequest ();
        
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('POST');
        req.setheader('Accept-Encoding','gzip,deflate');
        req.setheader('Content-Type','text/xml;charset=UTF-8');
        req.setheader('SOAPAction','http://zintelcogent.co.nz/xmlschemas/TwinsService/ITwinsService/UpdatePerorg');
        req.setheader('Host','twinsapi.zintel.co.nz');
        req.setheader('Connection','Keep-Alive');
        //req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        if(!Test.isRunningTest()){
            req.setEndpoint(TwinsCalloutIntegrationClass.getEndpoint());
        }else{
            req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        }
        
        req.setBody (tci.buildRequest('UpdateInsertAccount',acc, c));
        req.setTimeout(120000);
        //req.setClientCertificate(clientcert,'password'); 
        if(!Test.isRunningTest()){
            system.debug('Request --->' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response --->' + res.getBody());
            DOM.Document doc = new DOM.Document();    
            doc.load(res.getbody());  
            acc.TWINS_ID__c = tci.parseResponse(doc.getRootElement());
        }
        
        update acc;
    }
    
    @future(callout = true)
    public static void createUpdateAccountCallout(ID accId){
        Account acc = [select id,Name,TWINS_ID__c,Account_Manager_Communications__r.Name,Owner.Name,Phone,Twins_Street__c,Twins_Postcode__c,Twins_Suburb__c,Twins_City__c,Relationship_Type_Communications__c  from Account where Id =: accId];
        Contact c = new Contact ();
        
        String username = 'svc_twinsapi_sf';
        String password = 'HajcuHupsEl6%aj$KamIv6';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        http h = new http ();
        httpRequest req = new httpRequest ();
        
        req.setHeader('Authorization', authorizationHeader);
        
        req.setMethod('POST');
        req.setheader('Accept-Encoding','gzip,deflate');
        req.setheader('Content-Type','text/xml;charset=UTF-8');
        req.setheader('SOAPAction','http://zintelcogent.co.nz/xmlschemas/TwinsService/ITwinsService/UpdatePerorg');
        req.setheader('Host','twinsapi.zintel.co.nz');
        req.setheader('Connection','Keep-Alive');
        //req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        //req.setEndpoint('http://twinsapi.zintel.co.nz/TwinsService.svc');
        if(!Test.isRunningTest()){
            req.setEndpoint(TwinsCalloutIntegrationClass.getEndpoint());
        }else{
            req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        }
        
        req.setBody (tci.buildRequest('UpdateInsertAccount',acc, c));
        req.setTimeout(120000);
        //req.setClientCertificate(clientcert,'password'); 
        if(!Test.isRunningTest()){
            system.debug('Request --->' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response --->' + res.getBody());
            DOM.Document doc = new DOM.Document();    
            doc.load(res.getbody());  
            acc.TWINS_ID__c = tci.parseResponse(doc.getRootElement());
            
        }
        
        List <Contact> conlist = [select id,FirstName,LastName,Contact_Roles__c,Email,Account.Id, Account.Name from Contact where AccountId =: accId and TWINS_ID__c = null];
        List <Contact> upCon = new List <Contact> ();
        for(Contact con : conlist){
            if(!Test.isRunningTest()){
                req.setBody (tci.buildRequest('InsertContact',acc, con));
                system.debug('Request --->' + req.getBody());
                HttpResponse res = h.send(req);
                system.debug('Response --->' + res.getBody());
                DOM.Document doc = new DOM.Document();    
                doc.load(res.getbody());  
                con.TWINS_ID__c = tci.parseResponse(doc.getRootElement());
                upCon.add(con);
            }
        }
        
        update acc;
        update upCon;
    }
    
    @future(callout = true)
    public static void createContactCallout(Id conId){
        Contact con = [select id,FirstName,LastName,Email,Account.Id, Account.Name,Contact_Roles__c from Contact where id =: conId];
        Account acc = new Account();
        list <Contact> uplist  = new  list <Contact> ();
        //TwinsCalloutIntegrationClass tci = new TwinsCalloutIntegrationClass ();
        String username = 'svc_twinsapi_sf';
        String password = 'HajcuHupsEl6%aj$KamIv6';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        http h = new http ();
        httpRequest req = new httpRequest ();
        
        req.setHeader('Authorization', authorizationHeader);
        
        req.setMethod('POST');
        req.setheader('Accept-Encoding','gzip,deflate');
        req.setheader('Content-Type','text/xml;charset=UTF-8');
        req.setheader('SOAPAction','http://zintelcogent.co.nz/xmlschemas/TwinsService/ITwinsService/UpdatePerorg');
        req.setheader('Host','twinsapi.zintel.co.nz');
        req.setheader('Connection','Keep-Alive');
        //req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        //req.setEndpoint('http://twinsapi.zintel.co.nz/TwinsService.svc');
        if(!Test.isRunningTest()){
            req.setEndpoint(TwinsCalloutIntegrationClass.getEndpoint());
        }else{
            req.setEndpoint('https://twinsapi.zintel.co.nz:8443');
        }
        
        req.setBody (tci.buildRequest('InsertContact',acc, con));
        req.setTimeout(120000);
        if(!Test.isRunningTest()){
            system.debug('Request --->' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response --->' + res.getBody());
            DOM.Document doc = new DOM.Document();    
            doc.load(res.getbody());  
            con.TWINS_ID__c = tci.parseResponse(doc.getRootElement());
            uplist.add(con);
        }
        
        update uplist;
    }
    
    public String parseResponse(Dom.XmlNode node){
        String result ;
        
        for(Dom.Xmlnode child : node.getChildElements()){
            if(child.getNodeType() == Dom.Xmlnodetype.Element){
                for(Dom.Xmlnode gchild:child.getChildElements()){
                    if(gchild.getName() == 'UpdatePerorgResponse'){
                        for(Dom.Xmlnode ggchild: gchild.getChildElements()){
                            String responseXML = ggchild.getText();
                            system.debug('responseXML --->' + responseXML);
                            Dom.Document doc = new Dom.Document();
                            doc.load(responseXML);
                            Dom.Xmlnode rootNode = doc.getRootElement(); 
                            for(Dom.Xmlnode innerchild : rootNode.getChildElements()){
                                if(innerchild.getNodeType() == Dom.Xmlnodetype.Element){
                                    for(Dom.Xmlnode innergchild:innerchild.getChildElements()){
                                        system.debug('Innerchild --->' + innergchild.getName());
                                        if(innergchild.getName() == 'TwinsId'){
                                            result = innergchild.getText();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result;
    }
    
    public static String getEndpoint(){
        Map <String,TwinsEndpoint__c> endpoint = TwinsEndpoint__c.getAll();
        String s = endpoint.get('Twins'). Endpoint__c ;
        return s;
    }
}