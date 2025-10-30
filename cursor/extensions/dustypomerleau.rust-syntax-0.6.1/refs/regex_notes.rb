=begin

Test your regex code at http://rubular.com/.

Quick summary:

[abc] A single character of: a, b, or c
[^abc]  Any single character except: a, b, or c
[a-z] Any single character in the range a-z
[a-zA-Z]  Any single character in the range a-z or A-Z

^ Start of line /^regex/
$ End of line /regex$/
\A  Start of string /\Aregex/
\z  End of string /regex\z/
. Any single character (other than newlines)

\s  Any whitespace character
\S  Any non-whitespace character
\d  Any digit
\D  Any non-digit
\w  Any word character (letter, number, underscore)
\W  Any non-word character
\b  Any word boundary

(...) Capture everything enclosed

(a|b) a or b

a?  Zero or one of a
a*  Zero or more of a
a+  One or more of a
a{3}  Exactly 3 of a
a{3,} 3 or more of a
a{3,6}  Between 3 and 6 of a

options - these go outside the // - e.g. /regex/i
  g global matching in JS - matches all occurrences of the regex
    in Ruby you need to use the String.scan method for this
  i case insensitive
  m make dot match newlines
  o perform #{...} substitutions only once
  x ignore whitespace in regex

=end

# -----

