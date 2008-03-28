ruby$target:::ruby-probe
{
	printf("cpu: %d - %s '%s'", cpu, copyinstr(arg0), copyinstr(arg1))
}