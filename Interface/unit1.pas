unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  StdCtrls, ComCtrls, Grids, Spin, LCLtype, DBGrids, Arrow,
  sqldb, sqlite3conn, db, unit3, rd_commands, rd_protocol, rd_types, eventlog,
  zipper,  types, baseunix;

type

  MemoDifier = class
    public
      procedure DBGridOnGetText(Sender: TField; var aText: string;
        DisplayText: boolean);
    end;
  { TForm1 }

  TForm1 = class(TForm)
    ALL_Pause: TButton;
    Arrow1: TArrow;
    Arrow2: TArrow;
    Button1: TButton;
    IdleTimer1: TIdleTimer;
    Import_up: TButton;
    CheckBox4: TCheckBox;
    DBGrid3: TDBGrid;
    FloatSpinEdit2: TFloatSpinEdit;
    Label18: TLabel;
    Label19: TLabel;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    Login1: TButton;
    CReate_pin: TButton;
    Complete_button: TButton;
    ADD_Program: TButton;
    Button4: TButton;
    Button5: TButton;
    Import: TButton;
    MenuItem4: TMenuItem;
    hide_1: TMenuItem;
    hide_30: TMenuItem;
    hide_10: TMenuItem;
    hide_5: TMenuItem;
    Hidetimer: TTimer;
    Admin: TMenuItem;
    Ch_pwd: TMenuItem;
    Timer3: TTimer;
    water: TCheckBox;
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    Bay_select: TComboBox;
    Storage: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    RC_pin_dir: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    End_trigger: TComboBox;
    ComboBox5: TComboBox;
    Program_catagory: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    FloatSpinEdit1: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabeledEdit1: TLabeledEdit;
    WT_step: TLabeledEdit;
    WT_motor: TLabeledEdit;
    WT_cont: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    MainMenu1: TMainMenu;
    File_sys: TMenuItem;
    close1: TMenuItem;
    Memo1: TMemo;
    Memo2: TMemo;
    Activate_program: TMenuItem;
    Suspend_program: TMenuItem;
    Complete_test: TMenuItem;
    MOve_down: TMenuItem;
    Move_up: TMenuItem;
    Program_select_popup: TPopupMenu;
    remove_line: TMenuItem;
    Tab_Manager: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Program_Popup: TPopupMenu;
    Sheet_login: TTabSheet;
    Sheet_general: TTabSheet;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StringGrid2: TStringGrid;
    Sheet_ADMIN: TTabSheet;
    Sheet_Create_program: TTabSheet;
    Sheet_configure_rig: TTabSheet;
    Sheet_Programs: TTabSheet;
    StringGrid5: TStringGrid;
    God_timer: TTimer;
    Username1: TLabeledEdit;
    Password: TLabeledEdit;

    procedure Activate_programClick(Sender: TObject);
    procedure ADD_ProgramClick(Sender: TObject);
    procedure ALL_PauseClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure HidetimerTimer(Sender: TObject);
    procedure hide_10Click(Sender: TObject);
    procedure hide_30Click(Sender: TObject);
    procedure hide_5Click(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure Import_upClick(Sender: TObject);
    procedure CReate_pinClick(Sender: TObject);
    procedure DBGrid1CellClick();
    procedure DBGrid3CellClick();
    procedure LabeledEdit8KeyPress(Sender: TObject; var Key: char);
    procedure Login1Click(Sender: TObject);
    procedure Complete_buttonClick(Sender: TObject);
    procedure close1Click(Sender: TObject);
    procedure hide_1Click(Sender: TObject);
    procedure Ch_pwdClick(Sender: TObject);
    procedure PasswordKeyPress(Sender: TObject; var Key: char);
    procedure RC_pin_dirChange(Sender: TObject);
    procedure Bay_selectChange(Sender: TObject);
    procedure End_triggerChange(Sender: TObject);
    procedure Program_catagoryChange(Sender: TObject);
    procedure Complete_testClick(Sender: TObject);
    procedure DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MOve_downClick(Sender: TObject);
    procedure Move_upClick(Sender: TObject);
    procedure apply_update(mode: TUpdateMode);

    procedure Tab_ManagerChange(Sender: TObject);
    procedure remove_lineClick(Sender: TObject);
    procedure Suspend_programClick(Sender: TObject);
    procedure God_timerTimer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    Procedure SetDBCols();
    procedure Username1KeyPress(Sender: TObject; var Key: char);




  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Keys : Array [1..20,1..20] of string;
  memoload : integer;
  Offset : Integer;
  Program_sl: Tstringlist;

  log : TEventLog;
  update_program : integer;
  start_time : Tdatetime;
  temp_hold : string;
  count : integer;
  Max_retry : integer;
  state : integer;
  god_no : string;
  Base : string;
  config : textfile;
Const
  tab = '    ';

implementation

{$R *.lfm}

procedure MemoDifier.DBGridOnGetText(Sender: TField; var aText: string; // memo to text for dbgrids
  DisplayText: boolean);
begin
  if (DisplayText) then
    aText := Sender.AsString;
end;

procedure TForm1.FormCreate(Sender: TObject);                           // form creation

var
  s:TTextStyle;
  boxstyle : integer;

begin
  god_no := '';
  if fileexists('config') then
    begin                                                                    // does the config file exist
         Assignfile (config,'config');
         try
            reset(config);
            readln (config,base);                                            // read the line into base
            if base = '' then application.Terminate;
            closefile (config);
         Except
           on e: Einouterror do
           begin
                BoxStyle := MB_ICONError + MB_OK;
                Application.MessageBox('Config corruption '+slinebreak+'Please contact TECHNICAL for assistance', 'Fatal error', BoxStyle);
                application.Terminate;                                       // terminate application you cannot start without a config
           end;
         end;
    end
  else
  begin
       Application.MessageBox('Config file missing '+slinebreak+'Please contact TECHNICAL for assistance', 'Fatal error', BoxStyle);
       application.Terminate;                                                // terminate application you cannot start without a config
  end;
  Program_sl := Tstringlist.Create;                                          // temporay string list for program
  Program_sl.Sorted:= true;                                                  // set string list to sorted
  Program_sl.Duplicates:= dupIgnore;                                         // ignore duplicates
  {********************Set dimensions of components**********************}
  Form1.Width:=1280;
  Form1.Height:= 960;
  form1.top := 0;
  form1.Left:= (screen.Width div 2)-500;
  Panel1.Top := ((form1.Height div 2)-(Panel1.Height div 2))-100;
  Panel1.left := ((form1.width div 2)-(Panel1.width div 2));
  {**********************************************************************}
  s := StringGrid2.DefaultTextStyle;
  s.Alignment:= taCenter;
  StringGrid2.DefaultTextStyle := s;
  Tab_Manager.TabIndex:= 0;                                                   // Set the start page on the tab manger
  if not fileexists (base+'Main.db') then
    begin
         Application.MessageBox('Database file missing '+slinebreak+'Please contact TECHNICAL for assistance', 'Fatal error', BoxStyle);
       application.Terminate;
    end;
  Sqlite3connection1.DatabaseName:= base+'Main.db';                           // set the location of the sql database
  Sqlite3connection1.Connected:= true;                                        // set the connection to true
  god_timer.Enabled:= false;                                                  // disable the god timer
  redis_do('set',['INTERFACE',FPgetpid]);
  god_timer.Enabled:= true;                                                  // Enable god timer
end;

procedure TForm1.MOve_downClick(Sender: TObject);                       // Move selected line down
var
   c :integer;

begin
     with stringgrid2 do
     begin
        if rowcount = 1 then exit;                               // check if there is only 1 line
           rowcount := rowcount + 1;                             // Add row at bottom for storage

         for c := 0 to ColCount - 1 do                           // loop through the columns
         begin
              Cells[c,rowcount -1 ] := Cells[c,row ];            // Move selected cells to empty cells at bottom
              Cells[c,row ] := Cells[c,row + 1];                 // Rove row underneath selected cells to the selected row
              Cells[c,row +1] := Cells[c,rowcount -1];           // Move Cell from bottom into new slot below previous
         end;
         rowcount := rowcount - 1;                               // Remove the storage line
         row := row + 1;                                         // move selection to the line
     end;
end;

procedure TForm1.Move_upClick(Sender: TObject);                         // move selected line up
var
   c :integer;

begin
     with stringgrid2 do
     begin
        if row = 1 then exit;                                    // If only 1 row exit
          rowcount := rowcount + 1;                              // Add line at botome for storeage

         for c := 0 to ColCount - 1 do                           // loop through cell
      begin
           Cells[c,rowcount -1] := Cells[c,row - 1];             // copy cells above selected to storage lines
           Cells[c,row -1 ] := Cells[c,row];                     // copy selected cells to vacated line
           Cells[c,row] := Cells[c,rowcount - 1];                // copy cells from botom line to selected
      end;
         rowcount := rowcount - 1;                               // remove storage line
         row := row - 1;                                         // move selected marker up 1 line
     end;
end;

procedure TForm1.apply_update(mode: TUpdateMode);                       // Appy updates to the program (TBC)
{ TODO : anotate procedure and check its function }
begin
     SQLQuery1.Edit();
     SQLQuery1.UpdateMode := mode;
     SQLQuery1.ApplyUpdates();
     SQLTransaction1.Commit();
     SQLQuery1.Close();
     SQLQuery1.Open();
     SQLTransaction1.CommitRetaining;
end;

procedure TForm1.remove_lineClick(Sender: TObject);                     // remove the selected line
var
   r,c :integer;
begin
     with stringgrid2 do
     begin
    if rowcount = 1  then exit;                                  // are there more than 1 line prevent inf line being removed
    for r := Row to RowCount -2 do                               // loop through rows from selected row down
    begin
    for c := 0 to ColCount - 1 do                               // loop through columns
      begin
           Cells[c,r] := Cells[c,r + 1];                         // copy lines up 1 line
      end;
    end;
     RowCount := RowCount - 1                                    // remove last line
     end;
end;

procedure TForm1.Tab_ManagerChange(Sender: TObject);                    // setup each window when it is selected (Mainly Sql calls)
begin

  Timer3.Enabled:= false;                                               // disable auto updater
  Case Tab_Manager.ActivePageIndex of
  1:
    begin
        unit3.Check_SQL('Select Bay,ID,Description,Owner,EST_Finish_date,count From Programs where status = "Active" order by "Bay"');
        SetDBCols;
        Timer3.Enabled:=true;
    end;

  2:
    begin

    end;

  3:
    begin
         Timer3.Enabled:= true;                                                // enable auto updater
         Program_catagory.OnChange (self);                                     // select which data to show
    end;


   4:
    begin
        unit3.Check_SQL('Select Bay,bus,pin,Direction,alias,inuse From Buses order by "Bus"');
        SetDBCols;
    end;
    end;
end;

procedure TForm1.Login1Click(Sender: TObject);                          // login page
Var
   val,per : integer;

begin
    val := unit3.Check_SQL('Select * From Users where username = "'+username1.Text+'" and password ="'+password.Text+'"');  //does the person exist
    If val > 0 then                                                                   // if valid person and password
    begin
     Label19.Visible:= false;                                                         // hide label saying you have wrong creds
     Sqlquery1.Active:= true;
     Datasource1.DataSet.First;                                                       // activate the sql query
     Per := datasource1.Dataset.FieldByName('Permissions').AsInteger;                 // get the permissions byte
     Tab_Manager.TabIndex:= 1;                                                        // set the base page as the general page
     sheet_login.TabVisible:= false;                                                  // hide the login page
     If ((Per and 1)=1) then Sheet_Create_program.TabVisible:= true;                  // and per with a number to get the permissions
     If ((Per and 2)=2) then Sheet_Programs.TabVisible:= true;                        // and per with a number to get the permissions
     If ((Per and 64)=64) then Sheet_configure_rig.TabVisible:= False;                // and per with a number to get the permissions
     If ((Per and 128)=128) then Sheet_admin.TabVisible:= False;                      // and per with a number to get the permissions
     Password.Text:='';                                                               // wipe the password text
     Menuitem4.Visible:= true;                                                        // show the ability to hide the program
     admin.Visible:= true;
    End
    else
    begin
        Password.Text:='';                                                            // wipe password field
        Label19.Visible:= true;                                                       // show message that you have the wrong creds
    end;

end;

procedure TForm1.Suspend_programClick(Sender: TObject);                 // Suspen a single program
Var
test : integer;
Hold : Integer;
begin
   hold := dbgrid1.DataSource.DataSet.RecNo;                            // get the record we need to update
   test :=dbGrid1.DataSource.DataSet.Fields[0].Asinteger;               // convert ID to number
   SQLQuery1.Close;                                                     // close sql query
   SQLQuery1.sql.text := 'Update Programs SET status ="Paused" Where id ='+inttostr(test);   // update text in sql query
   SQLQuery1.ExecSQL;                                                                        // EXECUTE SQL
   SQLTransaction1.Commit;                                                                   // commit the
   unit3.Check_SQL('Select id, description, status,Owner,EST_Finish_date,Run_Time From Programs where Status = "'+Program_catagory.Text+'"');    // update the displayed data
   SetDBCols;                                                                                // set column widths
   dbgrid1.DataSource.DataSet.RecNo := hold -1;                                              // set the marker to the record above the one we just paused

end;

procedure TForm1.God_timerTimer(Sender: TObject);                       // Check if god is loaded

begin
  God_timer.Enabled:= false;
  God_timer.Interval:= 1000;                                            // set intrval to 15 seonds
  label3.Caption:= '';
  if God_no = '' then                                                  // do we have a number for god
  begin
  God_no := redis_do ('Get',['GOD']);
  if God_no = ''  then                                                 //  if god is not registerd in redis
  begin
       sleep (500);
       startdetachedprogram(base+'./God 1');
       label3.Caption:= god_no;                                  // attempt to start god
       Label1.Caption:='System Up time :- ';
       god_no := '';
       God_timer.Interval:= 1000;
  end

  end else
  begin
       if not directoryexists('/proc/'+god_no) then                    // if god no > '' then check if it is still running
       begin
            God_no := '';                                              // if not clear the number and reset interval to 1 second
            God_timer.Interval:= 1000;
            redis_do ('Del',['GOD']);
       end;
end;
  label3.Caption:= god_no;
  God_timer.Enabled:= true;                                             // restart the timer

end;

procedure TForm1.Timer3Timer(Sender: TObject);                          // Update the grid
begin
       unit3.Check_SQL('Select Bay,ID,Description,Owner,EST_Finish_date,count From Programs where status = "Active" order by "Bay"');
       SetDBCols;
end;

procedure TForm1.Activate_programClick(Sender: TObject);                // Set A single Program to active
Var

{todo: redis output}
test,hold : integer; // ACTIVATE PROGRAM
begin
   hold := dbgrid1.DataSource.DataSet.RecNo;
   test :=dbGrid1.DataSource.DataSet.Fields[0].Asinteger;
   SQLQuery1.Close;
   SQLQuery1.sql.text := 'Update Programs SET status ="Active" Where id ='+inttostr(test);
   SQLQuery1.ExecSQL;                                                                        // EXECUTE SQL
   SQLTransaction1.Commit;
   unit3.Check_SQL('Select id, description, status,Owner,EST_Finish_date,Run_Time From Programs where Status = "'+Program_catagory.Text+'"');
   SetDBCols;
   dbgrid1.DataSource.DataSet.RecNo := hold -1;
end;

procedure TForm1.Complete_testClick(Sender: TObject);                   // set program to completed (NOt finished)
Var
{todo: redis output}
  test : integer; // COMPLETE PROGRAM
  OurZipper: TZipper;

begin
   test :=dbGrid1.DataSource.DataSet.Fields[0].Asinteger;
   SQLQuery1.Close;
   SQLQuery1.sql.text := 'Update Programs SET status ="Completed" Where id ='+inttostr(test);
   SQLQuery1.ExecSQL;                                                                        // EXECUTE SQL
   SQLTransaction1.Commit;
   Program_catagory.ItemIndex:= 3;
   Program_catagory.OnChange(self);
   RenameFile (base+'/Python/'+inttostr(test)+'.py',base+'Python/Logfiles/'+inttostr(test)+'.PBac');
   OurZipper := TZipper.Create;
  try
    OurZipper.FileName := base+'/Python/Logfiles/Archives/'+inttostr(test)+'.zip';
    if fileexists (base+'/Python/Logfiles/'+inttostr(test)+'.PBac') then OurZipper.Entries.AddFileEntry(base+'/Python/'+inttostr(test)+'.py', inttostr(test)+'.py');
    if fileexists (base+'/Python/Logfiles/'+inttostr(test)+'.log') then OurZipper.Entries.AddFileEntry(base+'/Python/Logfiles/'+inttostr(test)+'.log', inttostr(test)+'.log');
    if fileexists (base+'/Python/Logfiles/'+inttostr(test)+'.err') then OurZipper.Entries.AddFileEntry(base+'/Python/Logfiles/'+inttostr(test)+'.err', inttostr(test)+'.err');
    if fileexists (base+'/Python/Logfiles/'+inttostr(test)+'.Tem') then OurZipper.Entries.AddFileEntry(base+'/Python/Logfiles/'+inttostr(test)+'.Tem', inttostr(test)+'.Tem');
    if fileexists (base+'/Python/Logfiles/'+inttostr(test)+'.CYC') then OurZipper.Entries.AddFileEntry(base+'/Python/Logfiles/'+inttostr(test)+'.CYC', inttostr(test)+'.CYC');
    OurZipper.ZipAllFiles;
  finally
    OurZipper.Free;
  end;

end;

procedure TForm1.close1Click(Sender: TObject);                          // form controls
begin
  Form1.close;
end;

procedure TForm1.hide_1Click(Sender: TObject);                          // hide for 1 minute
begin
    hidetimer.Enabled:= False;
    hidetimer.Interval:=  (1000 * 60)* 1 ;
    form1.BorderStyle:= bssizeable;
    sleep(200);
    form1.WindowState:= wsminimized;
    hidetimer.Enabled:= true;
end;

procedure TForm1.Ch_pwdClick(Sender: TObject);
var
  st : string;
begin
     InputQuery('Change password', 'Type new Password', TRUE, st);
     SQLQuery1.Close;
     SQLQuery1.sql.text := 'Update Users set password = "'+st+'"where username = "'+username1.Text+'"';
     SQLQuery1.ExecSQL;                                                   // EXECUTE SQL
     SQLTransaction1.Commit;
end;

procedure TForm1.PasswordKeyPress(Sender: TObject; var Key: char);      // Detect CR and login
begin
  if key = #13 then
  begin
   login1.Click;
  end;
end;

procedure TForm1.ADD_ProgramClick(Sender: TObject);                     // add line to the program (COMPLETE)
Var
   unfilled : integer;

begin
  unfilled := 0;
  if combobox2.ItemIndex < 0 then unfilled := unfilled + 1;
  if combobox3.ItemIndex < 0 then unfilled := unfilled + 1;
  if End_trigger.ItemIndex < 0 then unfilled := unfilled + 1;
  if (combobox5.ItemIndex < 0) and (floatspinedit2.Value = 0) then unfilled := unfilled + 1;
  if unfilled > 0 then
  begin
       application.MessageBox ('All information must be filled in', 'Missing information',MB_ICONERROR)
  end
  else
  begin
       stringgrid2.RowCount:= stringgrid2.RowCount + 1;
       If Stringgrid2.RowCount > 13 then
       begin
            stringgrid2.DefaultColWidth:= 159;
            stringgrid2.Row:= stringgrid2.RowCount - 1;
       end;

       stringgrid2.Cells[0,stringgrid2.RowCount -1 ] :=combobox2.Text;
       stringgrid2.Cells[1,stringgrid2.RowCount -1 ] :=combobox3.Text;
       Stringgrid2.Cells[2,stringgrid2.RowCount -1 ] :=End_trigger.Text;
       if End_trigger.ItemIndex = 0 then
         begin
         stringgrid2.Cells[3,stringgrid2.RowCount -1 ] := floattostr(floatspinedit2.value);
     end
        else
         begin
          stringgrid2.Cells[3,stringgrid2.RowCount -1 ] :=combobox5.Text;
     end;

end;
end;

procedure TForm1.ALL_PauseClick(Sender: TObject);                       // Suspend all active program
begin
  Case  (ALL_Pause.Tag) of

   0:
    begin
          Dbgrid1.DataSource.DataSet.First;
          Temp_hold := '';
        while not Dbgrid1.DataSource.DataSet.EOF do
        begin
             Temp_hold:=Temp_hold +','+dbGrid1.DataSource.DataSet.Fields[0].Asstring;
             Dbgrid1.DataSource.DataSet.Next;
        end;
        If temp_hold <> '' then
        begin
        Temp_hold := Copy (Temp_hold,2,(length(Temp_hold)));
        SQLQuery1.Close;
        SQLQuery1.sql.text := 'Update Programs SET status ="Paused" Where id IN ('+temp_hold+')';
        SQLQuery1.ExecSQL;// EXECUTE SQL
        SQLTransaction1.Commit;
        All_pause.Caption:= 'Resume All';
        All_pause.Tag := 1;
        end;
    end;
   1:
    begin
         SQLQuery1.Close;
         SQLQuery1.sql.text := 'Update Programs SET status ="Active" Where id IN ('+temp_hold+')';
         SQLQuery1.ExecSQL;                                                   // EXECUTE SQL
         SQLTransaction1.Commit;
        All_pause.Caption:= 'Pause All';
        All_pause.Tag := 0;
    end;
  end;
  unit3.Check_SQL('Select id, description, status,Owner,EST_Finish_date,Run_Time From Programs where Status = "'+Program_catagory.Text+'"');
  SetDBCols;
end;

procedure TForm1.Button4Click(Sender: TObject);                         // bay and pin assignment code
Var
   val : Integer;
begin
     val := unit3.Check_SQL('Select * From Buses where Bus = "'+Combobox8.Text+'" and Pin ="'+Combobox9.Text+'"');
    If (Val = 0) then
    Begin
    with DBGrid1.DataSource.DataSet do
    begin
    insert;
    FieldByName('Direction').Value := RC_pin_dir.Text;
    FieldByName('Pin').Value := strtoint(Combobox9.Text);
    FieldByName('BUS').Value := strtoint(Combobox8.Text);
    FieldByName('Bay').Value :=  strtoint(Combobox7.Text);
    FieldByName('Inuse').Value :=  0;
    Post;
    apply_update (upwherechanged);
    end;
    End
    else
    begin
    with DBGrid1.DataSource.DataSet do
    begin
    Edit;
    FieldByName('Bay').Value :=  strtoint(Combobox7.Text);
    Post;
    apply_update (upwhereall);
    end;

    end;
    unit3.Check_SQL('Select Bay,bus,pin,Direction,alias,inuse From Buses order by "Bus"');
    DBGrid3CellClick();
end;

procedure TForm1.HidetimerTimer(Sender: TObject);                       // timmer code that make form appear after being hiden
begin
  hidetimer.Enabled:= false;
  form1.show;
  form1.BorderStyle:= bsnone;
end;

procedure TForm1.hide_10Click(Sender: TObject);                         //  hide for 10 minutes
begin
  idletimer1.Enabled:= false;
  hidetimer.Enabled:= False;
  hidetimer.Interval:=  (1000 * 60)* 10 ;
    form1.BorderStyle:= bssizeable;
    sleep(200);
    form1.WindowState:= wsminimized;
    hidetimer.Enabled:= true;
end;

procedure TForm1.hide_30Click(Sender: TObject);                         //  hide for 30 minutes
begin
  idletimer1.Enabled:= false;
  hidetimer.Enabled:= False;
  hidetimer.Interval:=  (1000 * 60)* 30 ;
    form1.BorderStyle:= bssizeable;
    sleep(200);
    form1.WindowState:= wsminimized;
    hidetimer.Enabled:= true;
end;

procedure TForm1.hide_5Click(Sender: TObject);                          //  hide for 5 minutes
begin
     idletimer1.Enabled:= false;
     hidetimer.Enabled:= False;
     hidetimer.Interval:=  (1000 * 60)* 5 ;
    form1.BorderStyle:= bssizeable;
    sleep(200);
    form1.WindowState:= wsminimized;
    hidetimer.Enabled:= true;
end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);                      //  Idle timer loggs user out if inactive 5 mins
begin
     sheet_login.TabVisible:= true;
     Sheet_Create_program.TabVisible:= false;
     Sheet_Programs.TabVisible:= False;
     Sheet_configure_rig.TabVisible:= False;
     Sheet_admin.TabVisible:= False;
     Tab_Manager.TabIndex:= 0;
     Menuitem4.Visible:= False;
     admin.Visible:= false;
     idletimer1.Enabled:= True;
