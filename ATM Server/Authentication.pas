unit Authentication;

interface

uses
  MVCFramework.Commons, MVCFramework, System.Generics.Collections, System.SysUtils;

type
  TAuthentication = class(TInterfacedObject, IMVCAuthenticationHandler)
  public
    // called at each request to know if the request requires an authentication
    procedure OnRequest(const AContext: TWebContext; const ControllerQualifiedClassName: string; const ActionName: string;
      var AuthenticationRequired: Boolean);

    // if authentication is required, this method must execute the user authentication
    procedure OnAuthentication(const AContext: TWebContext; const UserName: string; const Password: string;
      UserRoles: TList<System.string>; var IsValid: Boolean; const SessionData: System.Generics.Collections.TDictionary<System.string, System.string>);

    // if authenticated, this method defines the user roles
    procedure OnAuthorization(const AContext: TWebContext; UserRoles: System.Generics.Collections.TList<System.string>;
      const ControllerQualifiedClassName: string; const ActionName: string; var IsAuthorized: Boolean);
  end;

implementation

{ TAuthentication }

procedure TAuthentication.OnAuthentication(const AContext: TWebContext; const UserName: string; const Password: string;
                                           UserRoles: TList<System.string>; var IsValid: Boolean;
                                           const SessionData: System.Generics.Collections.TDictionary<System.string, System.string>);
begin
  {
    Here you should do the actual query on database or other "users store" to
    check if the user identified by UserName and Password is a valid user.
    You have to fill also the UserRoles list with the roles of the user.
    Moreover additional user properties can be added in the SessionData dictionary
  }
   // Add here all the roles that the user has. These roles will be added to the JWT token

  // We defined 3 statc users here: admin, user1, user2
  IsValid := False;
  if (UserName = 'admin') and (Password = 'adminpass') then
  begin
    IsValid := True;
    UserRoles.Add('admin');
  end
  else if (UserName = 'user1') and (Password = 'user1pass') then
  begin
    IsValid := True;
    UserRoles.Add('role1');
  end
  else if (UserName = 'user2') and (Password = 'user2pass') then
  begin
    IsValid := True;
    UserRoles.Add('role2');
  end
  else if (UserName = 'user_raise_exception') then
  begin
    raise EMVCException.Create(500, 1024, 'This is a custom exception raised in "TAuthentication.OnAuthentication"');
  end;

  // if you dont have "roles" concept in your system, you can also avoid to use them and
  // sets only IsValid := True;
  if IsValid then
  begin
    AContext.SessionStart;
    // You can add custom data to the logged user
    SessionData.AddOrSetValue('customkey1', 'customvalue1');
    SessionData.AddOrSetValue('customkey2', 'customvalue2');
  end
  else
    UserRoles.Clear;
end;

procedure TAuthentication.OnAuthorization(const AContext: TWebContext; UserRoles: System.Generics.Collections.TList<System.string>;
                                          const ControllerQualifiedClassName: string; const ActionName: string;
                                          var IsAuthorized: Boolean);
begin
  if ControllerQualifiedClassName = 'Controllers.Users.TUsersController' then
  begin
    IsAuthorized := UserRoles.Contains('admin');
    if not IsAuthorized then
      IsAuthorized := (UserRoles.Contains('role1')) and (ActionName = 'OnlyRole1');
    if not IsAuthorized then
      IsAuthorized := (UserRoles.Contains('role2')) and (ActionName = 'OnlyRole2');
  end
  else
  begin
    // You can always navigate in the public section of API
    IsAuthorized := True;
  end;
end;

procedure TAuthentication.OnRequest(const AContext: TWebContext; const ControllerQualifiedClassName: string; const ActionName: string; var AuthenticationRequired: Boolean);
begin
  {
    This is the the auth schema implemented: All the actions present in the
    'PrivateControllerU.TPrivateController' requires authentication but
    the action 'PublicAction'. In other words, 'PublicAction' can be called also
    without authentication.
  }
//  AuthenticationRequired := ControllerQualifiedClassName = 'Controllers.Users.TUsersController';
  AuthenticationRequired := not AContext.SessionStarted;
  if AuthenticationRequired then
  begin
   if (ActionName = 'DoLogout') then
   begin
     AuthenticationRequired := False;
     AContext.SessionStop(False);
   end;
  end;
end;

end.
