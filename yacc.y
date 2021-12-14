%{
    #include <stdio.h>
    #include <locale.h>
    #define YYERROR_VERBOSE 1

    int yylex();
    int yywrap();
    extern int line;
    int errcount = 1;
 
    void yyerror(const char *s);

    void yyerror(const char *str) {
      fprintf(stderr,"error: %s in line %d", str, line);
    }
%}

%token  CREATE 
        GLOB_LOC 
        TEMPORARY 
        TABLE 
        ON_COMMIT 
        DELETE_PRESERVE 
        ROWS 
        REFERENCES
        FOREIGN_KEY 
        ON_UPDATE 
        ON_DELETE 
        PRIMARY_KEY
        NOT_NULL
        UNIQUE
        TRIGGER_ACTION
        DATE 
        TIME 
        NUMERIC   
        INTEGER 
        REAL 
        FLOAT 
        CHAR 
        VARCHAR 
        IDENTIFIER 
        NUMBER 
        COMMA 
        RB 
        LB 
        SEMICOLON

%start base

%%

base:     
    base create SEMICOLON           {printf("-----------------good----------------- \n")}|
    create SEMICOLON                {printf("-----------------good----------------- \n")};


create:   
    CREATE first_params TABLE table_name LB elements RB second_params;


table_name:
    IDENTIFIER;

first_params:    
    |
    GLOB_LOC TEMPORARY;

second_params:      
    |
    ON_COMMIT DELETE_PRESERVE ROWS;

elements:   
    element |
    elements COMMA element;

element: 
    constraint_def |
    field_def;

constraint_def: 
    unique_constr|
    link_constr;

unique_constr: 
    UNIQUE LB field_name_list RB        |
    PRIMARY_KEY LB field_name_list RB   |
    PRIMARY_KEY LB error RB {errorEvent("Wrong PRIMARY KEY decration")} ;

link_constr: 
    FOREIGN_KEY field_name_list link_spec;

link_spec: 
    REFERENCES table_name                               |
    REFERENCES table_name LB field_name_list RB         |
    REFERENCES table_name trigger_act                   |
    REFERENCES table_name LB field_name_list RB trigger_act  ;

trigger_act:    
    ON_UPDATE TRIGGER_ACTION|
    ON_DELETE TRIGGER_ACTION|
    ON_UPDATE TRIGGER_ACTION ON_DELETE TRIGGER_ACTION;

field_name_list: 
    field_name                          |
    field_name_list COMMA field_name    | 
    LB field_name_list RB               |
    field_name_list error field_name  {errorEvent("Need a COMMA in fiels declaration")}  ;

field_def:  
    field_name field_type | 
    field_name field_type field_constrs;

field_name:
    IDENTIFIER;

field_constrs: 
    field_constr |
    field_constrs field_constr;

field_constr:   
    NOT_NULL            |
    UNIQUE              |
    PRIMARY_KEY         ;

field_type:     
    numeric_type  |
    char_type     |
    datetime_type ;

numeric_type:   
    NUMERIC LB NUMBER COMMA NUMBER RB |
    NUMERIC LB NUMBER RB              |
    NUMERIC LB error RB  {errorEvent("Wrong NUMERIC type")}|
    NUMERIC                           |
    INTEGER                           |
    FLOAT LB NUMBER RB                |
    FLOAT                             |
    REAL                              ;

char_type:      
    CHAR LB NUMBER RB     |
    CHAR LB error RB  {errorEvent("Wrong CHAR type")}|
    CHAR                  |
    VARCHAR LB NUMBER RB  |
    VARCHAR LB error RB  {errorEvent("Wrong VARCHAR type")}|
    VARCHAR               ;

datetime_type:  
    DATE              |
    TIME              |
    TIME LB NUMBER RB ;
%%

void errorEvent(const char *errstr)
{
    fprintf(stderr, "\nerror: %s in line %d, current error: %d \n", errstr, line, errcount);
    errcount++;
    if (errcount > 3) {exit(-1);}
}





