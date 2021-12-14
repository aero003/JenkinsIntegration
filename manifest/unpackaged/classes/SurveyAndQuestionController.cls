global with sharing class SurveyAndQuestionController extends ViewSurveyController{
  
  public String questionType                    {get; set;}
  public List<SelectOption> questionTypeOptions {get; set;}
  public String  showBasicValues                {get; set;}
  public String  showSingleSelect               {get; set;}
  public String  showSingleSelectPreview        {get; set;}
  public String  showMultiSelect                {get; set;}
  public String  showMultiSelectPreview         {get; set;}
  public String  showFreeText                   {get; set;}
  public String  showFreeTextPreview            {get; set;}
  public String  showRowQuestion                {get; set;}
  public String  showRowQuestionPreview         {get; set;}
  public String  showSelectQuestionType         {get; set;}
  public List<SelectOption> singleOptions       {get; set;}
  public List<SelectOption> multiOptions        {get; set;}
  public List<SelectOption> rowOptions          {get; set;}
  public String  qQuestion                      {get; set;}
  public Boolean qRequired                      {get; set;}
  public String  qChoices                       {get; set;}
  public String  questionReference              {get; set;}
  public String  reportId                       {get; set;}
  private Boolean saveAndNew;
  private String  surveyRef;
  private String surveyOrderNumber;
  private Survey_Question__c questionToUpdate;
  
   
  public  SurveyAndQuestionController (ApexPages.StandardController stdController){
    super(stdController);
    surveyRef = surveyId;
    //updateUrl();
    setupQuestionTypeOptions();
    resetViewsToFalse(true);
    showSelectQuestionType = 'False';
    ReportFinderUtil rfu = new ReportFinderUtil();
    reportId = rfu.findReportId('Survey with Questions and Resposnses');
  }
  
  //test constructor and calls within it
  private static TestMethod void testCreateQuestionController(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Apexpages.Standardcontroller std;
    SurveyAndQuestionController cqc = new SurveyAndQuestionController(std);
    cqc.addQuestion();
    cqc.getNewQuestionNum();
    cqc.makeNewQuestionLink();
    System.assert(cqc.surveyId == tu.surveyId);
  }
  
  //if you are using a developement org you will need to manually add your Pod.
  public Pagereference updateUrl(){
    Survey__c survey = [select Name, Id, URL__c from Survey__c where id = :surveyId];  
    Site subSite = [select Subdomain, id from Site limit 1];
    if(survey.URL__c.contains(subSite.Subdomain))
      return null;
    else
      return updateDomain(survey, subSite);
  }
  
  private Pagereference updateDomain(Survey__c survey, Site subSite){
    String surveyUrl = survey.URL__c;
    String subdomainReplace = 'http://'+subSite.Subdomain;
    //surveyUrl = surveyUrl.replaceFirst('*.', subdomainReplace);
    surveyUrl = surveyUrl.substring(surveyUrl.indexOf('.'), surveyUrl.length());
    surveyUrl = subdomainReplace + surveyUrl;
    try{
        survey.URL__c = surveyUrl;
        update survey;
    }catch(Exception e){
        system.debug(e);
    }
    setSurveyNameAndThankYou(surveyId);
    return null;
  }
  
  public Pagereference makeNewQuestionLink(){
    questionReference = null;
    resetViewsToFalse(true);
    return null;
  }
  
  public Pagereference editQuestion(){
    if (questionReference == null)
     return null;
    setupEditQuestion();
    showSelectQuestionType = 'True';
    return null;
  }
  
  public Pagereference addQuestion(){
    showSelectQuestionType = 'True';
    resetViewsToFalse(true);
    return null;
  }
  
  private void setupEditQuestion(){
    questionToUpdate =     [Select Type__c, Question__c, Id, Choices__c, Required__c, 
                           OrderNumber__c, Survey__c, Name
                           From Survey_Question__c 
                           where Id = :questionReference];
    questionType = questionToUpdate.Type__c;
    setupQuestionFields();
    setupEditFields(questionToUpdate);
  }

  private void setupEditFields(Survey_Question__c q){
    qQuestion = q.Question__c;
    qRequired = q.Required__c;
    qChoices = q.Choices__c;
    surveyRef = q.Survey__c;    
  }

  private void setupQuestionTypeOptions(){
  
    //get picklist values
    Schema.DescribeFieldResult fieldResult = Survey_Question__c.Type__c.getDescribe();
    List<Schema.PicklistEntry>  ple = fieldResult.getPicklistValues();
  
    //set/add them to selectOption list
    questionTypeOptions = new List<SelectOption>();
    questionTypeOptions.add(new SelectOption('--SELECT--', '--SELECT--'));
    for(Schema.PicklistEntry pe: ple){
      questionTypeOptions.add(new SelectOption(pe.getLabel(), pe.getValue()));
    }
  }
 
  //test constructor and calls within it
  private static TestMethod void testEditQuestion(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Apexpages.Standardcontroller std;
    SurveyAndQuestionController cqc = new SurveyAndQuestionController(std);
    cqc.editQuestion();
    cqc.questionReference = tu.questionIds[0];
    cqc.editQuestion();
    cqc.questionReference = tu.questionIds[1];
    cqc.editQuestion();
    cqc.questionReference = tu.questionIds[2];
    cqc.editQuestion();
    cqc.questionReference = tu.questionIds[3];
    System.assert(cqc.editQuestion()==null);
    
  }
  
  
  private void resetViewsToFalse(Boolean clearFields){
    showSingleSelect =        'False';
    showSingleSelectPreview = 'False';
    showMultiSelect =         'False';
    showMultiSelectPreview=   'False';
    showFreeText =            'False';
    showFreeTextPreview=      'False';
    showRowQuestion=          'False';
    showRowQuestionPreview=   'False';
    qRequired =                true;
    if(clearFields){
      qChoices =                 '';
      qQuestion =                '';
      }
    }

  public Pagereference setupQuestionFields(){
    resetViewsToFalse(false);
    if(questionType=='Multi-Select--Vertical'){
     showMultiSelect='True';
    }
    else if(questionType == 'Single Select--Vertical'){
      showSingleSelect = 'True';
    }
    else if(questionType == 'Free Text'){
      showFreeText = 'True';
    }
    else if(questionType == 'Single Select--Horizontal'){
      showRowQuestion = 'True';
    }
    return null;
  }  
 
  public Pagereference saveAndNewQuestion(){
    saveAndNew = True;
    if(questionReference == null || questionReference.length() <5)
      return saveNewQuestion();
    else 
      return updateQuestion();  
  }
  
  
  //test the saving of new questions
  private static TestMethod void testsaveAndNewQuestion(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Apexpages.Standardcontroller std;
    SurveyAndQuestionController cqc = new SurveyAndQuestionController(std);
    //test saving new question
    cqc.qQuestion = 'THIS IS A NEW QUESTION';
    cqc.qChoices = '1\\n2\\n3\\3';
    cqc.qRequired=true;
    cqc.questionType='Single Select--Vertical';
    cqc.saveAndNewQuestion();
    System.assertEquals(5, cqc.getNewQuestionNum());
    //edit existing question
    SurveyAndQuestionController cqcI = new SurveyAndQuestionController(std);
    cqcI.questionReference = tu.questionIds[0];
    cqcI.editQuestion();
    cqcI.qQuestion = 'THIS IS A NEW QUESTION THAT IS EXTRA LONG SO THE NAME SHORTENING CALL WILL BE USED, THIS SHOULD BE LONG ENOUGH NOW THIS IS A NEW';
    cqcI.qChoices = '1\\n2\\n3\\3';
    cqcI.qRequired=true;
    cqcI.questionType='Single Select--Vertical';
    cqcI.saveAndNewQuestion();
    System.assertEquals(5, cqcI.getNewQuestionNum());
  }
  
  public Pagereference saveQuestion(){
    if(questionReference == null || questionReference.length() <5)
      return saveNewQuestion();
    else 
      return updateQuestion();
  }
  
  
  private static TestMethod void testsavesaveQuestion(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Apexpages.Standardcontroller std;
    SurveyAndQuestionController cqc = new SurveyAndQuestionController(std);
    //test saving new question
    cqc.qQuestion = 'THIS IS A NEW QUESTION';
    cqc.qChoices = '1\\n2\\n3\\3';
    cqc.qRequired=true;
    cqc.questionType='Single Select--Vertical';
    cqc.saveQuestion();
    System.assertEquals(5, cqc.getNewQuestionNum());
    //edit existing question
    SurveyAndQuestionController cqcI = new SurveyAndQuestionController(std);
    cqcI.questionReference = tu.questionIds[0];
    cqcI.editQuestion();
    cqcI.qQuestion = 'THIS IS A NEW QUESTION THAT IS EXTRA LONG SO THE NAME SHORTENING CALL WILL BE USED, THIS SHOULD BE LONG ENOUGH NOW';
    cqcI.qChoices = '1\\n2\\n3\\3';
    cqcI.qRequired=true;
    cqcI.questionType='Single Select--Vertical';
    cqcI.saveQuestion();
    System.assertEquals(5, cqcI.getNewQuestionNum());
  }
  
  
  private Pagereference updateQuestion(){
    //questionToUpdate is setup in an earlier call to editQuestion()
    questionToUpdate.Name = questionToName(qQuestion);
    questionToUpdate.Choices__c = qChoices;
    questionToUpdate.Required__c = qRequired;
    questionToUpdate.Type__c = questionType;
    questionToUpdate.Question__c = qQuestion;
    try{
      update questionToUpdate;
      resetViewsToFalse(true);
      deleteOldResponses(questionToUpdate.id);
      questionReference = null;
    }catch(Exception e){
      System.debug(e);
      Apexpages.addMessages(e);
    }
    
    return saveOrUpdateReturn();
  }
  
  private void deleteOldResponses(String qId){
    List <SurveyQuestionResponse__c> sResponses = [select id, Survey_Question__c from SurveyQuestionResponse__c where Survey_Question__c = :qId];
    if(sResponses != null)
     delete sResponses;
  }
  
  private Pagereference saveOrUpdateReturn(){
    setupQuestionList();
    questionType = '--SELECT--';
    if(saveAndNew != null  && saveAndNew == true){
      saveAndNew = False;
      showSelectQuestionType = 'True';      
      return null;
    }
    else{  
      showSelectQuestionType = 'False';      
      return null; 
    }
  }

  private Integer getNewQuestionNum(){
    if(allQuestions == null)
     return 0;
    else{
     return allQuestions.size();
    }    
  }

  private Pagereference saveNewQuestion(){ 
    Survey_Question__c newQuestion = new Survey_Question__c();
    newQuestion.Survey__c = surveyRef;
    newQuestion.Name = questionToName(qQuestion);
    newQuestion.Choices__c = qChoices;
    newQuestion.Required__c = qRequired;
    newQuestion.Type__c = questionType;
    newQuestion.OrderNumber__c = getNewQuestionNum();
    newQuestion.Question__c = qQuestion;
    try{
      insert newQuestion;
      resetViewsToFalse(true);
    }catch(Exception e){
      System.debug(e);
      Apexpages.addMessages(e);
    }
    return saveOrUpdateReturn();
  }
  
  private String questionToName(String q){
    if(q.length()<75)
     return q;
    else
     return q.substring(0, 75)+'...';
  }
  
  public Pagereference previewQuestion(){
    if(questionType  == 'Multi-Select--Vertical'){
      showMultiSelectPreview = 'True';
      multiOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType == 'Single Select--Vertical'){
     showSingleSelectPreview = 'True';
     singleOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType =='Free Text'){
      showFreeTextPreview = 'True';
    }
    else if(questionType == 'Single Select--Horizontal'){
      showRowQuestionPreview = 'True';
      rowOptions = stringToSelectOptions(qChoices);
    }
    return null;
  }


   //test constructor and calls within it
  private static TestMethod void testPreviewQuestion(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Apexpages.Standardcontroller std;
    SurveyAndQuestionController cqc = new SurveyAndQuestionController(std);
    
    cqc.questionReference = tu.questionIds[0];
    cqc.editQuestion();
    cqc.previewQuestion();

    cqc.questionReference = tu.questionIds[1];
    cqc.editQuestion();
    cqc.previewQuestion();
    
    cqc.questionReference = tu.questionIds[2];
    cqc.editQuestion();
    System.assert(cqc.previewQuestion()==null);
    
    cqc.questionReference = tu.questionIds[3];
    cqc.editQuestion();
    System.assert(cqc.previewQuestion()==null);
    
  }

  
  private List<SelectOption> stringToSelectOptions(String str){
    List<String> strList = str.split('\\r|\n');
    List<SelectOption> returnVal = new List<SelectOption>();
    for(String s: strList){
      returnVal.add(new SelectOption(s,s));
    }
    return returnVal;
    
  }


}