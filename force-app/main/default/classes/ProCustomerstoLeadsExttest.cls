@isTest
public class ProCustomerstoLeadsExttest {
    public static testMethod void ProCustomerstoLeadsExt_TEST() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('eFax®: Account').getRecordTypeId();
        acc.Name = 'Hospice place';
        acc.Brand__c='eFax';
        insert acc;
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('eFax®: Contact').getRecordTypeId();
        con.FirstName='test';
        con.LastName='one';
        con.Customer_ID__c='ISP-00001';
        con.Phone='1111444422';
        con.Email='testone@hospice.com';
        con.MailingStreet='street 1';
        con.MailingCity='CA';
        con.MailingState='CA';
        con.MailingCountry='US';
        con.DID_Number__c='1234567890';
        insert con;
        
        Contact con1 = new Contact();
        con1.AccountId=acc.Id;
        con1.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('eFax®: Contact').getRecordTypeId();
        con1.FirstName='test';
        con1.LastName='one';
        con.Customer_ID__c='ISP-00002';
        con1.Phone='1111444422';
        con1.Email='testone@hospice.com';
        con1.MailingStreet='street 1';
        con1.MailingCity='CA';
        con1.MailingState='CA';
        con1.MailingCountry='US';
        con1.DID_Number__c='1234567890';
        insert con1;
        Test.StartTest(); 

        PageReference pageRef = Page.ProsumerCustomersToLeads; // Add your VF page Name here
        Test.setCurrentPage(pageRef);
        
        ProCustomerstoLeadsExt testAccPlan = new ProCustomerstoLeadsExt();
        	
        //CheckBoxWrapper c = new CheckBoxWrapper(true,con);
        //CheckBoxWrapper c1 = new CheckBoxWrapper(true,con1);
        
        for(Contact contTest1 : [SELECT id,FirstName,LastName,Customer_ID__c,RecordTypeId,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,DID_Number__c,AccountId,Account.RecordTypeId,Account.Name,Account.Brand__c from Contact where id =:con1.id]){
            testAccPlan.contactWrappersById.put(contTest1.Id,new CheckBoxWrapper(true,contTest1 ));
        }
        
        Map<Id,CheckBoxWrapperTest> contactWrappersById1 = new Map<Id,CheckBoxWrapperTest>();
        for(Contact contTest1 : [SELECT id,FirstName,LastName,Customer_ID__c,RecordTypeId,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,DID_Number__c,AccountId,Account.RecordTypeId,Account.Name,Account.Brand__c from Contact where id =:con1.id]){
            contactWrappersById1.put(contTest1.Id,new CheckBoxWrapperTest(false,contTest1 ));
        }
        list<CheckBoxWrapperTest> wrapaccountList= new list<CheckBoxWrapperTest>();
        //list<CheckBoxWrapperTest> SelectedContactsTest = new  list<CheckBoxWrapperTest>();
        for(Contact contTest : [SELECT id,FirstName,LastName,Customer_ID__c,RecordTypeId,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,DID_Number__c,AccountId,Account.RecordTypeId,Account.Name,Account.Brand__c from Contact where id =:con1.id]){
            wrapaccountList.add(new CheckBoxWrapperTest(true,contTest ));
        }
        //for(CheckBoxWrapperTest WATest :wrapaccountList)
        //{
        //    WATest.isSelected=true;    
        //}
         testAccPlan.processSelected();
        //c.flag = true;
        //c.contObj = con;
        //Map<Id,CheckBoxWrapper> selectedContList = new Map<Id,CheckBoxWrapper>();
        
        //contactWrappersById1.put(con.Id,new CheckBoxWrapper(false,con));
        //contactWrappersById1.put(con1.Id,new CheckBoxWrapper(false,con1));
       	//List<CheckBoxWrapper> selectedContList1 = new List<CheckBoxWrapper>();
        //System.assert(testAccPlan.selectedContList.size()==3);
       	//System.assert(testAccPlan.selectedContList[0].flag==false);

        //testAccPlan.selectedContList[0].flag = true;
       
        //testAccPlan.selectedContList.add(c);
       //- testAccPlan.editMode=true;
        //-testAccPlan.searchtxt = testAccPlan.searchtxt + ',health';
        
        testAccPlan.toggleEditMode();
        testAccPlan.changeQry();
		//testAccPlan.SizeOfMap=2;
        
        
           
		//Test.StopTest();
        //Test.StartTest(); 

			//PageReference pageRef1 = Page.ProsumerCustomersToLeads; // Add your VF page Name here
			//Test.setCurrentPage(pageRef1);

			//ProCustomerstoLeadsExt testAccPlan1 = new ProCustomerstoLeadsExt();
        //testAccPlan1.editMode=false;
		//	testAccPlan1.processSelected();	
		Test.StopTest();
    }
    Public class CheckBoxWrapperTest{
        public contact cn2 {get;set;}
        public boolean isSelected {get;set;}
        public CheckBoxWrapperTest(boolean boo,contact c)
        {
            cn2=c;
            isSelected=boo;
        }
    }
    
}