##String Library  
Helper module containing functions for working with strings.  

###functions  

 - ```function StringLib.getRandom(str)```
   - get a random word from a string or table of words.
   - if param is a string it is first converted to a table of words.
   - each time it is called it grabs a word at random from the table, so repeated values are expected.


 - ```function StringLib.getUniqueRandom(str,rollOver)```
   - get a unique random word from a string or a table of words
   - if param is string then first convert it to a table of words.
   - if rollOver is true then once all the words in the original table of words have been used, the word table is reshuffled and is used again.
   - if rollOver is false or nil then after all words have been used up all subsequent calls will return an empty string.  
   

 - ```function StringLib.getWords(str)```
   - return table containing all words from the string.
   -  word is defined as group of any non space or non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.  


 - ```function StringLib.word(str)```
   - grab the first word in the string.
   - word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.  


 - ```function StringLib.squishSpaces(str)```
   - replace all multi-spaces with a single space.  


 - ```function StringLib.trim(str)```
   - trim space from front and rear of string.  


 - ```function StringLib.trimSpaceRear(str)```
   - trim space from the rear of a string.  


 - ```function StringLib.trimSpaceFront(str)```
   - trim space from the front of a string.  
