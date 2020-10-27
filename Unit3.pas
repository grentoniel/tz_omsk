unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON,
  IdBaseComponent, IdComponent,IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  Vcl.Grids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  IdThreadComponent, Vcl.ExtCtrls, IniFiles;
type
  TMyCurr = record
    nom:string;
    high:string;
    low:string;
    volume:string;
    quotevolume:string;
    percent:string;
    changeat:string;
  end;

  TForm3 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    StringGrid1: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDQuery1: TFDQuery;
    IdReqThread: TIdThreadComponent;
    FirstLoadTimer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdReqThreadRun(Sender: TIdThreadComponent);
    procedure FirstLoadTimer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form3: TForm3;
  stroka,s1:String;
  getted_json:TJSONObject;
  JSonValue: TJSONValue;
  JSonAr_lvl1:TJSONArray;
  Icounter:integer;
  Currency:array [1..2000] of TMyCurr;
  Kol_kur:integer;
  ini: TIniFile;

implementation

{$R *.dfm}

procedure PrepareStringGrid (Grd:TStringGrid);
begin
  for Icounter := 0 to Grd.ColCount-1 do
  begin
    Grd.Cols[Icounter].Clear;
  end;
  Grd.Cells[0,0]:='Symbol';
  Grd.Cells[1,0]:='HIgh';
  Grd.Cells[2,0]:='Low';
  Grd.Cells[3,0]:='Volume';
  Grd.Cells[4,0]:='quoteVolume';
  Grd.Cells[5,0]:='percentChange';
  Grd.Cells[6,0]:='updatedAt';
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
IdReqThread.Start;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
try
    ini.WriteInteger('Grid_Section', 'Width', StringGrid1.Width);
    ini.WriteInteger('Grid_Section', 'Row', StringGrid1.Row);
    ini.WriteInteger('Grid_Section', 'col1', StringGrid1.ColWidths[0]);
    ini.WriteInteger('Grid_Section', 'col2', StringGrid1.ColWidths[1]);
    ini.WriteInteger('Grid_Section', 'col3', StringGrid1.ColWidths[2]);
    ini.WriteInteger('Grid_Section', 'col4', StringGrid1.ColWidths[3]);
    ini.WriteInteger('Grid_Section', 'col5', StringGrid1.ColWidths[4]);
    ini.WriteInteger('Grid_Section', 'col6', StringGrid1.ColWidths[5]);
    ini.WriteInteger('Grid_Section', 'col7', StringGrid1.ColWidths[6]);
   finally
     ini.Free;
   end;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin

if ini.SectionExists('Grid_Section') then
  begin
    StringGrid1.Width:=ini.ReadInteger('Grid_Section', 'Width',100);
    StringGrid1.Row:=ini.ReadInteger('Grid_Section', 'Row',100);
    StringGrid1.ColWidths[0]:=ini.ReadInteger('Grid_Section', 'Col1',100);
    StringGrid1.ColWidths[1]:=ini.ReadInteger('Grid_Section', 'Col2',100);
    StringGrid1.ColWidths[2]:=ini.ReadInteger('Grid_Section', 'Col3',100);
    StringGrid1.ColWidths[3]:=ini.ReadInteger('Grid_Section', 'Col4',100);
    StringGrid1.ColWidths[4]:=ini.ReadInteger('Grid_Section', 'Col5',100);
    StringGrid1.ColWidths[5]:=ini.ReadInteger('Grid_Section', 'Col6',100);
    StringGrid1.ColWidths[6]:=ini.ReadInteger('Grid_Section', 'Col7',100);
  end;
end;

procedure TForm3.FirstLoadTimer1Timer(Sender: TObject);
begin



FirstLoadTimer1.Enabled:=false;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FDPhysMySQLDriverLink1.VendorLib:=GetCurrentDir+'\libmysql.dll';
  Kol_kur:=0;
  ini := TIniFile.Create(GetCurrentDir+'\ff.ini');
end;

