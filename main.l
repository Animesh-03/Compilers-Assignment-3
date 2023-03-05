%{
	#include <stdio.h>
    #include<limits.h>
    #include <string.h>

    char d[10];
    int maxValue = INT_MIN, nTransactions = 0, total = 0;
    char currentID[256], maxID[256];
%}

ws [\t ]*
initRecord "$"{ws}
custId [A-Z]+[0-9]+
date [0-9][0-9]"/"[0-9][0-9]
val [0-9]+
record [0-9][0-9]"/"[0-9][0-9]{ws}[0-9]+{ws}";"{ws}

%s INITRECORD
%s CUSTID
%s VAL
%%

<INITIAL>{initRecord} {
    BEGIN(INITRECORD); 
    // printf("Starting Record\n");
    strcpy(currentID, "");
}

\n {
    BEGIN(INITIAL);
}

<INITRECORD>{custId} {
    BEGIN(CUSTID); 
    // printf("Found custID: %s\n", yytext);
    strcpy(currentID, yytext);
}

<CUSTID>{date} {
    if(strcmp(yytext, d) == 0) {
        // printf("Found Date: %s for CustID: %s\n", yytext, currentID);
        nTransactions++;
        BEGIN(VAL);
    }
}

<VAL>{val} {
    int val = atoi(yytext);
    printf("Found val: %d\n", val);
    total += val;
    if(maxValue < val)
    {
        printf("Increasing val to %d and maxID to %s\n", val, currentID);
        maxValue = val;
        strcpy(maxID, currentID);
    }
}

<VAL>";" {
    BEGIN(CUSTID);
}

%%

int yywrap()
{ 
return 1;
}

int main()
{
    FILE* f = fopen("input.txt", "r");
    fscanf(f, "%s", d);

    yyin = fopen("data.txt", "r");
    FILE* out = fopen("output.txt", "w+");
    yyout = fopen("out.txt", "w+");
    yylex();
    printf("CustID: %s Max Val: %d Transactions: %d Total: %d\n", maxID, maxValue, nTransactions, total);
    fprintf(out,"$%d$%s#", nTransactions, maxID);
    

    return 0;
}