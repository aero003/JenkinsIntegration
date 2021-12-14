@isTest(seeAllData=false)
public class testAttachment {
    static testMethod void testAttachments() {
        Case c=new Case();
        insert c;
        Attachment att=new Attachment();
        att.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
        att.parentId=c.id;
        insert att;
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:c.id];
    }
}