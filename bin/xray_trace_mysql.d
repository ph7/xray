#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option dynvarsize=64m


/*
 * Inspired by Joyent's http://www.joyeur.com/2007/10/03/using-dtrace-on-mysql
 */
 
/*
 * MySQL query parsing (captures all incoming queries)
 */
 
 /* TODO For example we can see what queries are executed the most: => Top 10 queries */
pid*::*mysql*:entry
{
    printf("%Y %s\n", walltimestamp, copyinstr(arg1));
}


/*
 * Now lets say we want to find out how long a query took to execute. 
 * The function mysql_execute_command does the actual execution of 
 * the queries so all we do here is subtract the entry and return 
 * timestamps of this function.
 */
pid*:mysqld:*mysql_execute_command*:entry
{
    printf("OK");
}
