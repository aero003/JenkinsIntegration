@isTest(seeAllData=false)
public class testCaseComment {
	 static testMethod void testCaseComments() {
        Case c=new Case();
        insert c;
        CaseComment cc=new CaseComment();
        cc.CommentBody='Unit Test casecomment Body'; 
        cc.parentId=c.id;
        insert cc;
        List<CaseComment> CaseComment=[select id, CommentBody from CaseComment where parent.id=:c.id];
    }
}