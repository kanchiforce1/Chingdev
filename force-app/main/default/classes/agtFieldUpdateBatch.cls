global class agtFieldUpdateBatch implements Database.Batchable<sObject>
{
    public Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Acquisition_Goals__c').getDescribe().fields.getMap();
    /** A+ tier field set **/
    public List<Schema.FieldSetMember> getApFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.Ap_tier.getFields();
    }
    /** A tier field set **/ 
    public List<Schema.FieldSetMember> getAFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.A_tier.getFields();
    }
    /** B tier field set **/ 
    public List<Schema.FieldSetMember> getBFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.B_tier.getFields();
    }
    /** C tier field set **/ 
    public List<Schema.FieldSetMember> getCFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.C_tier.getFields();
    }
    /** D tier field set **/ 
    public List<Schema.FieldSetMember> getDFields() {
        return SObjectType.Acquisition_Goals__c.FieldSets.D_tier.getFields();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {     
        
        String query='Select ';
        for(String sfield : fieldMap.keyset()){
            query = query+sfield+',';
        }
        query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe
        System.debug('query'+query);
        
        /* Acquistion object dymanic query **/
        query = query+' FROM Acquisition_Goals__c';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Acquisition_Goals__c> acqList)  
    {
        //  map<decimal,map<String,map<String,Map<decimal,list<title__C>>>>> acqre = new map<decimal,map<String,map<String,map<decimal,list<title__C>>>>>();
        
        set<Integer> years = new set<Integer>();
        set<String> InternalImprints = new set<String>();
        for(Acquisition_Goals__c ac: acqList){
            if(ac.Year__c!=null && ac.Internal_Imprint__c!=null){
                integer agYearval = Integer.valueOf(ac.Year__c);
                years.add(agYearval);
                InternalImprints.add(ac.Internal_Imprint__c);                 
                
            }}
        
        
        map<decimal,map<String,map<String,Map<decimal,map<String,integer>>>>> acqre = new map<decimal,map<String,map<String,map<decimal,map<String,integer>>>>>();
        map<String,integer> chstat;
        list<String> itm = new list<String>();
        for(title__C t: [SELECT id,Status__c,Sales_Tier__c,  MonthOfDPD__c,
                         Digital_Publication_Date__c,Internal_Imprint__c,yearOfDpd__c,Referral_Source__c
                         FROM title__C WHERE Sales_Tier__c!=null and Digital_Publication_Date__c!=null and yearOfDpd__c!=null and 
                         Internal_Imprint__c!=null and MonthOfDPD__c!=null and Status__c!=null and Referral_Source__c!='BULK-APubDE' and yearOfDpd__c =: years and Internal_Imprint__c =: InternalImprints order by yearOfDpd__c,Internal_Imprint__c,Sales_Tier__c,MonthOfDPD__c]){
                             
                             Integer year = integer.valueOf(t.yearOfDpd__c);
                             String interimprint = t.Internal_Imprint__c.trim();
                             String tier = t.Sales_Tier__c.trim();
                             Integer month = integer.valueOf(t.MonthOfDPD__c);
                             
                             
                             
                             if(acqre.containskey(year)){
                                 if(acqre.get(year).containskey(interimprint)){
                                     if(acqre.get(year).get(interimprint).containskey(tier)){
                                         if(acqre.get(year).get(interimprint).get(tier).containskey(month)){
                                             chstat = new map<String,integer>();
                                             chstat=  checkStatus(t);
                                             if(chstat!=null){
                                                 itm = new list<String>();
                                                 itm.addAll(chstat.keyset());
                                                 if(acqre.get(year).get(interimprint).get(tier).get(month).containskey(itm[0])){
                                                     acqre.get(year).get(interimprint).get(tier).get(month).put(itm[0],acqre.get(year).get(interimprint).get(tier).get(month).get(itm[0])+1);          
                                                     
                                                 }else
                                                     acqre.get(year).get(interimprint).get(tier).get(month).put(itm[0],1);
                                             } 
                                             acqre.get(year).get(interimprint).get(tier).get(month).put('',0);                 
                                             
                                         }else{
                                             chstat = new map<String,integer>();
                                             chstat=  checkStatus(t);
                                             if(chstat!=null){
                                                 itm = new list<String>();
                                                 itm.addAll(chstat.keyset());
                                                 acqre.get(year).get(interimprint).get(tier).put(month,new map<String,integer>{itm[0]=>1});           
                                             }else
                                                 acqre.get(year).get(interimprint).get(tier).put(month,new map<String,integer>());            
                                         }
                                     }else{
                                         chstat = new map<String,integer>();
                                         chstat=  checkStatus(t);
                                         if(chstat!=null){
                                             itm = new list<String>();
                                             itm.addAll(chstat.keyset());
                                             acqre.get(year).get(interimprint).put(tier, new map<decimal,map<String,integer>>{month =>new map<String,integer>{itm[0]=>1}});           
                                             //   acqre.get(year).get(interimprint).get(tier).put(month,new map<String,integer>{itm[0]=>1});           
                                         }else
                                             acqre.get(year).get(interimprint).put(tier ,new map<decimal,map<String,integer>>{month =>new map<String,integer>()});      
                                         
                                     } 
                                     
                                 }else{
                                     
                                     chstat = new map<String,integer>();
                                     chstat=  checkStatus(t);
                                     if(chstat!=null){
                                         itm = new list<String>();
                                         itm.addAll(chstat.keyset());
                                         acqre.get(year).put(interimprint,  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>{itm[0]=>1}}});           
                                         
                                     }else
                                         acqre.get(year).put(interimprint,  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>()}});           
                                     
                                     
                                 }      
                             }   else{
                                 
                                 chstat = new map<String,integer>();
                                 chstat=  checkStatus(t);
                                 if(chstat!=null){
                                     itm = new list<String>();
                                     itm.addAll(chstat.keyset());
                                     acqre.put(year , new map<String,map<String,map<decimal,map<String,integer>>>>{interimprint=>  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>{itm[0]=>1}}}});
                                     //  acqre.get(year).put(interimprint,  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>{itm[0]=>1}}});           
                                     
                                 }else
                                     acqre.put(year , new map<String,map<String,map<decimal,map<String,integer>>>>{interimprint=>  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>()}}});
                                 // acqre.put(year , new map<String,map<String,map<decimal,map<String,integer>>>>{interimprint=>  new map<String,map<decimal,map<String,integer>>>{tier => new map<decimal,map<String,integer>>{month =>new map<String,integer>{'In_Negotiation_Titles' =>0}}}});
                                 
                                 
                                 
                             }
                         }
        System.debug('debug'+acqre);
        
        list<Acquisition_Goals__c> acqUpdate = new list<Acquisition_Goals__c>();
        
        
        
        for(Acquisition_Goals__c ac: acqList){ 
            // System.debug(ac);
            
            
            for(Schema.FieldSetMember f : this.getApFields()) {
                String apivalue = f.getFieldPath();
                ac.put(apivalue,0);
            } 
            
            
            /** A tier fields update **/
            
            
            
            for(Schema.FieldSetMember f : this.getAFields()) {
                String apivalue = f.getFieldPath();
                ac.put(apivalue,0);
            } 
            
            /** B tier fields update **/
            
            
            for(Schema.FieldSetMember f : this.getBFields()) {
                String apivalue = f.getFieldPath();
                ac.put(apivalue,0);
            } 
            
            
            for(Schema.FieldSetMember f : this.getCFields()) {
                String apivalue = f.getFieldPath();
                ac.put(apivalue,0);
            } 
            
            
            
            for(Schema.FieldSetMember f : this.getDFields()) {
                String apivalue = f.getFieldPath();
                ac.put(apivalue,0);
            } 
            
            
            
            acqUpdate.add(ac);              
        }
        
        
        list<Acquisition_Goals__c> acqUpdate1 = new list<Acquisition_Goals__c>();               
        for(Acquisition_Goals__c ac: acqUpdate){ 
            // System.debug(ac);
            integer year = Integer.valueOf(ac.Year_as_Number__c);
            if(acqre.containskey(year)){
                if(acqre.get(year).containskey(ac.Internal_Imprint__c)){
                    if(acqre.get(year).get(ac.Internal_Imprint__c).containskey('A+')){
                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A+'));
                        /* A+ tier field update  getLabel(),getFieldPath() */ 
                        for(decimal ma : acqre.get(year).get(ac.Internal_Imprint__c).get('A+').keyset()){
                            
                            for(Schema.FieldSetMember f : this.getApFields()) {
                                String apivalue = f.getFieldPath();
                                if(apivalue.contains('Acquired_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Acquired_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Acquired_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Acquired_Titles'):0);
                                        //  System.debug(ac);
                                    }
                                } 
                                if(apivalue.contains('In_Negotiation_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //            System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('In_Negotiation_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('In_Negotiation_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('In_Negotiation_Titles'):0);
                                        //  System.debug(ac);
                                    }
                                } 
                                
                                if(apivalue.contains('Pre_Acquisition_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Pre_Acquisition_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Pre_Acquisition_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A+').get(ma).get('Pre_Acquisition_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                            }
                        } 
                    } 
                    /** A tier fields update **/
                    
                    if(acqre.get(year).get(ac.Internal_Imprint__c).containskey('A')){
                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A+'));
                        /* A+ tier field update  getLabel(),getFieldPath() */ 
                        for(decimal ma : acqre.get(year).get(ac.Internal_Imprint__c).get('A').keyset()){
                            
                            for(Schema.FieldSetMember f : this.getAFields()) {
                                String apivalue = f.getFieldPath();
                                if(apivalue.contains('Acquired_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Acquired_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Acquired_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Acquired_Titles'):0);
                                        
                                        // System.debug(ac);
                                    }
                                } 
                                if(apivalue.contains('In_Negotiation_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('In_Negotiation_Titles'));
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('In_Negotiation_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('In_Negotiation_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('In_Negotiation_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                                if(apivalue.contains('Pre_Acquisition_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Pre_Acquisition_Titles'));
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Pre_Acquisition_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Pre_Acquisition_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('A').get(ma).get('Pre_Acquisition_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                            }
                        } 
                    } 
                    
                    /** B tier fields update **/
                    
                    if(acqre.get(year).get(ac.Internal_Imprint__c).containskey('B')){
                        
                        /* BV tier field update  getLabel(),getFieldPath() */ 
                        for(decimal ma : acqre.get(year).get(ac.Internal_Imprint__c).get('B').keyset()){
                            
                            for(Schema.FieldSetMember f : this.getBFields()) {
                                String apivalue = f.getFieldPath();
                                if(apivalue.contains('Acquired_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Acquired_Titles'));
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Acquired_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Acquired_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Acquired_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                if(apivalue.contains('In_Negotiation_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('In_Negotiation_Titles'));
                                        //ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('In_Negotiation_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('In_Negotiation_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('In_Negotiation_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                                if(apivalue.contains('Pre_Acquisition_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Pre_Acquisition_Titles'));
                                        //ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Pre_Acquisition_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Pre_Acquisition_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('B').get(ma).get('Pre_Acquisition_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                            }
                        } 
                    } 
                    
                    if(acqre.get(year).get(ac.Internal_Imprint__c).containskey('C')){
                        
                        /* BV tier field update  getLabel(),getFieldPath() */ 
                        for(decimal ma : acqre.get(year).get(ac.Internal_Imprint__c).get('C').keyset()){
                            
                            for(Schema.FieldSetMember f : this.getCFields()) {
                                String apivalue = f.getFieldPath();
                                if(apivalue.contains('Acquired_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Acquired_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Acquired_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Acquired_Titles'):0);
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Acquired_Titles'));
                                        // System.debug(ac);
                                    }
                                } 
                                if(apivalue.contains('In_Negotiation_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('In_Negotiation_Titles'));
                                        //ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('In_Negotiation_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('In_Negotiation_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('In_Negotiation_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                                if(apivalue.contains('Pre_Acquisition_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Pre_Acquisition_Titles'));
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Pre_Acquisition_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Pre_Acquisition_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('C').get(ma).get('Pre_Acquisition_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                            }
                        } 
                    } 
                    
                    if(acqre.get(year).get(ac.Internal_Imprint__c).containskey('D')){
                        
                        /* BV tier field update  getLabel(),getFieldPath() */ 
                        for(decimal ma : acqre.get(year).get(ac.Internal_Imprint__c).get('D').keyset()){
                            
                            for(Schema.FieldSetMember f : this.getDFields()) {
                                String apivalue = f.getFieldPath();
                                if(apivalue.contains('Acquired_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        //System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Acquired_Titles'));
                                        // ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Acquired_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Acquired_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Acquired_Titles'):0);
                                        //System.debug(ac);
                                    }
                                } 
                                if(apivalue.contains('In_Negotiation_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('In_Negotiation_Titles'));
                                        //ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('In_Negotiation_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('In_Negotiation_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('In_Negotiation_Titles'):0);
                                        // System.debug(ac);
                                    }
                                } 
                                
                                if(apivalue.contains('Pre_Acquisition_Titles'))
                                {
                                    integer tiermonth = this.tierMonth(apivalue); 
                                    if(ma==tiermonth){
                                        // System.debug(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Pre_Acquisition_Titles'));
                                        //ac.put(apivalue,acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Pre_Acquisition_Titles'));
                                        ac.put(apivalue,(acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Pre_Acquisition_Titles'))!=null?acqre.get(year).get(ac.Internal_Imprint__c).get('D').get(ma).get('Pre_Acquisition_Titles'):0);
                                        //System.debug(ac);
                                    }
                                } 
                                
                            }
                        } 
                    } 
                    
                    
                    
                    
                } 
            }          
            acqUpdate1.add(ac);              
        }
        
        database.update(acqUpdate1);
    }
    public integer tierMonth(String Str)
    {
        //String str = //'In_Negotiation_Titles_a10__c';
        integer tiermonth;
        Pattern p = Pattern.compile('(\\d+)');
        Matcher m = p.matcher( str );
        if( m.find() )
            tiermonth = integer.valueOf(m.group());
        return tiermonth;
    }
    
    
    public map<String,integer> checkStatus(Title__C t){
        list<String> Acqtitile = Label.Acquired_Title.split(',');
        list<String> In_Negotiation_Title = label.In_Negotiation_Title.split(',');
        list<String> Pre_Acquistion_tiles = label.Pre_Acquistion_titles.split(',');
        map<String,integer> statuss = new map<String,integer>();// = new map<String,integer>();
        // System.debug('t'+t);
        String Status = t.Status__c.trim();
        if(Acqtitile.contains(Status))
            statuss.put('Acquired_Titles',1);
        
        if(In_Negotiation_Title.contains(Status))
            statuss.put('In_Negotiation_Titles',1);
        
        if(Pre_Acquistion_tiles.contains(Status))
            statuss.put('Pre_Acquisition_Titles',1);
        if(!statuss.keyset().isempty())
            return statuss;else
                return null;
    }            
    
    global void finish(Database.BatchableContext bc)
    {
    }
}