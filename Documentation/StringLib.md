## String Library  
Helper module containing functions for working with strings.  
It is recommended that you call math.randomseed() if you intend to use either of the two random methods in this module. 

### functions  

 - ```function StringLib:getRandom(str)```
   - get a random word from a string or table of words.
   - if param is a string it is first converted to a table of words.
   - each time it is called it grabs a word at random from the table, so repeated values are expected.


 - ```function StringLib:getUniqueRandom(str,rollOver)```
   - get a unique random word from a string or a table of words
   - if param is string then first convert it to a table of words.
   - if rollOver is true then once all the words in the original table of words have been used, the word table is reshuffled and is used again.
   - if rollOver is false or nil then after all words have been used up all subsequent calls will return an empty string.  
   

 - ```function StringLib:getWordsTbl(str)```
   - return table containing all words from the string.
   -  word is defined as group of any non space or non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.  



 - ```function StringLib:firstWord(str)```
   - grab the first word in the string.
   - word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.  


- ```function StringLib:lastWord(str)```
   - grab the last word in the string.
   - word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.


- ```function StringLib:grabWord(str,n)```
   - grab the nth word in the string.
   - word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.


- ```function StringLib:charAt(str,i)```
   - grab the character at position i.
   - 

- ```function StringLib:squishSpaces(str)```
   - replace all multi-spaces with a single space.  


 - ```function StringLib:trim(str)```
   - trim space from front and rear of string.  


 - ```function StringLib:trimSpaceRear(str)```
   - trim space from the rear of a string.  


 - ```function StringLib:trimSpaceFront(str)```
   - trim space from the front of a string.  


- ```function StringLib:strToTbl(str,[pattern],[sep])```
   - convert string to table.
   - pattern is regex patter to sort each index by. if none is supplied, split on each character.
   - sep is character(s) which get appended to end of each index.


- ```function StringLib:isEmpty(str)```
  - return true if string is nil or contains only spaces. otherwise, returns false.
  

- ```function StringLib:splitAt(str,i)```
  - splits string at the given position.  
  

- ```function StringLib:splitAround(str,n,include)```
  - splits string at the nth word.
  

- ```function StringLib:splitAtWord(str,word,include)```
  - splits string at first instance of the word
  - if include is true then the first string includes the split word.
  

- ```function StringLib:splitByWord(str,word,include)```
  - splits string around each occurrence of the word.
  - if include is true then each split string includes the split word.  


- ```StringLib:format(str,formatters)```  
  - format the given string by the table provided.
  - in the str put all words which need formatting in the form $word or ${word} 
  - table should be in the form {word = "replace", word2 = "replace2"}. 


- ```StringLib:padFront(str,char,n)```  
  - pad the front of the provided string with the provided char up to length n.


- ```StringLib:padBack(str,char,n)```
    - pad the back of the provided string with the provided char up to length n.


- ```StringLib:isEmpty(str)```
  - returns true is str is nil,"", or nothing but space character(s). 


- ```StringLib:charIter(str)```
  - returns iterator which iterates over each character in provided string in order. 
  - iterators operates over a table created from passed in string, so changes to string inside of iteration dont affect iteration. 


- ```StringLib:wordIter(str)```
    - returns iterator which iterates over each word in provided string in order. 
    - a word is defined as any combination of letters,numbers,or punctuation. 
    - iterators operates over a table created from passed in string, so changes to string inside of iteration dont affect iteration. 
