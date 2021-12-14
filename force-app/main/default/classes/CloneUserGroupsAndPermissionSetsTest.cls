//test clone user groups and permission sets 
//test whenever a user is inserted and Cloned_From__c field is having some value then trigger should execute
// and clone old user's groups and permission sets into new user
@isTest
private class CloneUserGroupsAndPermissionSetsTest {
    public static testMethod void testCloneUser_1() {
        // Setup test data
        // This code runs as the system user
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sttes', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardusertesudece@live.com');
        insert u;
        //create group
        Group grp = new Group();
        grp.Name = 'Technology Partner Content';
        insert grp;
        //add group member
        GroupMember gm = new GroupMember();
        gm.userorGroupId = u.Id;
        gm.GroupId=grp.Id;
        insert gm;
        
        //create permission set
        //
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Sample_Permission_Set';
        ps.Label = 'Sample';
        insert ps;
        
        PermissionSetAssignment psm = new PermissionSetAssignment();
        psm.AssigneeId=u.id;
        psm.PermissionSetId = ps.Id;
        insert psm;
        List<User> user_List = new List<User>();
        User u1 = new User(Alias = 'sUser', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='tures11standardturesllc@live.com',
                           Cloned_from__c=u.Id);
        user_List.add(u1);
        User u2 = new User(Alias = 'ssUser', Email='sstandarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='taylorv12sstandard@live.com',
                           Cloned_from__c=u.Id);
        user_List.add(u2);
        insert user_List;
        //check for assigned permission sets
        List<PermissionSetAssignment> PermissionAssignment1 = [SELECT PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE 
                                                               AssigneeId =: u.Id];
        List<PermissionSetAssignment> PermissionAssignment2 = [SELECT PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE 
                                                               AssigneeId =: u1.Id];
        List<PermissionSetAssignment> PermissionAssignment3 = [SELECT PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE 
                                                               AssigneeId = :u2.Id];
        
        System.assertEquals(PermissionAssignment2.size(), PermissionAssignment1.size());
        System.assertEquals(PermissionAssignment3.size(), PermissionAssignment1.size());
        
        //check for assigned group member
        List<GroupMember> ListGroupMember1 = [select GroupId,userorGroupId  from GroupMember where userorGroupId =:u.Id];
        List<GroupMember> ListGroupMember2 = [select GroupId,userorGroupId  from GroupMember where userorGroupId = :u1.Id];
        List<GroupMember> ListGroupMember3 = [select GroupId,userorGroupId  from GroupMember where userorGroupId = :u2.Id];
        
        System.assertEquals(ListGroupMember2.size(), ListGroupMember1.size());
        System.assertEquals(ListGroupMember3.size(), ListGroupMember1.size());
    }
}