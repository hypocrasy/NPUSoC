module mem16384x16(CENY,WENY,AY,GWENY,Q,SO,CLK,CEN,WEN,A,D,EMA,EMAW,TEN,TCEN,TWEN,TA,TD,GWEN,TGWEN,RET1N,SI,SE,DFTRAMBYP);
inout  CENY;
inout  WENY;
inout  AY;
inout  GWENY;
output [15:0]Q;
inout  SO;
input  CLK;
input  CEN;
input  [15:0]WEN;
input  [13:0]A;
input  [15:0]D;
input  [2:0]EMA;
input  [1:0]EMAW;
input  [31:0]TEN;
input  [31:0]TCEN;
input  [15:0]TWEN;
input  [13:0]TA;
input  [15:0]TD;
input  GWEN;
input  [31:0]TGWEN;
input  [31:0]RET1N;
input  [1:0]SI;
input  [31:0]SE;
input  [31:0]DFTRAMBYP;
endmodule

module mem512x64(Q,CLK,CEN,WEN,A,D,EMA,EMAW,RET1N);
output [63:0]Q;
input  CLK;
input  CEN;
input  WEN;
input  [8:0]A;
input  [63:0]D;
input  [2:0]EMA;
input  [1:0]EMAW;
input  RET1N;
endmodule

module mem512x32(Q,CLK,CEN,WEN,A,D,EMA,EMAW,RET1N);
output [31:0]Q;
input  CLK;
input  CEN;
input  WEN;
input  [8:0]A;
input  [31:0]D;
input  [2:0]EMA;
input  [1:0]EMAW;
input  RET1N;
endmodule

