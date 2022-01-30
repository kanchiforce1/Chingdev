/***********************************
Author: Amazon Apub //kkolla@
Visualforce Page Extended:  
Description: 
************************************/

public class agtExportCsvFuture{
    public static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public static Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Acquisition_Goals__c').getDescribe().fields.getMap();
    /** A+ tier field set **/
    public static List<Schema.FieldSetMember> getApFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.ap_gp.getFields();
    }
    
    // method used to generate the .CSV file  
    @future
    public static void formCSV(String y){
        
        String query='Select ';
        for(String sfield : fieldMap.keyset()){
            query = query+sfield+',';
        }
        query = query.removeend(',');  
        integer year1 = Integer.valueOf(y);
        
        /* Acquistion object dymanic query **/
        query = query+' FROM Acquisition_Goals__c';
        List<Acquisition_Goals__c> acqlist = Database.Query(query);
        
        title__C chstat;
        list<String> itm = new list<String>();
        list<acqPlaceHolder> acqtitleslist = new list<acqPlaceHolder>();  //Wrapper Class, will hold all the records for .CSV file
        
        set<string> acquiredStatus = new set<string>();
        for(String st: label.Acquired_Title.split(',')){
            acquiredStatus.add(st.trim());
        }

        
        //Querying all the title records from the title__c object and generating the data for the wrapper class
        for(title__C t: [SELECT id,Status__c,Sales_Tier__c,  MonthOfDPD__c,name,
                         Digital_Publication_Date__c,Internal_Imprint__c,yearOfDpd__c,Marty_Title_ID__c
                         FROM title__C WHERE Finance_Imprint_Record__c=false AND Status__c IN :acquiredStatus])
        {
            acqPlaceHolder acp = new acqPlaceHolder();
            acp.pubMonth = (t.Digital_Publication_Date__c!=null?t.Digital_Publication_Date__c.format():null);
            acp.SalesTier = t.Sales_Tier__c;
            acp.InternalImprint = t.Internal_Imprint__c; 
            acp.Titles = t;
            acqtitleslist.add(acp);
        } 
        // creating the empty Placeholder rows based on Goal Progress values  
        for(Acquisition_Goals__c ac : acqlist){ 
            integer year = integer.valueOf(ac.Year__c); 
            for(Schema.FieldSetMember f : getApFields()) {
                String apivalue = f.getFieldPath();
                integer tiermonth = tierMonth(apivalue); 
                if((decimal)ac.get(apivalue)!=null && date.today().year()<=year)
                    for(decimal i= (decimal)ac.get(apivalue); i<0 ; i++){
                        acqPlaceHolder acp = new acqPlaceHolder();
                        acp.pubMonth = tiermonth + '/'+'01'+ '/'+ year;
                        acp.SalesTier = getTier(apivalue);
                        acp.InternalImprint = ac.Internal_Imprint__c; 
                        acp.Titles = new title__c(name='[Placeholder] - ' + ac.Internal_Imprint__c,Marty_Title_ID__c='');
                        acqtitleslist.add(acp);
                    }
            }
            
        }
        
        acqlist = new List<Acquisition_Goals__c>();
        schemaMap = new Map <String, Schema.SObjectType>();
        fieldMap = new Map <String, Schema.SObjectField>();
        
        string header = 'Pub Month, Sales Tier, Internal Imprint,Title ID, Title Name \n';
        string finalstr = header;
        for(acqPlaceHolder a: acqtitleslist)
        {
            string recordString = '"'+nullcheck(a.pubMonth)+'","'+nullcheck(a.SalesTier)+ '","'+nullcheck(a.InternalImprint)+ '","'+nullcheck(a.Titles.Marty_Title_ID__c)+ '","'+ nullcheck(a.Titles.name)+'"\n';
            if(recordString!=null)
                finalstr = finalstr +recordString;
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        //System.debug('lengh'+csvBlob);
        string csvname= 'Finance Catalog Export Request.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String subject ='Finance Catalog Placeholder Export Request';
        email.setSubject(subject);
        email.setToAddresses( new list<String>{UserInfo.getUserEmail()});
        //email.setccAddresses( label.agtEmailcc.split(','));
        email.setPlainTextBody('Acquisition_Goals CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        
    }
    public static string nullcheck(String str){
        return str!=null?str:'';
    }
    
    public static String getTier(String str){
        String regExp = '[\\d]';
        String tier = str.substringBetween('ss_','__');
        String tier1 = tier.replaceAll(regExp, '');
        tier = tier1.replace('ap', 'a+');
        
        return tier.capitalize();
        
        
    }
    /*
public static string yearTwoDigits(integer year){

string Y = String.valueOf(year).right(2);  
return Y; 
} */
    //
    /*public static string monthString(decimal mon){
Map<decimal, String> frenchDates = new Map<decimal, String>();
frenchDates.put(1, 'Jan');
frenchDates.put(2, 'Feb');
frenchDates.put(3, 'Mar');
frenchDates.put(4, 'Apr');
frenchDates.put(5, 'May');
frenchDates.put(6, 'June');
frenchDates.put(7, 'July');
frenchDates.put(8, 'Aus');
frenchDates.put(9, 'Sept');
frenchDates.put(10, 'Oct');
frenchDates.put(11, 'Nov');
frenchDates.put(12, 'Dec');
return frenchDates.get(mon); 
} */
    
    
    
    
    
    
    public static integer tierMonth(String Str)
    {
        //String str = //'In_Negotiation_Titles_a10__c';
        integer tiermonth;
        Pattern p = Pattern.compile('(\\d+)');
        Matcher m = p.matcher( str );
        if( m.find() )
            tiermonth = integer.valueOf(m.group());
        return tiermonth;
    } 
    
    
    public class acqPlaceHolder{
        public String pubMonth{get;set;} 
        public String SalesTier{get;set;}
        public String InternalImprint{get;set;}
        public title__c Titles{get;set;}
        
    } 
}