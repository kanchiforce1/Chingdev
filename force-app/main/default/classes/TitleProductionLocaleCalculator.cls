public class TitleProductionLocaleCalculator {
    public static string calculateProductionLocale(Title__c title){
        string locale;
        Map<string, string> localeMap = new Map<string, string>();
        //US Values
        localeMap.put('47North', 'US');
        localeMap.put('AmazonClassics', 'US');
        localeMap.put('Crossing CN', 'US');
        localeMap.put('Crossing US', 'US');
        localeMap.put('Deluxe', 'US');
        localeMap.put('Encore', 'US');
        localeMap.put('Grand Harbor Press', 'US');
        localeMap.put('Jet City Comics', 'US');
        localeMap.put('Kindle Illustrated', 'US');
        localeMap.put('Kindle Press', 'US');
        localeMap.put('Kindle Serials', 'US');
        localeMap.put('Kindle Worlds', 'US');
        localeMap.put('Lake Union', 'US');
        localeMap.put('Montlake', 'US');
        localeMap.put('NYC Adult', 'US');
        localeMap.put('Party Bus Vendor', 'US');
        localeMap.put('Party Bus Vendor 2', 'US');
        localeMap.put('Party Bus Vendor 3', 'US');
        localeMap.put('PB Alloy', 'US');
        localeMap.put('PB Howey', 'US');
        localeMap.put('PB Vendor 1', 'US');
        localeMap.put('Skyscape', 'US');
        localeMap.put('StoryFront', 'US');
        localeMap.put('Thomas & Mercer', 'US');
        localeMap.put('Two Lions', 'US');
        localeMap.put('Waterfall Press', 'US');
        //EU Values
        localeMap.put('APub DE', 'DE');
        localeMap.put('APub ES', 'ES');
        localeMap.put('APub FR', 'FR');
        localeMap.put('APub IT', 'IT');
        localeMap.put('Crossing DE', 'DE');
        localeMap.put('Crossing ES', 'ES');
        localeMap.put('Crossing FR', 'FR');
        localeMap.put('Crossing IT', 'IT');
        //UK Values
        localeMap.put('APub UK', 'UK');
        localeMap.put('Crossing UK', 'UK');
        //IN Values
        localeMap.put('Westland', 'IN');
        //JP Values
        localeMap.put('APub JP', 'JP');        
        
        if(title.External_Imprint__c == 'Amazon Original Stories'){
            locale = 'US';
            return locale;
        }
        
        if(localeMap.containsKey(title.Internal_Imprint__c)){
            locale = localeMap.get(title.Internal_Imprint__c);
        }else{
            locale = '';
        }
        
        return locale;
    }
}