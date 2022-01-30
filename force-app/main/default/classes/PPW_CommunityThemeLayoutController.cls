// ContactController.cls
public with sharing class PPW_CommunityThemeLayoutController{
    @AuraEnabled 
    public static user fetchUserDetail(){
        return [Select id,Name,SmallPhotoUrl, FullPhotoUrl,UserName
                From User
                Where Id =: Userinfo.getUserId()];
    }
    
    @AuraEnabled
  public static reRes getCaseRecordType() {
    reRes rs = new reRes();
    rs.caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Community_Vendor_Management').getRecordTypeId();
    rs.caseUSOwnerId = [SELECT id FROM Group WHERE type = 'Queue' AND DeveloperName = 'VM_US_Internal'].id;
    rs.caseUKOwnerId = [SELECT id FROM Group WHERE type = 'Queue' AND DeveloperName = 'VM_EU_Internal'].id;
    rs.vendorId = [SELECT Contact.Vendor__c FROM User WHERE Id =: Userinfo.getUserId()].Contact.Vendor__c;
    return rs;
    }
    public class reRes {
    @AuraEnabled
    public String caseRecordTypeId;
    @AuraEnabled
    public String caseUSOwnerId;
    @AuraEnabled
    public String caseUKOwnerId;
    @AuraEnabled
    public String vendorId;
    
    }
 }