###Read Only Tables  

Make a read only version of a table. can read values but can not update values.  
ReadOnly version is shallow. If table contains objects then any value in those objects can be modified.   

####functions 
 - ```function ReadOnlyTable:readOnly(t)```  
   - returns a read only version of t
