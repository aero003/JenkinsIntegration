/**
 * Created by mcurry on 8/23/20.
 */

public with sharing class NF_GetUserFirstName {
    public class Input {
        // Transcript ID to be check against
        @InvocableVariable(required=false)
        public String chatKey;
    }
    public class Output {


        // User's first name, to be used in personalized greeting
        @InvocableVariable(required=false)
        public String userFirstName;


        @InvocableVariable(required=false)
        public String chatButtonApiName;

        @InvocableVariable(required=false)
        public String caseNumber;


    }

    @InvocableMethod(label='NeuraFlash - Get User from Transcript')
    public static List<Output> getUserFromTranscript(List<Input> params) {
        Input input = params[0];
        Output out = new Output();

        LiveChatTranscript[] transcripts = [
                SELECT Id, Pre_Chat_Form_First_Name__c, CaseId, LiveChatButtonId
                FROM LiveChatTranscript
                WHERE ChatKey = :input.chatKey //OR Id =: session.ebotdata__Live_Chat_Transcript__c
                LIMIT 1
        ];

        LiveChatTranscript transcript = transcripts[0];

        String firstname = transcript.Pre_Chat_Form_First_Name__c;

        if (firstname == null || String.isBlank(firstname)) {
            firstname = 'there';
        }

        Case[] cases = [SELECT Id, Origin, CaseNumber FROM Case WHERE Id = :transcript.CaseId LIMIT 1];
        Case theCase = cases[0];

        User[] users = [Select Id, Name, Email FROM User WHERE Name = 'Chatbot User'];
        User chatbotUser = users[0];

        theCase.Origin = 'Chatbot';
        theCase.OwnerId = chatbotUser.Id;
        update theCase;

        out.caseNumber = theCase.CaseNumber;

        LiveChatButton[] buttons = [SELECT Id, DeveloperName FROM LiveChatButton WHERE Id = :transcript.LiveChatButtonId LIMIT 1];

        LiveChatButton button = new LiveChatButton();
        if (buttons.size() > 0)
            button = buttons[0];
        else
            button.DeveloperName = 'Test';


        out.chatButtonApiName = button.DeveloperName + '_Agent_Check';

        out.userFirstName = firstname;

        return new List<Output>{
                out
        };

    }


}