resources: [MIT missing semester](https://missing.csail.mit.edu/2020/data-wrangling/), [regexlearn.com](https://regexlearn.com) (quick go through), [regex101](https://regex101.com) (online debug), [LDP Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/regexp.html)

# Matching

### Basic matcher

To find the word curious in the text, type the same.

```bash
.      # any single character
foo    # find all 'foo'
```

### Character set/class

Charsets (bracket expressions) operate at the character (may be grouped) level, specifying a set of characters to be matched.

There are two special characters in a charset: `^` for negation, and `-` indicates a character range. 

To include a dash character in a bracket expression, making it the first character in the expression.

```bash
[]      # match in the char list
[abc]   # a single character of a, b or c
[^abmn] # any character except for a, b, m or n
[-a-z]  # dash, or any character in range a-z
[^a-z]  # any character except those in the range a-z.

```

### Pipe and Escape

Alternatives are at the expression level. For example, `/(c|r)at|dog/g` would select cat, rat and dog.

```bash
a|b    # alternate - match either a or b
```

Those characters having an interpretation above and beyond their literal meaning are called *metacharacters*. *Basic regular expressions (BRE)* recognizes the following metacharacters: `[ ] / \ * . $ ^`, whereas *extended regular expressions (ERE)* added `( ) { } ? + |`. However (and this is the fun part), the `()`,`{}`, `?`, `+` and `|` characters are treated as metacharacters in BRE if they are escaped with a backslash, whereas with ERE, preceding any metacharacter with a backslash causes it to be treated as a literal.

example using `sed` command:  

```bash
echo 'aabb' | sed 's/[ab]//'                  # output: abb
echo 'abcadb' | sed 's/[ab]//g'               # output: cd
echo 'abcaba' | sed 's/\(ab\)*//g'            # output: ca
echo 'abcaba' | sed -E 's/(ab)*//g'           # output: ca
echo 'abcbbc' | sed 's/\(ab\|bc\)\+//g'       # output: cb
echo 'abcbbc' | sed -E 's/(ab|bc)+//g'        # output: cb
```

### Meta sequences

```bash
.      # any single character

\s     # any space, tab or newline character.
\S     # anything other than a space, tab or newline.
\w     # letters, numbers and underscore characters (equivalent to [a-zA-Z0-9_])
\W     # any non-word character
\d     # any decimal digit. Equivalent to [0-9].
\D     # anything other than a decimal
```

### Anchoring

In regex, *anchors* qualify the position of regex matches. For example, we specify `^` for the start of a line, and `$` for the end of the same line. More exactly: 

- `^` asserts position at start of the string

- `$` for end of string, or before the line terminator right at the end of the string (if any)

Examples:

Find only numbers at the beginning of a line: `/^[0-9]/`

Find the html texts only at the end of the line: `/html$/`

# Quantifiers: Lazy and Greedy

Regex does a greedy match by default. This means that the matchmaking will be as long as possible. 

Lazy matchmaking, unlike greedy matching, stops at the first matching. **Non-greedy matching** requires PCRE-enabled tools or programming languages.

```bash
+    # put + after a pattern to indicate that it can occur 1 or more times
+?   # lazy matches the previous token
*    # 0 or more of that pattern as many times as possible, giving back as needed (greedy)
*?   # matches the previous token 0 or more times, as few times as possible, expanding as needed (lazy)
?    # to indicate that that pattern is optional

{3}   # a certain number of consecutive occurrences of that pattern
{3,}  # occur at least 3 times
{3,6} # between 3 and 6 (inclusive)
```
Greedy matching example:

```bash
echo '(abab-(cd)' | sed -E 's/(ab)?[-()]?//g' # output: cd
echo '(abab-(cd)' | sed -E 's/(ab)?[-()]//g'  # output: abcd
```

```regex
/^.*Disconnected from (invalid |authenticating )?user .* [0-9.]+ port [0-9]+$/
```

# Group

We can group an expression and use these groups to reference or enforce some rules. 

To group an expression, we enclose () in parentheses. Any parenthesis expression is a capture group by default, to which you can refer back in the replacement.

Example referencing a capture group:

```bash
cat ssh.log | sed -E 's/^.*?Disconnected from (invalid |authenticating )?user (.*) [0-9.]+ port [0-9]+( \[preauth\])?$/\2/'
```

### Non-capturing Group

`(?: )`: Group an expression and ensure that it is not captured by references. 

```bash
echo 'babzac' | sed
```

# Look around

For example, we want to select the hour value in the text. Therefore, to select only the numerical values that have PM after them, we need to write the positive look-ahead expression `(?=)` after our expression. Include PM after the = sign inside the parentheses

```bash
(?=)   # positive lookahead, after expression
(?!)   # negative lookahead, after expression
(?<=)  # positive lookbehind, before expression
(?<!)  # negative lookbehind, before expression
```

Example: 

Select only numeric values that are not preceded by $: `/(?<!\$)\d+/g`

## Flags

Flags change the output of the expression. That's why flags are also called *modifiers*. Flags determine whether the typed expression treats text as separate lines, is case sensitive, or finds all matches. Continue to the next step to learn the flags.

The `global` flag causes the expression to select all matches. If not used it will only select the first match. Now enable the global flag to be able to select all matches.

Regex sees all text as one line. But we use the `multiline` flag to handle each line separately. In this way, the expressions we write to identify patterns at the end of lines work separately for each line. 

In order to remove the case-sensitivity of the expression we have written, we must activate the `case-insensitive` flag.
