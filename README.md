## How to start?
---
if you use Windows:
1. Download
    - flex (analogue lex from Unix system)
    - bison (analogue yacc from Unix system)
    - gcc (analogue cc from Unix system)

```
    bison -vd yacc.y
    flex lex.l
    gcc yacc.tab.c lex.yy.c -o create
    create
```

---
## Task

You will need to create a lexical and parser for the sql (create) expression.

Such an analyzer should check the input text for compliance with the language rules and report errors found in expanded form, indicating the line number and position in the line.