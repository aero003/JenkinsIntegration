public class ConsensusController {
    public string J2Address {get;set;}
    public string J2State {get;set;}
    public string J2Street {get;set;}
    public string J2AccountName {get;set;}
    public string J2AccontNumber {get;set;}
    public string J2Routing {get;set;}
    public String J2SwiftCode {get;set;}
    public string J2Bank {get;set;}
    public string Telephone {get;set;}
    public string eFax {get;set;}
    public string j2TAXID {get;set;}
    public string dueDate {get;set;}
    public Opportunity oppData;
    public Contact con {get;set;}
    public List<Invoice__c> consensusInvoice {get;set;}
    public Decimal totalDueAmount {get;set;}
    public string orgCurrency {get;set;}
    public Boolean InvoiceFooter {get;set;}
    public Boolean CreditCardFooter {get;set;}
    
    public ConsensusController(Apexpages.StandardController controller) {
        Opportunity opp = (Opportunity)controller.getRecord();
        if(opp != null) {
            //get the invoice Data
            consensusInvoice = [SELECT id, Consensus_Amount_Breakdown__c, 
                                Consensus_Price__c, Consensus_Quantity__c, 
                                Description_Period__c, Status__c  
                                FROM Invoice__c 
                                WHERE Opportunity__c = :opp.Id AND Status__c = 'Active' AND Billing_Run_Date__c = THIS_MONTH ORDER BY Line_Number1__c];
            getTotalCharges();
            oppData = [SELECT Id, AccountId, Account.Corp_ID__c, Account.Payment_Method__c, Consensus_Invoice_No__c, Account.Sales_Rep__c, Account.Payment_Terms__c,Account.Payment_Terms_New__c from Opportunity where id =:opp.Id];   
        }
        if(oppData != null) {
            try{
                //get the contact information from account Id
                con = [SELECT Id,Name from Contact where accountId = : oppData.AccountId LIMIT 1];   
            }catch(Exception ex) {}
        }
        getcallCustomSetting();
        getDueDate();
        InvoicePaymentMethod();
        CreditCardPaymentMethod();
    }
    /*
* Fetching all the static values related to this invoice 
* from Custom setting
*/
    public void getcallCustomSetting() {
        Consensus__c test = Consensus__c.getvalues('J2Address');
        J2Address = test.J2_Address__c;
        J2Street = test.J2_Street__c;
        J2State = test.J2_State__c;
        J2AccountName = test.Account_Name__c;
        J2AccontNumber = test.Account_Number__c;
        J2Routing = test.Routing__c;
        J2SwiftCode = test.Swift_Code__c;
        J2Bank = test.Bank__c;
        Telephone = test.Telephone__c;
        eFax = test.eFax__c;
        j2TAXID = test.J2TaxID__c;
    }
    
    public void getDueDate() {
        Date monthEndDate = Date.today().toStartofMonth().addMonths(1).addDays(-1);
        dueDate = DateTime.newInstance(monthEndDate.year(),monthEndDate.month(),monthEndDate.day()).format('MM-d-YYYY');
    }
    
    public void getTotalCharges() {
        orgCurrency = UserInfo.getDefaultCurrency();
        totalDueAmount = 0.00;
        if(consensusInvoice != null) {
            for(Invoice__c invCharges : consensusInvoice) {
                totalDueAmount =  totalDueAmount + invCharges.Consensus_Amount_Breakdown__c;            
            }
        }
    }
    
    public Boolean InvoicePaymentMethod() {
        InvoiceFooter =false;
        if(oppData.Account.Payment_Method__c == 'Invoice') {
            InvoiceFooter = true;
        }
        return InvoiceFooter;
    }
    
    public Boolean CreditCardPaymentMethod() {
        CreditCardFooter =false;
        if(oppData.Account.Payment_Method__c == 'Credit Card') {
            CreditCardFooter = true;
        }
        return CreditCardFooter;
    }
}