ruby$target:::ruby-probe
{
	printf("%d cpu: %d - %s '%s'", timestamp, cpu, copyinstr(arg0), copyinstr(arg1))
}
