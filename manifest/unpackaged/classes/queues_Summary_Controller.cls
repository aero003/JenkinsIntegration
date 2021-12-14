public class queues_Summary_Controller {

    public String allCaseCount {get;set;}
    public String myCaseCount {get;set;}

    public queues_Summary_Controller(){
        Id userId = userinfo.getUserId();
        Set<Id> queueIds = new Set<id>();
        try
        {
            for ( GroupMember gm : [Select UserOrGroupId, Group.Type, Group.RelatedId, Group.Name, GroupId From GroupMember where Group.Type = 'Queue' and UserOrGroupId = :userId])
            {
                queueIds.add(gm.GroupId);
            }            
            queueIds.add(userId);
            Integer my = [Select Count() from Case where OwnerId = :userId and IsClosed != TRUE limit 10000];
            Integer myQueues = [Select Count() from Case where OwnerId in :queueIds and IsClosed != TRUE limit 10000];
            myCaseCount = string.valueOf(my);
            allCaseCount = string.valueof(myQueues);
        }
        catch(exception e)
        {
            myCaseCount = '0';
            allCaseCount = '0';
        }           
    }
}