import std.stdio;
import std.concurrency;

void worker(int i)
{
    Tid neib;
    int N;
    bool stop = false;

    receive((Tid message) { neib = message; });

    while (!stop)
    {
        receive(
            (int message)
            {
                N = message;
            },
            (Variant message)
            {
                stop = true;
            });
        if (N == 0)
        {
            ownerTid.send(i);
        }
        else
        {
            neib.send(N-1);
        }
    }
}

void main ()
{
    Tid[503] w;

    // create
    for (int i = 0; i < w.length; i++)
    {
        w[i] = spawn(&worker, i+1);
    }

    // set
    for (int i = 0; i < w.length - 1; i++)
    {
        w[i].send(w[i+1]);
    }
    w[$-1].send(w[0]);

    // start
    w[0].send(123456);

    receive(
        (int message) { writeln(message); }
    );
    // 222
}
