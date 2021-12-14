/**
 * Created by mcurry on 8/23/20.
 */

public with sharing class NF_CheckAgentAvailability {
    public class Input{
        @InvocableVariable(required=true)
        public String chatButtonApiName;
        @InvocableVariable(required=true)
        public String chatDeploymentApiName;
    }
    public class Output{
        @InvocableVariable(required=true)
        public boolean isAgentAvailability;
    }
    @InvocableMethod(label='Einstein Bot - Check Agent Availability')
    public static List<Output> checkAgentAvailability(List<Input> params){
        Output output = new Output();
        output.isAgentAvailability = false;
        try{
            System.debug('>> EinsteinBotCheckAgentAvailability.getButtonAvailability: chatButtonApiName='+params[0].chatButtonApiName);
            System.debug('>> EinsteinBotCheckAgentAvailability.getButtonAvailability: chatDeploymentApiName='+params[0].chatDeploymentApiName);
            output.isAgentAvailability = getButtonAvailability(params[0].chatButtonApiName,params[0].chatDeploymentApiName);

        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
        return new List<Output>{output};
    }

    @AuraEnabled
    public static boolean getButtonAvailability(String chatBotTransferButton, String chatbotDeployment){
        Boolean isAvailable = false;
        List<LiveChatButton> chatButtonIdList = [SELECT Id FROM LiveChatButton WHERE DeveloperName = :chatBotTransferButton LIMIT 1];

        List<LiveChatDeployment> deploymentList = [SELECT Id FROM LiveChatDeployment WHERE DeveloperName = :chatbotDeployment LIMIT 1];
        String chatBotTransferButtonId = chatButtonIdList[0].Id;
        chatBotTransferButtonId = chatBotTransferButtonId.substring(0,15);
        String chatbotDeploymentId = deploymentList[0].Id;
        chatbotDeploymentId = chatbotDeploymentId.substring(0,15);
        String botOrgId = UserInfo.getOrganizationId().substring(0, 15);

        String sPath = 'callout:EinsteinBotLiveAgentAvailability/chat/rest/Visitor/Availability?Availability.ids=['+chatBotTransferButtonId+']&deployment_id='+chatbotDeploymentId+'&org_id='+botOrgId;
        System.debug('>> EinsteinBotCheckAgentAvailability.getButtonAvailability: sPath='+sPath);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(sPath);
        request.setMethod('GET');
        request.setHeader('X-LIVEAGENT-API-VERSION', '47');

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('EinsteinBotCheckAgentAvailability.getButtonAvailability: response='+response.getBody());

        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'isAvailable')) {
                    // Get the value.
                    parser.nextToken();
                    isAvailable = parser.getBooleanValue() != null ? parser.getBooleanValue() : false;
                }
            }
        }
        return isAvailable;
    }
}