end;

procedure TForm1.ImportClick(Sender: TObject);                          // Import odl program
var
          holding : string;
          lines,column : tstringlist;
          r,per,val : integer;

begin

      Holding :='';
      val := 0;
      if labelededit8.Text <> '' then
      begin
      val := unit3.Check_SQL ('SELECT program_data FROM Programs WHERE ID = '+labelededit8.Text);
      end;
      if val > 0 then
      begin
      holding := DBGrid1.DataSource.DataSet.FieldByName('Program_data').Value;
      lines := tstringlist.create;
      column := tstringlist.create;
      lines := split (holding,';');
      stringgrid2.RowCount:= 1;
      Complete_button.Caption:= 'Complete Program';
      For r := 0 to lines.Count - 2 do
      begin
           stringgrid2.RowCount:= stringgrid2.RowCount + 1;
           column.Clear;
           column := split (lines[r],',');
           stringgrid2.Cells[0,r+1] := column[0];
           stringgrid2.Cells[1,r+1] := column[1];
           stringgrid2.Cells[2,r+1] := column[2];
           stringgrid2.Cells[3,r+1] := column[3];
      end;
      if (update_program = 1) then
      begin
           unit3.Check_SQL ('SELECT * FROM Programs WHERE ID = '+labelededit8.Text);
           with DBGrid1.DataSource.DataSet do
           begin
           Memo2.Text :=  FieldByName('Full_Reason').Value;                         // Parameters
           Labelededit1.Text:=  FieldByName('Description').Value;
           WT_step.Text:=  FieldByName('Step').Value;
           WT_motor.Text:=  FieldByName('Motor').Value;
           Floatspinedit1.Value:=  FieldByName('Voltage').Value;
           WT_cont.Text:=  FieldByName('Controller').Value;
           spinedit6.value:=  FieldByName('Target').Value;
           Bay_select.Text:=  FieldByName('Bay').Value;

           per:=  FieldByName('params').AsInteger;
           memo5.Lines.Add(inttostr ((per and 32)));
           if ((per and 1)> 0) then Checkgroup1.Checked[0] := true else Checkgroup1.Checked[0] := false;
           if ((per and 2)> 0) then Checkgroup1.Checked[1] := true else Checkgroup1.Checked[1] := false;
            if ((per and 4)> 0) then Checkbox4.Checked := true else Checkbox4.Checked := false;

           if ((per and 32) = 32) then water.Checked := true else water.Checked := false;
           Complete_button.Caption:= 'Update Program';
           end;
      end;
      Bay_selectChange(self);

      end;
