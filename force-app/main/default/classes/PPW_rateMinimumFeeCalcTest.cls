@isTest
private class PPW_rateMinimumFeeCalcTest {

 @isTest static void rateMinimumFeeCalc()
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
                          
    insert r; // rate trigger code coverage
    
   r.Minimum_Fee__c=20000;
    update r;
     
    }
    }