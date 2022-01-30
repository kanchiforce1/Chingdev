/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Project controller for rate calculations
Description: Handler form for rate calculation
***********************************/

public class ppw_handlerforCalculation{
    
   // public static map<String,rate__C> rates = new map<String,rate__C>();
    public static Map<String,String> mboProgram {get {
         if(mboProgram == null) {
         mboProgram = new Map<String,String>();
         for(rate__c r1 : [Select id,Service__c,Vendor__c,Rate_Currency__c,Minimum_Fee__c,Vendor__r.MBO_Program__c,
                                  Rate_Amount__c,Rate_Multiplier__c from rate__c where Active_rate__c = true])
                mboProgram.put(r1.Vendor__c,r1.Vendor__r.MBO_Program__c); 
             return mboProgram;
            
        } else
            return mboProgram;
            
    } set;} 
    
   
    public static map<String,rate__C> rates {get {
        
            if(rates == null) {
              rates = new map<String,rate__C>();
                /***  here we are querying all the rates  **/
                for(rate__c r1 : [Select id,Service__c,Vendor__c,Rate_Currency__c,Minimum_Fee__c,Vendor__r.MBO_Program__c,
                                  Rate_Amount__c,Rate_Multiplier__c from rate__c where Active_rate__c = true])
               // mboProgram.put(r1.Vendor__c,r1.Vendor__r.MBO_Program__c); 
                if(r1.Service__c!=null&&r1.Vendor__c!=null)
                    rates.put(r1.id,r1);
          
           return rates;
       } else
           return rates;
    } set;}
    
    public static Map<String,list<ASIN__c>> titlesmap = new map<String,list<ASIN__c>>();
    
    public static set<String> flatFeevendors = new set<String>();
    
    public static List<Manuscripts__mdt> mdlist = new LIst<Manuscripts__mdt>();
    public Decimal mboFeeValue =0; 
    
    public List<Project_Services__c> ratecalc(List<Project_Services__c> ps1){
          // get all rate records
        flatFeevendors.addall(Label.PPW_Sliding_scale_Vendor.split(';')); // flat fee vendor names from label
        /** fetch custom metadata for sliding scale flat fee vendor rate calculation data  **/
        mdlist = [select id,label,Rate_Amount__c,Rate_Multiplier__c,Rate_Note_Amount_Greater_Than__c,
                  Rate_Note_Amount_Less_Than__c,Service_Rate_Type__c,Vendor_Name__c from Manuscripts__mdt];
        
        
        set<id> conIds = new set<id>();
        set<Id> titleIds = new set<id>();
        
        
        list<Project_Services__c> pslistUpdate = new list<Project_Services__c>();
        list<Project_Services__c> pslist = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c	,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps1];
        for(Project_Services__c ps: pslist ) // ASIN query
            if(ps.Project__r.Title__c!=null)
            titleIds.add(ps.Project__r.Title__c);
        
        for(ASIN__c t: [select Name,Country_Of_Origin__c,Initial_Page_Count__c,Title__c from ASIN__c where title__c =: titleIds])
            if(titlesmap.containskey(t.title__c))
            titlesmap.get(t.title__c).add(t);
        else
            titlesmap.put(t.title__c,new list<ASIN__C>{t});
        
