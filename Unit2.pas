unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, Grids;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Panel3: TPanel;
    PaintBox1: TPaintBox;
    Panel4: TPanel;
    Button5: TButton;
    Button2: TButton;
    Button3: TButton;
    Timer2: TTimer;
    Panel5: TPanel;
    Edit6: TEdit;
    Label4: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    Label11: TLabel;
    Edit11: TEdit;
    Label6: TLabel;
    Label12: TLabel;
    Edit12: TEdit;
    Edit13: TEdit;
    Label13: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    TabControl1: TTabControl;
    Shape1: TShape;
    Memo1: TMemo;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    Panel2: TPanel;
    Panel6: TPanel;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    Timer1: TTimer;
    TrackBarRazmer: TTrackBar;
    PaintBox2: TPaintBox;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel7: TPanel;
    Timer3: TTimer;
    PanelGraph: TPanel;
    CheckBox3: TCheckBox;
    //procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarRazmerChange(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  kf=0.91;
var
  Form2: TForm2;
  //vx,vy- скорости; ax,ay- ускорения; fx,fy- силы;
  //dt- время; m- масса; ro- приц. параметр;
  vx,vy,ax,ay,fx,fy,dt,m,ro:real;
  F,r,alpha,v,q1,Q2,h:extended;
  x1,y1,x,y:real; stop:boolean;
  u0,v0,mx,my,zele,dr:integer;
  fool:boolean;
implementation

uses Math, DateUtils;

