### Read File  
module which reads in a file and parses content into a table. return the table.  
user supplies file name and pattern to use to parse out contents.  
each pattern match is added to an index of the table.  
requires the ReadOnlyTable module.  

#### functions  

 - ```function ReadFile:new(filePath,pat,readOnly,keyValue,keyPat,valuePat)```  
   - read a file and put the contents into a table.
   - table is parsed based on pat.
   - if readonly is true then make resulting table a readOnly table.
   - if keyValue is true then file is treated as a list of key value pairs.
   - if text is a list of key/value pairs then keyPat is pattern to find the keys.
   - if text is a list of key/value pairs then valuePat is pattern to find the values.
