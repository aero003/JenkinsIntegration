public class GetNextCaseController {
// Author:        Louis E. Wooldridge
// Description:   This class will be used by the GetNextCase Vf Page
//
// Created:        6/6/2010
// Last Updated:   6/7/2010
// Used By:        GetNextCase Visualforce Page
//
// Update History
// Date        Description

	private void debugmsg(String msgtxt) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING, msgtxt);
        ApexPages.addMessage(msg);		
	}	
    public String debug {get;set;}
    public Id QueueId {get;set;}
    
    public PageReference CheckParameter() {
    	//This procedure will be called when the Get Next Case Vf Page is displayed
    	//It will check to see if the url parameter GetNextCase is passed in with a true value
    	//If the parameter is checked it will automatically get the next case from the Queue Id
    	//that is saved on the user record and redirect the user to the next case.AccountId
    	PageReference NextPage = null;
    	String GetNextCase = ApexPages.currentPage().getParameters().get('GetNextCase');
    	
    	if (GetNextCase == 'true') {
    		User u = [Select Id, Get_Next_Active_Queue__c From User Where Id = :UserInfo.getUserId()];
    		if ((u.Get_Next_Active_Queue__c != null)&&(u.Get_Next_Active_Queue__c != '')) {
    			QueueId = u.Get_Next_Active_Queue__c; 
    			NextPage = GetNextCase();
    		}
    	}
    	return NextPage;
    }
    
    private List<Id> getParentRoleIds(Id roleId) {
    	List<Id> ret_id = new List<Id>();
    	Boolean quit = true;
    	do {
	    	List<UserRole> ids = [Select ParentRoleId From UserRole Where Id = :roleId];
	    	if (ids.isEmpty() == false) {
	    		if (ids[0].ParentRoleId != null) {
		    		ret_id.add(ids[0].ParentRoleId);
		    		roleId = ids[0].ParentRoleId;
	    			quit = false;
	    		} else {
	    			quit = true;
	    		}
	    	} else {
	    		quit = true;
	    	}
    	} while (quit == false);
    	
    	return ret_id;
    }
    
    private List<Id> getUserRoleIds(List<Id> userRoleIds) {
    	//This function will take a UserRoleId and make recursive calls
    	//to get all child UserRoleIds.
    	if (userRoleIds.isEmpty() == false) {
    		List<Id> childRoleIds = new List<Id>();
    		for (UserRole ur : [Select Id From UserRole Where ParentRoleId in :userRoleIds]) {
    			childRoleIds.add(ur.Id);
    		}
    		if (childRoleIds.isEmpty() == false) {
	    		//Recursively Call function to get child UserIds
	    		List<Id> resultIds = getUserRoleIds(childRoleIds);
	    		if (resultIds.isEmpty() == false) {
	    			userRoleIds.addAll(resultIds);
	    		}    			
    		}
    	}
    	return userRoleIds;
    }
    
    private List<Id> getVisibleQueues(){
    	//Procedure will get all the queue ids that are visible to the current user
    	List<Id> retQueueList = new List<Id>();
    	//Retrieving all the user roles for the current user
    	List<Id> userRoleIds = new Id[]{UserInfo.getUserRoleId()};
    	userRoleIds = getUserRoleIds(userRoleIds);
    	List<Id> parentRoleIds = getParentRoleIds(UserInfo.getUserRoleId());
    	List<Id> GroupIds = new List<Id>();
    	
    	if (parentRoleIds.isEmpty() == false) {
    		userRoleIds.addAll(parentRoleIds);
    	}
    	
    	//Retrieving groups based on user roles
    	for (Group g : [Select Id, Name, RelatedId, Type from Group where RelatedId in :userRoleIds]) {
    		GroupIds.add(g.Id);
    	}
    	
    	GroupIds.add(UserInfo.getUserId());
    	//Retrieving all of the visible queues for the user
		//for (GroupMember gm : [Select GroupId, Id, UserOrGroupId from GroupMember where UserOrGroupId in :GroupIds or UserOrGroupId = :UserInfo.getUserId()]) {
		for (GroupMember gm : [Select GroupId, Id, UserOrGroupId from GroupMember where UserOrGroupId in :GroupIds]) {
    		retQueueList.add(gm.GroupId);
    	}    		

    	return retQueueList;
    }
    
    public List<SelectOption> getQueues() {
        //This procedure will return a picklist values for Case Queues
        //Id CurrentQueue = [Select Get_Next_Active_Queue__c From User Where Id = :UserInfo.getUserId()].Get_Next_Active_Queue__c;
        List<Id> queues = getVisibleQueues();
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select --'));
        
        for (QueueSobject q : [Select QueueId, Queue.Name From QueueSobject Where SobjectType = 'Case' and QueueId in :queues]) {
        	options.add(new SelectOption(q.QueueId, q.Queue.Name));
        }
        return options;
    }
    
    public PageReference GetNextCancel() {
        //Cancel button on page, redirects user back to the Case tab
        PageReference tabCase = new PageReference('/500/o');
        tabCase.setRedirect(true);
        return tabCase;
    }
    
    public PageReference GetNextCase() {
        //Retrieves the next available case from the selected queue
        //and re-assigns it to the current user
        PageReference ReturnPage = null;
        
        List<Case> c = [Select Id, OwnerId From Case Where OwnerId = :QueueId And Status <> 'Closed' Order By CreatedDate Limit 1];
        
        if (c.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING, 'Another case was not retrieved from the queue, unable to assign next case.');
            ApexPages.addMessage(msg);
        } else {
        	Id UserId = UserInfo.getUserId();
            c[0].OwnerId = UserId;
            update c;
            
            //Updating the user record with the selected queue id
            User u = [Select Id, Get_Next_Queue_Name__c, Get_Next_Active_Queue__c From User Where Id = :UserId];
            if (u.Get_Next_Active_Queue__c != QueueId) {
            	u.Get_Next_Queue_Name__c = [Select Queue.Name From QueueSobject Where SobjectType = 'Case' and QueueId = :QueueId].Queue.Name;
	            u.Get_Next_Active_Queue__c = QueueId;
	            update u;
            }
     
            //redirects user to the newly assigned case
            ReturnPage = new PageReference('/' + c[0].Id);
            ReturnPage.setRedirect(true);
        }
        
        return ReturnPage;
    }   

    static testMethod void test_Methods() {
    	GetNextCaseController ctl = new GetNextCaseController();
    	
    	List<SelectOption> o = ctl.getQueues();
    	PageReference p = ctl.GetNextCancel();
    	List<Id> queues = new List<Id>();
    	for (Group g : [Select Id From Group Where Type = 'Queue']) {
    		queues.add(g.Id);
    	}
    	List<Case> c = [Select Id, OwnerId From Case Where OwnerId in :queues And Status <> 'Closed' Order By CreatedDate Limit 1];
    	ctl.QueueId = c[0].OwnerId;
    	p = ctl.GetNextCase();
    }
}