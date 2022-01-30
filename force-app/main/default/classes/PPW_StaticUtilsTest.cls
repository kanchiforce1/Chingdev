@isTest public class PPW_StaticUtilsTest {

    @isTest static void makeListIncludesTypeTest() {
        PPW_StaticUtils.makeListIncludesType('US');
        PPW_StaticUtils.verifyLocale('US;UK', 'US');
        PPW_StaticUtils.dynamicQueryListType('project__c' ,'', '');
         PPW_transmittalController_lwc.tsmWrapData = null;
        PPW_transmittalController_lwc.additionalRateStringMap();
       // Exception e;
       // PPW_StaticUtils.txThrowAuraException(e, 'PPW_StaticUtils', 'txThrowAuraException', 'utils', '1234', 'vendor');//txThrowAuraException
    }
    
}