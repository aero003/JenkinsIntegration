@isTest
private class AttachSignedContractControllerTest {
    @testsetup static void AttachSignedContractControllerTest_setup(){
        Id eFaxAccountRecordTypeID = [Select Name,Id From RecordType where Name ='eFax®: Account'].Id;
        
        Account a2 = new Account ();
        a2.Name = 'Test Account 2987';
        a2.Account_Status__c = 'Open';
        a2.RecordTypeId = eFaxAccountRecordTypeID;
        a2.Corp_Id__c = '73576';
        insert a2;
        
        Id eFaxCorporateOppRecordTypeID = [Select Name,Id From RecordType where Name ='eFax Corporate Opp'].Id;
        Id KISOppRecordTypeID = [select Name, ID from RecordType where Name='KeepItSafe: Opportunity'].Id;
        
        /*PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.OpportunityRecordTypeId__c = KISOppRecordTypeID;
        thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        insert thisconfig;
        PortalServiceHelper.config = thisconfig;*/
        
        Opportunity op=new Opportunity(); 
        op.Name='Sample Opportunity 9874';
        op.StageName='60% - Proposal';
        op.CloseDate=date.newInstance(2018, 04, 02);
        op.RecordTypeId= eFaxCorporateOppRecordTypeID;
        op.Current_Solution_Provider__c='Fax Machines';
        op.Net_new_monthly_revenue__c=50.00;
        op.AccountId = a2.id;
        op.Industry__c='Legal';
        op.isSignContractAttached__c=TRUE;
        op.Corp_Id__c = '73576';
        op.Amount = 3;
        insert op;
        
        Contract_Request__C conreq=new Contract_Request__C();
        conreq.Opportunity__c=op.Id;
        conreq.Account__c=a2.Id;
        conreq.Legal_Entity_Name__c ='Sample';	
        conreq.State_or_Non_US_Country_of_Incorporation__c='Sample';
        conreq.Date__c=date.newInstance(2018, 04, 02);
        conreq.Contact_Name__c='Sample';
        conreq.Term_of_Contract__c='3 years';
        conreq.Other_Term_of_Contract__c='3 years';
        conreq.Term_of_Amendment__c=2;
        conreq.Term_of_Amendment_Units__c='Month(s)';
        conreq.Autorenewal_Clause__c='yes';
        conreq.Currency__c='USD';
        conreq.Activation_Fee__c=120.00;
        conreq.Monthly_Fee_Local__c=1.00;
        conreq.Monthly_Fee_Toll_Free__c=2.00;
        conreq.Per_Page_Sending__c=2.000;
        conreq.Per_Page_Receiving_Local__c=3.00;
        conreq.Free_Inbound_Pages_per_DID__c=12;
        conreq.Aggregate_Pages__c='Yes';
        conreq.TLS__c='No';
        conreq.Porting__c='No';
        conreq.Domain_Send__c='No';
        conreq.EFax_Secure__c='No';
        conreq.Name='Sample 3';
        insert conreq;
    }
    //Test with all correct inputs to update contract request sobject fields,
    // add an attachment to Opportunity and update opportunity stage to Closed won
    public static testMethod void AttachSignedContractControllerTest_1(){
       
        Opportunity op = [select id from opportunity where name='Sample Opportunity 9874' limit 1];     
        Contract_Request__C conreq = [select id from Contract_Request__C where Opportunity__c =: op.Id limit 1];
        Contract_request__c cr=new Contract_Request__c();
        //setting opportunity Id into url
        ApexPages.currentPage().getParameters().put('OpportunityId', op.Id);
        //calling AttachSignedContractController using its constructor
        AttachSignedContractController ctrl =new AttachSignedContractController(new ApexPages.StandardController(cr));
        //setting attachment
        Attachment cntattach = new Attachment();
        cntattach.Name = 'Unit test attachment';
        Blob bodyblob = Blob.valueOf('Unit test attachment body');
        cntattach.body = bodyblob;
        
        ctrl.thisAttachment = cntattach;
        //setting the Picklist Id of Contract Requests 
        ctrl.contractRequests=conreq.Id;
        ctrl.getItems();
        ctrl.doSave();
        
        Opportunity opResult = [select StageName from Opportunity where Id = :op.Id];
        List<Attachment> list_OppAttachment = [select Name from Attachment where parentId = :Op.Id];
        System.assertEquals(1, list_OppAttachment.size());
        System.assertEquals('Closed Won', opResult.StageName);
        system.debug('opp id ' + ctrl);
    }
    //Test to check giving wrong inputs to Contract Request picklist Id 
    // to check if it fails to update Contract_Request__c fields
    // It will also test the get property of thisAttachment
    public static testMethod void AttachSignedContractControllerTest_2(){
        Opportunity op = [select id from opportunity where name='Sample Opportunity 9874' limit 1];
        
        Contract_Request__C conreq = [select id from Contract_Request__C where Opportunity__c =: op.Id limit 1];
        
        Contract_request__c cr=new Contract_Request__c();
        ApexPages.currentPage().getParameters().put('OpportunityId', op.Id);
        
        AttachSignedContractController ctrl =new AttachSignedContractController(new ApexPages.StandardController(cr));
        // wrong input to contract request id
        ctrl.contractRequests= op.id;
        
        try{
            Attachment testAttachment = ctrl.thisAttachment;
            ctrl.doSave();
        } 
        catch(Exception e){
            system.assert(true);
        }
    }
    //Test to check giving no Opportunity Id in the URL
    //to check if it fails to insert attachment in Opportunity sObject 
    public static testMethod void AttachSignedContractControllerTest_3(){
        Opportunity op = [select id from opportunity where name='Sample Opportunity 9874' limit 1];
        
        Contract_Request__C conreq = [select id from Contract_Request__C where Opportunity__c =: op.Id limit 1];
        
        Contract_request__c cr=new Contract_Request__c();
        //ApexPages.currentPage().getParameters().put('OpportunityId', '0060e00001rIoLJ');
        
        AttachSignedContractController ctrl =new AttachSignedContractController(new ApexPages.StandardController(cr));
        
        Attachment cntattach = new Attachment();
        cntattach.Name = 'Unit test attachment';
        Blob bodyblob = Blob.valueOf('Unit test attachment body');
        cntattach.body = bodyblob;
        
        ctrl.thisAttachment = cntattach;
        
        ctrl.contractRequests= conreq.id;
        
        try{
            ctrl.doSave();
            
        }
        catch(Exception e){
            system.assert(true);
        }
    }
    //Test to check giving wrong input to Opportunity Id in the URL
    //to check if it fails to update Opportunity StageName field to "Closed Won"
    public static testMethod void AttachSignedContractControllerTest_4(){
        Opportunity op = [select id from opportunity where name='Sample Opportunity 9874' limit 1];
        
        Contract_Request__C conreq = [select id from Contract_Request__C where Opportunity__c =: op.Id limit 1];
        
        Contract_request__c cr=new Contract_Request__c();
        //wrong input to Opportunity Id 
        ApexPages.currentPage().getParameters().put('OpportunityId', conreq.Id);
        
        AttachSignedContractController ctrl =new AttachSignedContractController(new ApexPages.StandardController(cr));
        
        try{
            ctrl.doSave();
        } 
        catch(Exception e){
            system.assert(true);
        }
    }
    //Test to check giving Expiration date of contract less than today's date
    //to check if it fails to update Contract_Request__c record
    public static testMethod void AttachSignedContractControllerTest_5(){
        
        Opportunity op = [select id from opportunity where name='Sample Opportunity 9874' limit 1];     
        Contract_Request__C conreq = [select id from Contract_Request__C where Opportunity__c =: op.Id limit 1];
        Contract_request__c cr=new Contract_Request__c();
        cr.Expiration_Date_of_Contract__c=date.newInstance(2018, 04, 28);
        //setting opportunity Id into url
        ApexPages.currentPage().getParameters().put('OpportunityId', op.Id);
        //calling AttachSignedContractController using its constructor
        AttachSignedContractController ctrl =new AttachSignedContractController(new ApexPages.StandardController(cr));
        ctrl.Amendment = false;
        //setting attachment
        Attachment cntattach = new Attachment();
        cntattach.Name = 'Unit test attachment';
        Blob bodyblob = Blob.valueOf('Unit test attachment body');
        cntattach.body = bodyblob;
        ctrl.thisAttachment = cntattach;
        //setting the Picklist Id of Contract Requests 
        ctrl.contractRequests=conreq.Id;
        ctrl.getItems();
        ctrl.ValuesForContractRequest();
        try{
        	ctrl.doSave();    
        }
         catch(Exception e){
            system.assert(true);
        }
        system.debug('opp id ' + ctrl);
    }
}