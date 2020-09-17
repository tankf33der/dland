import std.stdio;
import std.bitmanip;
import std.bigint;
import std.random;

uint urandom()
{
	auto f = File("/dev/urandom", "r");
	scope(exit) f.close();
	auto buf = f.rawRead(new ubyte[4]);
	return buf.read!uint();
}

// Input: n is always > 2 and odd
// easy probably prime based on Miller-Rabin
bool isPrime(in BigInt n)
{
	BigInt d = n - 1;
	ulong s = 0;
	while(d % 2 == 0)
	{
		d /= 2;
		s++;
	}

	outer:
	foreach (immutable _; 0..32)
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
	//auto f = File("composit.dat", "r");
	auto f = File("/root/composit-dat/psps-below-2-to-64.txt", "r");
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
}
