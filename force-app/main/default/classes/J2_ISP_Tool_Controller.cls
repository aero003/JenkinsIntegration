public class J2_ISP_Tool_Controller {
     //Public static Attachment thisID {get; set;}
     public static ContentDocumentLink thisID {get; set;}
    //public static List<dsfs__DocuSign_Status__c> lstOfAttachment {get;set;}
    public static List<dsfs__DocuSign_Status__c> lstOfAttachment {get;set;}
    
    public Map<ID, Contact> resultsMap{get;set;}
    public String JsonMap{get;set;}
    public J2_ISP_Tool_Controller(){
         Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        setAccountid();
    }
    public J2_ISP_Tool_Controller(ApexPages.StandardController controller){
         Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        setAccountid();
    }
    public string NoAccountFound {get;set;}
    public string accid {get;set;}
    public boolean DisplayNoAccount {
        get
        {
            if(DisplayNoAccount == null)
            {
                DisplayNoAccount = false;
            }
            return DisplayNoAccount;
        }
        set;
    }
    
    public PageReference setAccountid(){
        string customerid = Apexpages.currentPage().getParameters().get('customerid');
        if(customerid!=null){
             String newSearchText = 'ISP-'+customerid;
                String newSearchText2 = 'MFX-'+customerid;
                String newSearchText3 = 'MTF-'+customerid;
                String newSearchText4 = 'VCO-'+customerid;
            accid = null;
            
            List<Account> lstAcc;
            lstAcc = [select id from Account where Customer_id__c in (:newSearchText,:newSearchText2,:newSearchText3,:newSearchText4) limit 1];
            PageReference pageRef = ApexPages.currentPage();
            pageRef.getParameters().clear();
            if(lstAcc.isEmpty()){
                NoAccountFound = 'No account(s) found in Salesforce';
                DisplayNoAccount = true;
                accid = null;
                pageRef.getParameters().put('id', '');
            }
            else{
                pageRef.getParameters().put('id', lstAcc.get(0).id);
                accid = lstAcc.get(0).id;
                string id = Apexpages.currentPage().getParameters().get('id');
                system.debug(id);
                NoAccountFound = '';
                DisplayNoAccount = false;
            }
        }
        return null;
    }
    
   

    @RemoteAction
    public static String downloadLOA(String envelopId){
         dsfs__DocuSign_Status__c docusign = new dsfs__DocuSign_Status__c();
         lstOfAttachment= [SELECT id , (SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLinks) from dsfs__DocuSign_Status__c where dsfs__DocuSign_Envelope_ID__c =:envelopId];
        //thisID =[Select id  , (Select name,id,description from Attachments) from dsfs__DocuSign_Status__c where dsfs__DocuSign_Envelope_ID__c =:envelopId];
        //lstOfAttachment =[Select id  , (Select name,id,description from Attachments) from dsfs__DocuSign_Status__c where dsfs__DocuSign_Envelope_ID__c =:envelopId];
         //thisID = [Select id, name from Attachment where parentId = :envelopId];
        System.debug('fileid '+lstOfAttachment[0].id);
       //String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() +'/' + lstOfAttachment[0].id;
        String fileURL = URL.getSalesforceBaseUrl().toExternalForm();
        String id;
       // downloadAttachments(lstOfAttachment);
        for (dsfs__DocuSign_Status__c result : lstOfAttachment) {
        System.debug('>>>>>>>>>>>>'+result.ContentDocumentLinks);
            if(result.ContentDocumentLinks!=null){
                List<ContentDocumentLink> AttachmentList=result.ContentDocumentLinks;
                //fileURL += '/servlet/servlet.FileDownload?file=' + AttachmentList[0].id;
                fileURL += '/' + AttachmentList[0].ContentDocumentId;
                thisID=AttachmentList[0];
                //system.debug(URL.getFileFieldURL(AttachmentList[0].id,AttachmentList[0].body));
        }
        }
        //return fileURL;
        system.debug(fileURL);
        return fileURL;

    }
    
   
    
   
    @RemoteAction
    public static Map<String,String> getEnvelopStatus(List<String> envelopId){
         dsfs__DocuSign_Status__c docusign = new dsfs__DocuSign_Status__c();
          List<dsfs__DocuSign_Status__c> lstOfEnvelops = [Select dsfs__DocuSign_Envelope_ID__c,dsfs__Envelope_Status__c From dsfs__DocuSign_Status__c where dsfs__DocuSign_Envelope_ID__c IN :envelopId];
            system.debug('lstOfEnvelops--------'+lstOfEnvelops);
        //return fileURL;
        Map<String,String> myList = new Map<String,String>();
        for(dsfs__DocuSign_Status__c temp: lstOfEnvelops){
             myList.put(temp.dsfs__DocuSign_Envelope_ID__c, temp.dsfs__Envelope_Status__c);   
        }   
        system.debug(myList);
        return myList;

    }
}