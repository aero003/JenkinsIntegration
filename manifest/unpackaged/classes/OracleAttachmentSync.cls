public with sharing class OracleAttachmentSync {
	public OracleAttachmentSync() {
		
	}

    public static Boolean integrateWithOracle(Attachment att, Map<Id, Case> cases) {
    	Id parentId = att.ParentId;
    	return cases.containsKey(ParentId);
    }  

    public static void sync(Map<Id, Attachment> attachments, Map<Id, Case> cases) {
        if (System.isBatch() || System.isFuture()) {
            OracleAttachmentSync.syncWithOracle(attachments.values(), cases);
        } else {
            OracleAttachmentSync.syncWithOracleFuture(new List<Id>(attachments.keySet()), cases.keySet());
        }
    }

    @future(callout=true)
    public static void syncWithOracleFuture(List<Id> attachmentIds, Set<Id> caseIds) {
        syncWithOracle(attachmentIds, caseIds);
    }

    public static void syncWithOracle(List<Id> attachmentIds, Set<Id> caseIds) {
        List<Attachment> attachments = OracleSyncDAO.getAttachments(attachmentIds);
        Map<Id, Case> cases = new Map<Id, Case>(OracleSyncDAO.getBasicCaseInfo(caseIds));
        syncWithOracle(attachments, cases);
    }

    public static void syncWithOracle(List<Attachment> attachments, Map<Id, Case> cases) {

    	List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

    	for (Attachment a : attachments) {
        	OracleAttachment oAttachment = createOracleAttachment(a);
        	String caseOracleId = String.valueOf(cases.get(a.ParentId).Oracle_Service_Cloud_ID__c);
	        HttpRequest req = null;
        	req = OracleService.createHttpRequest('/incidents/' + caseOracleId + '/fileAttachments', 'POST');
	        req.setHeader('prefer',	'exclude-null-properties');
	        req.setBody(JSON.serializePretty(oAttachment));
	        try {
	        	String response = OracleService.send(req);
	        	System.debug('response = ' + response);

	        } catch(OracleService.OracleException e) {
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', a.Id));
	        } catch(Exception e) {
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', a.Id));
	        }

    	}

    	if (!errors.isEmpty()) {
    		insert errors;
    	}

    } 

    public static void syncAttachmentOnEmailsWithOracle(List<Attachment> attachments, Map<Id, EmailMessage> messages, Map<Id, Case> cases) {

        List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

        for (Attachment a : attachments) {
            OracleAttachment oAttachment = createOracleAttachment(a);
            EmailMessage message = messages.get(a.ParentId);
            Id caseId = message.ParentId;
            String caseOracleId = cases.get(caseId).Oracle_Service_Cloud_ID__c;

            HttpRequest req = null;
            req = OracleService.createHttpRequest('/incidents/' + caseOracleId + '/fileAttachments', 'POST');
            req.setHeader('prefer', 'exclude-null-properties');
            req.setBody(JSON.serializePretty(oAttachment));
            try {
                String response = OracleService.send(req);
                System.debug('response = ' + response);

            } catch(OracleService.OracleException e) {
                errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', a.Id));
            } catch(Exception e) {
                errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', a.Id));
            }

        }

        if (!errors.isEmpty()) {
            insert errors;
        }

    }

    /*********************DOWNLOAD ***********************************/



    public static void download(Map<Id, String> caseIdsWithAttachmentIds) {
        if (System.isBatch() || System.isFuture()) {
            OracleAttachmentSync.downloadFromOracle(caseIdsWithAttachmentIds);
        } else {
            OracleAttachmentSync.downloadFromOracleFuture(caseIdsWithAttachmentIds);
        }
    }

    @future(callout=true)
    public static void downloadFromOracleFuture(Map<Id, String> caseIdsWithAttachmentIds) {
        downloadFromOracle(caseIdsWithAttachmentIds);
    }

    /*public static void downloadFromOracle(List<Id> attachmentIds, Set<Id> caseIds) {
        List<Attachment> attachments = OracleSyncDAO.getAttachments(attachmentIds);
        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Oracle_Service_Cloud_ID__c FROM Case WHERE Id IN :caseIds]);
        syncWithOracle(attachments, cases);
    }*/



    public static void downloadFromOracle(Map<Id, String> caseIdsWithAttachmentIds) {

        List<Attachment> attachments = new List<Attachment>();
        List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

        Map<Id, Case> cases = new Map<Id, Case>(OracleSyncDAO.getBasicCaseInfo(caseIdsWithAttachmentIds.keySet()));

        for (Case c : cases.values()) {

            String caseOracleId = c.Oracle_Service_Cloud_ID__c;

            List<String> oracleAttachmentIds = caseIdsWithAttachmentIds.get(c.Id).split(',');
            //= String.isEmpty(c.Oracle_Attachment_Ids__c) 
            //? new List<String>() : c.Oracle_Attachment_Ids__c.split(',');
            
            for (String oracleAttachmentId : oracleAttachmentIds) {
                HttpRequest req = null;
                req = OracleService.createHttpRequest('/incidents/' + caseOracleId + '/fileAttachments/' + oracleAttachmentId.trim(), 'GET');
                Attachment a = new Attachment(ParentId = c.Id);
                attachments.add(a);
                try {
                    String response = OracleService.send(req);
                    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response);
                    populateAttachment(a, m);

                    req = OracleService.createHttpRequest('/incidents/' + caseOracleId + '/fileAttachments/' + oracleAttachmentId.trim() + '/data', 'GET');
                    response = OracleService.send(req);
                    m = (Map<String, Object>) JSON.deserializeUntyped(response);
                    populateAttachment(a, m);

                }  catch(OracleService.OracleException e) {
                    errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', c.Id));
                } catch(Exception e) {
                    errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', a.ParentId, 'Attachment__c', c.Id));
                }
            }
        }

        if (!errors.isEmpty()) {
            insert errors;
        }

        if (!attachments.isEmpty()) {
            insert attachments;
        }
    }

    public static OracleAttachment createOracleAttachment(Attachment a) {
    	OracleAttachment oAttachment = new OracleAttachment();

    	//data
    	Blob b = a.Body;
    	String b64 = EncodingUtil.base64Encode(b);
    	//return b64;
    	oAttachment.data = b64;

    	oAttachment.fileName = a.Name;
    	oAttachment.name = a.Name;
    	oAttachment.description = a.Description == null ? a.Name : a.Description;
    	oAttachment.contentType = a.ContentType;
    	return oAttachment;
    }

    public static void populateAttachment(Attachment a, Map<String, Object> m) {
        String data = m.get('data') == null ? null : (String) m.get('data');
        System.debug('m = ' + m);
        if ( String.isNotEmpty(data)) {
            Blob b = EncodingUtil.base64Decode(data);
            a.Body = b;
        }

        String fileName = m.get('fileName') == null ? null : (String) m.get('fileName');
        if (String.isNotEmpty(fileName)) {
            a.Name = fileName;
        }

        String contentType = m.get('contentType') == null ? null : (String) m.get('contentType');
        if (String.isNotEmpty(fileName)) {
            a.ContentType = contentType;
        }

        String description = m.get('description') == null ? null : (String) m.get('description');
        if (String.isNotEmpty(fileName)) {
            a.Description = description;
        }

    }

}