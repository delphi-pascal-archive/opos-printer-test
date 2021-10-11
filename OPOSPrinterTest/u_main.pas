unit u_main;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, Registry, SMJOPOSPOSPrinterControlObjectLib_TLB, System.Types;

type
  TOPOSPrinterTest = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    POSPrinter1: TPOSPrinter;
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ViewResultCode(ResultCode: integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure POSPrinter1ErrorEvent(ASender: TObject; ResultCode, ResultCodeExtended, ErrorLocus: integer; var pErrorResponse: integer);
    procedure POSPrinter1StatusUpdateEvent(ASender: TObject; Status: integer);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var OPOSPrinterTest: TOPOSPrinterTest;

implementation

{$R *.dfm}

function vbSpace(Number:integer):String;
var
i:integer;
SpaceLine:string;
begin
for i:=0 to Number-1 do
  begin
    SpaceLine:=SpaceLine+space;
  end;
   result:= SpaceLine;
end;

procedure TOPOSPrinterTest.btn1Click(Sender: TObject);
begin
ShowMessage(IntToStr(POSPrinter1.JrnLineChars));
end;

procedure TOPOSPrinterTest.Button10Click(Sender: TObject);
begin
  ViewResultCode(POSPrinter1.ReleaseDevice);

  CheckBox1.Enabled := False;
  CheckBox2.Enabled := False;
  CheckBox3.Enabled := False;
  CheckBox4.Enabled := False;
  CheckBox5.Enabled := False;
end;

procedure TOPOSPrinterTest.Button11Click(Sender: TObject);
begin
  ViewResultCode(POSPrinter1.Close);

  CheckBox1.Enabled := False;
  CheckBox2.Enabled := False;
  CheckBox3.Enabled := False;
  CheckBox4.Enabled := False;
  CheckBox5.Enabled := False;
  RadioButton1.Enabled := False;
  RadioButton2.Enabled := False;
  RadioButton3.Enabled := False;
end;

procedure TOPOSPrinterTest.Button1Click(Sender: TObject);
begin
  ViewResultCode(POSPrinter1.Open(ComboBox1.Text));
  If POSPrinter1.CapSlpPresent = True
  Then begin
    RadioButton3.Enabled := True;
    RadioButton3.Checked := True;
  end;
  If POSPrinter1.CapRecPresent = True
  Then begin
    RadioButton2.Enabled := True;
    RadioButton2.Checked := True;
  end;
  If POSPrinter1.CapJrnPresent = True
  Then begin
    RadioButton1.Enabled := True;
    RadioButton1.Checked := True;
  end;

end;

procedure TOPOSPrinterTest.Button2Click(Sender: TObject);
begin
  ViewResultCode(POSPrinter1.ClaimDevice(150));
end;

procedure TOPOSPrinterTest.Button3Click(Sender: TObject);
begin
  POSPrinter1.PowerNotify := 1;

  POSPrinter1.DeviceEnabled := True;

  ViewResultCode(POSPrinter1.ResultCode);

  If POSPrinter1.ResultCode = 0
  Then
    If POSPrinter1.CapCoverSensor = True
    Then CheckBox1.Enabled := True;
  If POSPrinter1.CapJrnEmptySensor = True
  Then CheckBox2.Enabled := True;
  If POSPrinter1.CapRecEmptySensor = True
  Then CheckBox3.Enabled := True;
  If POSPrinter1.CapSlpEmptySensor = True
  Then CheckBox4.Enabled := True;
  // ****************************
  If POSPrinter1.CoverOpen = True
  Then CheckBox1.Checked := True
  Else CheckBox1.Checked := False;
  // **************************
  If POSPrinter1.JrnEmpty = True
  Then begin
    CheckBox2.Checked := True;
    CheckBox2.Caption := 'JrnEmpty';
  end else If POSPrinter1.JrnNearEnd = True
  Then begin
    CheckBox2.Checked := True;
    CheckBox2.Caption := 'JrnNearEnd';
  end Else begin
    CheckBox2.Checked := False;
    CheckBox2.Caption := 'JrnEmpty';
  end;
  // ********************************************
  If POSPrinter1.RecEmpty = True
  Then begin
    CheckBox3.Checked := True;
    CheckBox3.Caption := 'RecEmpty';
  end Else If POSPrinter1.RecNearEnd = True
  Then begin
    CheckBox3.Checked := True;
    CheckBox3.Caption := 'RecNearEnd';
  end Else begin
    CheckBox3.Checked := False;
    CheckBox3.Caption := 'RecEmpty';
  end;
  // *********************************************
  If POSPrinter1.SlpEmpty = True
  Then begin
    CheckBox4.Checked := True;
    CheckBox4.Caption := 'SlpEmpty';
  end else If POSPrinter1.SlpNearEnd = True
  Then begin
    CheckBox4.Checked := True;
    CheckBox4.Caption := 'SlpNearEnd';
  end Else begin
    CheckBox4.Checked := False;
    CheckBox4.Caption := 'SlpEmpty';
  End;
  // *******************************************

  CheckBox5.Enabled := True;
  CheckBox5.Checked := False;
  POSPrinter1.CharacterSet:=1251;
  POSPrinter1.FlagWhenIdle := True;
end;

procedure TOPOSPrinterTest.Button8Click(Sender: TObject);
var DateMes, TimeMes: string; Messages: string; station, i: integer;
begin
  while POSPrinter1.State <> 2 do // Проверка на готовность
  begin
    Case POSPrinter1.State of
      1: Messages := 'State = OPOS_S_CLOSED';
      2: Messages := 'State = OPOS_S_IDLE';
      3: Messages := 'State = OPOS_S_BUSY';
      4: Messages := 'State = OPOS_S_ERROR';
      Else Messages := 'State = Error !?' + IntTostr(POSPrinter1.State);
      End;
      If MessageBox(0, PChar(Messages), 'Repeat?', MB_RETRYCANCEL) = mrCancel
        Then Exit;
  end;
  // *************************************
  If RadioButton1.Checked = True
    Then station := 1
      Else
        If RadioButton2.Checked = True
          Then station := 2
           Else
            If RadioButton3.Checked = True
              Then station := 4
               Else Exit;
  // **************************************
  DateMes := FormatDateTime('dd mmm yyyy', Date);
  TimeMes := FormatDateTime('tt', Time);
  ViewResultCode(POSPrinter1.TransactionPrint(station, 11));
    // 11-PTR_TP_TRANSACTION
  Case station of
    1: // PTR_S_JOURNAL
     begin
      ViewResultCode(POSPrinter1.RotatePrint(station, $1 { PTR_RP_NORMAL } ));
      If POSPrinter1.ValidateData(station, Chr($1B)+'|rA') = 0 { OPOS_SUCCESS }
        Then ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10))
        Else ViewResultCode(POSPrinter1.PrintNormal(station, vbSpace(POSPrinter1.JrnLineChars-Length(DateMes+' '+TimeMes))+DateMes+' '+TimeMes+#13#10+#13#10));
        Case POSPrinter1.CapCharacterSet of
      998://PTR_CCS_ASCII
          begin
            ViewResultCode(POSPrinter1.PrintNormal(station, 'Apple' + vbSpace(POSPrinter1.JrnLineChars - Length('Apple$20.00')) + '$20.00' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'Subtotal' + vbSpace(POSPrinter1.JrnLineChars - Length('Subtotal') - Length('$200.00')) + '$200.00' + #13#10));

              If POSPrinter1.ValidateData(station, Chr($1B) + '|uC') = 0 { OPOS_SUCCESS }
                Then ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|uC' + 'Tax' + vbSpace(POSPrinter1.JrnLineChars - Length('Tax') - Length('$10.00')) + '$10.00' + #13#10))
                  Else
                    begin
                      ViewResultCode(POSPrinter1.PrintNormal(station, 'Tax' + vbSpace(POSPrinter1.JrnLineChars - Length('Tax') - Length('$10.00')) + '$10.00' + #13#10));
                      ViewResultCode(POSPrinter1.PrintNormal(station, StringOfChar('-',POSPrinter1.JrnLineChars) + #13#10))
                     end;
         If POSPrinter1.ValidateData(station, Chr($1B) + '|2C') = 0 { OPOS_SUCCESS }
           Then
            begin
              ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'Total' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('Total') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, 'Received' + vbSpace(POSPrinter1.JrnLineChars - Length('Received') - Length('$300.00')) + '$300.00' + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|2C' + 'Change' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('Change') - Length('$90.00')) + '$90.00' + #13#10));
           end
           Else
            begin
            ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'Total' + vbSpace(POSPrinter1.JrnLineChars - Length('Total') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, 'Received' + vbSpace(POSPrinter1.JrnLineChars - Length('Received') - Length('$300.00')) + '$300.00' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, 'Change' + vbSpace(POSPrinter1.JrnLineChars - Length('Change') - Length('$90.00')) + '$90.00' + #13#10));
          end;
        end;

      10 { PTR_CCS_KANA } :
        begin
          ViewResultCode(POSPrinter1.PrintNormal(station, 'ШЭєЮ' + vbSpace(POSPrinter1.JrnLineChars - Length('ШЭєЮ\2,000')) + '\2,000' + #13#10));
          ViewResultCode(POSPrinter1.PrintNormal(station, 'КЮЕЕ' + vbSpace(POSPrinter1.JrnLineChars - Length('КЮЕЕ\3,000')) + '\3,000' + #13#10));
          ViewResultCode(POSPrinter1.PrintNormal(station, 'МЮДЮі' + vbSpace(POSPrinter1.JrnLineChars - Length('МЮДЮі\4,000')) + '\4,000' + #13#10));
          ViewResultCode(POSPrinter1.PrintNormal(station, 'ЪУЭ' + vbSpace(POSPrinter1.JrnLineChars - Length('ЪУЭ\5,000')) + '\5,000' + #13#10));
          ViewResultCode(POSPrinter1.PrintNormal(station, 'Р¶Э' + vbSpace(POSPrinter1.JrnLineChars - Length('Р¶Э\6,000')) + '\6,000' + #13#10 + #13#10));
          ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'ј®і№І' + vbSpace(POSPrinter1.JrnLineChars - Length('ј®і№І') - Length('\20,000')) + '\20,000' + #13#10));

        If POSPrinter1.ValidateData(station, Chr($1B) + '|uC') = 0 { OPOS_SUCCESS }
          Then ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|uC' + 'ј®іЛѕЮІ' + vbSpace(POSPrinter1.JrnLineChars - Length('ј®іЛѕЮІ') - Length('\1,000')) + '\1,000' + #13#10))
            Else
           begin
            ViewResultCode(POSPrinter1.PrintNormal(station, 'ј®іЛѕЮІ' + vbSpace(POSPrinter1.JrnLineChars - Length('ј®іЛѕЮІ') - Length('\1,000')) + '\1,000' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, StringOfChar('-',POSPrinter1.JrnLineChars) + #13#10));
           end;
        If POSPrinter1.ValidateData(station, Chr($1B) + '|2C') = 0 { OPOS_SUCCESS }
          Then
            begin
             ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'єЮі№І' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('єЮі№І') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
             ViewResultCode(POSPrinter1.PrintNormal(station, 'µ±ЅЮ¶Ш' + vbSpace(POSPrinter1.JrnLineChars - Length('µ±ЅЮ¶Ш') - Length('\30,000')) + '\30,000' + #13#10));
             ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|2C' + 'µВШ' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('µВШ') - Length('\9,000')) + '\9,000' + #13#10));
            end
             Else
             begin
              ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'єЮі№І' + vbSpace(POSPrinter1.JrnLineChars - Length('єЮі№І') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, 'µ±ЅЮ¶Ш' + vbSpace(POSPrinter1.JrnLineChars - Length('µ±ЅЮ¶Ш') - Length('\30,000')) + '\30,000' + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, 'µВШ' + vbSpace(POSPrinter1.JrnLineChars - Length('µВШ') - Length('\9,000')) + '\9,000' + #13#10));
             end;
      end;
      11 { PTR_CCS_KANJI } :
          begin
            ViewResultCode(POSPrinter1.PrintNormal(station, '‚и‚с‚І' + vbSpace(POSPrinter1.JrnLineChars - Length('‚и‚с‚І') * 2 - Length('\2,000')) + '\2,000' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, 'ѓoѓiѓi' + vbSpace(POSPrinter1.JrnLineChars - Length('ѓoѓiѓi') * 2 - Length('\3,000')) + '\3,000' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, '‚Ф‚З‚¤' + vbSpace(POSPrinter1.JrnLineChars - Length('‚Ф‚З‚¤') * 2 - Length('\4,000')) + '\4,000' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, 'ѓЊѓ‚ѓ“' + vbSpace(POSPrinter1.JrnLineChars - Length('ѓЊѓ‚ѓ“') * 2 - Length('\5,000')) + '\5,000' + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, '‚Э‚©‚с' + vbSpace(POSPrinter1.JrnLineChars - Length('‚Э‚©‚с') * 2 - Length('\6,000')) + '\6,000' + #13#10 + #13#10));
            ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'Џ¬Њv' + vbSpace(POSPrinter1.JrnLineChars - Length('Џ¬Њv') * 2 - Length('\20,000')) + '\20,000' + #13#10));
           If POSPrinter1.ValidateData(station, Chr($1B) + '|uC') = 0 { OPOS_SUCCESS }
            Then ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|uC' + 'ЏБ”пђЕ' + vbSpace(POSPrinter1.JrnLineChars - Length('ЏБ”пђЕ') * 2 - Length('\1,000')) + '\1,000' + #13#10))
              Else
              begin
                ViewResultCode(POSPrinter1.PrintNormal(station, 'ЏБ”пђЕ' + vbSpace(POSPrinter1.JrnLineChars - Length('ЏБ”пђЕ') * 2 - Length('\1,000')) + '\1,000' + #13#10));
                ViewResultCode(POSPrinter1.PrintNormal(station, StringOfChar('-',POSPrinter1.JrnLineChars) + #13#10));
               End;
           If POSPrinter1.ValidateData(station, Chr($1B) + '|2C') = 0 { OPOS_SUCCESS }
            Then
             begin
              ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'Ќ‡Њv' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('Ќ‡Њv') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, '‚Ё—a‚©‚и' + vbSpace(POSPrinter1.JrnLineChars - Length('‚Ё—a‚©‚и') * 2 - Length('\30,000')) + '\30,000' + #13#10));
              ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|2C' + '‚Ё’Ю‚и' + vbSpace(POSPrinter1.JrnLineChars div 2 - Length('‚Ё’Ю‚и') * 2 - Length('\9,000')) + '\9,000' + #13#10));
              end
           Else
            begin
             ViewResultCode(POSPrinter1.PrintNormal(station, Chr($1B) + '|bC' + 'Ќ‡Њv' + vbSpace(POSPrinter1.JrnLineChars - Length('Ќ‡Њv') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
             ViewResultCode(POSPrinter1.PrintNormal(station, '‚Ё—a‚©‚и' + vbSpace(POSPrinter1.JrnLineChars - Length('‚Ё—a‚©‚и') * 2 - Length('\30,000')) + '\30,000' + #13#10));
             ViewResultCode(POSPrinter1.PrintNormal(station, '‚Ё’Ю‚и' + vbSpace(POSPrinter1.JrnLineChars - Length('‚Ё’Ю‚и') * 2 - Length('\9,000')) + '\9,000' + #13#10));
            End;
          end;
     End;
     // Конец оператора выбора PTR_S_JOURNAL
    end;

    2: //PTR_S_RECEIPT
       begin
        ViewResultCode(POSPrinter1.RotatePrint(station, $1)); //PTR_RP_NORMAL
         Case POSPrinter1.CapCharacterSet of
                998: //PTR_CCS_ASCII
                begin
                    ViewResultCode(POSPrinter1.PrintBitmap(station, ExtractFilePath(Application.ExeName) + 'StarLogo1.bmp', POSPrinter1.RecLineWidth div 2, -2 { PTR_BM_RIGHT } ));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0 {OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0 {OPOS_SUCCESS}) Then
						          begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'ТЕЛ 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'Спасибо за визит, в наш магазин. ' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'Надеемся увидеть Вас снова!' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					          	end
                    Else
					        	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length('ТЕЛ 9999-99-9999')) + 'ТЕЛ 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('Спасибо за визит, в наш магазин. ')) div 2) + 'Спасибо за визит, в наш магазин. ' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('Надеемся увидеть Вас снова!')) div 2) + 'Надеемся увидеть Вас снова!' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					        	end;
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Яблоки' + vbSpace(POSPrinter1.RecLineChars - Length(PChar('Яблоки$20.00'))) + '$20.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Бананы' + vbSpace(POSPrinter1.RecLineChars - Length(PChar('Бананы$30.00'))) + '$30.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Грейпфрукт' + vbSpace(POSPrinter1.RecLineChars - Length(PChar('Грейпфрукт$40.00'))) + '$40.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Лимоны' + vbSpace(POSPrinter1.RecLineChars - Length(PChar('Лимоны$50.00'))) + '$50.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Апельсины' + vbSpace(POSPrinter1.RecLineChars - Length('Апельсины$60.00')) + '$60.00' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ВСЕГО' + vbSpace(POSPrinter1.RecLineChars - Length('ВСЕГО') - Length('$200.00')) + '$200.00' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0 {OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + 'НДС' + vbSpace(POSPrinter1.RecLineChars - Length('НДС') - Length('$10.00')) + '$10.00' + #13#10))
                    Else
                   		begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НДС' + vbSpace(POSPrinter1.RecLineChars - Length('НДС') - Length('$10.00')) + '$10.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.RecLineChars) + #13#10));
						          end;
                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0 {OPOS_SUCCESS} Then
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'ИТОГО:' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('ИТОГО:') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НАЛИЧНЫЕ:' + vbSpace(POSPrinter1.RecLineChars - Length('НАЛИЧНЫЕ:') - Length('$300.00')) + '$300.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'СДАЧА:' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('СДАЧА:') - Length('RUR 90.00')) + 'RUR 90.00' + #13#10));
					          	end
                    Else
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ИТОГО:' + vbSpace(POSPrinter1.RecLineChars - Length('ИТОГО:') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НАЛИЧНЫЕ:' + vbSpace(POSPrinter1.RecLineChars - Length('НАЛИЧНЫЕ:') - Length('$300.00')) + '$300.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'СДАЧА:' + vbSpace(POSPrinter1.RecLineChars - Length('СДАЧА:') - Length('RUR 90.00')) + 'RUR 90.00' + #13#10));
						          end
                end;


                10://PTR_CCS_KANA
                begin
                    ViewResultCode (POSPrinter1.PrintBitmap(Station, ExtractFilePath(Application.ExeName) + '\\StarLogo1.bmp', POSPrinter1.RecLineWidth div 2, -3 {PTR_BM_RIGHT}));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0 {OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0 {OPOS_SUCCESS}) Then
						          begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					          	end
                    Else
                    begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length('TEL 9999-99-9999')) + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡')) div 2) + 'ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ')) div 2) + 'ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					              end;

                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾘﾝｺﾞ' + vbSpace(POSPrinter1.RecLineChars - Length('ﾘﾝｺﾞ\2,000')) + '\2,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾊﾞﾅﾅ' + vbSpace(POSPrinter1.RecLineChars - Length('ﾊﾞﾅﾅ\3,000')) + '\3,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾌﾞﾄﾞｳ' + vbSpace(POSPrinter1.RecLineChars - Length('ﾌﾞﾄﾞｳ\4,000')) + '\4,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾚﾓﾝ' + vbSpace(POSPrinter1.RecLineChars - Length('ﾚﾓﾝ\5,000')) + '\5,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾐｶﾝ' + vbSpace(POSPrinter1.RecLineChars - Length('ﾐｶﾝ\6,000')) + '\6,000' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ｼｮｳｹｲ' + vbSpace(POSPrinter1.RecLineChars - Length('ｼｮｳｹｲ') - Length('\20,000')) + '\20,000' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0 {OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + 'ｼｮｳﾋｾﾞｲ' + vbSpace(POSPrinter1.RecLineChars - Length('ｼｮｳﾋｾﾞｲ') - Length('\1,000')) + '\1,000' + #13#10))
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｼｮｳﾋｾﾞｲ' + vbSpace(POSPrinter1.RecLineChars - Length('ｼｮｳﾋｾﾞｲ') - Length('\1,000')) + '\1,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.RecLineChars) + #13#10));
						          end;

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0 {OPOS_SUCCESS} Then
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'ｺﾞｳｹｲ' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('ｺﾞｳｹｲ') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵｱｽﾞｶﾘ' + vbSpace(POSPrinter1.RecLineChars - Length('ｵｱｽﾞｶﾘ') - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'ｵﾂﾘ' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('ｵﾂﾘ') - Length('\9,000')) + '\9,000' + #13#10));
						          end
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ｺﾞｳｹｲ' + vbSpace(POSPrinter1.RecLineChars - Length('ｺﾞｳｹｲ') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵｱｽﾞｶﾘ' + vbSpace(POSPrinter1.RecLineChars - Length('ｵｱｽﾞｶﾘ') - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵﾂﾘ' + vbSpace(POSPrinter1.RecLineChars - Length('ｵﾂﾘ') - Length('\9,000')) + '\9,000' + #13#10));
						          end
                end;
               11:// PTR_CCS_KANJI
                begin
                    ViewResultCode (POSPrinter1.PrintBitmap(Station, ExtractFileName(Application.ExeName) + '\\StarLogo1.bmp', POSPrinter1.RecLineWidth div 2, -3{PTR_BM_RIGHT}));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0 {OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0 {OPOS_SUCCESS}) Then
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'お買い上げありがとうございました。' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'またのご来店をお待ちしております。' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					          	end
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length('TEL 9999-99-9999')) + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('お買い上げありがとうございました。') * 2) div 2) + 'お買い上げありがとうございました。' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.RecLineChars - Length('またのご来店をお待ちしております。') * 2) div 2) + 'またのご来店をお待ちしております。' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.RecLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
						          end;

                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'りんご' + vbSpace(POSPrinter1.RecLineChars - Length('りんご') * 2 - Length('\2,000')) + '\2,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'バナナ' + vbSpace(POSPrinter1.RecLineChars - Length('バナナ') * 2 - Length('\3,000')) + '\3,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ぶどう' + vbSpace(POSPrinter1.RecLineChars - Length('ぶどう') * 2 - Length('\4,000')) + '\4,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'レモン' + vbSpace(POSPrinter1.RecLineChars - Length('レモン') * 2 - Length('\5,000')) + '\5,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'みかん' + vbSpace(POSPrinter1.RecLineChars - Length('みかん') * 2 - Length('\6,000')) + '\6,000' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + '小計' + vbSpace(POSPrinter1.RecLineChars - Length('小計') * 2 - Length('\20,000')) + '\20,000' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0 {OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + '消費税' + vbSpace(POSPrinter1.RecLineChars - Length('消費税') * 2 - Length('\1,000')) + '\1,000' + #13#10))
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, '消費税' + vbSpace(POSPrinter1.RecLineChars - Length('消費税') * 2 - Length('\1,000')) + '\1,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.RecLineChars) + #13#10));
						          end;
                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0 {OPOS_SUCCESS} Then
                      begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + '合計' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('合計') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お預かり' + vbSpace(POSPrinter1.RecLineChars - Length('お預かり') * 2 - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'お釣り' + vbSpace(POSPrinter1.RecLineChars div 2 - Length('お釣り') * 2 - Length('\9,000')) + '\9,000' + #13#10));
					           	end
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + '合計' + vbSpace(POSPrinter1.RecLineChars - Length('合計') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お預かり' + vbSpace(POSPrinter1.RecLineChars - Length('お預かり') * 2 - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お釣り' + vbSpace(POSPrinter1.RecLineChars - Length('お釣り') * 2 - Length('\9,000')) + '\9,000' + #13#10));
					          	end;
                    End;
                   end;
                   For i:= 1 To POSPrinter1.RecLinesToPaperCut do
                    begin
                     ViewResultCode (POSPrinter1.PrintNormal(Station, #13#10)) ;
                    end ;
                     ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|P'));
                End; //Конец PTR_S_RECEIPT

       4://PTR_S_SLIP
    begin
     ViewResultCode (POSPrinter1.RotatePrint(Station, $1));
            Case POSPrinter1.CapCharacterSet of
                998://PTR_CCS_ASCII
				      	begin
                    ViewResultCode (POSPrinter1.PrintBitmap(Station, ExtractFilePath(Application.ExeName) + '\\StarLogo1.bmp', POSPrinter1.SlpLineWidth div 2, -3 {PTR_BM_RIGHT}));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0{OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0 {OPOS_SUCCESS}) Then
						          begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'Тел 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'Сбасибо за покупку ' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'Надеемся увидеть вас снова!' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
                      End
                    Else
						          begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length('Тел 9999-99-9999')) + 'Тел 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('Сбасибо за покупку ')) div 2) + 'Сбасибо за покупку ' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('Надеемся увидеть вас снова!')) div 2) + 'Надеемся увидеть вас снова!' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
						          end;
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Яблоко' + vbSpace(POSPrinter1.SlpLineChars - Length('Apple$20.00')) + '$20.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Бананы' + vbSpace(POSPrinter1.SlpLineChars - Length('Banana$30.00')) + '$30.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Грейпфрукт' + vbSpace(POSPrinter1.SlpLineChars - Length('Grape$40.00')) + '$40.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Лимон' + vbSpace(POSPrinter1.SlpLineChars - Length('Lemon$50.00')) + '$50.00' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'Апельсин' + vbSpace(POSPrinter1.SlpLineChars - Length('Orange$60.00')) + '$60.00' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ИТОГО' + vbSpace(POSPrinter1.SlpLineChars - Length('ИТОГО') - Length('$200.00')) + '$200.00' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0{OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + 'НДС' + vbSpace(POSPrinter1.SlpLineChars - Length('НДС') - Length('$10.00')) + '$10.00' + #13#10))
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НДС' + vbSpace(POSPrinter1.SlpLineChars - Length('НДС') - Length('$10.00')) + '$10.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.SlpLineChars) + #13#10));
                    End;

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0 {OPOS_SUCCESS} Then
						          begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'ИТОГ' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('ИТОГ') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НАЛИЧНЫЕ' + vbSpace(POSPrinter1.SlpLineChars - Length('НАЛИЧНЫЕ') - Length('$300.00')) + '$300.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'СДАЧА' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('СДАЧА') - Length('$90.00')) + '$90.00' + #13#10));
					          	End
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ИТОГ' + vbSpace(POSPrinter1.SlpLineChars - Length('ИТОГ') - Length('$210.00')) + '$210.00' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'НАЛИЧНЫЕ' + vbSpace(POSPrinter1.SlpLineChars - Length('НАЛИЧНЫЕ') - Length('$300.00')) + '$300.00' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'СДАЧА' + vbSpace(POSPrinter1.SlpLineChars - Length('СДАЧА') - Length('$90.00')) + '$90.00' + #13#10));
						          End
                 End;
                10:// PTR_CCS_KANA
                	begin
                    ViewResultCode (POSPrinter1.PrintBitmap(Station, ExtractFilePath(Application.ExeName) + '\\StarLogo1.bmp', POSPrinter1.SlpLineWidth div 2, -3{PTR_BM_RIGHT}));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0{OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0{OPOS_SUCCESS}) Then
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					          	End
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length('TEL 9999-99-9999')) + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡')) div 2) + 'ｵｶｲｱｹﾞｱﾘｶﾞﾄｳｺﾞｻﾞｲﾏｼﾀ｡' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ')) div 2) + 'ﾏﾀﾉｺﾞﾗｲﾃﾝｦｵﾏﾁｼﾃｵﾘﾏｽ｡ ' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
                        End ;

                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾘﾝｺﾞ' + vbSpace(POSPrinter1.SlpLineChars - Length('ﾘﾝｺﾞ\2,000')) + '\2,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾊﾞﾅﾅ' + vbSpace(POSPrinter1.SlpLineChars - Length('ﾊﾞﾅﾅ\3,000')) + '\3,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾌﾞﾄﾞｳ' + vbSpace(POSPrinter1.SlpLineChars - Length('ﾌﾞﾄﾞｳ\4,000')) + '\4,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾚﾓﾝ' + vbSpace(POSPrinter1.SlpLineChars - Length('ﾚﾓﾝ\5,000')) + '\5,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ﾐｶﾝ' + vbSpace(POSPrinter1.SlpLineChars - Length('ﾐｶﾝ\6,000')) + '\6,000' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ｼｮｳｹｲ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｼｮｳｹｲ') - Length('\20,000')) + '\20,000' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0{OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + 'ｼｮｳﾋｾﾞｲ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｼｮｳﾋｾﾞｲ') - Length('\1,000')) + '\1,000' + #13#10))
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｼｮｳﾋｾﾞｲ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｼｮｳﾋｾﾞｲ') - Length('\1,000')) + '\1,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.SlpLineChars) + #13#10));
                        End;

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0{OPOS_SUCCESS} Then
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + 'ｺﾞｳｹｲ' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('ｺﾞｳｹｲ') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵｱｽﾞｶﾘ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｵｱｽﾞｶﾘ') - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'ｵﾂﾘ' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('ｵﾂﾘ') - Length('\9,000')) + '\9,000' + #13#10));
					          	End
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + 'ｺﾞｳｹｲ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｺﾞｳｹｲ') - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵｱｽﾞｶﾘ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｵｱｽﾞｶﾘ') - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'ｵﾂﾘ' + vbSpace(POSPrinter1.SlpLineChars - Length('ｵﾂﾘ') - Length('\9,000')) + '\9,000' + #13#10));
					        	end;
                    End;
                  11://PTR_CCS_KANJI:
                	begin
                    ViewResultCode (POSPrinter1.PrintBitmap(Station, ExtractFilePath(application.ExeName) + '\\StarLogo1.bmp', POSPrinter1.SlpLineWidth div 2, -3{PTR_BM_RIGHT}));

                    If (POSPrinter1.ValidateData(Station, Chr($1B) + '|rA') = 0{OPOS_SUCCESS}) And (POSPrinter1.ValidateData(Station, Chr($1B) + '|cA') = 0{OPOS_SUCCESS}) Then
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'お買い上げありがとうございました。' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|cA' + 'またのご来店をお待ちしております。' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|rA' + DateMes + '  ' + TimeMes + #13#10 + #13#10));
					          	end
                    Else
				          		begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length('TEL 9999-99-9999')) + 'TEL 9999-99-9999' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('お買い上げありがとうございました。') * 2) div 2) + 'お買い上げありがとうございました。' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace((POSPrinter1.SlpLineChars - Length('またのご来店をお待ちしております。') * 2) div 2) + 'またのご来店をお待ちしております。' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, vbSpace(POSPrinter1.SlpLineChars - Length(DateMes + '  ' + TimeMes)) + DateMes + '  ' + TimeMes + #13#10 + #13#10));
                        End;
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'りんご' + vbSpace(POSPrinter1.SlpLineChars - Length('りんご') * 2 - Length('\2,000')) + '\2,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'バナナ' + vbSpace(POSPrinter1.SlpLineChars - Length('バナナ') * 2 - Length('\3,000')) + '\3,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'ぶどう' + vbSpace(POSPrinter1.SlpLineChars - Length('ぶどう') * 2 - Length('\4,000')) + '\4,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'レモン' + vbSpace(POSPrinter1.SlpLineChars - Length('レモン') * 2 - Length('\5,000')) + '\5,000' + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, 'みかん' + vbSpace(POSPrinter1.SlpLineChars - Length('みかん') * 2 - Length('\6,000')) + '\6,000' + #13#10 + #13#10));
                    ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + '小計' + vbSpace(POSPrinter1.SlpLineChars - Length('小計') * 2 - Length('\20,000')) + '\20,000' + #13#10));

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|uC') = 0{OPOS_SUCCESS} Then
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|uC' + '消費税' + vbSpace(POSPrinter1.SlpLineChars - Length('消費税') * 2 - Length('\1,000')) + '\1,000' + #13#10))
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, '消費税' + vbSpace(POSPrinter1.SlpLineChars - Length('消費税') * 2 - Length('\1,000')) + '\1,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, StringOfChar('-',POSPrinter1.SlpLineChars) + #13#10));
                    	End;

                    If POSPrinter1.ValidateData(Station, Chr($1B) + '|2C') = 0{OPOS_SUCCESS}  Then
					          	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + Chr($1B) + '|2C' + '合計' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('合計') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お預かり' + vbSpace(POSPrinter1.SlpLineChars - Length('お預かり') * 2 - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|2C' + 'お釣り' + vbSpace(POSPrinter1.SlpLineChars div 2 - Length('お釣り') * 2 - Length('\9,000')) + '\9,000' + #13#10));
					          	End
                    Else
                    	begin
                        ViewResultCode (POSPrinter1.PrintNormal(Station, Chr($1B) + '|bC' + '合計' + vbSpace(POSPrinter1.SlpLineChars - Length('合計') * 2 - Length('\21,000')) + '\21,000' + #13#10 + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お預かり' + vbSpace(POSPrinter1.SlpLineChars - Length('お預かり') * 2 - Length('\30,000')) + '\30,000' + #13#10));
                        ViewResultCode (POSPrinter1.PrintNormal(Station, 'お釣り' + vbSpace(POSPrinter1.SlpLineChars - Length('お釣り') * 2 - Length('\9,000')) + '\9,000' + #13#10));
						          End ;
                    End ;
                 End ;
              End;
       end; //Конец общего оператора выбора
    If Station = 4 {PTR_S_SLIP} Then
        begin
            If (POSPrinter1.CapSlpEmptySensor = False) Or (POSPrinter1.BeginInsertion(5000) = 0 {OPOS_SUCCESS}) Then
				      begin
                 ViewResultCode (POSPrinter1.EndInsertion);
                 POSPrinter1.AsyncMode:= False;     //Synchronous
                 ViewResultCode (POSPrinter1.TransactionPrint(Station, 12{PTR_TP_NORMAL}));
                 ViewResultCode (POSPrinter1.BeginRemoval(-1{OPOS_FOREVER}));
                 ViewResultCode (POSPrinter1.EndRemoval);
                 Exit;
                End
            Else
                begin
                   Case POSPrinter1.ResultCode of
                     0:      Messages:= 'BeginInsertion : OPOS_SUCCESS';
                     101:     Messages:= 'BeginInsertion : OPOS_E_CLOSED';
                     102:    Messages:= 'BeginInsertion : OPOS_E_CLAIMED';
                     103: Messages:= 'BeginInsertion : OPOS_E_NOTCLAIMED';
                     104:  Messages:= 'BeginInsertion : OPOS_E_NOSERVICE';
                     105:   Messages:= 'BeginInsertion : OPOS_E_DISABLED';
                     106:    Messages:= 'BeginInsertion : OPOS_E_ILLEGAL';
                     107: Messages:= 'BeginInsertion : OPOS_E_NOHARDWARE';
                     108:    Messages:= 'BeginInsertion : OPOS_E_OFFLINE';
                     109:    Messages:= 'BeginInsertion : OPOS_E_NOEXIST';
                     110:     Messages:= 'BeginInsertion : OPOS_E_EXISTS';
                     111:    Messages:= 'BeginInsertion : OPOS_E_FAILURE';
                     112:    Messages:= 'BeginInsertion : OPOS_E_TIMEOUT';
                     113:       Messages:= 'BeginInsertion : OPOS_E_BUSY';
                     114:   Messages:= 'BeginInsertion : OPOS_E_EXTENDED';
                     Else Messages:= 'BeginInsertion : ResultCode Error !?';
                    end;

                  ViewResultCode (POSPrinter1.EndInsertion);
                  If MessageBox(0,PChar(Messages), 'Message',MB_RETRYCANCEL) = mrCancel Then
					        begin
                    POSPrinter1.ClearOutput;
                    Exit;
                    End
                  End
        End else
         begin
          POSPrinter1.AsyncMode:= True ;
           ViewResultCode(POSPrinter1.TransactionPrint(Station, 12{PTR_TP_NORMAL}));
         End;
    CheckBoX5.Checked:= False;
    POSPrinter1.FlagWhenIdle:= True;

  end;//Конец всей процедуры


              procedure TOPOSPrinterTest.Button9Click(Sender: TObject); begin POSPrinter1.DeviceEnabled := False;

      ViewResultCode(POSPrinter1.ResultCode);

      If (POSPrinter1.ResultCode = 0) or (POSPrinter1.ResultCode <> 113) Then begin CheckBox1.Enabled := False; CheckBox2.Enabled := False; CheckBox3.Enabled := False; CheckBox4.Enabled := False; CheckBox5.Enabled := False; End end;

              procedure TOPOSPrinterTest.FormClose(Sender: TObject; var Action: TCloseAction);
              begin
              POSPrinter1.DeviceEnabled := False;
              POSPrinter1.ReleaseDevice;
              POSPrinter1.Close;
              While Not(POSPrinter1.State = 1) Or (POSPrinter1.State = 2) Do
                            end;

              procedure TOPOSPrinterTest.FormCreate(Sender: TObject); var reg: TRegistry; StatusKeyReg: boolean; i: integer; l: TStringList; begin reg := TRegistry.Create; l := TStringList.Create; try reg.RootKey := HKEY_LOCAL_MACHINE; StatusKeyReg := reg.OpenKeyReadOnly('Software\OLEforRetail\ServiceOPOS\POSPrinter'); if StatusKeyReg <> True then ShowMessage('Problem with the Windows Registry') else reg.GetKeyNames(l); for i := 0 to l.Count - 1 do begin ComboBox1.Items.Add(l[i]); end;
      reg.CloseKey; finally reg.Free; l.Free; end;

      end;

              procedure TOPOSPrinterTest.Memo1Change(Sender: TObject); begin Memo1.Perform(EM_LineScroll, 0, Memo1.Lines.Count); end;

              procedure TOPOSPrinterTest.POSPrinter1ErrorEvent(ASender: TObject; ResultCode, ResultCodeExtended, ErrorLocus: integer; var pErrorResponse: integer); var MessageError: PChar; begin case ResultCode of 201: MessageError := 'ResultCode : OPOS_EPTR_COVER_OPEN'; 202: MessageError := 'ResultCode : OPOS_EPTR_JRN_EMPTY'; 203: MessageError := 'ResultCode : OPOS_EPTR_REC_EMPTY'; 204: MessageError := 'ResultCode : OPOS_EPTR_SLP_EMPTY'; 112: MessageError := 'ResultCode : OPOS_E_TIMEOUT';
      107: MessageError := 'ResultCode : OPOS_E_NOHARDWARE'; 108: MessageError := 'ResultCode : OPOS_E_OFFLINE'; else MessageError := 'ResultCode : Error !?'; end; if Application.MessageBox(MessageError, 'System Message', MB_RETRYCANCEL) = mrCancel then pErrorResponse := 12;

      end;

              procedure TOPOSPrinterTest.POSPrinter1StatusUpdateEvent(ASender: TObject; Status: integer); begin Case Status of 2001: Memo1.Lines.Add('Event : OPOS_SUE_POWER_ONLINE'); 2002: Memo1.Lines.Add('Event : OPOS_SUE_POWER_OFF'); 2003: Memo1.Lines.Add('Event : OPOS_SUE_POWER_OFFLINE'); 2004: Memo1.Lines.Add('Event : OPOS_SUE_POWER_OFF_OFFLINE'); 11: Memo1.Lines.Add('Event : PTR_SUE_COVER_OPEN'); 12: Memo1.Lines.Add('Event : PTR_SUE_COVER_OK');
      21: Memo1.Lines.Add('Event : PTR_SUE_JRN_EMPTY'); 22: Memo1.Lines.Add('Event : PTR_SUE_JRN_NEAREMPTY'); 23: Memo1.Lines.Add('Event : PTR_SUE_JRN_PAPEROK'); 24: Memo1.Lines.Add('Event : PTR_SUE_REC_EMPTY'); 25: Memo1.Lines.Add('Event : PTR_SUE_REC_NEAREMPTY'); 26: Memo1.Lines.Add('Event : PTR_SUE_REC_PAPEROK'); 27: Memo1.Lines.Add('Event : PTR_SUE_SLP_EMPTY'); 28: Memo1.Lines.Add('Event : PTR_SUE_SLP_NEAREMPTY'); 29: Memo1.Lines.Add('Event : PTR_SUE_SLP_PAPEROK');
      1001: Memo1.Lines.Add('Event : PTR_SUE_IDLE'); Else Memo1.Lines.Add('Event : Status Error !?'); End;

      Case Status of 11: CheckBox1.Checked := True; 12: CheckBox1.Checked := False; 21: begin CheckBox2.Checked := True; CheckBox2.Caption := 'JrnEmpty'; end; 22: begin CheckBox2.Checked := True; CheckBox2.Caption := 'JrnSlpNearEnd'; end; 23: begin CheckBox2.Checked := False; CheckBox2.Caption := 'JrnEmpty'; end; 24: begin CheckBox3.Checked := True; CheckBox3.Caption := 'RecEmpty'; end; 25: begin CheckBox3.Checked := True; CheckBox3.Caption := 'RecNearEnd'; end;
      26: begin CheckBox3.Checked := False; CheckBox3.Caption := 'RecEmpty'; end; 27: begin CheckBox4.Checked := True; CheckBox4.Caption := 'SlpEmpty'; end; 28: begin CheckBox4.Checked := True; CheckBox4.Caption := 'SlpNearEnd'; end; 29: begin CheckBox4.Checked := False; CheckBox4.Caption := 'SlpEmpty'; end; 1001: CheckBox5.Checked := True; End; end;

              procedure TOPOSPrinterTest.ViewResultCode(ResultCode: integer); begin case ResultCode of 0: Memo1.Lines.Add('ResultCode : OPOS_SUCCESS'); 101: Memo1.Lines.Add('ResultCode : OPOS_E_CLOSED'); 102: Memo1.Lines.Add('ResultCode : OPOS_E_CLAIMED'); 103: Memo1.Lines.Add('ResultCode : OPOS_E_NOTCLAIMED'); 104: Memo1.Lines.Add('ResultCode : OPOS_E_NOSERVICE'); 105: Memo1.Lines.Add('ResultCode : OPOS_E_DISABLED'); 106: Memo1.Lines.Add('ResultCode : OPOS_E_ILLEGAL');
      107: Memo1.Lines.Add('ResultCode : OPOS_E_NOHARDWARE'); 108: Memo1.Lines.Add('ResultCode : OPOS_E_OFFLINE'); 109: Memo1.Lines.Add('ResultCode : OPOS_E_NOEXIST'); 110: Memo1.Lines.Add('ResultCode : OPOS_E_EXISTS'); 111: Memo1.Lines.Add('ResultCode : OPOS_E_FAILURE'); 112: Memo1.Lines.Add('ResultCode : OPOS_E_TIMEOUT'); 113: Memo1.Lines.Add('ResultCode : OPOS_E_BUSY'); 114: Memo1.Lines.Add('ResultCode : OPOS_E_EXTENDED'); Else Memo1.Lines.Add('ResultCode : ResultCode Error !?') end; end;

      end.
