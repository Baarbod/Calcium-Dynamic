function P = initparamlist(varargin)

Data = load(['C:\Users\Baarbod\Desktop\local_repos\calcium_sandbox\'...
    'parameter_sets\Typical_Case.mat']);

fname = char(fieldnames(Data));
P = Data.(fname);

return



P.volCt.Value = 0.75;       P.volCt.Unit = 'pL';
P.volMd.Value = 0.3;        P.volMd.Unit = 'pL';   
P.volER.Value = 0.1;        P.volER.Unit = 'pL';
P.volMt.Value = 0.05;       P.volMt.Unit = 'pL';
P.Jin.Value = 0.08;         P.Jin.Unit = 'uM/s';
P.Vpmca.Value = 0.32;       P.Vpmca.Unit = 'uM/s';
P.kpmca.Value = 1;          P.kpmca.Unit = 'uM';
P.Vip3r.Value = 0.41;        P.Vip3r.Unit = 'uM/s';
P.Vserca.Value = 40;        P.Vserca.Unit = 'uM/s';
P.kserca.Value = 0.2;       P.kserca.Unit = 'uM';
P.ip3.Value = 0.47;         P.ip3.Unit = 'uM';
P.Vmcu.Value = 0.65;        P.Vmcu.Unit = 'uM/s';
P.kmcu.Value = 1.5;         P.kmcu.Unit = 'uM';
P.Vncx.Value = 80;          P.Vncx.Unit = 'uM/s';
P.kncx.Value = 35;          P.kncx.Unit = 'uM';
P.kna.Value = 9.4;          P.kna.Unit = 'mM';
P.N.Value = 10;             P.N.Unit = 'mM';
P.N_u.Value = 10;           P.N_u.Unit = 'mM';
P.leak_e_u.Value = 0.01;    P.leak_e_u.Unit = '1/s';
P.leak_e_c.Value = 0.01;    P.leak_e_c.Unit = '1/s';
P.leak_u_c.Value = 0.02;    P.leak_u_c.Unit = '1/s';
P.leak_u_m.Value = 0;    P.leak_u_m.Unit = '1/s';
P.cI.Value = 0.23;           P.cI.Unit = '';
P.cS.Value = 0.1;           P.cS.Unit = '';
P.cM.Value = 0.02;           P.cM.Unit = '';
P.cN.Value = 0.31;           P.cN.Unit = '';
P.bt_c.Value = 220;         P.bt_c.Unit = 'uM';
P.K_c.Value = 10;           P.K_c.Unit = '';
P.bt_e.Value = 220;         P.bt_e.Unit = 'uM';
P.K_e.Value = 10;           P.K_e.Unit = '';
P.bt_m.Value = 220;         P.bt_m.Unit = 'uM';
P.K_m.Value = 10;           P.K_m.Unit = '';
P.bt_u.Value = 220;         P.bt_u.Unit = 'uM';
P.K_u.Value = 10;           P.K_u.Unit = '';
P.a2.Value = 0.02;          P.a2.Unit = '1/(uM*s)';
P.d1.Value = 0.018;         P.d1.Unit = 'uM';
P.d2.Value = 1.5;           P.d2.Unit = 'uM';
P.d3.Value = 0.18;          P.d3.Unit = 'uM';
P.d5.Value = 0.2;           P.d5.Unit = 'uM';





