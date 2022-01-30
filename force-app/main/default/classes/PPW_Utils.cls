public class PPW_Utils {
    public static boolean verifyLocale(String titlelocale, String locale ) { // verify locale with title from vendor,project,ps
        if(String.isNotBlank(titlelocale) && String.isNotBlank(locale)) {
        List<String> tlocale = splitString(titlelocale);
        for(String str: tlocale)
            if(locale.contains(str))
                return true;
             
        
        }
    return false;
    }
    public static List<String> splitString(String titlelocale) {
     List<String> tlocale = new List<String>();
        if(titlelocale.contains(';')) 
            tlocale = titlelocale.split(';');
        else tlocale.add(titlelocale);
    return tlocale;
    
    }
    
     public static String makeListIncludesType(String prodLocale) {
       List<String> plocale = new List<String>();
      
       for(String s: splitString(prodLocale))
           plocale.add('\''+ s+ '\'');
        return String.join(plocale, ',');
       // return 
    }

}