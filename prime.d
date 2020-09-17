import std.stdio;
import std.bitmanip;
import std.bigint;
import std.random;

uint urandom() @safe
{
	auto f = File("/dev/urandom", "r");
	scope(exit) f.close();
	auto buf = f.rawRead(new ubyte[4]);
	return buf.read!uint();
}

// Input: n is always > 2 and odd
// easy probably prime based on Miller-Rabin
// works on n > 1024
bool isPrime(in BigInt n) @safe
{
	if (n > 2 && !(n & 1))
	{
		return false;
	}

	BigInt d = n - 1;
	ulong s = 0;
	while(!(d & 1))
	{
		d /= 2;
		s++;
	}

	outer:
	foreach (immutable _; 0..8)
	{
		ulong a = uniform(2, 1024);
		BigInt b = n / a;
		BigInt x = powmod(b, d, n);
		if (x == 1 || x == n - 1)
			continue;
		foreach (immutable __; 1 .. s)
		{
			x = powmod(x, BigInt(2), n);
			if (x == 1)
				return false;
			if (x == n - 1)
				continue outer;
		}
		return false;
	}
	return true;
}

void main()
{
	auto f = File("composit.dat", "r");
	scope(exit) f.close();

	auto rnd = Random(urandom());
	auto n = 0;
	BigInt a;

	foreach(line; f.byLine())
	{
		a = cast(BigInt)line;
		if (isPrime(a))
		{
			writeln("found prime: ", a);
		}
	}
	// true
	writeln(isPrime(cast(BigInt)"4547337172376300111955330758342147474062293202868155909489"));
	writeln(isPrime(cast(BigInt)"643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153"));

	// false
	writeln(isPrime(cast(BigInt)"4547337172376300111955330758342147474062293202868155909393"));
	writeln(isPrime(cast(BigInt)"743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153"));
}
