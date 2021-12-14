/**
 * Created by mcurry on 8/27/20.
 */

@IsTest
private class NF_UpdateCaseSubjectTest {
    @IsTest
    static void testBehavior() {
        String casId = insertCase();

        String visitorId = insertChatVisitor();

        insertTranscript(casId, visitorId);

        NF_UpdateCaseSubject.Input inp = new NF_UpdateCaseSubject.Input();
        inp.chatKey = 'abc';
        inp.issueDescription = 'updated';
        NF_UpdateCaseSubject.getUserFromTranscript(new List<NF_UpdateCaseSubject.Input>{inp});



    }

    private static String insertCase(){
        Case newCase = new Case();

        newCase.Subject = 'test';

        insert newCase;

        return newCase.Id;

    }

    private static void insertTranscript(String caseId, String visId){
        LiveChatTranscript lt = new LiveChatTranscript();
        lt.ChatKey = 'abc';
        lt.Pre_Chat_Form_First_Name__c = 'Dave';
        lt.LiveChatVisitorId = visId;
        lt.CaseId = caseId;

        insert lt;
    }

    private static String insertChatVisitor(){
        LiveChatVisitor cv = new LiveChatVisitor();
        insert cv;
        return cv.Id;
    }
}