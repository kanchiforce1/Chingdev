public class PPW_CommunityContactUs {

    public reRes getCaseRecordType() {
    reRes rs = new reRes();
    rs.caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Community_Vendor_Management').getRecordTypeId();
    rs.caseOwnerId = [SELECT id FROM Group WHERE type = 'Queue' AND Name =: Label.VMQueue].id;
    //VM Queue
    return rs;
}
public class reRes {
@AuraEnabled
public String caseRecordTypeId;
@AuraEnabled
public String caseOwnerId;

}

}