{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
  if (Timer2.Enabled=true) then begin
    Button2.Caption:='Play';
    Timer2.Enabled:=false;
  end
  else begin
    Button2.Caption:='Stop';
    Timer2.Enabled:=true;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  Timer2.Enabled:=false;
  ShowMessage('Программа закрывается, пока, пока!');
  close;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  u0:=PaintBox1.Width div 2;
  v0:=PaintBox1.Height-TrackBarRazmer.Position*10-10;
  PaintBox1.Width:=Panel4.Width;
  PaintBox1.Height:=Panel4.Height;
  Form2.Caption:='Формула Резерфорда';
  //----------------------
  m:=StrToFloat(Edit1.Text);
  dt:=StrToFloat(Edit7.Text);
  ro:=StrToFloat(Edit5.Text);
  v:=StrToFloat(Edit2.Text);
  h:=strtofloat(Edit4.Text);
    if h=0 then h:=0.0000001;
  q1:=strtoFloat(Edit3.Text);
  Q2:=strtoFloat(Edit8.Text);
  x1:=(-1)*abs(h); y1:=ro;
  x:=x1; y:=y1; vx:=v; vy:=0;
  Button2.Caption:='Stop';
  Shape1.Parent:=Panel4;
  Shape1.BringToFront;
  Shape1.Height:=6;
  Shape1.Width:=6;
  //----------------------
  Timer1.Enabled:=true;  Timer2.Enabled:=true;   Timer3.Enabled:=true;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  zele:=0;
  fool:=false;
  Timer1.Enabled:=false;
  Timer2.Enabled:=false;
  Form2.ClientHeight:=328;
  StringGrid2.Cells[0,0]:='№ опыта';
  StringGrid1.Cells[0,0]:='Vначал.';
  StringGrid1.Cells[1,0]:='Vвыхода';
  StringGrid1.Cells[2,0]:='Alpha';
  StringGrid3.Cells[0,0]:='р*V^2/sin^2 (A/2)';
  Shape2.Parent:=PanelGraph; Shape3.Parent:=PanelGraph; Shape4.Parent:=PanelGraph;
  Shape2.Left:=308; Shape3.Left:=308; Shape4.Left:=308;
  Shape2.Top:=120;  Shape3.Top:=120;  Shape4.Top:=120;
end;
//_??___??__????___??????__??__??_\\
//_???_???_??__??____??____???_??_\\
//_??_?_??_??????____??____??_???_\\
//_??___??_??__??____??____??__??_\\
//_??___??_??__??__??????__??__??_\\
procedure TForm2.Timer1Timer(Sender: TObject);
var hi:extended;
begin
  if ((shape1.Left<=0)or(shape1.Left>=PaintBox1.Width)or(shape1.top<=0)or(shape1.Top>=PaintBox1.Height)) or ((Shape1.Left>u0-kf*dr)and(Shape1.Left<u0+kf*dr)and(Shape1.Top>v0-kf*dr)and(Shape1.Top<v0+dr*kf))
  then begin
    Timer2.Enabled:=false; zele:=zele+1; Timer1.Enabled:=false;
    Form2.Caption:='Опыт № '+IntToStr(zele)+' завершен.';
    hi:=ro*sqr(StrToFloat(Edit12.Text))/ ( Sqr(Sin (alpha/2)) );
    if zele>=StringGrid1.RowCount then begin
      //Panel6.Height:=Panel6.Height+StringGrid1.DefaultRowHeight+2;
      StringGrid1.RowCount:=StringGrid1.RowCount+1;
      StringGrid2.RowCount:=StringGrid2.RowCount+1;
      StringGrid3.RowCount:=StringGrid3.RowCount+1;
      StringGrid1.Height:=StringGrid1.RowCount*StringGrid1.DefaultRowHeight;
      StringGrid2.Height:=StringGrid2.RowCount*StringGrid2.DefaultRowHeight;
      StringGrid3.Height:=StringGrid3.RowCount*StringGrid3.DefaultRowHeight;
      Panel6.Height:=StringGrid3.Height+5;
      Form2.height:=Form2.height+StringGrid3.DefaultRowHeight;
    end;
      StringGrid2.Cells[0,zele]:=IntToStr(zele);
      StringGrid1.Cells[0,zele]:=FloatToStr(v);
      StringGrid1.Cells[1,zele]:=Edit12.Text;
      StringGrid1.Cells[2,zele]:=FloatToStr(alpha);
      StringGrid3.Cells[0,zele]:=FloatToStr(hi);
  end;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
var xk,yk:integer; v:extended;
  procedure koord(x,y:real; var xk,yk:integer);
  begin
    xk:=u0+Round(x*mx);
    yk:=v0-Round(y*my);
  end;
  {=------ ЧУШЬ! ------=}
Begin
  //----------------------
  r:=sqrt(sqr(x)+sqr(y));
  F:=(q1*Q2) / sqr(r);
  fx:=f*x/r; fy:=f*y/r;
  ax:=fx/m; ay:=fy/m;
  vx:=vx+(ax*dt); //рассеяние
  vy:=vy+(ay*dt); // частицы
  x:=x+vx*dt;  y:=y+vy*dt;
  //----------------------
  with PaintBox1.Canvas do
  begin
    koord(x,y,xk,yk);
    Shape1.Left:=xk;  Shape1.Top:=yk;
    Shape1.BringToFront;
  end;
  //----------------------
  v:=sqrt(sqr(vx)+sqr(vy));
  //alpha:=ArcTan2(vy/vx,1);
  alpha:=ArcTan(vy/vx);
  //----------------------
  Edit6.Text:=FloatToStr(y);
  Edit9.Text:=FloatToStr(vx);
  Edit10.Text:=FloatToStr(vy);
  Edit11.Text:=FloatToStr(x);
  Edit12.Text:=FloatToStr(v);
  Edit13.Text:=FloatToStr(alpha);
  //----------------------
End;

procedure TForm2.Timer3Timer(Sender: TObject);
begin
  if CheckBox1.State=cbChecked then begin
    Shape2.Left:=Round(mx*ArcTan(vy/vx));
    Shape2.Top:=Round(Shape2.Top-dt*160);
    Shape2.BringToFront;
  end;
  if CheckBox2.State=cbChecked then begin
    Shape3.Left:=Round(mx*sqrt(sqr(vx)+sqr(vy)));
    Shape3.Top:=Round(Shape3.Top-dt*160);
    Shape3.BringToFront;
  end;
  if CheckBox3.State=cbChecked then begin
    Shape4.Left:=Round(mx*(q1*Q2) / sqr(r));
    Shape4.Top:=Round(Shape4.Top-dt*160);
    Shape4.BringToFront;
  end;
end;

//_____________________________________________\\
  //_______________________________________________\\
procedure TForm2.TrackBarRazmerChange(Sender: TObject);
  //_______________________________\\
  procedure osi(u0,v0,mx,my:integer; x,y:string);
  var {nadpis}u,v,dl,sh:integer;   //s:string;
  begin
    dl:=PaintBox1.Width;
    sh:=PaintBox1.Height;
    with PaintBox1.Canvas do
    begin
      Pen.Width:=1;
      brush.Color:=clwhite;
      rectangle(0,0,dl,sh);
      pen.Color:=clred;
      moveto(u0,0);
      lineto(u0,sh);
      moveto(0,v0);
      lineto(dl,v0);
      //********************
      u:=u0 mod mx;
      while u<dl do
      begin
        moveto(u,v0+5);
        lineto(u,v0-5);
        u:=u+mx;
      end;
      v:=v0 mod my;
      while v<sh do
      begin
        moveto(u0-5,v);
        lineto(u0+5,v);
        v:=v+my;
      end;
    end;

    dl:=PaintBox2.Width;
    sh:=PaintBox2.Height;
    with PaintBox2.Canvas do
    begin
      Pen.Width:=1;
      brush.Color:=clwhite;
      rectangle(0,0,dl,sh);
      pen.Color:=clred;
      moveto(u0,0);
      lineto(u0,sh);
      moveto(0,PaintBox2.Height div 2);
      lineto(dl,PaintBox2.Height div 2);
      //********************
      u:=u0 mod mx;
      while u<dl do
      begin
        moveto(u,PaintBox2.Height div 2 +5);
        lineto(u,PaintBox2.Height div 2 -5);
        u:=u+mx;
      end;
      v:=v0 mod my;
      while v<sh do
      begin
        moveto(u0-5,v);
        lineto(u0+5,v);
        v:=v+my;
      end;
    end;
  end;
  //_______________________________\\
begin
  Panel4.Visible:=true;
  u0:=PaintBox1.Width div 2;
  v0:=PaintBox1.Height-Round(TrackBarRazmer.Position*16.4);
  mx:=15*TrackBarRazmer.Position;
  my:=15*TrackBarRazmer.Position;
  dr:=TrackBarRazmer.Position*5;
  osi(u0,v0,mx,my,'X','Y');
  PaintBox1.Width:=Panel4.Width;
  PaintBox1.Height:=Panel4.Height;
  PaintBox1.Color:=clBtnText;
  with PaintBox1.Canvas do begin
    brush.Color:=clWhite;
    Pen.Color:=clRed;
    Pen.Width:=TrackBarRazmer.Position div 2;
    Ellipse(u0-dr,v0-dr,u0+dr,v0+dr);
  end;
end;

procedure TForm2.TabControl1Change(Sender: TObject);
begin
  If TabControl1.TabIndex=0 then begin
    Form2.ClientHeight:=328;
    Form2.ClientHeight:=Form2.ClientHeight+Panel6.Height+4;
    TabControl1.Width:=Panel6.Width;
    Memo2.Visible:=false;
    Memo1.Visible:=false;
    panel6.Visible:=true;
    Panel7.Visible:=false;
    PaintBox2.Visible:=false;
    StringGrid1.Visible:=true;
    StringGrid2.Visible:=true;
    StringGrid3.Visible:=true;
    StringGrid1.BringToFront;
    StringGrid2.BringToFront;
    StringGrid3.BringToFront;
    PanelGraph.Visible:=false;
  end;
  If TabControl1.TabIndex=1 then begin
    Form2.ClientHeight:=328;
    Form2.ClientHeight:=Form2.ClientHeight+Memo1.Height+4;
    TabControl1.Width:=Memo1.Width+2;
    StringGrid1.Visible:=false;
    StringGrid2.Visible:=false;
    StringGrid3.Visible:=false;
    Panel6.Visible:=False;
    Panel7.Visible:=false;
    PaintBox2.Visible:=false;
    Memo2.Visible:=false;
    Memo1.Visible:=true;
    Memo1.BringToFront;
    PanelGraph.Visible:=false;
  end;
  If TabControl1.TabIndex=2 then begin
    Form2.ClientHeight:=328;
    Form2.ClientHeight:=Form2.ClientHeight+Memo2.Height+4;
    TabControl1.Width:=Memo2.Width+2;
    StringGrid1.Visible:=false;
    StringGrid2.Visible:=false;
    StringGrid3.Visible:=false;
    PaintBox2.Visible:=false;
    Panel6.Visible:=False;
    Panel7.Visible:=false;
    Memo1.Visible:=false;
    Memo2.Visible:=true;
    Memo2.BringToFront;
    PanelGraph.Visible:=false;
  end;
  if TabControl1.TabIndex=3 then begin
    PaintBox2.Visible:=true;
    Panel7.Visible:=true;
    Form2.ClientHeight:=328;
    Form2.ClientHeight:=Form2.ClientHeight+PaintBox2.Height+4;
    TabControl1.Width:=Memo2.Width+2;
    StringGrid1.Visible:=false;
    StringGrid2.Visible:=false;
    StringGrid3.Visible:=false;
    Panel6.Visible:=False;
    Memo1.Visible:=false;
    Memo2.Visible:=true;
    Memo2.BringToFront;
    PanelGraph.Visible:=true;
    PanelGraph.BringToFront;
  end;

end;

END.
