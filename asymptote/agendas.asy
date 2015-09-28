agenda chi = newAgenda("Read China Daily");
chi.fillPen = gold2;
chi.period.push((1,14));
chi.period.push((3,14));
chi.period.push((5,14));
chi.period.push((7,14));
//agendas.push(chi);

agenda cctv = newAgenda("Watch CCTV news"); cctv.fillPen = magenta4;
//cctv.period.push((1,7));
//cctv.period.push((2,6));
//cctv.period.push((3,5));
//cctv.period.push((4,4));
//cctv.period.push((5,3));
//cctv.period.push((6,1));
//cctv.period.push((7,2));
cctv.weight = 3;
agendas.push(cctv);

agenda en = newAgenda("Lean In"); en.fillPen = gray70;
en.period.push((2,14));
en.period.push((4,14));
en.period.push((6,14));
//agendas.push(en);

//agenda occ = newAgenda("Occupied"); // (week, period)
//occ.period.push((1,5)); // fitness
//occ.period.push((4,5)); // fitness
//agendas.push(occ);

agenda job = newAgenda("read PCOM GM90"); job.fillPen = white;
agendas.push(job);

agenda job2 = newAgenda("MPI"); job2.fillPen = firebrick3;
agendas.push(job2);

agenda job3 = newAgenda("Data Analysis"); job3.fillPen = DarkOliveGreen3;
//job3.weight = 18;
agendas.push(job3);

//agenda job4 = newAgenda("Ocean Model Fund."); job4.fillPen = cyan3;
agenda job4 = newAgenda("Learn tensor"); job4.fillPen = cyan3;
agendas.push(job4);

agenda job5 = newAgenda("Learn git"); job5.fillPen = pink;
job5.weight = 14;
agendas.push(job5);
