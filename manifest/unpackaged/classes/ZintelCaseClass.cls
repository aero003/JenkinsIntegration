public class ZintelCaseClass{
    
    public void taskCreation(list <Case> caselist){
        try{
            list <Task> tlist = new list <Task> ();
             
            for(Case c:caselist){
                
                    Task t    = new Task();
                    t.subject = 'Billing Activity';
                    t.OwnerId   = c.OwnerId;
                    t.WhatId = c.Id;
                    tlist.add(t);
                
                    Task t1    = new Task();
                    t1.subject = 'Provisioning Activity';
                    t1.OwnerId   = c.OwnerId;
                    t1.WhatId = c.Id;
                    tlist.add(t1);
               
            }
            system.debug(tlist);
            insert tlist;
        }catch(exception e){
            e.getMessage();
        }
    }
}