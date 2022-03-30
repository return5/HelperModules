### Logger  
a very simple logger. prints log info to a file.  
when starting program first set file. when program ends close the file. 
Prints all logs to a directory called 'logs'. directory must exist before running program.  
  
Requires the ReadOnlyTable and TableToString modules.

#### functions  

 - ```function Logger:setFile(f)```
     - set the file which logger will print to.  


 - ```function Logger:new(name)```
     - set the name of the program which is using logger.  
   

 - ```function Logger:startMethod(methodName)```
     - log the start of a method.


 - ```function Logger:endMethod(methodName)```
     - log the end of a method.


 - ```function Logger:startAndEndMethod(methodName)```
     - log both start and end of a method at once.


 - ```function Logger:info(methodName,str,del)```
     - log a string of information.


 - ```function Logger:err(methodName,err)```
     - log an error.


 - ```function Logger:close()```
     - close the file used for logging.
