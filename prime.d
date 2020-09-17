import std.stdio;
import std.file;
import std.bigint;

void main()
{
	auto f = File("tests.dat", "r");
	BigInt a;
	foreach(char[] line; f.byLine())
	{
		a = cast(BigInt)line;
	}
	writeln("start", a);
}
