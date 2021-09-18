unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, rd_commands, rd_protocol, rd_types, eventlog,strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    Edit1: TEdit;
    Timer1: TTimer;
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure CheckGroup2ItemClick(Sender: TObject; Index: integer);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

  var
  IO      : TRedisIO;
  return  : TRedisReturnType;
  log : TEventLog;
  RedisConnection : TRedisConnection;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
Var
   X : integer;
   tmp : string;
   val,b : integer;

begin
   Timer1.Enabled:= false;
   For x := 1 to 16 do
     begin
         tmp := inttostr(x)+','+edit1.text;
         return := RedisConnection.send_command2 ('Hget',['PIN_READ',tmp]);
         if return.value > '' then
         begin
         val := strtoint (return.Value);
         if (val = 1) then
         begin
              Checkgroup1.Checked[x-1] := true;

         end
         else
         begin
              Checkgroup1.Checked[x-1] := False;
         end;
     end;

     end;

   For x := 1 to 16 do
     begin

         tmp := inttostr(x)+','+edit1.text;
         return := RedisConnection.send_command2 ('Hget',['PIN_WRITE',tmp]);
         if return.value > '' then
         begin
         val := strtoint (return.Value);
         if (Val = 1) then
         begin
              Checkgroup2.Checked[x-1] := true;
         end
         else
         begin
              Checkgroup2.Checked[x-1] := False;
         end;

         end;
     end;
   Timer1.Enabled:= true;
end;

procedure TForm1.FormActivate(Sender: TObject);
  var

x : integer;
tmp : string;
begin
     IO := TRedisIO.Create;
     IO.Connect;
     RedisConnection        := TRedisConnection.Create(IO);
     return := RedisConnection.Ping;
     form1.Caption := return.Value;
end;

procedure TForm1.CheckGroup2ItemClick(Sender: TObject; Index: integer);
var
   tmp,val : String;

begin
         RedisConnection        := TRedisConnection.Create(IO);

         tmp := inttostr(index + 1)+','+edit1.text;
         if checkgroup2.Checked[index] then
         begin
              val := '1';
         end
         else
         begin
              val := '0';
         end;
         return := RedisConnection.send_command2 ('hset',['PIN_WRITE',tmp,val]);
end;

procedure TForm1.CheckGroup1ItemClick(Sender: TObject; Index: integer);
var
   tmp,val : String;

begin
         RedisConnection        := TRedisConnection.Create(IO);

         tmp := inttostr(index + 1)+','+edit1.text;
         if checkgroup1.Checked[index] then
         begin
              val := '1';
         end
         else
         begin
              val := '0';
         end;
         return := RedisConnection.send_command2 ('hset',['PIN_READ',tmp,val]);
end;

end.