end;

procedure TForm1.Import_upClick(Sender: TObject);                       // Import and update a program
begin
     update_program := 1;
     importclick (sender);
end;

procedure TForm1.CReate_pinClick(Sender: TObject);                      // Assign data to pin (DONE)
Var
   val : Integer;
begin
     val := unit3.Check_SQL('Select * From Buses where Bus = "'+Combobox8.Text+'" and Pin ="'+Combobox9.Text+'"');
     If (Val > 0) then
     Begin
      with DBGrid1.DataSource.DataSet do
  begin
    Edit;

    FieldByName('Direction').Value := RC_pin_dir.Text;
    FieldByName('Pin').Value := strtoint(Combobox9.Text);
    FieldByName('Bus').Value := strtoint(Combobox8.Text);

     If (Labelededit5.Text <> '') then
     begin
          FieldByName('Alias').Value :=Labelededit5.Text;
     end;
     Post;
  end;
     apply_update (upwherechanged);
     unit3.Check_SQL('Select Bay,bus,pin,Direction,alias,inuse From Buses order by "Bus"');
end;
end;

procedure TForm1.DBGrid1CellClick();                                    // display log data from the selected program
var
test : string;
begin
     test := dbGrid1.DataSource.DataSet.Fields[0].asstring;
     if fileexists (Base+'/Python/Logfiles/'+test+'.log') then memo4.Lines.LoadFromFile(Base+'/Python/Logfiles/'+test+'.log') else memo4.Lines.add(Base+'/Python/Logfiles/'+test+'.log') ;
     memo4.Lines.SaveToFile(Base+'/Python/Logfiles/'+test+'.fuc' );
     memo4.Lines.LoadFromFile(Base+'/Python/Logfiles/1.log');
