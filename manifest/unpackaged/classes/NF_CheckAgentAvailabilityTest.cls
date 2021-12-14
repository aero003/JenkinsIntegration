/**
 * Created by mcurry on 8/23/20.
 */

@IsTest
private class NF_CheckAgentAvailabilityTest {
    @IsTest
    static void CheckAgentPass() {
        List<LiveChatDeployment> deploymentList = [SELECT Id,DeveloperName FROM LiveChatDeployment];
        List<LiveChatButton> chatButtonIdList =[SELECT Id,DeveloperName FROM LiveChatButton];
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockLiveAgentResponse());
        NF_CheckAgentAvailability.Input input = new NF_CheckAgentAvailability.Input();
        input.ChatButtonApiName =chatButtonIdList[0].DeveloperName ;
        input.ChatDeploymentApiName = deploymentList[0].DeveloperName;
        List<NF_CheckAgentAvailability.Input> inputList = new List<NF_CheckAgentAvailability.Input>{ input };
        System.assert(NF_CheckAgentAvailability.checkAgentAvailability(inputList) != null);
        Test.stopTest();

    }


    public class MockLiveAgentResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"results":{"type":"array","description":"List of ids and their availability","items":{"name":"result","type":"object","properties":{"isAvailable":{"type":"boolean","description":"Whether or not the entity is available for chat","required":true,"version":29.0}}},"required":true}}');
            res.setStatusCode(200);
            return res;
        }
    }
}