global class cases_WebServices {

    webservice static Case getCaseBrand(String caseId){
        List<Case> cases = [Select Id, Brand__c from Case where Id = :caseId limit 1];
        if ( cases.size() > 0 ){
            return cases[0];
        } else {
            return new Case();
        }
    }

    webservice static Boolean updateCase(String caseId, Case c){
        Case c2 = new Case(Id=caseId);
        c2.srv_Comments__c = c.srv_Comments__c;
        c2.srv_Email_Address__c = c.srv_Email_Address__c;
        c2.srv_Name__c = c.srv_Name__c;
        c2.srv_Q1__c = c.srv_Q1__c;
        c2.srv_Q2__c = c.srv_Q2__c;
        c2.srv_Q3__c = c.srv_Q3__c;
        c2.srv_Q4__c = c.srv_Q4__c;
        c2.srv_Q5__c = c.srv_Q5__c;
        c2.srv_Q6__c = c.srv_Q6__c;
        c2.srv_Q7__c = c.srv_Q7__c;
        c2.srv_Q8__c = c.srv_Q8__c;
        database.saveResult dsr = database.update(c2,true);
        return dsr.isSuccess();
    }

    ///<summary> Helper Method for Test Methods
    public static Case insertTestCase(){
        Case c = new Case();
        c.Subject = 'test';
        c.Status = 'New';
        c.OwnerId = userinfo.getUserId();
        insert c;
        return c;
    }
    public static Case insertTestCase1(){
        Case c = new Case();
        c.Subject = 'test';
        c.Status = 'New';
        c.OwnerId = userinfo.getUserId();
        insert c;
        Case c1 = [SELECT ID, Subject, Status, CaseNumber, OwnerId, Email_Thread_Id__c from Case Where ID= : c.ID];
        return c1;
    }

}