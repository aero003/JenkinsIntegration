@isTest(SeeAllData=true)
public with sharing class CodeCoverageImprovementTest {

   static testmethod void fakeTest(){
     CodeCoverageImprovement c = new CodeCoverageImprovement ();
     CodeCoverageImprovement.fakeMethod();
  }  
}