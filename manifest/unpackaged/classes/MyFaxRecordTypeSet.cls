Public Class MyFaxRecordTypeSet {
@istest
 public static void MyFaxRecordTypeSet()
 {
   Account a = new Account (
       Name = 'Test Account',
       Status__c = 'Active',
       RecordTypeid = '012600000009V7u',
       Customer_ID__c = 'MFX-12345676');
insert a;
update a;
  }    
  }