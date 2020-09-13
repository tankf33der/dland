import std.stdio;
import std.concurrency;

const N = 2;

void worker(int index)
{
    uint Ns = 0;
    uint Ne = 0;
    bool stop = false;
    while (!stop)
    {
        // getting range for calculating
        receive(
            (uint s, uint e) {
                writeln(index, " got new range: ", s, ":", e-1);
                Ns = s;
                Ne = e;
            },
            (Variant _) { stop = true; }
            );
        // processing range of numbers
        //writeln(index, " processing range: ", Ns, ":", Ne-1);
        //done, send me next
        ownerTid.send(thisTid, true);
    }
}

void main ()
{
    Tid[N] w;
    uint N = 1;
    uint Ne = 100000;

    // create
    for (int i = 0; i < w.length; i++)
    {
        w[i] = spawn(&worker, i);
        w[i].send(N, N+Ne);
        N = N+Ne;
    }

    // feed numbers
    for (int i = 0; i < 11; i++)
    {
        receive(
            (Tid sender, bool _)
            {
                sender.send(N, N+Ne);
                N = N+Ne;
            });
    }

    // stop all workers
    for (uint i = 0; i < w.length; i++)
    {
        w[i].send(true);
    }
}
