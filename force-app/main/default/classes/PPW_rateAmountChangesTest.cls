@isTest
private class PPW_rateAmountChangesTest {
    
    @isTest static void rateAmountChanges()
    {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Test');
        insert t;
        
       project__c p;
         try {
         p =  [select id from project__c limit 1];//new project__c(title__C = t.id);
         } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p; 
         }
        
        Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        r.Minimum_Fee__c=20000;
        insert r;
        update r; // rate trigger code coverage 
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id);
        Insert ps;
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        ps.Rate__c=r1.id;
        update ps;
    } 
    @isTest static void rateAmountChanges1()
    {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Test');
        insert t;
        
        project__c p;
         try {
         p =  [select id from project__c limit 1];//new project__c(title__C = t.id);
         } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p; 
         }
        Service__c s = new Service__c(Name='Copy Editing',
                                      Service_Rate_Type__c='Copy Editing - standard');
        Insert s; 
        Service__c s1 = new Service__c(Name='Copy Editing',
                                       Service_Rate_Type__c='Copy Editing - standard');
        Insert s1;                              
        Vendor__c v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='EUR',Rate_Multiplier__c='Flat Fee',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r; 
        Rate__c r1 = new Rate__c(Rate_Currency__c='EUR',Rate_Multiplier__c='Flat Fee',
                                 Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r1;                       
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id);
        insert ps;
        
        ps = [select id, Rate__c,  Service__c,  Vendor__c from Project_Services__c where id=:ps.id limit 1];                   
        ps.Service__c=s1.id;                         
        update ps; 
        
    }
}