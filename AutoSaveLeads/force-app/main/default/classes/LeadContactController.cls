public with sharing class LeadContactController {

    
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts() {
        return [ SELECT Id, Name FROM Contact LIMIT 20 ];
    }

    @AuraEnabled(cacheable = true)
    public static List<Lead> getLeads() {
        return [ SELECT Id, Name, Title, Phone FROM Lead LIMIT 20];
    }

    @AuraEnabled
    public static void updateLead(String id, String title, String phone) {
        Lead lead = [SELECT Id, Title, Phone FROM Lead WHERE Id = :id];
        if (String.isNotEmpty(title)) {
            lead.Title = title;
        }
        if (String.isNotEmpty(phone)) {
            lead.Phone = phone;
        }
        try {
            update lead;
        } catch (DmlException e) {}
    }
}
