all: cobra
cobra.tab.c cobra.tab.h:	cobra.y
	bison -t -v -d cobra.y
lex.yy.c: cobra.lex cobra.tab.h
	flex cobra.lex
cobra: lex.yy.c cobra.tab.c cobra.tab.h
	g++ -o cobra cobra.tab.c lex.yy.c
clean:
	rm cobra cobra.tab.c lex.yy.c cobra.tab.h cobra.output