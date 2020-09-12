import std.stdio;
import std.concurrency;
import core.thread;

void worker(int i)
{
    Tid neib;
    Tid owner = ownerTid();
    uint N;
    bool stop = false;

    //writeln("starting: ", i, " ", thisTid());
    receive((Tid message) { neib = message; });

    while (!stop)
    {
        receive(
            (uint message)
            {
                N = message;
                //writeln(i, " got N: ", N);

            },
            (Tid  message)
            {
                neib = message;
                //writeln(i, " got neib: ", neib);
            },
            (Variant message) { stop = true; }
            );
        //if (stop) break;
        //N--;
        //Thread.sleep(1.seconds);
        if (N == 0) {
            //writeln(i, " fin to ", owner, ": ", N);
            owner.send(i);
            // XXX
            //break;
        }
        else
        {
            //writeln(i, " sending to ", neib, ": ", N);
            neib.send(N-1);
        }
    }
}

void main ()
{
    Tid[503] w;
    uint fin;
    for (int i = 0; i < w.length; i++) {
        w[i] = spawn(&worker, i+1);
    }
    for (int i = 0; i < w.length - 1; i++) {
        w[i].send(w[i+1]);
    }
    w[$-1].send(w[0]);

    uint start = 123456;
    w[0].send(start);

    //writeln("owner is ready");
    receive(
        (int message) { writeln("fin: ", message); }
    );
    //writeln("fin: ", fin);
    // fin: 222 (503, 123456)
    //        3 (5  , 12    )
}
