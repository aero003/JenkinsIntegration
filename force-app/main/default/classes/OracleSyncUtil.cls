public with sharing class OracleSyncUtil {


    public static Boolean isChanged(SObject oldSobject, SObject newSObject, List<String> fieldNames) {
        /*List<String> fieldNames = new List<String> {'Name', 'Alt_Phone_Number__c', 'Fax__c', 'Livevault_Product__c', 
            'OwnerId', 'ParentId', 'phone', 'Primary_Contact__c', 'RecordTypeId', 'AccountSource', 'Secondary_Partner_Contact__c',
            'Account_Status__c', 'Website'
        };*/

        for (String fieldName : fieldNames) {
            if (oldSobject.get(fieldName) != newSObject.get(fieldName)) {
                return true;
            }
        }
        return false;
    } 

    public static Oracle_Error__c createErrorLog(OracleService.OracleException e, String lookupField, String lookupId) {
    	String errorResponse = e.getMessage();
     	Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(errorResponse);
     	
     	Oracle_Error__c oracleError = new Oracle_Error__c();
     	oracleError.Title__c = m.get('title') == null ? null : (String) m.get('title');
     	oracleError.Status__c = m.get('status') == null ? null : (Integer) m.get('status');
     	oracleError.Detail__c = m.get('detail') == null ? null : (String) m.get('detail');
     	oracleError.Error_Code__c = m.get('o:errorCode') == null ? null : (String) m.get('o:errorCode');
     	oracleError.Instance__c = m.get('instance') == null ? null : (String) m.get('instance');
     	oracleError.Type__c = m.get('type') == null ? null : (String) m.get('type');
     	oracleError.put(lookupField, lookupId);

     	return oracleError;
   }	

    public static Oracle_Error__c createErrorLog(Exception e, String lookupField, String lookupId) {
    	String errorResponse = e.getMessage();
     	//Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(errorResponse);
     	
     	Oracle_Error__c oracleError = new Oracle_Error__c();
     	oracleError.Detail__c = errorResponse;
     	oracleError.put(lookupField, lookupId);

     	return oracleError;
   }

    public static Oracle_Error__c createErrorLog(OracleService.OracleException e, String lookupField, String lookupId, String fieldName, String fieldValue) {
     	
     	Oracle_Error__c oracleError = createErrorLog(e, lookupField, lookupId);
     	oracleError.put(fieldName, fieldValue);

     	return oracleError;
   }	

    public static Oracle_Error__c createErrorLog(Exception e, String lookupField, String lookupId, String fieldName, String fieldValue) {
    	String errorResponse = e.getMessage();
     	//Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(errorResponse);
     	
     	Oracle_Error__c oracleError = createErrorLog(e, lookupField, lookupId);
     	oracleError.put(fieldName, fieldValue);

     	return oracleError;
    }

    public static Map<String, Schema.RecordTypeInfo> getRecordTypesByName(String objectName) {
        Schema.DescribeSObjectResult[] d = 
            Schema.describeSObjects(new String[]{objectName});
        Map<String,Schema.RecordTypeInfo> rtMapByName = d[0].getRecordTypeInfosByName();
        return rtMapByName;
    }

    public static Schema.RecordTypeInfo getRecordTypeByName(String objectName, String rtName) {
        Map<String, Schema.RecordTypeInfo> m = getRecordTypesByName(objectName);
        return m.get(rtName);
    }

    public static Boolean isAPIUser() {
        OracleSettings__c settings = OracleService.getOracleSettings();
        return (Test.isRunningTest()) ? false : settings.Salesforce_API_User__c.equalsIgnoreCase(UserInfo.getUserName());

    }

}