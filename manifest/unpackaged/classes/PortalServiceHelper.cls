public class PortalServiceHelper{
/*
  public static PartnerPortalSettings__c config = PartnerPortalSettings__c.getValues('PortalSettings');
    
  public static void SyncEntity(string entityType, string jsonString){
  
  if(!UserInfo.getUserId().startsWith(PortalServiceHelper.config.SalesforceAPIUserId__c))
    {
        if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
             system.debug(LoggingLevel.Error, 'Future method limit reached. Skipping...');
        } else {
          if(entityType == 'account') {
               PortalServiceHelper.AddAccount(jsonString);
          } else if (entityType == 'lead') {
               PortalServiceHelper.SyncLead(jsonString);
          } else if (entityType == 'opportunity') {
               PortalServiceHelper.SyncOpportunity(jsonString);
          } else if (entityType == 'contact') {
              PortalServiceHelper.SyncContact(jsonString);
          } else if (entityType == 'note') {
              PortalServiceHelper.SyncNote(jsonString);
          } 
       }
       
      }
  }
 
  //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void AddAccount(string accountJsonString) {
            
    PortalService portalService =  new PortalService();
    portalService.getContent('/api/salesforce/SyncAccount', accountJsonString);
   
  }

  //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void SyncOpportunity(string accountJsonString) {
            
    PortalService portalService =  new PortalService();
    portalService.getContent('/api/salesforce/SyncOpportunity', accountJsonString);
   
  }
  
    //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void SyncLead(string accountJsonString) {
            
    PortalService portalService =  new PortalService();
    portalService.getContent('/api/salesforce/SyncLead', accountJsonString);
   
  }
  
    //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void SyncContact(string accountJsonString) {
            
    PortalService portalService =  new PortalService();
    portalService.getContent('/api/salesforce/SyncContact', accountJsonString);
   
  }
  
    //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void SyncNote(string accountJsonString) {
            
    PortalService portalService =  new PortalService();
    portalService.getContent('/api/salesforce/SyncNote', accountJsonString);
   
  }

  public static Database.LeadConvertResult ConvertLead(string leadId) {
       Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setOwnerId(UserInfo.getUserId());
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);           
        Database.LeadConvertResult lcr ;
        try{
            lcr = Database.convertLead(lc);
            system.debug('*****lcr.isSuccess()'+lcr.isSuccess());            
       
        }
        catch(exception ex){
            system.debug('***NOT CONVERTED**');           
        }
        return lcr;
  }
*/
}