@isTest
public class BCBSLeadRecordsManualSharingTest {
    // Test for the manualShareRead method
    
    static testMethod void testManualShareRead(){
        List<User> user_list = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'sttes', Email='standarduser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardusertesudece1@live.com');
        
        user_list.add(u1);
        User u2 = new User(Alias = 'sttes', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardusertesudece2@live.com');
        user_list.add(u2);
        insert user_list;
        // Select users for the test.
        List<User> users = [SELECT Id FROM User WHERE UserName='standardusertesudece2@live.com' OR UserName='standardusertesudece1@live.com'];
        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;
        
        // Create new job.
        Lead j = new Lead();
        j.Company = 'Test Company';
        j.LeadSource = 'Email';
        j.Country = 'MA';
        j.City = 'Boston';
        j.Country_Code__c = 'MA';
        j.LastName = 'test Last Name';
        j.Email = 'testlastname@lastname.com';
        j.Phone='32547158';
        j.OwnerId = user1Id;
        insert j;    
        
        Map<Id, Id> recordId_OwnerId = new Map<Id, Id>();
        recordId_OwnerId.put(j.Id, user2Id);
        // Insert manual share for user who is not record owner.
        System.assertEquals(BCBSLeadRecordsManualSharing.manualShareRead(recordId_OwnerId), true);
        
        // Query job sharing records.
        List<LeadShare> jShrs = [SELECT Id, UserOrGroupId, LeadAccessLevel, 
                                 RowCause FROM LeadShare WHERE LeadId = :j.Id AND UserOrGroupId= :user2Id];
        
        // Test for only one manual share on job.
        System.assertEquals(jShrs.size(), 1, 'Set the object\'s sharing model to Private.');
        
        // Test attributes of manual share.
        System.assertEquals(jShrs[0].LeadAccessLevel, 'Read');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);
        
        // Test invalid job Id.
        delete j;   
        
        // Insert manual share for deleted job id. 
        System.assertEquals(BCBSLeadRecordsManualSharing.manualShareRead(recordId_OwnerId), false);
    }  
}