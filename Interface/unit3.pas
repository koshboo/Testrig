unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,unix, sqldb, sqlite3conn,db,dialogs,rd_commands, rd_protocol, rd_types,forms,baseunix,LCLtype;
Function Check_SQL (Query : String):integer;
procedure startdetachedprogram(cmd: string);
function Split(const strwhole: string; const separator: string): tstringlist;
Function redis_DO (cmd: string ; param :array of const) :string;
Function sql_execute (): Boolean;





implementation
Uses Unit1;

Function Check_SQL (Query : String):integer;
Var
   Loop : Integer;
Begin
  with form1 do
  Begin
       Repeat
       Loop := 0;
       Try
       SQLTransaction1.Commit;
       SQLQuery1.Active:= False;
       SQLQuery1.SQL.Text:= Query;
       SQLQuery1.Active:= true;
       Result := DataSource1.DataSet.RecordCount;
       SQLTransaction1.CommitRetaining;
       EXCEPT
         on e: EDatabaseError do
         begin
             sleep (1000);
             Loop := 1;
             messagedlg(e.Message,mtError, mbOKCancel, 0);
         end;
       end;
       Until Loop = 0;

  end;

End;
procedure startdetachedprogram(cmd: string);
var sh:tstringlist;
const fn='/dev/shm/startdetachscript';
begin
  sh:=tstringlist.Create;
  sh.add('nohup '+cmd+' >/dev/null 2>&1 &');
  sh.add('disown');
  sh.add('exit');
  sh.SaveToFile(fn);
  fpsystem('bash < '+fn);
  deletefile(fn);
  sh.Free;
end;
function Split(const strwhole: string; const separator: string): tstringlist;

var

  i: integer;
  strline: tstringlist;
  str :  string;
begin
  str := strwhole;
  i := 1;
  Strline := Tstringlist.Create;
  while i > 0 do
  begin
       i := pos (separator,str);
       strline.Add(copy (str,0,i-1));
       delete (str,1,i);
  end;
  Result := strline;
end;
Function redis_DO (cmd: string ; param :array of const) :string ;
var
  temp : integer;
  count,Max_retry : integer;
  ret : string;
  RedisConnection : TRedisConnection;
  IO      : TRedisIO;
  return  : TRedisReturnType;
begin
  count := 0;
  Ret:=  '';
  Max_retry := 5;
  repeat
  temp := 0;
  try                                                                             // use memoload as flag
  begin
  IO := TRedisIO.Create;
  IO.Connect;
  RedisConnection        := TRedisConnection.Create(IO);
  return := RedisConnection.send_command2 (cmd,Param);                            // read god pid
  ret := return.Value;
  end;
  EXCEPT
       ON e: exception do                                                         // on exception { TODO : refine exception handleing}
       begin
            sleep (1000);
            temp := 1;
            count := count + 1;
       end;
  end;
  until ((temp = 0) or (count = Max_retry));

 {*****************************************************************************}
  If count = Max_retry then                                                       // if the max reties was used to no use
  begin
       Messagedlgpos('The program has failed to contact the REDIS server'+slinebreak+'Please contact TECHNICAL for assistance',mterror,[mbok],0,10,10);  // inform the user of problem
       application.Terminate;                                                     // terminate the application
  end;
 {*****************************************************************************}
 if return = nil then ret:= '';
 Result := ret
end;
Function sql_execute (): Boolean;
var
    Loop : Integer;
begin
 with form1 do
  Begin
 Repeat
 Loop := 0;

  try
      SQLQuery1.ExecSQL;
      SQLTransaction1.Commit;

  Except
        on e: EDatabaseError do
         begin
             sleep (1000);
             Loop := 1;
             messagedlg(e.Message,mtError, mbOKCancel, 0);
         end;
  end;
  Until loop = 0;
  end;
end;

end.

