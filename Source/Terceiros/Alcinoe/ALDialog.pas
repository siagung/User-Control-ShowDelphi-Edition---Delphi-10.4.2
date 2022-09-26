{ *************************************************************
  www:          http://sourceforge.net/projects/alcinoe/
  svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code
  Author(s):    St�phane Vander Clock (alcinoe@arkadia.com)
  Sponsor(s):   Arkadia SA (http://www.arkadia.com)

  product:      ALDialog
  Version:      4.00

  Description:  Standart dialog function
  - ALInputQuery function
  - ALInputBox function

  Legal issues: Copyright (C) 1999-2013 by Arkadia Software Engineering

  This software is provided 'as-is', without any express
  or implied warranty.  In no event will the author be
  held liable for any  damages arising from the use of
  this software.

  Permission is granted to anyone to use this software
  for any purpose, including commercial applications,
  and to alter it and redistribute it freely, subject
  to the following restrictions:

  1. The origin of this software must not be
  misrepresented, you must not claim that you wrote
  the original software. If you use this software in
  a product, an acknowledgment in the product
  documentation would be appreciated but is not
  required.

  2. Altered source versions must be plainly marked as
  such, and must not be misrepresented as being the
  original software.

  3. This notice may not be removed or altered from any
  source distribution.

  4. You must register this software by sending a picture
  postcard to the author. Use a nice stamp and mention
  your name, street address, EMail address and any
  comment you like to say.

  History :     26/06/2012: Add xe2 support

  Know bug :

  History :

  Link :

  * Please send all your feedback to alcinoe@arkadia.com
  * If you have downloaded this source from a website different from
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
  * Please, help us to keep the development of these components free by
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
  ************************************************************** }
unit ALDialog;

interface

{$IF CompilerVersion >= 25} { Delphi XE4 }
{$LEGACYIFEND ON} // http://docwiki.embarcadero.com/RADStudio/XE4/en/Legacy_IFEND_(Delphi)
{$IFEND}
function ALInputQuery(const ACaption, APrompt: Ansistring;
  var Value: Ansistring; ACancelButton: Boolean): Boolean;
function ALInputBox(const ACaption, APrompt, ADefault: Ansistring;
  ACancelButton: Boolean): Ansistring;

implementation

uses {$IF CompilerVersion >= 23} {Delphi XE2}
  Winapi.windows,
  Vcl.forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Vcl.controls,
  Vcl.Consts;
{$ELSE}
  windows,
  forms,
  Graphics,
  StdCtrls,
  controls,
  Consts;
{$IFEND}

{ ***************************************************************************************************************** }
function ALInputQuery(const ACaption, APrompt: Ansistring;
  var Value: Ansistring; ACancelButton: Boolean): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array [0 .. 51] of Char;
  begin
    for I := 0 to 25 do
      Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do
      Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := String(ACaption);
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := String(APrompt);
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := String(Value);
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        If ACancelButton then
          SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
            ButtonHeight)
        else
          SetBounds(MulDiv(65, DialogUnits.X, 4), ButtonTop, ButtonWidth,
            ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      If ACancelButton then
        with TButton.Create(Form) do
        begin
          Parent := Form;
          Caption := SMsgDlgCancel;
          ModalResult := mrCancel;
          Cancel := True;
          SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
            ButtonWidth, ButtonHeight);
        end;
      if ShowModal = mrOk then
      begin
        Value := Ansistring(Edit.Text);
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

{ ***************************************************************************************************** }
function ALInputBox(const ACaption, APrompt, ADefault: Ansistring;
  ACancelButton: Boolean): Ansistring;
begin
  Result := ADefault;
  ALInputQuery(ACaption, APrompt, Result, ACancelButton);
end;

end.
