### Helper Modules  
collection of small lua modules I wrote to help me with certain projects or scripts. I hope they can be of use to someone else as well.  

#### List of Modules included 

 - StringLib  
   - Some basic string manipulation methods.  
   

 - ReadOnlyTable  
   - Module to make tables read only.  
   

 - ReadFile
   - module to read a file and parse the contents into a table based upon a pattern.  


 - PrintableTable
   - module for using a table with a tostring method set to TableToString. also uses a custom pairs method which preserves insertion order of keys.  


 - TableToString  
   - module for converting a table into a human-readable string for printing.  
   

 - ~~Logger~~
   - ~~module for doing very simple logging.~~  currently needs major work, removed until it is fixed  


 - Utils  
    - Utility methods for working with tables.  
    

 - Helpers  
    - Single File which contains all of the modules. returns a key/value table with each of the modules as a key/value pair.
        ```
            Helpers["StringLib"]      = StringLib
            Helpers["Utils"]          = Utils
            Helpers["PrintableTable"] = PrintableTable
            Helpers["ReadFile"]       = ReadFile
            Helpers["ReadOnlyTable"]  = ReadOnlyTable
            Helpers["TableToString"]  = TableToString
        ```

#### further information  
please see examples and documentation for more information on each module.  