        for(Project_Services__c ps: pslist ){
            if(rates.containsKey(ps.rate__c))
                ps.Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + rateCalculation(rates.get(ps.rate__c),ps);
            pslistUpdate.add(ps);
        }
        return pslistUpdate;
    }
        
    public static String getCurrency(String rateCurrency) {
        switch on rateCurrency {
            when 'USD' {
                return '$';
            }
            when 'EUR' {
                return '€';
            }
            when 'GBP' {
                return '£';
            }
            when 'JPY' {
                return '¥';
                
            }
            when else {
                return '';
                
            }
            
        }
        
    }
    
    public static Decimal updateMBOValue(Project_Services__c ps) {
         
        
        if(mboProgram.containsKey(ps.Vendor__c) && ps.Vendor__c != null && ps.Amount__c != null && ps.Amount__c != 0) {
            if(mboProgram.get(ps.Vendor__c) == 'US Vendor Services')
                return ((ps.Amount__c.setScale(2)/0.9505)-ps.Amount__c).setScale(2);
            else {    
                if(mboProgram.get(ps.Vendor__c) == 'US Business Services')
                    return ((ps.Amount__c.setScale(2)/0.9405)-ps.Amount__c).setScale(2);
                else {
                    if(mboProgram.get(ps.Vendor__c) == 'UK MBO Vendor Services')
                        return ((ps.Amount__c.setScale(2) * 1.039*1.0175*1.006)-ps.Amount__c).setScale(2);
                    else
                        return 0;
                    
                    
                }          
                
            }
        } else
            return 0;
    }
   
    /*
    public void userInputRateAmount(List<Project_Services__c> ps1) {
         
        list<Project_Services__c> pslistUpdate = new list<Project_Services__c>();
        list<Project_Services__c> pslist = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c	,Service__r.Name,
                                            Word_Count_Cancelled__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,
                                            Word_Count_Completed__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,
                                            Word_Count_Killed__c,Service_Type_Complexity__c,MBO_Fee__c ,Status__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c
                                            from Project_Services__c where id=:ps1];
        for(Project_Services__c ps: pslist ) {
            
            if(rates.containsKey(ps.rate__c)) {
                ps.Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.User_Input_Rate_Amount__c.divide(1, 2) + ' ('+ps.Rate__r.Rate_Multiplier__c+')';
                ps.Amount__c = ps.User_Input_Rate_Amount__c.divide(1, 2);
                ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps);
                ps.Total_Rate_Amount__c  =  getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' +ps.Total_Rate_Amount_with_MBO_Fee__c  +' ('+ps.Rate__r.Rate_Multiplier__c+')';
                ps.MBO_Fee__c  = updateMBOValue(ps);
            }  
            
            pslistUpdate.add(ps);  
        }
        update pslistUpdate;  
    } 
    */
        
    /**  Sliding scale Rate Calculation**/
    public static String slidingRateCalc(rate__c r,Project_Services__c ps){
         
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        String str='0';
        decimal rate = 0; 
        for(Manuscripts__mdt md :mdlist)
            if(md.Vendor_Name__c == ps.Vendor__r.name && 
               ps.Project__r.Title__r.Pre_Dev_Edit_Word_Count__c	 > md.Rate_Note_Amount_Greater_Than__c &&
               ps.Project__r.Title__r.Pre_Dev_Edit_Word_Count__c	 <= md.Rate_Note_Amount_Less_Than__c &&
               ps.Service_Type_Complexity__c.equalsIgnoreCase(md.Service_Rate_Type__c) &&
               ps.Service__r.Name.equalsIgnoreCase(md.Label) && 
               ps.Rate__r.Rate_Multiplier__c.equalsIgnoreCase(md.Rate_Multiplier__c)){
                   
                   rate = (md.Rate_Amount__c) ;
                   ps.Base_Amount__c = (rate).divide(1, 2);
                   
                   str = (rate + (rate * rushFee)/100).divide(1, 2) +' ('+ps.Rate__r.Rate_Multiplier__c+')';
                   ps.Amount__c = (rate + (rate * rushFee)/100).divide(1, 2);
                   ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
                   ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps); 
                   ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + ' ('+ps.Rate__r.Rate_Multiplier__c+')'; 
                   ps.MBO_Fee__c = updateMBOValue(ps); 
               }
        
        
        return str;
    }
    
    /** minimum Fee**/
    public static string minimumfee(String str,Project_Services__c ps){
         
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        decimal minfee = (ps.Rate__r.Minimum_Fee__c!=null?ps.Rate__r.Minimum_Fee__c:0);
        str = (minfee+ (minfee * rushFee)/100).divide(1, 2)+' (Minimum Fee)';
        ps.Amount__c = (minfee+ (minfee * rushFee)/100).divide(1, 2);
        ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
        ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps); 
        ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + ' (Minimum Fee)'; 
        ps.MBO_Fee__c = updateMBOValue(ps); 
        ps.Base_Amount__c = (minfee).divide(1, 2);
        return str;
    }
    
    /** flat fee calculation **/
    public static String rateFlatFeeCalc(String str,Project_Services__c ps) {
          
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        decimal minfee = (ps.Rate__r.Minimum_Fee__c!=null?ps.Rate__r.Minimum_Fee__c:0);
        ps.Amount__c = 0;
        decimal rate= ps.Rate__r.Rate_Amount__c;
        ps.Amount__c = ps.Rate__r.Rate_Amount__c;
        if(ps.Amount__c<=minfee && minfee!=0){  // minimum fee calculation
            str=minimumfee(str,ps);
        }else{
            ps.Base_Amount__c = (rate).divide(1, 2);
            rate = (rate + (rate * rushFee)/100).divide(1, 2);
            ps.Amount__c = rate;
            str = rate +' (Flat Fee)';
        }
        ps.Amount__c = ps.Amount__c != null? ps.Amount__c : 0; 
        ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
        ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps); 
        ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + ' (Flat Fee)'; 
        ps.MBO_Fee__c = updateMBOValue(ps); 
        
        return str;
    }
    
    /** Custom Quote calculation **/
    public static String rateCustomQuoteCalc(String str,Project_Services__c ps) {
        decimal rate = ps.Rate__c != null ? ps.Rate__r.Rate_Amount__c != null ? ps.Rate__r.Rate_Amount__c : 0.000 : 0.000; 
        decimal minfee = (ps.Rate__r.Minimum_Fee__c!=null?ps.Rate__r.Minimum_Fee__c:0);
        system.debug('---CQR---'+ps.Custom_Quote_Amount__c);
        rate = rate + (ps.Custom_Quote_Amount__c!=null? ps.Custom_Quote_Amount__c : 0.000);
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        if(ps.Amount__c<=minfee && minfee!=0){  // minimum fee calculation
            str=minimumfee(str,ps);
        }else{
            ps.Base_Amount__c = (rate).divide(1, 2);
            rate = (rate + (rate * rushFee)/100).divide(1, 2);
            ps.Amount__c = rate;
            str = rate +' (Custom Quote)';
        }
        ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
        ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps);
        ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + ' (Custom Quote)'; 
        ps.MBO_Fee__c = updateMBOValue(ps); 
        
        return str;
    }
    
    /** rate calculation values  **/ 
    public static String rateCalculation(rate__c r,Project_Services__c ps) {
         
        String str='0';
        String confirmYes;
        String confirmNo;
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        decimal minfee = (ps.Rate__r.Minimum_Fee__c!=null?ps.Rate__r.Minimum_Fee__c:0);
        if(flatFeevendors.contains(ps.Vendor__r.name))
            return slidingRateCalc(r,ps);
        
        
        if(ps.Rate__r.Rate_Multiplier__c == 'Flat Fee'){
            return rateFlatFeeCalc(str,ps);
        }
        
        if(ps.Rate__r.Rate_Multiplier__c == 'Custom Quote'){
            return rateCustomQuoteCalc(str,ps);
        }
        
        
        if(ps.Rate__r.Rate_Multiplier__c == 'Per Page') {
            decimal inPageCount=0;
            boolean paperBack=false;
            if(ps.Project__r.Title__c!=null){
                Map<string,decimal> titleNamesMAp = new Map<String,decimal>();
                if(titlesmap.containskey(ps.Project__r.Title__c)) {
                    for(ASIN__c a: titlesmap.get(ps.Project__r.Title__c))
                        if(a.Initial_page_count__c!=null && a.Initial_Page_Count__c !=0)
                        titleNamesMap.put(a.Name,a.Initial_Page_Count__c);
                    if(!titleNamesMap.isEmpty()){
                        if(titleNamesMap.containsKey('Paperback')){
                            inPageCount = titleNamesMap.get('Paperback');
                        }
                        else{
                            if(titleNamesMap.containsKey('Hardcover')){
                                inPageCount = titleNamesMap.get('Hardcover');
                            }
                        }
                    }
                }
                
            }   
          
            decimal rate = (ps.Rate__r.Rate_Amount__c * (inPageCount!=null? inPageCount: 0));
            if(rate!=0)    
                str = (rate + (rate * rushFee)/100).divide(1, 2) +' ('+String.valueOf((rate)/(inPageCount))+'/Per Page)';
            
            if(rate<=minfee && minfee!=0) // minimum fee calculation
                str= minimumfee(str,ps);
            else{
                ps.Base_Amount__c = (rate).divide(1, 2);
                ps.Amount__c = (rate +(rate * rushFee)/100).divide(1, 2); 
            }
            ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
            ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps); 
            if(rate!=0) 
                ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c +' ('+String.valueOf((rate)/(inPageCount))+'/Per Page)'; 
                ps.MBO_Fee__c = updateMBOValue(ps); 
            return str;
        }
        
        if(ps.Rate__r.Rate_Multiplier__c == 'Per Word') {
            decimal devValue = getPredevValue(ps);
            decimal predev = devValue != null? devValue : 0; 
            ps.Amount__c = 0;
            decimal rate = (ps.Rate__r.Rate_Amount__c * ( ps.Service__r.Name=='Developmental Edit' || ps.Service__r.Name=='Copyediting' || ps.Service__r.Name=='Proofreading' || ps.Service__r.Name=='Coldreading'?predev : (ps.Additional_Rate_Input__c!=null ? ps.Additional_Rate_Input__c:0) ));
            if(rate!=0) 
                str = (rate+ (rate * rushFee)/100).divide(1, 2) +' ('+String.valueOf(rate/( ps.Service__r.Name=='Developmental Edit' || ps.Service__r.Name=='Copyediting' || ps.Service__r.Name=='Proofreading' ||
                                                                                           ps.Service__r.Name=='Coldreading'?predev :ps.Additional_Rate_Input__c != null? ps.Additional_Rate_Input__c : 0))+'/Per Word)';
                
            System.debug(rate);
            if(rate<=minfee && minfee!=0)  // minimum fee calculation
                str = minimumfee(str,ps);
            else{
                ps.Base_Amount__c = (rate).divide(1, 2);
                ps.Amount__c = (rate +(rate * rushFee)/100).divide(1, 2);
            }
            System.debug(str); 
            ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
            ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps); 
            if(rate!=0) 
                ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) +''+ ps.Total_Rate_Amount_with_MBO_Fee__c +' ('+String.valueOf(rate/( ps.Service__r.Name=='Developmental Edit' || 
                                                                                                          ps.Service__r.Name=='Copyediting' || ps.Service__r.Name=='Proofreading' || 
                                                                                                          ps.Service__r.Name=='Coldreading' ? predev : ps.Additional_Rate_Input__c != null? ps.Additional_Rate_Input__c : 0))+'/Per Word)';
            if(devValue ==0) { 
                ps.Total_Rate_Amount__c =getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + 0+''; 
                ps.Rush_Fee__c =0; 
            }
            ps.MBO_Fee__c = updateMBOValue(ps); 
            return str; 
        } 
        
        return ratecalculationFinal(r,ps);
    }
    
    public static decimal getPredevValue(Project_Services__c p) { 
        if(Label.Word_Count_Services.containsIgnoreCase(p.Service__r.Name)) { //ps.Service__r.Name=='Developmental Edit'
        if(p.Status__c == 'In Planning')
            return p.Word_Count_In_Planning__c;
        if(p.Status__c == 'Confirming')
            return  p.Word_Count_Confirming__c;
        if(p.Status__c == 'Scheduled')
            return p.Word_Count_Scheduled__c;
        if(p.Status__c == 'Kicked Off') 
            return p.Word_Count_Kicked_Off__c;
       // if(Label.Word_Count_Services_Completed.containsIgnoreCase(p.Service__r.Name)) // check only special services only
            if(p.Status__c == 'Completed') {
                if(Label.Word_Count_Services_Completed.containsIgnoreCase(p.Service__r.Name)) { // check only special services only
                    if(p.Word_Count_Completed__c > p.Word_Count_Kicked_Off__c)
                        return p.Word_Count_Completed__c;
                    else     
                        return p.Word_Count_Kicked_Off__c;
                
                } else 
                    return p.Word_Count_Kicked_Off__c;
                
             }   
        if(p.Status__c == 'Cancelled')
            return p.Word_Count_Cancelled__c;
        
        //if(p.Status__c == 'Killed')
           // return p.Word_Count_Killed__c;
        }
        return 0;
        
    } 
    
    
    public static string ratecalculationFinal(rate__c r,Project_Services__c ps) {
         
        Decimal userAmount=0;
        Decimal userDisplayAmount=0;
        string str ='0';
        decimal rushFee=(ps.Rush_Fee__c!=null?ps.Rush_Fee__c:0);
        System.debug('ps.Rate__c'+ps.Rate__c);
        decimal minfee = (ps.Rate__r.Minimum_Fee__c!=null?ps.Rate__r.Minimum_Fee__c:0); // minimum fee
        if(ps.Rate__c!=null && String.valueOf(ps.Rate__c)!='' && ps.Rate__r.Rate_Amount__c!=null && ps.Additional_Rate_Input__c!=null) 
            userAmount = ps.Rate__r.Rate_Amount__c * ps.Additional_Rate_Input__c;
        if( ps.Additional_Rate_Input__c!=0 && ps.Additional_Rate_Input__c!=null)
            userDisplayAmount = (userAmount / ps.Additional_Rate_Input__c);
        
        switch on ps.Rate__r.Rate_Multiplier__c{
            
            when 'Per Chapter' {
                str = (userAmount+(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Chapter)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Chapter)'); 
                
                System.debug(ps.Amount__c);        
                
            }
            when 'Per Hour' {
                str = (userAmount + (userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Hour)';
                
                if(userAmount<=minfee && minfee!=0) // minimum fee calculation
                    str= minimumfee(str,ps);
                else {
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Hour)'); 
                }
            }
            when 'Per Image' {
                str = (userAmount + (userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Image)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Image)'); 
                
            }
            when 'Per Issue' {
                str = (userAmount + (userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Issue)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Issue)');
                
            }
            when 'Per Word' {
                str = (userAmount + (userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Word)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Word)');
                
            }
            when 'Per Page' {
                str = (userAmount +(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Page)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Page)');
                
            } 
            when 'Per Minute' {
                str = (userAmount +(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Minute)';
                
                
                if(userAmount<=minfee&& minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Minute)');
                
            }
            when 'Per Month' {
                str = (userAmount +(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Month)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Month)');
                
            } 
            when 'Per Character' {
                str = (userAmount +(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Character)';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Character)');
                
            }
            when 'Per Round ' {
                str = (userAmount +(userAmount * rushFee)/100).divide(1, 2) +' ('+userDisplayAmount+'/Per Round )';
                
                if(userAmount<=minfee && minfee!=0)  // minimum fee calculation
                    str= minimumfee(str,ps);
                else
                    getRateAmount(ps, userAmount ,rushFee , ' ('+userDisplayAmount+'/Per Round)');
                
            }
             
            when else{  
                ps.Amount__c = 0; 
                ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
                ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps);
                ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + ''; 
                ps.MBO_Fee__c = updateMBOValue(ps); 
                str = '0';
            }
        }
        
        return str;   
    }
    private static void getRateAmount(Project_Services__c ps, Decimal userAmount ,Decimal rushFee , String wordText) { 
        ps.Base_Amount__c = (userAmount).divide(1, 2);
        ps.Amount__c = (userAmount+(userAmount * rushFee)/100).divide(1, 2); 
        ps.Rate_Amount_with_Currency__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Amount__c;
        ps.Total_Rate_Amount_with_MBO_Fee__c = ps.Amount__c + updateMBOValue(ps);
        ps.Total_Rate_Amount__c = getCurrency(rates.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c + wordText; 
        ps.MBO_Fee__c = updateMBOValue(ps); 
    }
}