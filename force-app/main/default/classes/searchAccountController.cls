public with sharing class searchAccountController {
 
 @AuraEnabled(cacheable=true)
 public static List < Lead> fetchAccount(String searchKeyWord) {
     
     Map<String,String> fieldsMap =  (Map<String,String>)JSON.deserialize(
               searchKeyWord, Map<String,String>.class);
     system.debug(fieldsMap);
     String q = '\'';
    
         String wherecondtion = ' WHERE ';
         
         for(String s: fieldsMap.keyset()) 
            if(String.isNotBlank(fieldsMap.get(s))) {

          
              wherecondtion = wherecondtion + ' ('+ s+ ' like \''+ fieldsMap.get(s) + '%\' ';
              wherecondtion = wherecondtion + ' OR '+ s + ' like \'%'+ fieldsMap.get(s) + '%\' ';
              wherecondtion = wherecondtion + ' OR '+ s+ ' like \'%'+ fieldsMap.get(s) + '\') AND ';
          
         }

     wherecondtion = wherecondtion.removeEnd('AND ');
         system.debug(wherecondtion);

     for(String searchval: fieldsMap.values())
            if(String.isNotblank(searchVal))
                 q +=  searchval + ' OR ' + searchval + '* OR ' ;
      q = q.removeEnd(' OR ');
       q+= '\'';
    
    String searchquery='FIND ' + q +' IN ALL FIELDS RETURNING Lead(id,name,Phone '+ wherecondtion +' )'; 

   system.debug(searchquery);
     List<List<Lead>>searchList=search.query(searchquery);
     
     
   

        return (Lead[])searchList[0];
 }
    
     @AuraEnabled
 public static integer fetchAccountsCount(String searchKeyWord) {
     
     Map<String,String> fieldsMap =  (Map<String,String>)JSON.deserialize(
               searchKeyWord, Map<String,String>.class);
     system.debug(fieldsMap);
     String q = '\'';
    
         String wherecondtion = ' WHERE ';
         
         for(String s: fieldsMap.keyset()) 
            if(String.isNotBlank(fieldsMap.get(s))) {

              wherecondtion = wherecondtion + ' ('+ s+ ' like \''+ fieldsMap.get(s) + '%\' ';
              wherecondtion = wherecondtion + ' OR '+ s + ' like \'%'+ fieldsMap.get(s) + '%\' ';
              wherecondtion = wherecondtion + ' OR '+ s+ ' like \'%'+ fieldsMap.get(s) + '\') AND ';
           // }
         }

     wherecondtion = wherecondtion.removeEnd('AND ');
         system.debug(wherecondtion);
// 'Mark OR Mark*''8037186603 OR 8037186603*' 
     for(String searchval: fieldsMap.values())
            if(String.isNotblank(searchVal))
                 q +=  searchval + ' OR ' + searchval + '* OR ' ;
      q = q.removeEnd(' OR ');
       q+= '\'';
      
    // String q = 'dolo OR test';
    String searchquery='FIND ' + q +' IN ALL FIELDS RETURNING Lead(id '+ wherecondtion +' )'; 
  
   system.debug(searchquery);
     List<List<Lead>>searchList=search.query(searchquery);
     
   
        return searchList[0].size();
 }
}