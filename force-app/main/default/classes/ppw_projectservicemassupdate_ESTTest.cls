@isTest
private class ppw_projectservicemassupdate_ESTTest {
    @isTest static void agtFieldUpdateBatchExcTest() {
    Title__c t = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Published');
    insert t;
    Title__c t1 = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    insert t1;
    
    List<String> pIds = new List<String>();
    Project__c p = new Project__c(title__c = t.id);
    insert p;
    pIds.add(p.id);
    Project__c p1 = new Project__c(title__c = t1.id);
    insert p1;
     pIds.add(p1.id);
     
      Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
    Insert s;                              
    Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                               First_Name__c='abc',Last_Name__c='abc');
    Insert v;
    
    Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',Active_Rate__c = true,
                            Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
    insert r;  
    Comic_Book_Service__c cb = new Comic_Book_Service__c(Project__c = p.id,rate__c = r.id);
    insert cb;
   /* Cover_Service__c cs = new Cover_Service__c(Project__c = p.id,rate__c = r.id);
    insert cs;
    Full_Color_Service__c fcs = new Full_Color_Service__c(Project__c = p.id,rate__c = r.id);
    insert fcs;
    Interior_Service__c fs = new Interior_Service__c(Project__c = p.id,rate__c = r.id);
    insert fs;
    Promotional_Text_Service__c pt = new Promotional_Text_Service__c(Project__c = p.id,rate__c = r.id);
    insert pt; */
    
    
              
    
   // Interior_Service__c cb = new Comic_Book_Service__c(Project__c = p.id);
    ppw_projectservicemassupdate_EST_Batch est = new ppw_projectservicemassupdate_EST_Batch(pIds);
    database.executeBatch(est,100);
  }
  
   @isTest static void agtFieldUpdateBatchExcTest1() {
    Title__c t = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Published');
    insert t;
    Title__c t1 = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    insert t1;
    
    List<String> pIds = new List<String>();
    Project__c p = new Project__c(title__c = t.id);
    insert p;
    pIds.add(p.id);
    Project__c p1 = new Project__c(title__c = t1.id);
    insert p1;
     pIds.add(p1.id);
     
      Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
    Insert s;                              
    Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                               First_Name__c='abc',Last_Name__c='abc');
    Insert v;
    
    Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',Active_Rate__c = true,
                            Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
    insert r;  
   
     Comic_Book_Service__c cb1 = new Comic_Book_Service__c(Project__c = p1.id,rate__c = r.id);
    insert cb1;
   /* Cover_Service__c cs1 = new Cover_Service__c(Project__c = p1.id,rate__c = r.id);
    insert cs1;
    Full_Color_Service__c fcs1 = new Full_Color_Service__c(Project__c = p1.id,rate__c = r.id);
    insert fcs1;
    Interior_Service__c fs1 = new Interior_Service__c(Project__c = p1.id,rate__c = r.id);
    insert fs1;
    Promotional_Text_Service__c pt1 = new Promotional_Text_Service__c(Project__c = p1.id,rate__c = r.id);
    insert pt1; */
    
              
    
   // Interior_Service__c cb = new Comic_Book_Service__c(Project__c = p.id);
    ppw_projectservicemassupdate_EST_Batch est = new ppw_projectservicemassupdate_EST_Batch(pIds);
    database.executeBatch(est,100);
  }
  }