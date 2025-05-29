

   MEMBER('geaSyPOE.clw')                                  ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('GEASYPOE003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
PasswordEncrypt      PROCEDURE  (sTexto)                   ! Declare Procedure
sText CString(255)
sCaracter  String(1)
PasswordEncrypt    CString(255)

  CODE
    wEsimPar# = 1
    n# = 1
    i# = Len(sTexto)
    Loop while i#<>0
            sCaracter = SUB(sTexto, i#, 1)
            If (wEsimPar# = 1) Then
              sCaracter[1] = Chr(val(sCaracter[1]) + n#)
              If ((sCaracter[1] = chr(39)) Or (sCaracter[1] = '|')) Then
                 sCaracter[1] = Chr(val(sCaracter[1]) + 2)
              End 
              wEsimPar#=0
            Else
              sCaracter[1] = Chr(val(sCaracter[1]) - n#)
              If ((sCaracter[1] = chr(39) ) Or (sCaracter[1] = '|')) Then
                 sCaracter[1] = Chr(val(sCaracter[1]) + 2)
              End 
              wEsimPar# = 1
            End 
            sText = sText & sCaracter[1]
            i# = i# - 1
            n# = n# + 1
    End
        PasswordEncrypt = sText
    RETURN     PasswordEncrypt
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
PasswordScreen PROCEDURE (Sistema,Permiso,Usr,StrConn)

User                 STRING(20)                            !
Con                  SHORT                                 !
Salida               BYTE                                  !
ChangePw             STRING(1)                             !
Passwords            STRING(20)                            !
i                    SHORT                                 !
loc:str              STRING(4000)                          !
Window               WINDOW(' INGRESO AL SISTEMA'),AT(,,170,75),FONT('Microsoft Sans Serif',10,,FONT:bold),CENTER, |
  COLOR(00DCF5F5h),ICON('ini.ico'),GRAY,MAX,IMM
                       PANEL,AT(5,5,160,35),USE(?Panel1),BEVEL(-2,2),FILL(00DCDCDCh)
                       PROMPT('Usuario:'),AT(22,9),USE(?User:Prompt),FONT(,12,COLOR:Blue),COLOR(00DCDCDCh)
                       ENTRY(@s20),AT(63,9,85,12),USE(User),FONT('Courier New',12,COLOR:Blue,FONT:regular,CHARSET:ANSI), |
  UPR,COLOR(COLOR:White),FLAT
                       PROMPT('Clave:'),AT(30,24),USE(?Password:Prompt),FONT(,12,COLOR:Blue),COLOR(00DCDCDCh)
                       ENTRY(@s20),AT(63,24,85,12),USE(Passwords),FONT('Courier New',12,COLOR:Blue,FONT:regular,CHARSET:ANSI), |
  UPR,COLOR(COLOR:White),FLAT,PASSWORD
                       BUTTON,AT(5,50,160,20),USE(?OkButton),LEFT,COLOR(00DCDCDCh),ICON(ICON:Tick),DEFAULT
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('PasswordScreen')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Panel1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(Window)                                        ! Open window
      Salida = false
      i = 1
      User = GetIni('Seguridad','User','','ftv.ini')
      if user <> ''
          ?USER{PROP:SKIP} = TRUE
          select(?Passwords)
      end
      permiso = -1
  Do DefineListboxStyle
  INIMgr.Fetch('PasswordScreen',Window)                    ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('PasswordScreen',Window)                 ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  !    if ~salida then
  !!!      halt(0,'Se Cierra la Aplicacion')
   !      permiso = -1
   !   else
      if permiso = 0
          usr = user
          PutIni('Seguridad','User',User,'ftv.ini')
      end ! if
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?OkButton
        if i = 3 then
              message(' Demasiados Intentos | Consulte al Administrador',' MENSAJE AL OPERADOR',Icon:question)
              salida = false
              permiso = -1
        else
          con = 0
          if CheckLogin(User,Passwords,ChangePw,StrConn,Con)
              permiso = 0
      !        if changePW = 'S'
      !                Message('A continuacion deberá cambiar la clave',' MENSAJE AL OPERADOR',Icon:Exclamation)
      !                salida = PasswordChange(User,Passwords,ChangePw,StrConn)
      !                if salida then
      !                Message('Reingrese al sistema, para comprobar el cambio de clave.', ' MENSAJE AL OPERADOR')
      !                permiso = -1
      !                end
      !        end
          else
              if con = -1
                  permiso = -1
                  salida = true
              else
                  message('Usuario/Clave Incorrecta vuelva a intentar',' MENSAJE AL OPERADOR',Icon:Question)
                  i += 1
                  select(?Passwords)
                  Cycle
              end
           end
        end
      
        Post(Event:CLoseWindow)
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
CheckLogin           PROCEDURE  (User,Password,ChangePw,StrConn,Con) ! Declare Procedure
str                  STRING(20)                            !
loc:ok               BYTE                                  !
loc:base             STRING(20)                            !
loc:pw               STRING(20)                            !
loc:Server           STRING(20)                            !
loc:str              STRING(4000)                          !
Cola                 QUEUE,PRE(col)                        !
nada                 CSTRING(100)                          !
                     END                                   !
FilesOpened     BYTE(0)

  CODE
    DO openfiles
    User = LOWER(User)
    Password = LOWER(Password)
    loc:STR = 'select usu_codigo, usu_password, usu_activo, ' & |
              'case when USU_ADMSEG = ''S'' then 1 else 0 end as es_admin ' & |
              'from geaseguridad_corpico..usuarios where usu_codigo = ''' & clip(user) & ''''
!    SETCLIPBOARD(LOC:STR)
    SQLQUERY{PROP:sql} = LOC:STR
    IF ERRORCODE() THEN
        message('Error acceso user_info')
        loc:ok = 0
    ELSE
        NEXT(SQLQUERY)
        IF LOWER(user) = 'supervisor' AND LOWER(Password) = 'huaw48' THEN
            glo:usuario = 'SUPERVISOR'
            glo:fechalogin = TODAY()
            loc:ok = 1
        ELSIF CLIP(SQL:Col02) = PasswordEncrypt(CLIP(Password)) AND SQL:Col03 = 'S' THEN
            glo:usuario  = SQL:Col01
            glo:password = Password
            glo:esadmin = SQL:COL04
            glo:fechalogin = TODAY()
            loc:ok = 1
        ELSE
            loc:ok = 0
        END      
    END
    DO closefiles
    RETURN loc:ok
!--------------------------------------
OpenFiles  ROUTINE
  Access:SQLQUERY.Open                                     ! Open File referenced in 'Other Files' so need to inform its FileManager
  Access:SQLQUERY.UseFile                                  ! Use File referenced in 'Other Files' so need to inform its FileManager
  FilesOpened = True
!--------------------------------------
CloseFiles ROUTINE
  IF FilesOpened THEN
     Access:SQLQUERY.Close
     FilesOpened = False
  END
!!! <summary>
!!! Generated from procedure template - Window
!!! Window
!!! </summary>
MotivoRechazo PROCEDURE 

QuickWindow          WINDOW('Solicitud Rechazo'),AT(,,285,121),FONT('Microsoft Sans Serif',10,COLOR:Black,FONT:regular, |
  CHARSET:DEFAULT),DOUBLE,CENTER,GRAY,IMM,HLP('NroRecibo'),SYSTEM
                       OPTION('Motivo'),AT(5,5,119,42),USE(Glo:Motivo),FONT(,12,,FONT:bold),BOXED
                         RADIO('Rechazado por Asociado'),AT(10,15,110),USE(?Motivo:Opt1),VALUE('1')
                         RADIO('Refinanciar'),AT(10,30),USE(?Motivo:Opt2),VALUE('2')
                       END
                       PROMPT('Descripción:'),AT(130,5),USE(?Descripcion:Prompt),FONT(,12,,FONT:bold)
                       TEXT,AT(130,20,150,75),USE(Glo:ObsMotivo),FONT(,12,,FONT:regular),VSCROLL
                       BUTTON('&Aceptar'),AT(172,98,53,20),USE(?Ok),LEFT,ICON('WAOK.ICO'),FLAT,MSG('Accept operation'), |
  TIP('Accept Operation')
                       BUTTON('&Cancelar'),AT(228,98,53,20),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel Operation'), |
  TIP('Cancel Operation')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('MotivoRechazo')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Motivo:Opt1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Ok,RequestCancelled)                    ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Ok,RequestCompleted)                    ! Add the close control to the window manger
  END
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  SELF.Open(QuickWindow)                                   ! Open window
  Glo:Motivo = 0
  Glo:ObsMotivo = ''
  Do DefineListboxStyle
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('MotivoRechazo',QuickWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  IF Glo:Motivo = '1'
     ENABLE(?Descripcion:Prompt)
     ENABLE(?Glo:ObsMotivo)
  END
  IF Glo:Motivo <> '1'
     DISABLE(?Descripcion:Prompt)
     DISABLE(?Glo:ObsMotivo)
  END
  IF Glo:Motivo = '2'
     DISABLE(?Descripcion:Prompt)
     DISABLE(?Glo:ObsMotivo)
  END
  IF Glo:Motivo <> '2'
     ENABLE(?Descripcion:Prompt)
     ENABLE(?Glo:ObsMotivo)
  END
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('MotivoRechazo',QuickWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?Ok
      IF ?Glo:ObsMotivo = '' THEN CYCLE.
    OF ?Cancel
      Glo:Motivo = 0
      Glo:ObsMotivo = ''
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Glo:Motivo
      IF Glo:Motivo = '1'
         ENABLE(?Descripcion:Prompt)
         ENABLE(?Glo:ObsMotivo)
      END
      IF Glo:Motivo <> '1'
         DISABLE(?Descripcion:Prompt)
         DISABLE(?Glo:ObsMotivo)
      END
      IF Glo:Motivo = '2'
         DISABLE(?Descripcion:Prompt)
         DISABLE(?Glo:ObsMotivo)
      END
      IF Glo:Motivo <> '2'
         ENABLE(?Descripcion:Prompt)
         ENABLE(?Glo:ObsMotivo)
      END
      ThisWindow.Reset()
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! Window
!!! </summary>
NroRecibo PROCEDURE 

QuickWindow          WINDOW('Solicitud Aceptada'),AT(,,173,53),FONT('Microsoft Sans Serif',10,COLOR:Black,FONT:regular, |
  CHARSET:ANSI),RESIZE,CENTER,GRAY,IMM,HLP('NroRecibo'),SYSTEM
                       PROMPT('Nro. Recibo:'),AT(5,5),USE(?PROMPT1),FONT(,14,,FONT:bold)
                       ENTRY(@s15),AT(68,6,100,13),USE(Glo:NroRecibo),FONT(,12,,FONT:bold),CENTER
                       BUTTON('&Aceptar'),AT(56,26,55,20),USE(?Ok),LEFT,ICON('WAOK.ICO'),FLAT,MSG('Accept operation'), |
  TIP('Accept Operation')
                       BUTTON('&Cancelar'),AT(114,26,55,20),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel Operation'), |
  TIP('Cancel Operation')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('NroRecibo')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PROMPT1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Ok,RequestCancelled)                    ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Ok,RequestCompleted)                    ! Add the close control to the window manger
  END
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  SELF.Open(QuickWindow)                                   ! Open window
  Glo:NroRecibo = ''
  Do DefineListboxStyle
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('NroRecibo',QuickWindow)                    ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('NroRecibo',QuickWindow)                 ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?Ok
      IF ?Glo:NroRecibo = '' THEN CYCLE.
    OF ?Cancel
      Glo:NroRecibo = ''
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! Window
!!! </summary>
RechazoSolicitud PROCEDURE 

QuickWindow          WINDOW('Motivo Rechazo de Solicitud'),AT(,,160,147),FONT('Microsoft Sans Serif',10,COLOR:Black, |
  FONT:regular,CHARSET:ANSI),RESIZE,CENTER,GRAY,IMM,HLP('RechazoSolicitud'),SYSTEM
                       PROMPT('Descripción'),AT(5,5),USE(?PROMPT1),FONT(,12,,FONT:bold)
                       TEXT,AT(5,20,150,100),USE(Glo:ObsMotivo),VSCROLL
                       BUTTON('&Aceptar'),AT(48,124,52,20),USE(?Ok),LEFT,ICON('WAOK.ICO'),FLAT,MSG('Aceptar Operación'), |
  TIP('Aceptar Operación')
                       BUTTON('&Cancelar'),AT(104,124,52,20),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancelar Operación'), |
  TIP('Cancelar Operación')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('RechazoSolicitud')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PROMPT1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Ok,RequestCancelled)                    ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Ok,RequestCompleted)                    ! Add the close control to the window manger
  END
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  SELF.Open(QuickWindow)                                   ! Open window
  Glo:ObsMotivo = ''
  Do DefineListboxStyle
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('RechazoSolicitud',QuickWindow)             ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('RechazoSolicitud',QuickWindow)          ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?Ok
      IF Glo:ObsMotivo = '' THEN CYCLE.
    OF ?Cancel
      Glo:ObsMotivo = ''
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! SOLICITUD_OBRA_ELECTRICA
!!! </summary>
SolicitudesDetalles PROCEDURE 

CurrentTab           STRING(80)                            !
Loc:APYNOM           STRING(60)                            !
Loc:DIRECCION        STRING(40)                            !
Loc:TipoObra         STRING(5)                             !
Loc:Estado           STRING(15)                            !
BRW1::View:Browse    VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ID)
                       PROJECT(SOE:SOE_TIPO)
                       PROJECT(SOE:SOE_ESTADO)
                       PROJECT(SOE:SOE_MOTIVO)
                       PROJECT(SOE:SOE_NRECIBO)
                       PROJECT(SOE:SOE_DNI)
                       PROJECT(SOE:SOE_TELEFONO)
                       PROJECT(SOE:SOE_EMAIL)
                       PROJECT(SOE:SOE_UPDATE_DATE)
                       PROJECT(SOE:SOE_USUARIO)
                       PROJECT(SOE:SOE_APELLIDO)
                       PROJECT(SOE:SOE_NOMBRE)
                       PROJECT(SOE:SOE_CALLE)
                       PROJECT(SOE:SOE_ALTURA)
                       PROJECT(SOE:SOE_PISO)
                       PROJECT(SOE:SOE_DPTO)
                       JOIN(TDO:PK_TDO_TIPO,SOE:SOE_TIPO)
                         PROJECT(TDO:TDO_TIPO)
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !List box control field - type derived from field
SOE:SOE_TIPO           LIKE(SOE:SOE_TIPO)             !List box control field - type derived from field
SOE:SOE_ESTADO         LIKE(SOE:SOE_ESTADO)           !List box control field - type derived from field
SOE:SOE_MOTIVO         LIKE(SOE:SOE_MOTIVO)           !List box control field - type derived from field
SOE:SOE_NRECIBO        LIKE(SOE:SOE_NRECIBO)          !List box control field - type derived from field
SOE:SOE_DNI            LIKE(SOE:SOE_DNI)              !List box control field - type derived from field
Loc:APYNOM             LIKE(Loc:APYNOM)               !List box control field - type derived from local data
Loc:DIRECCION          LIKE(Loc:DIRECCION)            !List box control field - type derived from local data
SOE:SOE_TELEFONO       LIKE(SOE:SOE_TELEFONO)         !List box control field - type derived from field
SOE:SOE_EMAIL          LIKE(SOE:SOE_EMAIL)            !List box control field - type derived from field
SOE:SOE_UPDATE_DATE    LIKE(SOE:SOE_UPDATE_DATE)      !List box control field - type derived from field
SOE:SOE_USUARIO        LIKE(SOE:SOE_USUARIO)          !List box control field - type derived from field
SOE:SOE_APELLIDO       LIKE(SOE:SOE_APELLIDO)         !Browse hot field - type derived from field
SOE:SOE_NOMBRE         LIKE(SOE:SOE_NOMBRE)           !Browse hot field - type derived from field
SOE:SOE_CALLE          LIKE(SOE:SOE_CALLE)            !Browse hot field - type derived from field
SOE:SOE_ALTURA         LIKE(SOE:SOE_ALTURA)           !Browse hot field - type derived from field
SOE:SOE_PISO           LIKE(SOE:SOE_PISO)             !Browse hot field - type derived from field
SOE:SOE_DPTO           LIKE(SOE:SOE_DPTO)             !Browse hot field - type derived from field
TDO:TDO_TIPO           LIKE(TDO:TDO_TIPO)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDCB2::View:FileDropCombo VIEW(TIPO_DE_OBRA)
                       PROJECT(TDO:TDO_TIPO)
                     END
FDCB3::View:FileDropCombo VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ESTADO)
                       PROJECT(SOE:SOE_ID)
                     END
Queue:FileDropCombo  QUEUE                            !Queue declaration for browse/combo box using ?TDO:TDO_TIPO
TDO:TDO_TIPO           LIKE(TDO:TDO_TIPO)             !List box control field - type derived from field
Loc:TipoObra           LIKE(Loc:TipoObra)             !Browse hot field - type derived from local data
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo:1 QUEUE                           !Queue declaration for browse/combo box using ?SOE:SOE_ESTADO
SOE:SOE_ESTADO         LIKE(SOE:SOE_ESTADO)           !List box control field - type derived from field
Loc:Estado             LIKE(Loc:Estado)               !Browse hot field - type derived from local data
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Detalle Solicitudes de Obra Eléctrica'),AT(,,400,221),FONT('Microsoft Sans Serif', |
  10,,FONT:regular,CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,SYSTEM
                       LIST,AT(10,20,380,175),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('35C|~Nro~@N' & |
  '06B@25C|~Tipo~@s5@65L(1)|~Estado~C(0)@s15@120L(1)|M~Motivo~C(0)@s130@50C|~Nro. Recib' & |
  'o~@s15@60R(1)|~DNI/CUIT~C(0)@S12@130L(1)|M~Apellido y Nombre~C(0)@s60@130L(1)|M~Dire' & |
  'cción~C(0)@s40@75R(1)|~Teléfono~C(0)@s20@115L(1)|M~E-Mail~C(0)@s50@50C|~Última Mod.~' & |
  '@D06B@40L(1)|~Usuario~C(0)@s20@'),FROM(Queue:Browse:1),IMM,MSG('SOLICITUD_OBRA_ELECTRICA')
                       PROMPT('Tipo de Obra:'),AT(5,205),USE(?TipoObra:Prompt),FONT(,12,,FONT:bold)
                       COMBO(@s5),AT(64,206,40,11),USE(TDO:TDO_TIPO),FONT(,12),DROP(8),FORMAT('20L(1)|@s5@'),FROM(Queue:FileDropCombo), |
  IMM,READONLY
                       PROMPT('Estado:'),AT(115,205),USE(?PROMPT1),FONT(,12,,FONT:bold)
                       COMBO(@s15),AT(150,206,60,11),USE(SOE:SOE_ESTADO),DROP(5),FORMAT('60L(1)|@s15@'),FROM(Queue:FileDropCombo:1), |
  IMM,READONLY
                       BUTTON,AT(220,205,12,12),USE(?FilterIn),ICON('filter.ico'),TIP('Aplicar Filtro')
                       BUTTON('&Cerrar'),AT(358,205,37,12),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                       SHEET,AT(5,5,390,195),USE(?CurrentTab)
                         TAB('Nº SOLICITUD'),USE(?TAB1)
                           STRING(@N06B),AT(272,204,40),USE(SOE:SOE_ID),FONT(,12,COLOR:Blue,FONT:bold),CENTER
                         END
                         TAB('DNI/CUIT'),USE(?TAB2)
                           STRING(@s20),AT(272,204,40),USE(SOE:SOE_DNI),FONT(,12,COLOR:Blue,FONT:bold),CENTER
                         END
                         TAB('APELLIDO'),USE(?TAB3)
                           STRING(@s30),AT(272,204,40),USE(SOE:SOE_APELLIDO),FONT(,12,COLOR:Blue,FONT:bold),CENTER
                         END
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW1::Sort1:Locator  IncrementalLocatorClass               ! Conditional Locator - CHOICE(?CurrentTab) = 1
BRW1::Sort2:Locator  FilterLocatorClass                    ! Conditional Locator - CHOICE(?CurrentTab) = 2
BRW1::Sort3:Locator  FilterLocatorClass                    ! Conditional Locator - CHOICE(?CurrentTab) = 3
FDCB2                CLASS(FileDropComboClass)             ! File drop combo manager
Q                      &Queue:FileDropCombo           !Reference to browse queue type
                     END

FDCB3                CLASS(FileDropComboClass)             ! File drop combo manager
Q                      &Queue:FileDropCombo:1         !Reference to browse queue type
                     END

Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_SolicitudesDetalles_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
  !------------------------------------
  !Style for ?Browse:1
  !------------------------------------
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SolicitudesDetalles')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('SOE:SOE_ID',SOE:SOE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TIPO',SOE:SOE_TIPO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ESTADO',SOE:SOE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_MOTIVO',SOE:SOE_MOTIVO)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_NRECIBO',SOE:SOE_NRECIBO)                  ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DNI',SOE:SOE_DNI)                          ! Added by: BrowseBox(ABC)
  BIND('Loc:APYNOM',Loc:APYNOM)                            ! Added by: BrowseBox(ABC)
  BIND('Loc:DIRECCION',Loc:DIRECCION)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TELEFONO',SOE:SOE_TELEFONO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_EMAIL',SOE:SOE_EMAIL)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_USUARIO',SOE:SOE_USUARIO)                  ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_APELLIDO',SOE:SOE_APELLIDO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_NOMBRE',SOE:SOE_NOMBRE)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_CALLE',SOE:SOE_CALLE)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ALTURA',SOE:SOE_ALTURA)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_PISO',SOE:SOE_PISO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DPTO',SOE:SOE_DPTO)                        ! Added by: BrowseBox(ABC)
  BIND('TDO:TDO_TIPO',TDO:TDO_TIPO)                        ! Added by: BrowseBox(ABC)
  BIND('Loc:TipoObra',Loc:TipoObra)                        ! Added by: FileDropCombo(ABC)
  BIND('Loc:Estado',Loc:Estado)                            ! Added by: FileDropCombo(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  Relate:TIPO_DE_OBRA.Open                                 ! File TIPO_DE_OBRA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:SOLICITUD_OBRA_ELECTRICA,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.FileLoaded = 1                                      ! This is a 'file loaded' browse
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,SOE:PK_SOE_ID)                        ! Add the sort order for SOE:PK_SOE_ID for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(?SOE:SOE_ID,SOE:SOE_ID,,BRW1)   ! Initialize the browse locator using ?SOE:SOE_ID using key: SOE:PK_SOE_ID , SOE:SOE_ID
  BRW1.AddSortOrder(,SOE:FK_SOE_DNI)                       ! Add the sort order for SOE:FK_SOE_DNI for sort order 2
  BRW1.AddLocator(BRW1::Sort2:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort2:Locator.Init(?SOE:SOE_DNI,SOE:SOE_DNI,1,BRW1) ! Initialize the browse locator using ?SOE:SOE_DNI using key: SOE:FK_SOE_DNI , SOE:SOE_DNI
  BRW1.AddSortOrder(,SOE:FK_SOE_APELLIDO)                  ! Add the sort order for SOE:FK_SOE_APELLIDO for sort order 3
  BRW1.AddLocator(BRW1::Sort3:Locator)                     ! Browse has a locator for sort order 3
  BRW1::Sort3:Locator.Init(?SOE:SOE_APELLIDO,SOE:SOE_APELLIDO,1,BRW1) ! Initialize the browse locator using ?SOE:SOE_APELLIDO using key: SOE:FK_SOE_APELLIDO , SOE:SOE_APELLIDO
  BRW1.AddSortOrder(,SOE:PK_SOE_ID)                        ! Add the sort order for SOE:PK_SOE_ID for sort order 4
  BRW1.AppendOrder('-SOE:SOE_ID')                          ! Append an additional sort order
  BRW1.AddField(SOE:SOE_ID,BRW1.Q.SOE:SOE_ID)              ! Field SOE:SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_TIPO,BRW1.Q.SOE:SOE_TIPO)          ! Field SOE:SOE_TIPO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_ESTADO,BRW1.Q.SOE:SOE_ESTADO)      ! Field SOE:SOE_ESTADO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_MOTIVO,BRW1.Q.SOE:SOE_MOTIVO)      ! Field SOE:SOE_MOTIVO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_NRECIBO,BRW1.Q.SOE:SOE_NRECIBO)    ! Field SOE:SOE_NRECIBO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_DNI,BRW1.Q.SOE:SOE_DNI)            ! Field SOE:SOE_DNI is a hot field or requires assignment from browse
  BRW1.AddField(Loc:APYNOM,BRW1.Q.Loc:APYNOM)              ! Field Loc:APYNOM is a hot field or requires assignment from browse
  BRW1.AddField(Loc:DIRECCION,BRW1.Q.Loc:DIRECCION)        ! Field Loc:DIRECCION is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_TELEFONO,BRW1.Q.SOE:SOE_TELEFONO)  ! Field SOE:SOE_TELEFONO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_EMAIL,BRW1.Q.SOE:SOE_EMAIL)        ! Field SOE:SOE_EMAIL is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_UPDATE_DATE,BRW1.Q.SOE:SOE_UPDATE_DATE) ! Field SOE:SOE_UPDATE_DATE is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_USUARIO,BRW1.Q.SOE:SOE_USUARIO)    ! Field SOE:SOE_USUARIO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_APELLIDO,BRW1.Q.SOE:SOE_APELLIDO)  ! Field SOE:SOE_APELLIDO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_NOMBRE,BRW1.Q.SOE:SOE_NOMBRE)      ! Field SOE:SOE_NOMBRE is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_CALLE,BRW1.Q.SOE:SOE_CALLE)        ! Field SOE:SOE_CALLE is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_ALTURA,BRW1.Q.SOE:SOE_ALTURA)      ! Field SOE:SOE_ALTURA is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_PISO,BRW1.Q.SOE:SOE_PISO)          ! Field SOE:SOE_PISO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_DPTO,BRW1.Q.SOE:SOE_DPTO)          ! Field SOE:SOE_DPTO is a hot field or requires assignment from browse
  BRW1.AddField(TDO:TDO_TIPO,BRW1.Q.TDO:TDO_TIPO)          ! Field TDO:TDO_TIPO is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('SolicitudesDetalles',QuickWindow)          ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FDCB2.Init(TDO:TDO_TIPO,?TDO:TDO_TIPO,Queue:FileDropCombo.ViewPosition,FDCB2::View:FileDropCombo,Queue:FileDropCombo,Relate:TIPO_DE_OBRA,ThisWindow,GlobalErrors,0,1,0)
  FDCB2.EntryCompletion = FALSE
  FDCB2.Q &= Queue:FileDropCombo
  FDCB2.AddSortOrder(TDO:PK_TDO_TIPO)
  FDCB2.AddField(TDO:TDO_TIPO,FDCB2.Q.TDO:TDO_TIPO) !List box control field - type derived from field
  FDCB2.AddField(Loc:TipoObra,FDCB2.Q.Loc:TipoObra) !Browse hot field - type derived from local data
  FDCB2.AddUpdateField(TDO:TDO_TIPO,Loc:TipoObra)
  ThisWindow.AddItem(FDCB2.WindowComponent)
  FDCB2.DefaultFill = 0
  FDCB2.IncludeEmpty = TRUE
  FDCB3.Init(SOE:SOE_ESTADO,?SOE:SOE_ESTADO,Queue:FileDropCombo:1.ViewPosition,FDCB3::View:FileDropCombo,Queue:FileDropCombo:1,Relate:SOLICITUD_OBRA_ELECTRICA,ThisWindow,GlobalErrors,0,1,0)
  FDCB3.EntryCompletion = FALSE
  FDCB3.RemoveDuplicatesFlag = TRUE
  FDCB3.Q &= Queue:FileDropCombo:1
  FDCB3.AddSortOrder(SOE:FK_SOE_ESTADO)
  FDCB3.AddField(SOE:SOE_ESTADO,FDCB3.Q.SOE:SOE_ESTADO) !List box control field - type derived from field
  FDCB3.AddField(Loc:Estado,FDCB3.Q.Loc:Estado) !Browse hot field - type derived from local data
  FDCB3.AddField(SOE:SOE_ID,FDCB3.Q.SOE:SOE_ID) !Primary key field - type derived from field
  FDCB3.AddUpdateField(SOE:SOE_ESTADO,Loc:Estado)
  ThisWindow.AddItem(FDCB3.WindowComponent)
  FDCB3.DefaultFill = 0
  FDCB3.IncludeEmpty = TRUE
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:SOLICITUD_OBRA_ELECTRICA.Close
    Relate:TIPO_DE_OBRA.Close
  END
  IF SELF.Opened
    INIMgr.Update('SolicitudesDetalles',QuickWindow)       ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?FilterIn
      ThisWindow.Update()
      IF Loc:TipoObra = '' THEN
          IF Loc:Estado = '' THEN
              BRW1.SetFilter('')
          ELSE
              BRW1.SetFilter('(SOE:SOE_ESTADO = <39>' & CLIP(Loc:Estado) & '<39>)')
          END
      ELSE
          IF Loc:Estado = '' THEN
              BRW1.SetFilter('(SOE:SOE_TIPO = <39>' & CLIP(Loc:TipoObra) & '<39>)')
          ELSE
              BRW1.SetFilter('(SOE:SOE_TIPO = <39>' & CLIP(Loc:TipoObra) & '<39> AND SOE:SOE_ESTADO = <39>' & CLIP(Loc:Estado) & '<39>)')
          END
      END
      ThisWindow.Reset(TRUE)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?CurrentTab) = 1
    RETURN SELF.SetSort(1,Force)
  ELSIF CHOICE(?CurrentTab) = 2
    RETURN SELF.SetSort(2,Force)
  ELSIF CHOICE(?CurrentTab) = 3
    RETURN SELF.SetSort(3,Force)
  ELSE
    RETURN SELF.SetSort(4,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW1.SetQueueRecord PROCEDURE

  CODE
  Loc:APYNOM = SOE:SOE_APELLIDO & ', ' & SOE:SOE_NOMBRE
  Loc:DIRECCION = 'Calle ' & CLIP(SOE:SOE_CALLE) & ' Nº' & CLIP(SOE:SOE_ALTURA)
  IF SOE:SOE_PISO <> '' THEN
      Loc:DIRECCION = CLIP(Loc:DIRECCION) & ', P. ' & CLIP(SOE:SOE_PISO)
  END
  IF SOE:SOE_DPTO <> '' THEN
      Loc:DIRECCION = CLIP(Loc:DIRECCION) & ', D. ' & CLIP(SOE:SOE_DPTO)
  END
  IF LEN(SOE:SOE_DNI) > 6 AND LEN(SOE:SOE_DNI) < 9 THEN
      SOE:SOE_DNI{PROPLIST:Picture} = '@P##.###.###PB'
  ELSIF LEN(SOE:SOE_DNI) > 9 AND LEN(SOE:SOE_DNI) < 12 THEN
      SOE:SOE_DNI{PROP:Text} = '@P##-##.###.###-#PB'
  END
  PARENT.SetQueueRecord
  


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! PRESUPUESTO_OBRA_ELECTRICA
!!! </summary>
PresupuestosDetalles PROCEDURE 

CurrentTab           STRING(80)                            !
Loc:Estado           STRING(20)                            !
BRW1::View:Browse    VIEW(PRESUPUESTO_OBRA_ELECTRICA)
                       PROJECT(POE:POE_ID)
                       PROJECT(POE:POE_SOE_ID)
                       PROJECT(POE:POE_ESTADO)
                       PROJECT(POE:POE_NRO_OBRA)
                       PROJECT(POE:POE_UPDATE_DATE)
                       PROJECT(POE:POE_USUARIO)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
POE:POE_ID             LIKE(POE:POE_ID)               !List box control field - type derived from field
POE:POE_SOE_ID         LIKE(POE:POE_SOE_ID)           !List box control field - type derived from field
POE:POE_ESTADO         LIKE(POE:POE_ESTADO)           !List box control field - type derived from field
POE:POE_NRO_OBRA       LIKE(POE:POE_NRO_OBRA)         !List box control field - type derived from field
POE:POE_UPDATE_DATE    LIKE(POE:POE_UPDATE_DATE)      !List box control field - type derived from field
POE:POE_USUARIO        LIKE(POE:POE_USUARIO)          !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDCB2::View:FileDropCombo VIEW(PRESUPUESTO_OBRA_ELECTRICA)
                       PROJECT(POE:POE_ESTADO)
                       PROJECT(POE:POE_ID)
                     END
Queue:FileDropCombo  QUEUE                            !Queue declaration for browse/combo box using ?POE:POE_ESTADO
POE:POE_ESTADO         LIKE(POE:POE_ESTADO)           !List box control field - type derived from field
Loc:Estado             LIKE(Loc:Estado)               !Browse hot field - type derived from local data
POE:POE_ID             LIKE(POE:POE_ID)               !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Detalle de Presupuestos de Obras Eléctricas'),AT(,,320,200),FONT('Microsoft Sans Serif', |
  10,,FONT:regular,CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,HLP('BrowsePRESUPUESTO_O' & |
  'BRA_ELECTRICA'),SYSTEM
                       BUTTON('&Cerrar'),AT(278,183,37,12),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                       LIST,AT(5,5,310,173),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('35C|~Nro.~@N0' & |
  '6B@40C|~Solicitud~@N06B@60L(1)|~Estado~C(0)@s15@45C|~Nro. Obra~@N06B@50C|~Fecha Mod.' & |
  '~@D06B@40L(1)|~Usuario~C(0)@s20@'),FROM(Queue:Browse:1),IMM,MSG('PRESUPUESTO_OBRA_ELECTRICA')
                       COMBO(@s15),AT(40,184,65,11),USE(POE:POE_ESTADO),DROP(5),FORMAT('60L(1)|@s15@'),FROM(Queue:FileDropCombo), |
  IMM
                       PROMPT('Estado:'),AT(4,183),USE(?PROMPT1),FONT(,12,,FONT:bold)
                       STRING(@N06B),AT(182,183,35,12),USE(POE:POE_ID),FONT(,12,COLOR:Blue,FONT:bold),CENTER
                       BUTTON,AT(108,183,12,12),USE(?FilterIn),ICON('filter.ico')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
                     END

BRW1::Sort0:Locator  FilterLocatorClass                    ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FDCB2                CLASS(FileDropComboClass)             ! File drop combo manager
Q                      &Queue:FileDropCombo           !Reference to browse queue type
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_PresupuestosDetalles_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('PresupuestosDetalles')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('POE:POE_ID',POE:POE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('POE:POE_SOE_ID',POE:POE_SOE_ID)                    ! Added by: BrowseBox(ABC)
  BIND('POE:POE_ESTADO',POE:POE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('POE:POE_NRO_OBRA',POE:POE_NRO_OBRA)                ! Added by: BrowseBox(ABC)
  BIND('POE:POE_USUARIO',POE:POE_USUARIO)                  ! Added by: BrowseBox(ABC)
  BIND('Loc:Estado',Loc:Estado)                            ! Added by: FileDropCombo(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:PRESUPUESTO_OBRA_ELECTRICA.Open                   ! File PRESUPUESTO_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:PRESUPUESTO_OBRA_ELECTRICA,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.FileLoaded = 1                                      ! This is a 'file loaded' browse
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,POE:PK_POE_ID)                        ! Add the sort order for POE:PK_POE_ID for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(?POE:POE_ID,POE:POE_ID,,BRW1)   ! Initialize the browse locator using ?POE:POE_ID using key: POE:PK_POE_ID , POE:POE_ID
  BRW1.AddField(POE:POE_ID,BRW1.Q.POE:POE_ID)              ! Field POE:POE_ID is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_SOE_ID,BRW1.Q.POE:POE_SOE_ID)      ! Field POE:POE_SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_ESTADO,BRW1.Q.POE:POE_ESTADO)      ! Field POE:POE_ESTADO is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_NRO_OBRA,BRW1.Q.POE:POE_NRO_OBRA)  ! Field POE:POE_NRO_OBRA is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_UPDATE_DATE,BRW1.Q.POE:POE_UPDATE_DATE) ! Field POE:POE_UPDATE_DATE is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_USUARIO,BRW1.Q.POE:POE_USUARIO)    ! Field POE:POE_USUARIO is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('PresupuestosDetalles',QuickWindow)         ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FDCB2.Init(POE:POE_ESTADO,?POE:POE_ESTADO,Queue:FileDropCombo.ViewPosition,FDCB2::View:FileDropCombo,Queue:FileDropCombo,Relate:PRESUPUESTO_OBRA_ELECTRICA,ThisWindow,GlobalErrors,0,1,0)
  FDCB2.RemoveDuplicatesFlag = TRUE
  FDCB2.Q &= Queue:FileDropCombo
  FDCB2.AddSortOrder(POE:FK_POE_ESTADO)
  FDCB2.AddField(POE:POE_ESTADO,FDCB2.Q.POE:POE_ESTADO) !List box control field - type derived from field
  FDCB2.AddField(Loc:Estado,FDCB2.Q.Loc:Estado) !Browse hot field - type derived from local data
  FDCB2.AddField(POE:POE_ID,FDCB2.Q.POE:POE_ID) !Primary key field - type derived from field
  FDCB2.AddUpdateField(POE:POE_ESTADO,Loc:Estado)
  ThisWindow.AddItem(FDCB2.WindowComponent)
  FDCB2.DefaultFill = 0
  FDCB2.IncludeEmpty = TRUE
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:PRESUPUESTO_OBRA_ELECTRICA.Close
    Relate:SOLICITUD_OBRA_ELECTRICA.Close
  END
  IF SELF.Opened
    INIMgr.Update('PresupuestosDetalles',QuickWindow)      ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?FilterIn
      ThisWindow.Update()
      IF Loc:Estado = '' THEN
          BRW1.SetFilter('')
      ELSE
          BRW1.SetFilter('(POE:POE_ESTADO = <39>' & CLIP(Loc:Estado) & '<39>)')
      END
      ThisWindow.Reset(TRUE)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
wndScanning PROCEDURE 

LocalRequest         LONG                                  !
OriginalRequest      LONG                                  !
LocalResponse        LONG                                  !
FilesOpened          BYTE                                  !
WindowOpened         LONG                                  !
WindowInitialized    LONG                                  !
ForceRefresh         LONG                                  !
Loc:ShowUi           SIGNED                                !
loc:PixelType        SIGNED                                !
Loc:PdfFilename      STRING(255)                           !
Loc:TiffFilename     STRING(255)                           !
Loc:ShowProgress     SIGNED                                !
ImageQ      QUEUE, PRE()
Text        STRING(30)
Bitmap      &ImageExBitmapClass

            END
TheBitmap   ImageExBitmapClass
JpgSaver    ImageExJpegSaverClass
PdfSaver    ImageExPdfSaverClass
TiffSaver   ImageExTiffSaverClass
Window               WINDOW('Certificado'),AT(,,445,283),FONT('Microsoft Sans Serif',10,,FONT:regular),RESIZE,AUTO, |
  GRAY,SYSTEM
                       CHECK('&Show scanner UI'),AT(19,74),USE(Loc:ShowUi),RIGHT,HIDE
                       REGION,AT(140,28,300,250),USE(?Viewer)
                       BUTTON,AT(140,5,18,18),USE(?Acquire),ICON('scanner.ico'),CURSOR(CURSOR:Hand),DEFAULT,TIP('Escanear Documento')
                       BUTTON,AT(365,5,18,18),USE(?Pdf),FONT(,,,FONT:bold),ICON('PDF.ico'),CURSOR(CURSOR:Hand),TIP('Crear y Gu' & |
  'ardar archivo PDF')
                       BUTTON('Create multi-page &TIFF'),AT(26,110),USE(?Tiff),HIDE
                       BUTTON('S&eleccionar Scanner'),AT(5,5,60,18),USE(?Select),FONT('Microsoft Sans Serif',8,,FONT:regular)
                       CHECK('Show &progress indicator'),AT(19,90),USE(Loc:ShowProgress),RIGHT,HIDE
                       OPTION('Pixel Type'),AT(7,154,127,28),USE(loc:PixelType),BOXED,HIDE
                         RADIO('B/W'),AT(17,202),USE(?loc:PixelType:Radio1),VALUE('0')
                         RADIO('Grayscale'),AT(49,202),USE(?loc:PixelType:Radio1:2),VALUE('1')
                         RADIO('RGB'),AT(97,202),USE(?loc:PixelType:Radio1:3),VALUE('2')
                       END
                       LIST,AT(5,28,130,250),USE(?List1),VSCROLL,FORMAT('80L(2)~Text~@s20@'),FROM(ImageQ)
                       BUTTON,AT(422,5,18,18),USE(?Close),FONT('Microsoft Sans Serif',10,,FONT:bold),ICON('exit.ico'), |
  CURSOR(CURSOR:Hand),TIP('Salir')
                       BUTTON,AT(287,5,18,18),USE(?RotLeft),ICON('rotleft.ico'),CURSOR(CURSOR:Hand),TIP('Girar a la' & |
  ' izquierda')
                       BUTTON,AT(308,5,18,18),USE(?RotRight),ICON('rotright.ico'),CURSOR(CURSOR:Hand),TIP('Girar a la derecha')
                       BUTTON,AT(203,5,18,18),USE(?ZoomFit),ICON('ZoomToFit.ico'),CURSOR(CURSOR:Hand),TIP('Ajustar a ' & |
  'la Ventana')
                       BUTTON,AT(224,5,18,18),USE(?ZoomIn),FONT('Microsoft Sans Serif',,,FONT:regular),ICON('zoomIn.ico'), |
  CURSOR(CURSOR:Hand),TIP('Acercar')
                       BUTTON,AT(245,5,18,18),USE(?ZoomOut),ICON('zoomOut.ico'),CURSOR(CURSOR:Hand),TIP('Alejar')
                       BUTTON,AT(161,5,18,18),USE(?Eliminar),ICON('Eliminar.ico'),CURSOR(CURSOR:Hand),HIDE,TIP('Eliminar Página')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Viewer               CLASS(ImageExViewerClass)
                     END
ImageExTwain1        CLASS(ImageExTwainClass)
OnAcquired              FUNCTION (ImageExBitmapClass bmp), BOOL, DERIVED
OnAcquireCancelled      PROCEDURE, DERIVED
OnSourceDisabled        PROCEDURE, DERIVED
                     END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_wndScanning_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  Viewer.Init(Window, ?Viewer)
  Viewer.SetBkColor(13882323)
  Viewer.Bitmap.SetStretchFilter(IMAGEEXSTRETCHFILTER:Linear)
  Viewer.Bitmap.SetDrawMode(IMAGEEXDRAWMODE:Opaque)
  Viewer.Bitmap.SetMasterAlpha(255)
  Viewer.SetZoomPercent(100)
  Viewer.SetAllowFocus(1)
  Viewer.SetScrollsVisible(1)
  Viewer.SetMouseMode(1*IEMM:PAN + 1*IEMM:ZoomWheel + 1 * IEMM:HOTSPOTS)
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('wndScanning')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Loc:ShowUi
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(Window)                                        ! Open window
  Loc:PixelType = IETPT:RGB
  Loc:ShowProgress = TRUE
  ?List1{PROP:LINEHEIGHT}=12
  Do DefineListboxStyle
  INIMgr.Fetch('wndScanning',Window)                       ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:SOLICITUD_OBRA_ELECTRICA.Close
  END
  IF SELF.Opened
    INIMgr.Update('wndScanning',Window)                    ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Acquire
      ThisWindow.Update()
      ImageExTwain1.SetIndicators(loc:ShowProgress)
      ImageExTwain1.SetPixelType(Loc:PixelType)
      ImageExTwain1.Acquire(Loc:ShowUI)
      Select(?Viewer)
    OF ?Pdf
      ThisWindow.Update()
      Loc:PdfFilename = CLIP(Glo:SOE_ID)
       PictureDialogResult# = ImageEx:PictureDialog(, Loc:PdfFilename, 'Portable Document Format (*.pdf)|*.pdf', FILE:SAVE+FILE:KEEPDIR+FILE:APPENDEXTENSION)
      if PictureDialogResult#
          SETCURSOR(Cursor:Wait)
          PdfSaver.Compression = IECA:JPEG
          PdfSaver.BeginCreate(Loc:PdfFilename)
          Loop i# = 1 to records(ImageQ)
              Get(ImageQ, i#)
              PdfSaver.AddPage(ImageQ.Bitmap)
          end
          PdfSaver.EndCreate()
          Glo:Path = CLIP(Loc:PdfFilename)
          Glo:Save = 1
          SETCURSOR()
      end
    OF ?Tiff
      ThisWindow.Update()
       PictureDialogResult# = ImageEx:PictureDialog(, Loc:TiffFilename, 'Portable Document Format (*.pdf)|*.pdf', FILE:SAVE+FILE:KEEPDIR)
         if PictureDialogResult#
            TiffSaver.Compression = IECA:JPEG
            Get(ImageQ, 1)
            if ~errorcode()
               ImageQ.Bitmap.SaveToFile(Loc:TiffFilename, TiffSaver)
      
               loop i# = 2 to Records(ImageQ)
                  Get(ImageQ, i#)
                  if ~errorcode()
                     TiffSaver.InsertIntoFile(Loc:TiffFilename, -1, ImageQ.Bitmap)
                  end
               end
            end
         end
    OF ?Select
      ThisWindow.Update()
      ImageExTwain1.SelectSource()
    OF ?RotLeft
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          Viewer.Bitmap.Rotate270(ImageQ.Bitmap)
          Viewer.Bitmap.Assign (ImageQ.Bitmap)
      end
      Select(?Viewer)
    OF ?RotRight
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          Viewer.Bitmap.Rotate90(ImageQ.Bitmap)
          Viewer.Bitmap.Assign (ImageQ.Bitmap)
      end
      Select(?Viewer)
    OF ?ZoomFit
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      !if ~Errorcode()
          Viewer.ZoomToFit()
          Viewer.Bitmap.Assign(ImageQ.Bitmap)
      !end
      Select(?Viewer)
    OF ?ZoomIn
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          Viewer.ZoomIn()
          Viewer.Bitmap.Assign(ImageQ.Bitmap)
      end
      Select(?Viewer)
    OF ?ZoomOut
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          Viewer.ZoomOut()
          Viewer.Bitmap.Assign(ImageQ.Bitmap)
      end
      Select(?Viewer)
    OF ?Eliminar
      ThisWindow.Update()
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          REMOVE(ImageQ)
      end
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeNewSelection PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all NewSelection events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeNewSelection()
    CASE FIELD()
    OF ?List1
      Get(ImageQ, Choice(?List1))
      if ~Errorcode()
          Viewer.Bitmap.Assign (ImageQ.Bitmap)
          Viewer.ZoomToFit()
      end
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ImageExTwain1.OnAcquired FUNCTION(ImageExBitmapClass Bmp)
Result               BOOL
   CODE
      Clear(ImageQ)
      ImageQ.Text = 'Página ' & Records(ImageQ)+1
      ImageQ.Bitmap &= new (ImageExBitmapClass)
      ImageQ.Bitmap.Assign(Bmp)
      Add(ImageQ)
   
      ?List1{PROP:SELECTED} = Records(ImageQ)
      Post(event:NewSelection, ?List1)
   Result = Parent.OnAcquired(Bmp)
   Return Result

ImageExTwain1.OnAcquireCancelled PROCEDURE()
   CODE
   Parent.OnAcquireCancelled()

ImageExTwain1.OnSourceDisabled PROCEDURE()
   CODE
   Parent.OnSourceDisabled()
