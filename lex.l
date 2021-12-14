%{
    #include "yacc.tab.h"
    int line = 1;
    int yyparse();
%}

digit                   [0-9]
char                    [A-Za-z]
number                  {digit}+
identifier             ({char}|_)({digit}|_|{char})*

%%

CREATE                  return(CREATE);
GLOBAL      |
LOCAL                   return(GLOB_LOC);
TEMPORARY               return(TEMPORARY);
TABLE                   return(TABLE);

ON\ COMMIT              return(ON_COMMIT);
DELETE      |
PRESERVE                return(DELETE_PRESERVE);
ROWS                    return(ROWS);
REFERENCES              return(REFERENCES);
FOREIGN\ KEY            return(FOREIGN_KEY);
ON\ UPDATE              return(ON_UPDATE);
ON\ DELETE              return(ON_DELETE);
NOT\ NULL               return(NOT_NULL);
UNIQUE                  return(UNIQUE);
PRIMARY\ KEY            return(PRIMARY_KEY);
CASCADE     |
SET\ NULL   |
SET\ DEFAULT |
NO\ ACTION                                  return(TRIGGER_ACTION);

DATE                                            return(DATE);
TIME                                            return(TIME);
NUMERIC                                         return(NUMERIC);   
INTEGER                                         return(INTEGER);
FLOAT                                           return(FLOAT);
REAL                                            return(REAL);
CHAR                                            return(CHAR);
VARCHAR                                         return(VARCHAR);

{identifier}           return(IDENTIFIER);
{number}                return(NUMBER);

,           return(COMMA);
\n          { 
                line++; 
            };
[ \t]+      ;
\(          return(LB) ;
\)          return(RB) ;
;           return(SEMICOLON) ;
.           return(yytext[0]);
                    

%%

void main(int argc, char* argv[]) {
  FILE *myfile = fopen("test.txt", "r");
  if (!myfile) {
    printf("Problem with opening file!");
    return -1;
  }
  yyin = myfile;
  
  yyparse();
  exit(0);
  
}

int yywrap(){
    return(1);
}







