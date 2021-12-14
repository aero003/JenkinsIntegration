/**
 * Created by mcurry on 8/23/20.
 */

public with sharing class NF_UpdateCaseSubject {
    public class Input {
        // Transcript ID to be check against
        @InvocableVariable(required=false)
        public String chatKey;

        @InvocableVariable(required=false)
        public String issueDescription;


    }


    @InvocableMethod(label='NeuraFlash - Update Case Subject')
    public static void getUserFromTranscript(List<Input> params) {
        Input input = params[0];

        LiveChatTranscript[] transcripts = [
                SELECT Id, Pre_Chat_Form_First_Name__c, CaseId, LiveChatButtonId
                FROM LiveChatTranscript
                WHERE ChatKey = :input.chatKey //OR Id =: session.ebotdata__Live_Chat_Transcript__c
                LIMIT 1
        ];

        LiveChatTranscript transcript = transcripts[0];

        Case[] cases = [SELECT Id, Origin, Subject FROM Case WHERE Id =: transcript.CaseId LIMIT 1];
        Case theCase = cases[0];

        if (input.issueDescription.length() > 254) {
            theCase.Subject = input.issueDescription.substring(0, 254);
        } else {
            theCase.Subject = input.issueDescription;
        }

        update theCase;

    }
}