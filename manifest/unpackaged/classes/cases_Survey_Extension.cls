public without sharing class cases_Survey_Extension {

    public case thisCase {get;set;}
    public Boolean showThankYou {get;set;}
    public Boolean showError {get;set;}
    public String caseId;

    public cases_Survey_Extension(ApexPages.StandardController controller){
        caseId = apexPages.currentPage().getParameters().get('cid');
        if ( caseId == null || caseId == '' || caseId == ' ' ){
            showError = true;
            this.thisCase = new Case();
        } else {
            this.thisCase = cases_WebServices.getCaseBrand(caseId).clone(false,true);
        }
    }

    public List<SelectOption> getSatisfiedOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Very Satisfied','Very Satisfied'));
        options.add(new SelectOption('Satisfied','Satisfied'));
        options.add(new SelectOption('Neither Satisfied nor Dissatisfied','Neither Satisfied nor Dissatisfied'));
        options.add(new SelectOption('Dissatisfied','Dissatisfied'));
        options.add(new SelectOption('Very Dissatisfied','Very Dissatisfied'));
        return options;
    }

    public List<SelectOption> getGoodOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Excellent','Excellent'));
        options.add(new SelectOption('Very Good','Very Good'));
        options.add(new SelectOption('Good','Good'));
        options.add(new SelectOption('Average','Average'));
        options.add(new SelectOption('Poor','Poor'));
        return options;
    }

    public List<SelectOption> getRecommendOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
    options.add(new SelectOption('3','3'));
    options.add(new SelectOption('4','4'));
    options.add(new SelectOption('5','5'));
    options.add(new SelectOption('6','6'));
    options.add(new SelectOption('7','7'));
    options.add(new SelectOption('8','8'));
    options.add(new SelectOption('9','9'));
    options.add(new SelectOption('10','10'));
        return options;
    }

    public List<SelectOption> getInterestOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Virtual Phone System','Virtual Phone System'));
        options.add(new SelectOption('Online Data Backup','Online Data Backup'));
    options.add(new SelectOption('Hosted Email','Hosted Email'));
    options.add(new SelectOption('Email Marketing','Email Marketing'));
        return options;
    }

    public List<SelectOption> getAwareOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }

    public PageReference submitSurvey(){
        if ( cases_WebServices.updateCase(caseId,thisCase) == true ){
            showThankYou = true;
        } else {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'An Error has occurred.'));
        }
        return null;
    }   

}