@isTest
private class agtFieldUpdateBatchTest {
    @isTest static void agtFieldUpdateBatchExcTest() {
    
    Acquisition_Goals__c act = new Acquisition_Goals__c(Year__c=String.valueOf(date.today().Year()),Internal_Imprint__c='47North',Business_Goal_Ap1__c=12,Business_Goal_Ap2__c=34);
    insert act;
    
    list<Title__c> tilist = new list<Title__c>();
    
    Title__c til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(1),name='Test1',Sales_Tier__c='A',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(7),name='Test2',Sales_Tier__c='B',Status__c='Production');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(6),name='Test3',Sales_Tier__c='B',Status__c='In Negotiation');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(5),name='Test4',Sales_Tier__c='C',Status__c='Pre-Acquistion tiles');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test5',Sales_Tier__c='D',Status__c='Art in Progress');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(2),name='Test6',Sales_Tier__c='A+',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test7',Sales_Tier__c='A+',Status__c='In Negotiation');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(3),name='Test8',Sales_Tier__c='A+',Status__c='');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test9',Sales_Tier__c='A+',Status__c='Pre-Acquistion tiles');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(4),name='Test',Sales_Tier__c='A+',Status__c='Pre-Acquistion tiles');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(4),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='Pre-Acquistion tiles');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today().addMonths(5),name='Test',Sales_Tier__c='A+',Status__c='Contracted');
    tilist.add(til);
    til = new Title__c(Internal_Imprint__c='47North',Digital_Publication_Date__c=date.today(),name='Test',Sales_Tier__c='A+',Status__c='In Negotiation');
    tilist.add(til);
    insert tilist;
    database.executebatch(new agtFieldUpdateBatch(),200);
    
    
    }
    }