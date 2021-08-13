unit Controllers.Users;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Logger, Web.HTTPApp, Data.DBXJSON, System.SysUtils, System.Classes,
  Controllers.MemoryWebSession, MVCFramework.Swagger.Commons;

type
  [MVCPath('/api/users')]
  [MVCSwagAuthentication(atJsonWebToken)]
  TUsersController = class(TMVCController)
  protected
    procedure OnBeforeAction(AContext: TWebContext; const AActionName: string; var AHandled: Boolean); override;
  public
    [MVCPath('/name')]
    [MVCHTTPMethod([httpGET])]
    procedure Name;

    [MVCPath('/list')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomSessionData;

    [MVCPath('/login/($username)')]
    [MVCHTTPMethod([httpGET])]
    procedure DoLogin(const username: string);

    [MVCPath('/logout')]
    [MVCHTTPMethod([httpGET])]
    procedure DoLogout;

    [MVCPath('/reg/($username)')]
    [MVCHTTPMethod([httpGET])]
    procedure RegisterUser(const username: string);
  end;

implementation

{ TUsersController }

procedure TUsersController.DoLogin(const username: string);
begin
  Session['username'] := username;
  Render(200, 'Logged in');
end;

procedure TUsersController.RegisterUser(const username: string);
var
  lList: TStringList;
begin
  lList := SessionAs<TWebSessionMemoryController>.List;
  lList.Add(username);
  Redirect('/users/list');
end;

procedure TUsersController.DoLogout;
begin
  Context.SessionStop(false);
  Render(200, 'Logged out');
end;

procedure TUsersController.GetCustomSessionData;
var
  List: TStringList;
begin
  if Session is TWebSessionMemoryController then // just if you want to do a check
  begin
    List := SessionAs<TWebSessionMemoryController>.List;
    ResponseStream.AppendLine('List of users:');
    for var i := 0 to (List.Count - 1) do
      ResponseStream.AppendLine(IntToStr(i + 1) + '-' + List[i]);
  end
  else
    ResponseStream.AppendLine('The current session is not a custom session (TWebSessionMemoryController)');
  RenderResponseStream;
end;

procedure TUsersController.Name;
begin
  ContentType := TMVCMediaType.TEXT_PLAIN;
  // do not create session if not already created
  if Context.SessionStarted then
    // automaticaly create the session
    Render('Session[''username''] = ' + Session['username'])
  else
    Render(400, 'Session not created. Do login first');
end;

procedure TUsersController.OnBeforeAction(AContext: TWebContext; const AActionName: string; var AHandled: Boolean);
begin
  inherited;
  if Assigned(AContext.LoggedUser) and Assigned(AContext.LoggedUser.CustomData) then
  begin
    Assert(AContext.LoggedUser.CustomData['customkey1'] = 'customvalue1', 'customkey1 not valid');
    Assert(AContext.LoggedUser.CustomData['customkey2'] = 'customvalue2', 'customkey2 not valid');
  end;
  AHandled := False;
end;

end.
