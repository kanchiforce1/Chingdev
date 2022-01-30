<aura:application extends="force:slds">
    <aura:attribute name="selectRecordId" type="String" required="false"></aura:attribute>
    <aura:attribute name="selectRecordName" type="String" required="false"></aura:attribute>
    
    
    <c:PageHeader/>
	<c:customLookUp objectName="Account" fieldName="Name"
                    selectRecordId="{!v.selectRecordId}"
                    selectRecordName="{!v.selectRecordName}"
                    iconName = "action:new_account" onselected="{!c.selectedRecords}"/>
Selected Record: {!v.selectRecordName}
    
    
    <c:michatemCodeButtonsComponent/>
</aura:application>