# list of metacharacters:
[. ^ $ * + ? {} [] \ | ()

[] # define a character class you want to match (separate characters, ranges) - metacharacters other than \ are not active inside []

^ # complements the set, or indicates start of line if it's outside a set
/[^5]/ # match any character except 5
/^5/ # match 5 at the beginning of a line

\ # escape a metacharacter if you need to match it outside []

\ # provide an intro to a special sequence, such as:
  /\d/ # Matches any decimal digit; this is equivalent to the class [0-9].
  /\D/ # Matches any non-digit character; this is equivalent to the class [^0-9].
  /\s/ # Matches any whitespace character; this is equivalent to the class [ \t\n\r\f\v].
  /\S/ # Matches any non-whitespace character; this is equivalent to the class [^ \t\n\r\f\v].
  /\w/ # Matches any alphanumeric character; this is equivalent to the class [a-zA-Z0-9_].
  /\W/ # Matches any non-alphanumeric character; this is equivalent to the class [^a-zA-Z0-9_].
  /\A/ # Matches at the start of a string.
  /\z/ # Matches at the end of a string.
  /\b/ # Matches at a word boundary.

* # match 0 or more times (greedy - grabs as many reps as are available)

+ # match 1 or more times

? # match 0 or 1 times - think of it as meaning optional

{m, n} # match a minimum of m but no more than n repetitions

| # or - put the options on either side of the or in parentheses unless the whole regex is either or

() # creates capture groups

/regex/ =~ 'String that might contain the regex' # returns the character number where the match starts
'String that might contain the regex' =~ /regex/ # returns the same as above - order is up to you (I prefer the first)

/regex/ !~ 'String that might contain the regex' # returns boolean true if the pattern is not present

# calling the match method returns an instance of the MatchData class, which gives you access to lots of methods after you complete the match:
a_match = /regex/.match(string, 5) # start trying to match the string at character 5, starts at 0 if none given
a_match.to_s # returns the entire text of the match as a string
a_match.pre_match # returns the portion of the string before the match
a_match.post_match # returns the portion of the string after the match

my_string = "The force will be with you always"
my_match = /(.*)force(.*)/.match(my_string) # note use of capture groups
my_match.captures #=> ['The ', ' will be with you always']
my_match[0] #=> "The force will be with you always"
my_match[1] #=> 'The '

# MatchData class instances are Array-like but aren't Arrays - if you want to use Array methods call to_a on them:
my_match.to_a.each { |i| puts i }

# A positive lookahead only matches the string if the string following ?= follows it:
my_string = "Who's the more foolish, the fool or the fool who follows him?"
/fool(?=ish)/ # matches foolish but not fool or fools
/fool(?!ish)/ # a negative lookahead - does not match foolish but would match fool or fools
my_string.gsub(/fool(?=ish)/, 'self') #=> "Who's the more selfish, the fool or the fool who follows him?"

# gsub is one good example, but you can pass a regex as an argument to almost any string method - review String docs for ideas.

# Similarly, you can use a positive or negative lookbehind:
/(?<=powerful )ally/ # matches 'powerful ally' but not ally preceded by anything else
/(?<!powerful )ally/ # matches ally only when not preceded by powerful

# You can make a greedy quantifier like * or + lazy by adding a ? after it:
my_string = "There's no time to talk about time we don't have the time."
/.+time/.match(my_string) #=> "There's no time to talk about time we don't have the time."
/.+?time/.match(my_string) #=> "There's no time"

# You can make a greedy quantifier possessive by adding a + after it:
/.++time/.match(my_string) #=> returns nil because in this case the entire string matches .+ and then it tries to look for 'time' *after* the entire string. Use these with short regexes (generally when they are nested in larger regexes) and in general use with caution - they are good when you want to minimise system resources because they only try once.

# Matching Numeric Ranges with a Regular Expression

# Since regular expressions deal with text rather than with numbers, matching a number in a given range takes a little extra care. You can't just write [0-255] to match a number between 0 and 255. Though a valid regex, it matches something entirely different. [0-255] is a character class with three elements: the character range 0-2, the character 5 and the character 5 (again). This character class matches a single digit 0, 1, 2 or 5, just like [0125].

# Since regular expressions work with text, a regular expression engine treats 0 as a single character, and 255 as three characters. To match all characters from 0 to 255, we'll need a regex that matches between one and three characters.

# The regex [0-9] matches single-digit numbers 0 to 9. [1-9][0-9] matches double-digit numbers 10 to 99. That's the easy part.

# Matching the three-digit numbers is a little more complicated, since we need to exclude numbers 256 through 999. 1[0-9][0-9] takes care of 100 to 199. 2[0-4][0-9] matches 200 through 249. Finally, 25[0-5] adds 250 till 255.

# As you can see, you need to split up the numeric range in ranges with the same number of digits, and each of those ranges that allow the same variation for each digit. In the 3-digit range in our example, numbers starting with 1 allow all 10 digits for the following two digits, while numbers starting with 2 restrict the digits that are allowed to follow.

# Putting this all together using alternation we get: [0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]. This matches the numbers we want, with one caveat: regular expression searches usually allow partial matches, so our regex would match 123 in 12345. There are two solutions to this.

# If you're searching for these numbers in a larger document or input string, use word boundaries to require a non-word character (or no character at all) to precede and to follow any valid match. The regex then becomes \b([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\b. Since the alternation operator has the lowest precedence of all, the parentheses are required to group the alternatives together. This way the regex engine will try to match the first word boundary, then try all the alternatives, and then try to match the second word boundary after the numbers it matched. Regular expression engines consider all alphanumeric characters, as well as the underscore, as word characters.

# If you're using the regular expression to validate input, you'll probably want to check that the entire input consists of a valid number. To do this, replace the word boundaries with anchors to match the start and end of the string: ^([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$.

# Here are a few more common ranges that you may want to match:

# 000..255: ^([01][0-9][0-9]|2[0-4][0-9]|25[0-5])$
# 0 or 000..255: ^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$
# 0 or 000..127: ^(0?[0-9]?[0-9]|1[01][0-9]|12[0-7])$
# 0..999: ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
# 000..999: ^[0-9]{3}$
# 0 or 000..999: ^[0-9]{1,3}$
# 1..999: ^([1-9]|[1-9][0-9]|[1-9][0-9][0-9])$
# 001..999: ^(00[1-9]|0[1-9][0-9]|[1-9][0-9][0-9])$
# 1 or 001..999: ^(0{0,2}[1-9]|0?[1-9][0-9]|[1-9][0-9][0-9])$
# 0 or 00..59: ^[0-5]?[0-9]$
# 0 or 000..366: ^(0?[0-9]?[0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
