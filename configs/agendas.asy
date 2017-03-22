
// tried pens:
//   magenta4, white, gold2, DarkOliveGreen3, cyan3, pink, firebrick3, gray70, 

agenda urgent = newAgenda("open word"); urgent.fillPen = firebrick3;
urgent.weight *= 3;
//agendas.push(urgent);

agenda pcom = newAgenda("rewrite pcom"); pcom.fillPen = gold2;
//agenda pcom = newAgenda("use core force"); pcom2.fillPen = yellow;
pcom.weight *= 1;
agendas.push(pcom);

//agenda paper_1 = newAgenda("Read Bryan1967"); paper_1.fillPen = gray20;
agenda paper_1 = newAgenda("Griffies 2009"); paper_1.fillPen = gray40;
//agenda paper_1 = newAgenda("Read Bryan1968"); paper_1.fillPen = gray20;
paper_1.weight *= 1;
agendas.push(paper_1);

agenda roms = newAgenda("ROMES upwelling"); roms.fillPen = magenta4;
roms.weight *= 1;
agendas.push(roms);

agenda fvbook_1 = newAgenda("CFD-FV ch3"); fvbook_1.fillPen = white;
//agenda fvbook_1 = newAgenda("FV in Met."); fvbook_1.fillPen = white;
fvbook_1.weight *= 1;
agendas.push(fvbook_1);
