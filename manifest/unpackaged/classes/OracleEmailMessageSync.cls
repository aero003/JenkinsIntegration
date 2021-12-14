public with sharing class OracleEmailMessageSync {
	public OracleEmailMessageSync() {
		
	}

    public static Boolean integrateWithOracle(EmailMessage e, Map<Id, Case> cases) {
        Id parentId = e.ParentId;
        return cases.containsKey(ParentId);
    } 

    public static void sync(Map<Id, EmailMessage> messages, Map<Id, Case> cases, Boolean isUpdate) {
        if (System.isBatch() || System.isFuture()) {
            syncWithOracle(messages.values(), cases, isUpdate);
        } else {
            syncWithOracleFuture(new List<Id>(messages.keySet()), cases.keySet(), isUpdate);
        }
    }

    @future(callout=true)
    public static void syncWithOracleFuture(List<Id> messageIds, Set<Id> caseIds, Boolean isUpdate) {
        syncWithOracle(messageIds, caseIds, isUpdate);
    }

    public static void syncWithOracle(List<Id> messageIds, Set<Id> caseIds, Boolean isUpdate) {
        List<EmailMessage> messages = OracleSyncDAO.getMessages(messageIds);
        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Oracle_Service_Cloud_ID__c, Contact.Oracle_Service_Cloud_ID__c FROM Case WHERE Id IN :caseIds]);
        syncWithOracle(messages, cases, isUpdate);
    }

    public static void syncWithOracle(List<EmailMessage> messages, Map<Id, Case> cases, Boolean isUpdate) {

    	List<Oracle_Error__c> errors = new List<Oracle_Error__c>();
        Map<Id, EmailMessage> messagesWithAttachments = new Map<Id, EmailMessage>();
        Set<Id> caseIds = new Set<Id>();

    	for (EmailMessage em : messages) {

        	Case c = cases.get(em.ParentId);
        	String caseOracleId = String.valueOf(c.Oracle_Service_Cloud_ID__c);

        	OracleThread thread = createOracleThread(em, c);


	        HttpRequest req = OracleService.createHttpRequest('/incidents/' + caseOracleId + '/threads/', 'POST');
	        req.setBody(JSON.serializePretty(thread));
	        try {
	        	String response = OracleService.send(req);
	        	System.debug('response = ' + response);

                if (em.HasAttachment) {
                    messagesWithAttachments.put(em.Id, em);
                    caseIds.add(c.Id);
                }
	        } catch(OracleService.OracleException e) {
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', em.ParentId, 'Email_Message__c', em.Id));
	        } catch(Exception e) {
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', em.ParentId, 'Email_Message__c', em.Id));
	        }

    	}

    	if (!errors.isEmpty()) {
    		insert errors;
    	}

        if (! messagesWithAttachments.isEmpty()) {
            List<Attachment> attachments = OracleSyncDAO.getAttachmentsFromEmails(messagesWithAttachments);
            Map<Id, Case> m = new Map<Id, Case>([SELECT Id, Oracle_Service_Cloud_ID__c, Contact.Oracle_Service_Cloud_ID__c 
                FROM Case WHERE Id IN :caseIds]);
            OracleAttachmentSync.syncAttachmentOnEmailsWithOracle(attachments, messagesWithAttachments, m);
        }


    }

    public static OracleThread createOracleThread(EmailMessage e, Case c) {

		OracleThread thread = new OracleThread();
    	if (e.Incoming) {
    		thread = new OracleThreadInbound();
    		OracleObject.LookupById contact = new OracleObject.LookupById();
    		contact.id = Integer.valueOf(c.Contact.Oracle_Service_Cloud_ID__c);
    		thread.setContact(contact);
		}
		
		//OracleObject.LookupByName entryType = new OracleObject.LookupByName();
		//entryType.lookupName = (e.Incoming) ? 'Customer' : 'Staff Account';
        OracleObject.LookupById entryType = new OracleObject.LookupById();
        entryType.id = (e.Incoming) ? 1 : 2;    //'Customer' : 'Staff Account';
        thread.entryType = entryType; 

		OracleObject.LookupByName channel = new OracleObject.LookupByName();
		channel.lookupName = 'Email'; 
		thread.channel = channel;

        OracleObject.LookupById contentType = new OracleObject.LookupById();

        String text = String.isEmpty(e.HtmlBody) ? e.TextBody : e.HtmlBody;
        contentType.id = String.isEmpty(e.HtmlBody) ? 1 : 2;
        System.debug('text = ' + text);

        if (String.isNotEmpty(text) && text.contains('ref:_')) {
            //Integer index = text.indexOf('ref:_');
            //text = text.substring(0, index);
        }

		thread.text = text;
        thread.contentType = contentType; 

		thread.mailHeader = e.Headers;

		return thread;

    }
}