procedure TForm3.IdReqThreadRun(Sender: TIdThreadComponent);
begin

  try
    stroka:=IdHTTP1.Get('https://api.bittrex.com/v3/markets/summaries');
  except
   on E:EIdHTTPProtocolException do
     if IdHTTP1.ResponseCode>100 then
      begin
       stroka:='';
       ShowMessage('smth wrong');
       PrepareStringGrid(StringGrid1);
       //load data from DB into STRgRD
       FDQuery1.SQL.Clear;
       FDQuery1.SQL.Add('select *');
       FDQuery1.SQL.Add('from table1');
       FDQuery1.Active:=true;

       StringGrid1.RowCount:=FDQuery1.RecordCount+1;
       FDQuery1.First;
       repeat
        begin
           StringGrid1.Cells[0,Icounter]:=FDQuery1.FieldByName('nom').AsString;
           StringGrid1.Cells[1,Icounter]:=FDQuery1.FieldByName('high').AsString;
           StringGrid1.Cells[2,Icounter]:=FDQuery1.FieldByName('low').AsString;
           StringGrid1.Cells[3,Icounter]:=FDQuery1.FieldByName('volume').AsString;
           StringGrid1.Cells[4,Icounter]:=FDQuery1.FieldByName('quotevolume').AsString;
           StringGrid1.Cells[5,Icounter]:=FDQuery1.FieldByName('percent_ch').AsString;
           StringGrid1.Cells[6,Icounter]:=FDQuery1.FieldByName('updateat').AsString;
        FDQuery1.Next;
        end;
       until FDQuery1.Eof;
       exit;
      end;
  end;

  JSonAr_lvl1:= TJSONObject.ParseJSONValue(stroka) as TJSONArray;
  Memo1.Lines.Add(JSonAr_lvl1.Count.ToString);
  StringGrid1.RowCount:=JSonAr_lvl1.Count+1;

  PrepareStringGrid(StringGrid1);

  //выгружаем полученное из памяти
  for Icounter := 1 to JSonAr_lvl1.Count-1 do
    begin
     getted_json:=JSonAr_lvl1.Items[Icounter].AsType<TJSONObject>;
     Kol_kur:=Icounter;
     //грузим из сети в структуру и в грид, по умолчанию считаем что это - самые свежие данные
     //базу обновим по мере необходимости
     Currency[Icounter].nom:=getted_json.FindValue('symbol').Value;
     Currency[Icounter].high:=getted_json.FindValue('high').Value;
     Currency[Icounter].low:=getted_json.FindValue('low').Value;
     Currency[Icounter].volume:=getted_json.FindValue('volume').Value;
     Currency[Icounter].quotevolume:=getted_json.FindValue('quoteVolume').Value;
     StringGrid1.Cells[0,Icounter]:=getted_json.FindValue('symbol').Value;
     StringGrid1.Cells[1,Icounter]:=getted_json.FindValue('high').Value;
     StringGrid1.Cells[2,Icounter]:=getted_json.FindValue('low').Value;
     StringGrid1.Cells[3,Icounter]:=getted_json.FindValue('volume').Value;
     StringGrid1.Cells[4,Icounter]:=getted_json.FindValue('quoteVolume').Value;
     //костыль, но в рамках задачи - считаю что вполне нормально, при желании можно пробежать Енумератором
     //данное поле появляется только если не было изменения курса
     if getted_json.Count=7 then
      begin
        Currency[Icounter].percent:=getted_json.FindValue('percentChange').Value;
        StringGrid1.Cells[5,Icounter]:=getted_json.FindValue('percentChange').Value;
      end;
     Currency[Icounter].changeat:=getted_json.FindValue('updatedAt').Value;
     StringGrid1.Cells[6,Icounter]:=getted_json.FindValue('updatedAt').Value;
     s1:='';
    end;
  stroka:='';
//обновляем базу
//проверяем есть ли точно такая же запись, если нет - то делаем апдейт, ведь по умолчанию - все данные в таблице есть
  for Icounter := 1 to Kol_kur do
    begin
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select *');
      FDQuery1.SQL.Add('from table1');
      FDQuery1.SQL.Add('where nom='+#39+Currency[Icounter].nom+#39+' and high='+#39+Currency[Icounter].high+#39+' and low='+#39+Currency[Icounter].low+#39+
      ' and volume='+#39+Currency[Icounter].volume+#39+' and quotevolume='+#39+Currency[Icounter].quotevolume+#39+' and percent_ch='+#39+Currency[Icounter].percent+#39+
      ' and updateat='+#39+Currency[Icounter].changeat+#39);
      FDQuery1.Active:=true;
      //ShowMessage(IntToStr(FDQuery1.RecordCount));
      //если мы не нашли точно такой записи - значит что-то поменялось и надо апдейт
      if FDQuery1.RecordCount=0 then
        begin
         FDQuery1.Active:=false;
         FDQuery1.SQL.Clear;
         FDQuery1.SQL.Add('update table1');
         FDQuery1.SQL.Add('set high='+#39+Currency[Icounter].high+#39+', low='+#39+Currency[Icounter].low+#39+
         ', volume='+#39+Currency[Icounter].volume+#39+', quotevolume='+#39+Currency[Icounter].quotevolume+#39+', percent_ch='+#39+Currency[Icounter].percent+#39+
         ', updateat='+#39+Currency[Icounter].changeat+#39);
         FDQuery1.SQL.Add('where nom='+#39+Currency[Icounter].nom+#39);
         FDQuery1.ExecSQL;
        end;
    end;
  Sleep(10000);
end;

end.
