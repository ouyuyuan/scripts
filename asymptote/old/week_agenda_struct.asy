agenda chi = newAgenda("Read Shi Ji");
chi.fillPen = gold2;
chi.period.push((1,6));
chi.period.push((2,7));
chi.period.push((3,8));
chi.period.push((4,9));
chi.period.push((5,10));
chi.period.push((6,11));
chi.period.push((7,12));
agendas.push(chi);

agenda phy = newAgenda("Feynman Physics");
phy.fillPen = gray70;
phy.period.push((1,3));
phy.period.push((2,4));
phy.period.push((3,5));
phy.period.push((4,6));
phy.period.push((5,7));
phy.period.push((6,8));
phy.period.push((7,9));
agendas.push(phy);

agenda en = newAgenda("NCE4");
en.fillPen = SpringGreen3;
en.period.push((1,11));
en.period.push((2,12));
en.period.push((3,1));
en.period.push((4,2));
en.period.push((5,3));
en.period.push((6,4));
en.period.push((7,5));
agendas.push(en);

agenda occ = newAgenda("Occupied"); // (week, period)
occ.period.push((1,5)); // fitness
occ.period.push((4,5)); // fitness
agendas.push(occ);

agenda job = newAgenda("Plot daily log"); job.fillPen = cyan3;
job.weight = stdWei*8;
agendas.push(job);

//agenda job = newAgenda("Linear Algebra");
//agenda job = newAgenda("FAMIL website"); job.fillPen = DarkOliveGreen2;
//agenda job = newAgenda("Dynamic Core"); job.fillPen = magenta4;
//agenda job = newAgenda("Plot daily log"); job.fillPen = cyan3;
//agenda temp = newAgenda("Graphviz");
//agenda temp = newAgenda("mom5 github");
//agenda boo = newAgenda("Fund. of OCM");
//agenda boo = newAgenda("Fluid Dynamics");
//agenda job = newAgenda("Thomas' Calculus"); job.fillPen = pink1;
//agenda cod = newAgenda("Code GPEM");
//agenda cod = newAgenda("Read PCOM");
//agenda lan = newAgenda("Ferret");
//agenda mat = newAgenda("Tensor");
//agenda job = newAgenda("Read paper"); job.fillPen = white;
