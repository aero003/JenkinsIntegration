/**
 * Created by mcurry on 8/24/20.
 */

public with sharing class NF_UpdateOfflineCaseOwner {
    public class Input {
        // Transcript ID to be check against
        @InvocableVariable(required=false)
        public String chatKey;

        @InvocableVariable(required=false)
        public String queueName;


    }


    @InvocableMethod(label='NeuraFlash - Update Case Owner')
    public static void updateCaseOwner(List<Input> params) {
        Input input = params[0];

        List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND DeveloperName =: input.queueName LIMIT 1];

        String theQueue = queues[0].Id;

        LiveChatTranscript[] transcripts = [
                SELECT Id, Pre_Chat_Form_First_Name__c, CaseId, LiveChatButtonId
                FROM LiveChatTranscript
                WHERE ChatKey = :input.chatKey //OR Id =: session.ebotdata__Live_Chat_Transcript__c
                LIMIT 1
        ];


        LiveChatTranscript transcript = transcripts[0];

        Case[] cases = [SELECT Id, OwnerId FROM Case WHERE Id =: transcript.CaseId LIMIT 1];
        Case theCase = cases[0];

        theCase.OwnerId = theQueue;

        update theCase;

    }
}