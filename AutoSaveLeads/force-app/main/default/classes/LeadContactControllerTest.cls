@isTest
public with sharing class LeadContactControllerTest {

    @TestSetup
    static void setupData(){
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 20; i++){
            leads.add(new Lead(
                LastName = 'Lead'+i, 
                Title = 'Developer', 
                Company = 'Salesforce' + i, 
                Phone = '+11111'));
        }
        insert leads;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 20 ; i++){
            contacts.add(new Contact(FirstName = 'FirstName' + i, LastName = 'LastName' + i));
        }
        insert contacts;
    }
    
    @isTest
    static void getContacts_returnContacts_contactsIsLoaded() { 
        List<Contact> contacts = [SELECT Id FROM Contact];
        Test.startTest();
        Integer contacts1 = LeadContactController.getContacts().size();
        Test.stopTest();
        System.assertEquals(contacts.size(), contacts1, 'Contacts are not loaded');
    }

    @IsTest
    static void getContacts_returnContacts_contactsNotLoaded() {
        List<Contact> oneContact = [
            SELECT Id, LastName, FirstName, CreatedDate FROM Contact
            WHERE FirstName = 'FirstNameContact1'
        ];
        Test.startTest();
        Integer oneContact1 = LeadContactController.getContacts().size();
        Test.stopTest();
        System.assertNotEquals(oneContact.size(), oneContact1, 'Contacts are loaded');
    }

    @isTest
    static void getLeads_returnLeads_LeadsIsLoaded() { 
        List<Lead> allLeads = [SELECT Id FROM Lead];
        Test.startTest();
        Integer allLeads1  = LeadContactController.getLeads().size();
        Test.stopTest();
        System.assertEquals(allLeads.size(), allLeads1, 'Leads are not loaded');
    }
    @IsTest
    static void getLeads_returnLeads_LeadsIsNotLoaded() {
        List<Lead> oneLead = [
            SELECT Id, Title, Phone FROM Lead WHERE Title = 'Developer1'
        ];
        Test.startTest();
        Integer oneLead1 = LeadContactController.getLeads().size();
        Test.stopTest();
        System.assertNotEquals(oneLead.size(), oneLead1, 'Leads are loaded');
    }
    
    @isTest 
    static void updateLeadTitle_changingLeadTitle_leadTitleUpdated() {
        Lead lead = [SELECT Id, LastName, Title, Phone FROM Lead WHERE LastName = 'Lead1'];
        Test.startTest();
        LeadContactController.updateLead(lead.Id, 'DEVELOP', '');
        Lead updatedLead = [SELECT Id, LastName, Title, Phone FROM Lead WHERE LastName = 'Lead1'];
        Test.stopTest();
        System.assertEquals('DEVELOP', updatedLead.Title, 'Lead was not updated');
    }
    
    @isTest 
    static void updateLeadPhone_changingLeadPhone_leadPhoneNotUpdated() {
        Lead lead = [SELECT Id, LastName, Title, Phone FROM Lead WHERE LastName = 'Lead1'];
        Test.startTest();
        LeadContactController.updateLead(lead.Id, '', '+22222');
        Lead updatedLead = [SELECT Id, LastName, Title, Phone FROM Lead WHERE LastName = 'Lead1'];
        Test.stopTest();
        System.assertNotEquals('+11111', updatedLead.Phone, 'Lead phone is updated');
    }
}