end;

procedure TForm1.DBGrid3CellClick();                                    // transfer data from dbgird to selections
begin
     combobox8.Text:= dbGrid3.DataSource.DataSet.Fields[1].Asstring;
     combobox9.Text:= dbGrid3.DataSource.DataSet.Fields[2].Asstring;
     rc_pin_dir.Text:= dbGrid3.DataSource.DataSet.Fields[3].Asstring
end;

procedure TForm1.LabeledEdit8KeyPress(Sender: TObject; var Key: char);  // allow only numbers to be typed
begin
     if not (Key in [#8, '0'..'9',#10,#13]) then
     begin
     key := #0;
     ShowMessage('Only numbers are allowed');
     end;
end;

procedure TForm1.Complete_buttonClick(Sender: TObject);                 // send completed program to sql data base (Not COMPLETE)
var
   {todo: redis output}
unfilled,Per,r,c,logging : integer;
Holding : string;
temp,temp2,tmp3 : string;
tmp1,tmp2,tmp4: String;
val : Integer;
begin
     temp := '';

  {  Code used to verify all REQUIRED data is filled in
     Also used to up load the program into the sql database}
unfilled := 0;
PER := 0;
if labelededit1.text=''       then unfilled := unfilled + 1;            // short desc of testing
if memo2.text = ''            then unfilled := unfilled + 1;            // desc of testing
if Bay_select.ItemIndex < 0   then unfilled := unfilled + 1;            // bay select
if WT_step.text=''            then unfilled := unfilled + 1;            // what step
if WT_motor.text=''           then unfilled := unfilled + 1;            // wnat motor
if Spinedit6.Value = 0        then unfilled := unfilled + 1;            // target
if floatSpinedit1.Value = 0   then unfilled := unfilled + 1;            // Voltage
unfilled := 0;
if unfilled > 0 then                                                    // check if any of the things above are not filled in
begin
     application.MessageBox ('All information must be filled in', 'Missing information',MB_ICONERROR); // inform user not all data is complete
end
else
begin                                                                   //  all data filled in
   If stringgrid2.RowCount > 2 then
   begin
       { Check that the program contains at least 2 program lines.
        If the above check then the program is loaded into the SQL Database
        Convert the checkboxes into a binary format and send it to 'PER'}
       IF Checkgroup1.Checked[0] Then PER := per + 1;               //  should the cycle time be loged
       IF Checkgroup1.Checked[1] Then PER := per + 2;               //  should the tempratute be logged (not available)
       If Checkbox4.Checked      then PER := Per + 4;               //  use ram
       If water.Checked          then PER := Per + 32;

       Holding := '';                                               // flush the temporay variable
       For R := 1 to Stringgrid2.RowCount - 1 do                    // Cycle through each line of the program and create a string
        Begin
            For C := 0 to stringgrid2.ColCount - 1 do               // Cycle through each column of program
            Begin
                 Holding := Holding + Stringgrid2.Cells[c,r]+',';   // write cell value into the holding variable
            end;
            Holding := Holding + ';';                               // add ';' to the end of each full line
        end;

     if (Update_program = 1) then                                   // is this an up date or a new program
     begin                                                          // in update mode
     r := MB_ICONWARNING + MB_YESNO;
     val :=  application.MessageBox ('Are you sure you want to update this program Press NO to create a new program', 'WARNING!!',r);
     if val = IDYES then                                            // if the users answers they want to update the program
     Begin
     SQLQuery1.sql.text := 'update  Programs set Full_reason = :FR,Description = :SR,step = :ST,motor = :MO,voltage = :VO,controller = :CO,target= :TA,params = :PAR,program_data = :PD,owner = :OW,bay = :BA, status = :STA where Id = '+labelededit8.Text;
     End
     else
     begin                                                          // if the user answers they want a new program
     SQLQuery1.sql.text := 'insert into Programs (Full_reason,Description,step,motor,voltage,controller,target,params,program_data,owner,bay, status) values (:FR, :SR, :ST,:MO,:VO,:CO,:TA,:PAR,:PD,:OW,:BA, :STA)';
     end;
     end
     else
     begin                                                          // not in update mode
     SQLQuery1.sql.text := 'insert into Programs (Full_reason,Description,step,motor,voltage,controller,target,params,program_data,owner,bay, status,count) values (:FR, :SR, :ST,:MO,:VO,:CO,:TA,:PAR,:PD,:OW,:BA, :STA ,:COU)';    // Clear and update sql query
     end;
     {SET UP PARAMERERS FOR THE SQL DATA BASE}
     SQLQuery1.params.parambyname('FR').asstring     := Memo2.Text;
     SQLQuery1.params.paramByName('SR').asstring     := Labelededit1.Text;
     SQLQuery1.params.paramByName('ST').asstring     := WT_step.Text;
     SQLQuery1.params.paramByName('MO').asstring     := WT_motor.Text;
     SQLQuery1.params.paramByName('VO').asfloat      := Floatspinedit1.Value;
     SQLQuery1.params.paramByName('CO').asstring     := WT_cont.Text;
     SQLQuery1.params.paramByName('TA').asinteger    := spinedit6.value;
     SQLQuery1.params.paramByName('BA').asstring     := Bay_select.Text;
     SQLQuery1.params.paramByName('PAR').asinteger   := per;
     SQLQuery1.params.paramByName('PD').asstring     := holding;
     SQLQuery1.params.paramByName('OW').asstring     := username1.Text;
     SQLQuery1.params.paramByName('STA').asstring    := 'New';
     SQLQuery1.params.paramByName('COU').Asinteger   := 0;
     {completed setting up parameters  }
     SQLQuery1.ExecSQL;                                                // EXECUTE SQL
     SQLTransaction1.Commit;                                           // committ the sql transaction
     storage.Clear;
     For r := 1 to stringgrid2.RowCount - 1 do
     begin

     unit3.Check_SQL ('SELECT Pin,i2c_bus FROM Buses WHERE Alias ="'+stringgrid2.Cells[0,r]+'"');

     // read sql to get pin id and port id
    If (stringgrid2.Cells[2,r] = 'Time')then                                    // if timed create string with the following setup    port,pin,val,time
     begin
      if (stringgrid2.Cells[1,r] = 'Out') then tmp1 := '1' else tmp1 := '0';
      temp :=  '#'+stringgrid2.Cells[0,r]+','+stringgrid2.Cells[1,r]+','+stringgrid2.Cells[2,r]+','+stringgrid2.Cells[3,r];       // human readable
      storage.Lines.Add(temp);
      temp :=  datasource1.dataset.Fields[1].Asstring+','+datasource1.dataset.Fields[0].Asstring+','+'0,'+tmp1+','+stringgrid2.Cells[3,r];        // program readable
      storage.Lines.Add(temp);
     end
    else
    begin
          // if target string is port,pin,val,port,pin,val
    end;
    end;
     unit3.Check_SQL ('SELECT ID FROM Programs WHERE   ID = (SELECT MAX(ID)  FROM Programs);');    // get the id number assigned for this program
     Temp:= datasource1.dataset.Fields[0].Asstring;
     if ((Update_program = 1) and (val = Idyes)) then                  // is this an update and a overwrite
     begin
        Update_program := 0;                                           // reset the update variable
        complete_button.Caption:= 'Complete Program';                  // change caption
        Temp := labelededit8.Text;                                     // set id as the one we loaded
     end;
     If not directoryexists (Base+'Programs/') then
     begin
         createdir (Base+'Programs/')
     end;

     Storage.Lines.SaveToFile(Base+'Programs/'+temp);







{**********************************************************************************************************************}

     // clear all data inserted by user
     Memo2.Clear;
     Labelededit1.Text := '';
     WT_step.Text := '';
     WT_motor.Text := '';
     WT_cont.Text := '';
     Spinedit6.Value:= 0;
     floatspinedit2.value := 0;
     Bay_select.text := 'Select Bay';
     combobox2.text := 'Select Item';
     combobox3.text := 'Select Status';
     End_trigger.text := 'Select Trigger';
     combobox5.Text:= 'Select Trigger State';
     Checkgroup1.Checked[0] := false;
     Checkgroup1.Checked[1] := false;
     water.Checked := False;
     Holding := '';
     Stringgrid2.RowCount:= 1;
     Memoload := 0;

   end
   else
   Begin
        application.MessageBox ('No Program instructions - You must have at least 2 operations', 'No Program',MB_ICONERROR)
   end;
end;
end;

procedure TForm1.End_triggerChange(Sender: TObject);                    // set the end trigger show the correct type of display based on it (DON
begin
   if End_trigger.Text = 'Time' then
   begin
        floatspinedit2.Visible:= true;
        combobox5.Visible:= false;
        floatspinedit2.value := 0;
        Combobox5.itemindex := -1;
        Label9.Caption:='Time (sec)';
   end
   else
   begin
        floatspinedit2.Visible:= false;
        combobox5.Visible:= true;
        combobox5.Text:= 'Select Trigger State';
        Combobox5.itemindex := -1;
        floatspinedit2.value := 0;
        Label9.Caption:='Trigger State';
   end;
end;

procedure TForm1.Bay_selectChange(Sender: TObject);                     //select the bay (NOT COMPLETED)
var
rec,x : integer;
begin
  End_trigger.Items.Clear;
  combobox2.Items.Clear;
  End_trigger.Items.Add('Time');
  Case Bay_select.Text of
 '1':
  begin

      Panel3.Visible:= False;
      if update_program = 0 then water.Checked:= false;
      Checkbox4.Visible:= true;
  end;
 '9':
  Begin

      Panel3.Visible:= false;
      if update_program = 0 then water.Checked:= false;
      Checkbox4.Visible:= true;
  end;
  else
  begin
      Checkbox4.Visible:= False;
      Panel3.Visible:= False;
    if update_program = 0 then  water.Checked:= false;
  end;

  end;
  rec := unit3.Check_SQL('select Pin,Bus,Alias from buses where bay="'+Bay_select.Text +'" and direction ="Output"');
  for x := 0 to rec -1 do
  begin
       combobox2.Items.Append(dbGrid1.DataSource.DataSet.Fields[2].Asstring);
       dbGrid1.DataSource.DataSet.Next;
  end;
  rec := unit3.Check_SQL('select Pin,Bus,Alias from buses where bay="'+Bay_select.Text +'" and direction ="Input"');
  for x := 0 to rec -1 do
  begin
       end_trigger.Items.Append(dbGrid1.DataSource.DataSet.Fields[2].Asstring);
       dbGrid1.DataSource.DataSet.Next;
  end;


end;

procedure TForm1.Program_catagoryChange(Sender: TObject);               // select the correct data to show based on the user input (DONE)
begin
       unit3.Check_SQL('Select id, description, status,Owner,EST_Finish_date,Run_Time From Programs where Status = "'+Program_catagory.Text+'"');     // select the data based on progran cat text
       SetDBCols;                                                       // update the withds of the dbgrid

       if Program_catagory.ItemIndex = 1 then ALL_Pause.Visible:= true else ALL_Pause.Visible:= false;  // show the all pause button if on active data
end;

procedure TForm1.DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer); // helper function (DONE)
var
  MemoFieldReveal: MemoDifier;
  F : Integer;
begin
     if (DataCol = 1) then
   begin
     try
       with sender as tdbgrid do
       begin
      for f := 0 to Columns.Count -1 do
      begin
       Columns.Items[F].Field.OnGetText := @MemoFieldReveal.DBGridOnGetText;
       end;
       end;
     except
       On E: Exception do
       begin
         ShowMessage('Exception caught : ' + E.Message);
       end;
     end;
   end;
end;

procedure TForm1.RC_pin_dirChange(Sender: TObject);                     // rig config change direction of pin (NOT IMPLEMENTED)
var
   BoxStyle: Integer;
begin
  BoxStyle := MB_ICOnWARNING + MB_OK;
  Application.MessageBox('Changing the direction of the pin must be done AFTER you have physicaly changed the wire and BEFORE any program attempts to use it.PLEAS CHECK OTHER PROGRAMS TO SEE IF THEY USE THE OLD DIRECTION. If this is not done the rig electronics may be damaged.', 'WARNING!!', BoxStyle);
  end;

Procedure  TForm1.SetDBCols();                                          // Set the withdth of the columns on the dbgrid
begin
       dbgrid1.Columns[0].Width:= 60;
       dbgrid1.Columns[1].Width:= 660;
       dbgrid1.Columns[2].Width:= 87;
       dbgrid1.Columns[3].Width:= 87;
       dbgrid1.Columns[4].Width:= 200;
       dbgrid1.Columns[5].Width:= 150;

       dbgrid2.Columns[0].Width:= 60;
       dbgrid2.Columns[1].Width:= 660;
       dbgrid2.Columns[2].Width:= 87;
       dbgrid2.Columns[3].Width:= 87;
       dbgrid2.Columns[4].Width:= 200;
       dbgrid2.Columns[5].Width:= 150;
end;

procedure TForm1.Username1KeyPress(Sender: TObject; var Key: char);     // Check for enter in the user name box
begin
  if key = #13 then
  begin
   form1.ActiveControl := password;
  end;
end;

end.

