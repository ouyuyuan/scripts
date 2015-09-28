
use 5.010;
use strict;

say (300/200);
say int(300/200);
say int(300/200+0.5);

#test();
#test();
#test();

sub test {
    state $i = 0;
    $i += 1;
}
