import std.stdio;
import std.concurrency;

const N = 2;

void worker(int index)
{
    uint N = 0;

    receive(
        (uint s, uint e) {
            writeln(index, " got new range: ", s, ":", e-1);
        });
}

void main ()
{
    Tid[N] w;
    uint N = 3;

    // create
    for (int i = 0; i < w.length; i++)
    {
        w[i] = spawn(&worker, i);
        w[i].send(N, N+4);
        N = N+4;
    }

    writeln("start");
}
