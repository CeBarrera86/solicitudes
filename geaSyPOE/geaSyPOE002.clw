

   MEMBER('geaSyPOE.clw')                                  ! This is a MEMBER module


   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('GEASYPOE002.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('GEASYPOE003.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Form SOLICITUD_OBRA_ELECTRICA
!!! </summary>
Solicitud PROCEDURE 

CurrentTab           STRING(80)                            !
Loc:Observa          BYTE                                  !
ActionMessage        CSTRING(40)                           !
Loc:acepta           BYTE                                  !
FDCB4::View:FileDropCombo VIEW(TIPO_DE_OBRA)
                       PROJECT(TDO:TDO_TIPO)
                       PROJECT(TDO:TDO_DESCRIPCION)
                     END
Queue:FileDropCombo  QUEUE                            !Queue declaration for browse/combo box using ?TDO:TDO_TIPO
TDO:TDO_TIPO           LIKE(TDO:TDO_TIPO)             !List box control field - type derived from field
TDO:TDO_DESCRIPCION    LIKE(TDO:TDO_DESCRIPCION)      !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
History::SOE:Record  LIKE(SOE:RECORD),THREAD
QuickWindow          WINDOW('Solicitud'),AT(0,0,185,270),FONT('Microsoft Sans Serif',10,,FONT:bold,CHARSET:DEFAULT), |
  DOUBLE,GRAY,IMM,MDI,SYSTEM
                       PROMPT('Usuario:'),AT(5,5),USE(?SOE:SOE_USUARIO:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s10),AT(39,6,45,11),USE(SOE:SOE_USUARIO),FONT(,12,COLOR:Blue,FONT:regular),CENTER,READONLY, |
  REQ
                       PROMPT('Fecha:'),AT(107,5),USE(?SOE:SOE_UPDATE_DATE:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@D06B),AT(135,6,45,11),USE(SOE:SOE_UPDATE_DATE),FONT(,12,COLOR:Blue,FONT:regular),CENTER, |
  READONLY,REQ
                       PROMPT('Nro:'),AT(5,30),USE(?SOE:SOE_ID:Prompt),FONT(,14),TRN
                       ENTRY(@N06B),AT(26,30,45,13),USE(SOE:SOE_ID),FONT(,14,,FONT:regular),CENTER,READONLY,REQ
                       OPTION('¿Acepta?'),AT(108,20,73,27),USE(Loc:acepta),FONT(,12),BOXED
                         RADIO('SI'),AT(116,30,20),USE(?Opt:SI),VALUE('1')
                         RADIO('NO'),AT(152,30,20),USE(?Opt:NO),VALUE('0')
                       END
                       CHECK('Observación Verificada'),AT(90,50,91),USE(Loc:Observa),FONT(,12,,FONT:bold),VALUE('1', |
  '0')
                       GROUP('Titular'),AT(5,65,175,60),USE(?Titular),FONT(,12,COLOR:Black),BOXED
                         PROMPT('DNI/CUIT:'),AT(10,77,,12),USE(?SOE:SOE_DNI:Prompt),FONT(,10),TRN
                         ENTRY(@S15),AT(45,77,60,11),USE(SOE:SOE_DNI),FONT(,12,,FONT:regular),RIGHT,REQ
                         PROMPT('Apellido:'),AT(10,92),USE(?SOE:SOE_APELLIDO:Prompt),FONT(,12),TRN
                         ENTRY(@s30),AT(45,93,130,11),USE(SOE:SOE_APELLIDO),FONT(,12,,FONT:regular),REQ
                         PROMPT('Nombre:'),AT(10,107),USE(?SOE:SOE_NOMBRE:Prompt),FONT(,12),TRN
                         ENTRY(@s30),AT(45,107,130,11),USE(SOE:SOE_NOMBRE),FONT(,12,,FONT:regular),REQ
                       END
                       GROUP('Dirección'),AT(5,125,175,45),USE(?Direccion),FONT(,12),BOXED
                         PROMPT('Calle:'),AT(10,137),USE(?SOE:SOE_CALLE:Prompt),FONT(,12),TRN
                         ENTRY(@s20),AT(37,138,138,11),USE(SOE:SOE_CALLE),FONT(,12,,FONT:regular),REQ
                         PROMPT('Altura:'),AT(10,152),USE(?SOE:SOE_ALTURA:Prompt),FONT(,12),TRN
                         ENTRY(@s6),AT(37,152,30,11),USE(SOE:SOE_ALTURA),FONT(,12,,FONT:regular),CENTER,REQ
                         PROMPT('Piso:'),AT(80,152),USE(?SOE:SOE_PISO:Prompt),FONT(,12),TRN
                         ENTRY(@s3),AT(100,152,20,11),USE(SOE:SOE_PISO),FONT(,12,,FONT:regular),CENTER
                         PROMPT('Dpto:'),AT(132,152),USE(?SOE:SOE_DPTO:Prompt),FONT(,12),TRN
                         ENTRY(@s3),AT(156,152,20,11),USE(SOE:SOE_DPTO),FONT(,12,,FONT:regular),CENTER
                       END
                       GROUP('Contacto'),AT(5,170,175,45),USE(?Contacto),FONT(,12),BOXED
                         PROMPT('Teléfono:'),AT(10,182),USE(?SOE:SOE_TELEFONO:Prompt),FONT(,12),TRN
                         ENTRY(@s20),AT(48,182,128,11),USE(SOE:SOE_TELEFONO),FONT(,12,,FONT:regular)
                         PROMPT('E-Mail:'),AT(10,197),USE(?SOE:SOE_EMAIL:Prompt),FONT(,12),TRN
                         ENTRY(@s50),AT(48,198,128,11),USE(SOE:SOE_EMAIL),FONT(,12,,FONT:regular)
                       END
                       PROMPT('Tipo:'),AT(5,220),USE(?SOE:SOE_TIPO:Prompt),FONT(,12,,FONT:bold),TRN
                       COMBO(@s5),AT(26,220,45,11),USE(TDO:TDO_TIPO),DROP(7),FORMAT('20C|@s5@'),FROM(Queue:FileDropCombo), |
  IMM
                       PROMPT('Estado:'),AT(84,220),USE(?SOE:SOE_ESTADO:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s15),AT(116,220,64,11),USE(SOE:SOE_ESTADO),FONT(,12,,FONT:regular),READONLY,REQ
                       ENTRY(@s50),AT(5,235,175,11),USE(TDO:TDO_DESCRIPCION),FONT(,12,,FONT:regular),READONLY
                       BUTTON('&Aceptar'),AT(80,251,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancelar'),AT(131,251,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
InsertAction           PROCEDURE(),BYTE,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
Reset                  PROCEDURE(BYTE Force=0),DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FDCB4                CLASS(FileDropComboClass)             ! File drop combo manager
Q                      &Queue:FileDropCombo           !Reference to browse queue type
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END
Bitmap           &ImageExBitmapClass
TheBitmap        ImageExBitmapClass
JpgSaver         ImageExJpegSaverClass
PDFSaver         ImageExPdfSaverClass
kMaxFoto         EQUATE(2048)

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_Solicitud_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
ActPresupuesto       ROUTINE
    POE:POE_USUARIO = glo:usuario
    POE:POE_UPDATE_DATE = TODAY()
    POE:POE_UPDATE_TIME = CLOCK()
ActSolicitud          ROUTINE
    SOE:SOE_USUARIO = glo:usuario
    SOE:SOE_UPDATE_DATE = TODAY()
    SOE:SOE_UPDATE_TIME = CLOCK()

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Alarma'
  OF InsertRecord
    ActionMessage = 'Se agregará nueva Solicitud'
  OF ChangeRecord
    ActionMessage = 'La Solicitud será modificado'
  END
  QuickWindow{PROP:StatusText,2} = ActionMessage           ! Display status message in status bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Solicitud')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?SOE:SOE_USUARIO:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('TDO:TDO_DESCRIPCION',TDO:TDO_DESCRIPCION)          ! Added by: FileDropCombo(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(SOE:Record,History::SOE:Record)
  SELF.AddHistoryField(?SOE:SOE_USUARIO,13)
  SELF.AddHistoryField(?SOE:SOE_UPDATE_DATE,20)
  SELF.AddHistoryField(?SOE:SOE_ID,1)
  SELF.AddHistoryField(?SOE:SOE_DNI,2)
  SELF.AddHistoryField(?SOE:SOE_APELLIDO,3)
  SELF.AddHistoryField(?SOE:SOE_NOMBRE,4)
  SELF.AddHistoryField(?SOE:SOE_CALLE,5)
  SELF.AddHistoryField(?SOE:SOE_ALTURA,6)
  SELF.AddHistoryField(?SOE:SOE_PISO,7)
  SELF.AddHistoryField(?SOE:SOE_DPTO,8)
  SELF.AddHistoryField(?SOE:SOE_TELEFONO,9)
  SELF.AddHistoryField(?SOE:SOE_EMAIL,10)
  SELF.AddHistoryField(?SOE:SOE_ESTADO,12)
  SELF.AddUpdateFile(Access:SOLICITUD_OBRA_ELECTRICA)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  Relate:TIPO_DE_OBRA.Open                                 ! File TIPO_DE_OBRA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:SOLICITUD_OBRA_ELECTRICA
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  IF SELF.Request = InsertRecord THEN
      HIDE(?SOE:SOE_ID:Prompt)
      HIDE(?SOE:SOE_ID)
      DISABLE(?Loc:acepta)
      DISABLE(?Loc:Observa)
  ELSE
      UNHIDE(?SOE:SOE_ID:Prompt)
      UNHIDE(?SOE:SOE_ID)
      CASE SOE:SOE_ESTADO
      OF 'Pendiente' OROF 'Cerrada'
          SELF.Request = ViewRecord
      OF 'Presupuestada'
          DISABLE(?SOE:SOE_DNI)
          DISABLE(?SOE:SOE_APELLIDO)
          DISABLE(?SOE:SOE_NOMBRE)
          DISABLE(?SOE:SOE_CALLE)
          DISABLE(?SOE:SOE_ALTURA)
          DISABLE(?SOE:SOE_PISO)
          DISABLE(?SOE:SOE_DPTO)
          DISABLE(?SOE:SOE_TELEFONO)
          DISABLE(?SOE:SOE_EMAIL)
          DISABLE(?TDO:TDO_TIPO)
          DISABLE(?Loc:Observa)
          ENABLE(?Loc:acepta)
      OF 'Observada'
          DISABLE(?SOE:SOE_DNI)
          DISABLE(?SOE:SOE_APELLIDO)
          DISABLE(?SOE:SOE_NOMBRE)
          DISABLE(?SOE:SOE_CALLE)
          DISABLE(?SOE:SOE_ALTURA)
          DISABLE(?SOE:SOE_PISO)
          DISABLE(?SOE:SOE_DPTO)
          DISABLE(?SOE:SOE_TELEFONO)
          DISABLE(?SOE:SOE_EMAIL)
          DISABLE(?TDO:TDO_TIPO)
          ENABLE(?Loc:Observa)
          DISABLE(?Loc:acepta)
      END
  END  
  Do DefineListboxStyle
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?SOE:SOE_USUARIO{PROP:ReadOnly} = True
    ?SOE:SOE_UPDATE_DATE{PROP:ReadOnly} = True
    ?SOE:SOE_ID{PROP:ReadOnly} = True
    DISABLE(?Loc:acepta)
    DISABLE(?Opt:SI)
    DISABLE(?Opt:NO)
    DISABLE(?Loc:Observa)
    ?SOE:SOE_DNI{PROP:ReadOnly} = True
    ?SOE:SOE_APELLIDO{PROP:ReadOnly} = True
    ?SOE:SOE_NOMBRE{PROP:ReadOnly} = True
    ?SOE:SOE_CALLE{PROP:ReadOnly} = True
    ?SOE:SOE_ALTURA{PROP:ReadOnly} = True
    ?SOE:SOE_PISO{PROP:ReadOnly} = True
    ?SOE:SOE_DPTO{PROP:ReadOnly} = True
    ?SOE:SOE_TELEFONO{PROP:ReadOnly} = True
    ?SOE:SOE_EMAIL{PROP:ReadOnly} = True
    DISABLE(?TDO:TDO_TIPO)
    ?SOE:SOE_ESTADO{PROP:ReadOnly} = True
    ?TDO:TDO_DESCRIPCION{PROP:ReadOnly} = True
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('Solicitud',QuickWindow)                    ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.AddItem(ToolbarForm)
  FDCB4.Init(TDO:TDO_TIPO,?TDO:TDO_TIPO,Queue:FileDropCombo.ViewPosition,FDCB4::View:FileDropCombo,Queue:FileDropCombo,Relate:TIPO_DE_OBRA,ThisWindow,GlobalErrors,0,1,0)
  FDCB4.Q &= Queue:FileDropCombo
  FDCB4.AddSortOrder(TDO:PK_TDO_TIPO)
  FDCB4.AddField(TDO:TDO_TIPO,FDCB4.Q.TDO:TDO_TIPO) !List box control field - type derived from field
  FDCB4.AddField(TDO:TDO_DESCRIPCION,FDCB4.Q.TDO:TDO_DESCRIPCION) !Browse hot field - type derived from field
  FDCB4.AddUpdateField(TDO:TDO_TIPO,SOE:SOE_TIPO)
  ThisWindow.AddItem(FDCB4.WindowComponent)
  FDCB4.DefaultFill = 0
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.InsertAction PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.InsertAction()
  !MESSAGE('Después de Insert Action')
  !SOLICITUD_OBRA_ELECTRICA{prop:Sql}= 'SELECT @@IDENTITY' !busco el número que se asignó
  !IF NOT Access:SOLICITUD_OBRA_ELECTRICA.Next()
  !    message('aceddiste a la tabla')!en el primer campo de Tabla viene cargado el número autogenerado
  !    MESSAGE(SOE:SOE_ID)
  !ELSE
  !    message('Error')
  !    MESSAGE(ERROR() & ' - ' & ERRORCODE())        
  !END
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
    INIMgr.Update('Solicitud',QuickWindow)                 ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.PrimeFields PROCEDURE

  CODE
  SOE:SOE_USUARIO = glo:usuario
  SOE:SOE_ESTADO = 'Iniciada'
  SOE:SOE_FECHA_DATE = TODAY()
  SOE:SOE_FECHA_TIME = CLOCK()
  SOE:SOE_UPDATE_DATE = TODAY()
  SOE:SOE_UPDATE_TIME = CLOCK()
  PARENT.PrimeFields


ThisWindow.Reset PROCEDURE(BYTE Force=0)

  CODE
  SELF.ForcedReset += Force
  IF QuickWindow{Prop:AcceptAll} THEN RETURN.
  POE:POE_SOE_ID = SOE:SOE_ID                              ! Assign linking field value
  Access:PRESUPUESTO_OBRA_ELECTRICA.Fetch(POE:FK_POE_SOE_ID)
  PARENT.Reset(Force)


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
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
    OF ?OK
      !IF SELF.Request = InsertRecord THEN
      !    IF SOE:SOE_EMAIL = '' AND SOE:SOE_TELEFONO = '' THEN
      !        MESSAGE('Debe completar, al menos, un dato de contacto!','Contacto',ICON:Exclamation, BUTTON:OK, 1)
      !        SELECT(?Contacto)
      !        CYCLE
      !    END
      !    SOE:SOE_APELLIDO = CLIP(UPPER(SOE:SOE_APELLIDO))
      !    SOE:SOE_NOMBRE = CLIP(UPPER(SOE:SOE_NOMBRE))
      !    SOE:SOE_CALLE = CLIP(UPPER(SOE:SOE_CALLE))
      !    SOE:SOE_ALTURA = CLIP(UPPER(SOE:SOE_ALTURA))
      !    SOE:SOE_PISO = CLIP(UPPER(SOE:SOE_PISO))
      !    SOE:SOE_DPTO = CLIP(UPPER(SOE:SOE_DPTO))
      !    SOE:SOE_EMAIL = CLIP(LOWER(SOE:SOE_EMAIL))
      !ELSIF SELF.Request = ChangeRecord THEN
      !    CLEAR(POE:Record)
      !    POE:POE_SOE_ID = SOE:SOE_ID
      !    GET(PRESUPUESTO_OBRA_ELECTRICA, POE:FK_POE_SOE_ID)
      !    IF NOT ERRORCODE() THEN
      !        CASE SOE:SOE_ESTADO
      !        OF 'Presupuestada'
      !            IF Loc:acepta = 1 THEN
      !                NroRecibo()
      !                IF Glo:NroRecibo <> '' THEN
      !                    POE:POE_ESTADO = 'Aceptado'
      !                    SOE:SOE_NRECIBO = Glo:NroRecibo
      !                    SOE:SOE_ESTADO = 'Aceptada'
      !                END
      !            ELSE
      !                MotivoRechazo()
      !                IF Glo:Motivo = 1 THEN
      !                    POE:POE_ESTADO = 'Cerrado'
      !                    SOE:SOE_MOTIVO = 'Asociado - ' & Glo:ObsMotivo
      !                    SOE:SOE_ESTADO = 'Cerrada'
      !                ELSIF Glo:Motivo = 2 THEN
      !                    POE:POE_ESTADO = 'Refinanciar'
      !                    SOE:SOE_ESTADO = 'Pendiente'
      !                END
      !            END
      !            DO ActPresupuesto
      !            Access:PRESUPUESTO_OBRA_ELECTRICA.Update()
      !        OF 'Observada'
      !            IF ?Glo:Observa = 0 THEN
      !                SOE:SOE_ESTADO = 'Pendiente'
      !            END
      !        END
      !        DO ActSolicitud
      !    END
      !END
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?SOE:SOE_DNI
      IF LEN(SOE:SOE_DNI) > 6 AND LEN(SOE:SOE_DNI) < 9 THEN
          ?SOE:SOE_DNI{PROP:Text} = '@P##.###.###PB'
      ELSIF LEN(SOE:SOE_DNI) > 9 AND LEN(SOE:SOE_DNI) < 12 THEN
          IF CLIP(SOE:SOE_DNI) = '30545719386' THEN
              SOE:SOE_APELLIDO = 'Cooperativa'
              SOE:SOE_NOMBRE = 'Corpico Ltd.'
              SOE:SOE_CALLE = '11'
              SOE:SOE_ALTURA = '341'
              SOE:SOE_EMAIL = '2dojefe_tecnico@corpico.com.ar'
              SOE:SOE_TIPO = 'M'
              SOE:SOE_ESTADO = 'Pendiente'
          END
          ?SOE:SOE_DNI{PROP:Text} = '@P##-##.###.###-#PB'
      ELSE
          MESSAGE('DNI/CUIT Incorrectos', 'Error Dígitos', ICON:Exclamation, BUTTON:OK, 1)
          SELECT(?SOE:SOE_DNI)
          SOE:SOE_DNI = ''
          CYCLE
      END
      ThisWindow.Reset(TRUE)
    OF ?SOE:SOE_EMAIL
      IF SOE:SOE_EMAIL <> '' THEN
          X# = MATCH(lower(CLIP(SOE:SOE_EMAIL)),'^[a-zA-Z0-9._#$&-]+@{{[a-zA-Z0-9._]+}.+[a-z][a-z][a-z]?[a-z]?$', Match:Regular)
          IF ~X# THEN
              MESSAGE('Correo eléctronico no válido!')
              SOE:SOE_EMAIL = ''
              ThisWindow.Reset(1)
              SELECT(?SOE:SOE_EMAIL)
          END    
      END
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCompleted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  IF SELF.Request = InsertRecord THEN
      IF SOE:SOE_EMAIL = '' AND SOE:SOE_TELEFONO = '' THEN
          MESSAGE('Debe completar, al menos, un dato de contacto!','Contacto',ICON:Exclamation, BUTTON:OK, 1)
          SELECT(?Contacto)
          CYCLE
      END
      SOE:SOE_APELLIDO = CLIP(UPPER(SOE:SOE_APELLIDO))
      SOE:SOE_NOMBRE = CLIP(UPPER(SOE:SOE_NOMBRE))
      SOE:SOE_CALLE = CLIP(UPPER(SOE:SOE_CALLE))
      SOE:SOE_ALTURA = CLIP(UPPER(SOE:SOE_ALTURA))
      SOE:SOE_PISO = CLIP(UPPER(SOE:SOE_PISO))
      SOE:SOE_DPTO = CLIP(UPPER(SOE:SOE_DPTO))
      SOE:SOE_EMAIL = CLIP(LOWER(SOE:SOE_EMAIL))
  ELSIF SELF.Request = ChangeRecord THEN
      CLEAR(POE:Record)
      POE:POE_SOE_ID = SOE:SOE_ID
      GET(PRESUPUESTO_OBRA_ELECTRICA, POE:FK_POE_SOE_ID)
      IF NOT ERRORCODE() THEN !Existe un presupuesto
          IF SOE:SOE_ESTADO = 'Presupuestada'THEN
              IF Loc:acepta = 1 THEN
                  NroRecibo()
                  IF Glo:NroRecibo <> '' THEN
                      POE:POE_ESTADO = 'Aceptado'
                      SOE:SOE_NRECIBO = Glo:NroRecibo
                      SOE:SOE_ESTADO = 'Aceptada'
                  END
              ELSE
                  MotivoRechazo()
                  CASE Glo:Motivo
                  OF 1
                      POE:POE_ESTADO = 'Cerrado'
                      SOE:SOE_MOTIVO = 'Asociado - ' & Glo:ObsMotivo
                      SOE:SOE_ESTADO = 'Cerrada'
                  OF 2
                      POE:POE_ESTADO = 'Refinanciar'
                      SOE:SOE_ESTADO = 'Pendiente'
                  END
              END
              DO ActPresupuesto
              Access:PRESUPUESTO_OBRA_ELECTRICA.Update()
              DO ActSolicitud
          END
      ELSE !No existe presupuesto
          IF SOE:SOE_ESTADO = 'Observada' AND Loc:Observa = 1 THEN
              SOE:SOE_ESTADO = 'Pendiente'
              SOE:SOE_MOTIVO = ''
          END
          DO ActSolicitud
      END
  END
  !IF SOE:SOE_ESTADO = 'Presupuestada' THEN
  !    CLEAR(POE:Record)
  !    POE:POE_SOE_ID = SOE:SOE_ID
  !    GET(PRESUPUESTO_OBRA_ELECTRICA, POE:FK_POE_SOE_ID)
  !    IF NOT ERRORCODE() THEN
  !        IF Loc:acepta = 1 THEN
  !            NroRecibo()
  !            IF Glo:NroRecibo <> '' THEN
  !                POE:POE_ESTADO = 'Aceptado'
  !                SOE:SOE_NRECIBO = Glo:NroRecibo
  !                SOE:SOE_ESTADO = 'Aceptada'
  !            END
  !        ELSE
  !            MotivoRechazo()
  !            IF Glo:Motivo = 1 THEN
  !                POE:POE_ESTADO = 'Cerrado'
  !                SOE:SOE_MOTIVO = 'Asociado - ' & Glo:ObsMotivo
  !                SOE:SOE_ESTADO = 'Cerrada'
  !            ELSIF Glo:Motivo = 2 THEN
  !                POE:POE_ESTADO = 'Refinanciar'
  !                SOE:SOE_ESTADO = 'Pendiente'
  !            END
  !        END
  !        DO ActPresupuesto
  !        Access:PRESUPUESTO_OBRA_ELECTRICA.Update()
  !    END
  !    DO ActSolicitud
  !END
  ReturnValue = PARENT.TakeCompleted()
  !IF SELF.Response = RequestCompleted AND SELF.Request = InsertRecord
  !   SOLICITUD_OBRA_ELECTRICA{prop:Sql}= 'SELECT @@IDENTITY' !busco el número que se asignó
  !   IF NOT Access:SOLICITUD_OBRA_ELECTRICA.Next()
  !        message('aceddiste a la tabla')!en el primer campo de Tabla viene cargado el número autogenerado
  !        MESSAGE(SOE:SOE_ID)
  !   ELSE
  !      message('Error')
  !   END
  !END
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
!!! Form TIPO_DE_OBRA
!!! </summary>
TDO_Formulario PROCEDURE 

CurrentTab           STRING(80)                            !
ActionMessage        CSTRING(40)                           !
History::TDO:Record  LIKE(TDO:RECORD),THREAD
QuickWindow          WINDOW('Tipo de Obra'),AT(,,290,55),FONT('Microsoft Sans Serif',10,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,GRAY,IMM,MDI,SYSTEM
                       BUTTON('&Aceptar'),AT(185,36,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancelar'),AT(237,36,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       PROMPT('Tipo:'),AT(35,5),USE(?TDO:TDO_TIPO:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s5),AT(58,6,35,11),USE(TDO:TDO_TIPO),FONT(,12),CENTER,REQ,TIP('Abreviatura de la Obra')
                       PROMPT('Descripción:'),AT(5,20),USE(?TDO:TDO_DESCRIPCION:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s50),AT(58,20,227,11),USE(TDO:TDO_DESCRIPCION),FONT(,12),REQ,TIP('Nombre complet' & |
  'o de la Obra')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_TDO_Formulario_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Alarma'
  OF InsertRecord
    ActionMessage = 'Se agregará nueva Alarma'
  OF ChangeRecord
    ActionMessage = 'La Alarma será modificado'
  END
  QuickWindow{PROP:StatusText,2} = ActionMessage           ! Display status message in status bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('TDO_Formulario')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?OK
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(TDO:Record,History::TDO:Record)
  SELF.AddHistoryField(?TDO:TDO_TIPO,1)
  SELF.AddHistoryField(?TDO:TDO_DESCRIPCION,2)
  SELF.AddUpdateFile(Access:TIPO_DE_OBRA)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:TIPO_DE_OBRA.Open                                 ! File TIPO_DE_OBRA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:TIPO_DE_OBRA
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?TDO:TDO_TIPO{PROP:ReadOnly} = True
    ?TDO:TDO_DESCRIPCION{PROP:ReadOnly} = True
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('TDO_Formulario',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:TIPO_DE_OBRA.Close
  END
  IF SELF.Opened
    INIMgr.Update('TDO_Formulario',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
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
    OF ?OK
      TDO:TDO_TIPO = CLIP(UPPER(TDO:TDO_TIPO))
      TDO:TDO_DESCRIPCION = CLIP(UPPER(TDO:TDO_DESCRIPCION))
      GET(TIPO_DE_OBRA, TDO:PK_TDO_TIPO)
      IF NOT ERRORCODE() THEN
          MESSAGE('Ya existe un Tipo de Obra con la misma abreviatura','Error', ICON:Exclamation, BUTTON:OK, 1)
          TDO:TDO_TIPO = ''
          SELECT(?TDO:TDO_TIPO)
          CYCLE
      END
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
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
!!! Generated from procedure template - Source
!!! </summary>
ExtractFileExt       PROCEDURE  (STRING Filename)          ! Declare Procedure
Path  CSTRING(FILE:MAXFILENAME)
Drive CSTRING(FILE:MAXFILENAME)
Dir   CSTRING(FILE:MAXFILENAME)
Name  CSTRING(FILE:MAXFILENAME)
Ext   CSTRING(FILE:MAXFILENAME)

  CODE
   Path = clip(Filename)

   if fnsplit(Path, Drive, Dir, Name, Ext)
      return clip(ext)
   else
      Return ''
   end
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
SaveImage PROCEDURE (ImageExBitmapClass Bmp,BOOL ShowOptions,<string filename>)

Loc:Filename         STRING(255)                           !
Loc:SaveFilename     STRING(255)                           !
Loc:CString          CSTRING(256)                          !
Loc:TiffAppend       SIGNED                                !
LocalRequest         LONG                                  !
OriginalRequest      LONG                                  !
LocalResponse        LONG                                  !
FilesOpened          BYTE                                  !
WindowOpened         LONG                                  !
WindowInitialized    LONG                                  !
ForceRefresh         LONG                                  !
JpegCompression      SIGNED                                !
JpegProgressive      SIGNED                                !
GifPalette           STRING(20)                            !
GifDither            STRING(20)                            !
GifCompression       SIGNED                                !
PngCompression       SIGNED                                !
PngInterlaced        SIGNED                                !
PngSaveAlpha         SIGNED                                !
PcxCompress          SIGNED                                !
Jpeg2000Compression  REAL                                  !
Loc:Result           SIGNED                                !
FileSize             SIGNED                                !
TiffCompr            STRING(20)                            !
TiffResolution       SIGNED                                !
PdfCompression       STRING(20)                            !
PdfPaperWidth        SIGNED                                !
PdfPaperHeight       SIGNED                                !
PsCompression        STRING(20)                            !
PsPaperWidth         SIGNED                                !
PsPaperHeight        SIGNED                                !
BmpSaver    IMAGEEXBMPSAVERCLASS
JpgSaver    IMAGEEXJPEGSAVERCLASS
TgaSaver    IMAGEEXTARGASAVERCLASS
PngSaver    IMAGEEXPNGSAVERCLASS
PcxSaver    IMAGEEXPCXSAVERCLASS
GifSaver    IMAGEEXGIFSAVERCLASS
TifSaver    IMAGEEXTIFFSAVERCLASS
JP2Saver    IMAGEEXJP2SAVERCLASS
J2KSaver    IMAGEEXJ2KSAVERCLASS
PDFSaver    IMAGEEXPDFSAVERCLASS
PsSaver     IMAGEEXPSSAVERCLASS

PreviewVisible BOOL(True)
Window               WINDOW('Saving options'),AT(,,236,212),FONT('MS Sans Serif',8,,FONT:regular,CHARSET:ANSI), |
  DOUBLE,CENTER,GRAY,SYSTEM
                       SHEET,AT(0,0,161,95),USE(?Sheet1),BELOW
                         TAB('JPEG'),USE(?JpegTab)
                           GROUP('JPEG options'),AT(8,8,145,65),USE(?Group1),BOXED
                             PROMPT('Quality:'),AT(12,20),USE(?JpegCompression:Prompt)
                             SPIN(@n_3),AT(40,20,29,12),USE(JpegCompression),RIGHT,RANGE(0,100)
                             STRING('(100=best, 0=lowest)'),AT(76,20),USE(?String1)
                             CHECK('Pr&ogressive'),AT(40,40),USE(JpegProgressive),RIGHT
                           END
                         END
                         TAB('GIF'),USE(?GifTab)
                           GROUP('GIF options'),AT(8,8,145,65),USE(?Group2),BOXED
                             LIST,AT(60,20,68,12),USE(GifPalette),DROP(5),FROM('Optimal|System|Web')
                             PROMPT('P&alette:'),AT(15,21),USE(?GifPalette:Prompt)
                             PROMPT('&Dithering:'),AT(15,41),USE(?GifDither:Prompt)
                             LIST,AT(60,40,68,12),USE(GifDither),DROP(10),FROM('Nearest|FloydSteinberg|Stucki|Sierra' & |
  '|JaJuNi|SteveArche|Burkes')
                             STRING('Compression:'),AT(16,58),USE(?String11)
                             OPTION,AT(60,56,73,14),USE(GifCompression)
                               RADIO('LZW'),AT(60,58),USE(?GifCompression:Radio1),VALUE('2')
                               RADIO('RLE'),AT(92,58),USE(?GifCompression:Radio2),VALUE('1')
                             END
                           END
                         END
                         TAB('PNG'),USE(?PngTab)
                           GROUP('PNG options'),AT(8,8,145,65),USE(?Group3),BOXED
                             SPIN(@n1),AT(80,20,29,12),USE(PngCompression),RIGHT,RANGE(0,9)
                             PROMPT('&Compression level:'),AT(16,21),USE(?PngCompression:Prompt)
                             STRING('(9=best)'),AT(112,24),USE(?String2)
                             CHECK('&Interlaced'),AT(68,40),USE(PngInterlaced),RIGHT
                             CHECK('&Save alpha channel'),AT(68,52),USE(PngSaveAlpha),RIGHT
                           END
                         END
                         TAB('TIFF'),USE(?TiffTab)
                           GROUP('TIFF options'),AT(8,8,145,65),USE(?Group5),BOXED
                             PROMPT('&Compression:'),AT(16,21),USE(?Prompt5)
                             LIST,AT(72,20,68,12),USE(TiffCompr),DROP(10),FROM('None|CCITT|Group 3|Group 4|LZW|Jpeg|Packbits')
                             PROMPT('&Resolution:'),AT(16,40),USE(?TiffResolution:Prompt)
                             ENTRY(@n_3),AT(72,40),USE(TiffResolution),RIGHT
                             STRING('DPI'),AT(100,41),USE(?String6)
                           END
                         END
                         TAB('PCX'),USE(?PcxTab)
                           GROUP('PCX options'),AT(8,8,145,65),USE(?Group6),BOXED
                             CHECK('use &RLE compression'),AT(16,24),USE(PcxCompress),RIGHT
                           END
                         END
                         TAB('J2000'),USE(?J2000Tab)
                           GROUP('JPEG 2000 options'),AT(8,8,145,65),USE(?Group7),BOXED
                             PROMPT('&Compression:'),AT(16,21),USE(?Jpeg2000Compression:Prompt)
                             SPIN(@n3.1),AT(68,20,29,12),USE(Jpeg2000Compression),RIGHT,RANGE(0,1),STEP(0.1)
                             STRING('(1.0 = lossless)'),AT(68,36),USE(?String3)
                           END
                         END
                         TAB('PDF'),USE(?PdfTab)
                           GROUP('PDF options'),AT(8,8,145,65),USE(?GroupX),BOXED
                             PROMPT('&Compression:'),AT(16,21),USE(?PdfCompression:Prompt)
                             LIST,AT(72,20,68,12),USE(PdfCompression),LEFT,DROP(5),FROM('None|RLE|Group4|Group3|JPEG')
                             PROMPT('Paper &width:'),AT(16,37),USE(?PdfPaperWidth:Prompt)
                             ENTRY(@n_4),AT(72,36),USE(PdfPaperWidth),RIGHT
                             PROMPT('Paper &height:'),AT(16,53),USE(?PdfPaperHeight:Prompt)
                             ENTRY(@n_4),AT(72,52),USE(PdfPaperHeight),RIGHT
                             STRING('points'),AT(104,37),USE(?String7)
                             STRING('points'),AT(104,53),USE(?String7:2)
                           END
                         END
                         TAB('PS'),USE(?PsTab)
                           GROUP('PostScript options'),AT(8,8,145,65),USE(?GroupY),BOXED
                             PROMPT('&Compression:'),AT(16,21),USE(?PsCompression:Prompt)
                             LIST,AT(72,20,68,12),USE(PsCompression),LEFT,DROP(5),FROM('RLE|Group4|Group3|JPEG')
                             PROMPT('Paper &width:'),AT(16,37),USE(?PsPaperWidth:Prompt)
                             ENTRY(@n_4),AT(72,36),USE(PsPaperWidth),RIGHT
                             PROMPT('Paper &height:'),AT(16,53),USE(?PsPaperHeight:Prompt)
                             ENTRY(@n_4),AT(72,52),USE(PsPaperHeight),RIGHT
                             STRING('points'),AT(104,37),USE(?String7:2:2:2)
                             STRING('points'),AT(104,53),USE(?String7:2:2:2:2)
                           END
                         END
                       END
                       BUTTON('OK'),AT(172,8,53,16),USE(?OkButton),LEFT,DEFAULT
                       BUTTON('Cancel'),AT(172,32,53,16),USE(?CancelButton),LEFT
                       BUTTON('&Preview <<<<'),AT(172,56,53,16),USE(?Preview)
                       STRING(@s20),AT(40,200),USE(FileSize)
                       REGION,AT(13,89,210,99),USE(?Viewer)
                       STRING('File size:'),AT(8,200),USE(?String5)
                       GROUP('&Preview'),AT(8,80,221,114),USE(?Group4),BOXED
                       END
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ImageExViewer2       CLASS(ImageExViewerClass)
                     END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  RETURN(Loc:Result)

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
CreatePreview  ROUTINE

   Do SetOptions
   if Not PreviewVisible then exit.

   ! We save to a blob here to avoid having to deal with temporary files...
   case Upper(ExtractFileExt(loc:savefilename))
   of '.JPG'
      Bmp.SaveToBlob(SQB:IMAGEN, JpgSaver)
   of '.GIF'
      Bmp.SaveToBlob(SQB:IMAGEN, GifSaver)
   of '.PNG'
     if ~Bmp.SaveToBlob(SQB:IMAGEN, PngSaver)
         Message('Saving PNG to blob failed!')
     else
         Message(SQB:IMAGEN{PROP:SIZE})
     end
   of '.TIF'
      Bmp.SaveToBlob(SQB:IMAGEN, TifSaver)
   of '.PCX'
      Bmp.SaveToBlob(SQB:IMAGEN, PcxSaver)
   of '.JP2'
      Bmp.SaveToBlob(SQB:IMAGEN, Jp2Saver)
   of '.J2K'
      Bmp.SaveToBlob(SQB:IMAGEN, J2KSaver)
   of '.PDF'
      Bmp.SaveToBlob(SQB:IMAGEN, PdfSaver)
   of '.PS'
      Bmp.SaveToBlob(SQB:IMAGEN, PsSaver)
   end
   ImageExViewer2.Bitmap.LoadFromBlob(SQB:IMAGEN)

   FileSize = SQB:IMAGEN{PROP:SIZE}

SetOptions  ROUTINE

   case Upper(ExtractFileExt(loc:savefilename))
   of '.JPG'
      JpgSaver.CompressionQuality = JpegCompression
      JpgSaver.Progressive      = JpegProgressive
   of '.GIF'
      Case GifPalette
      of 'Optimal'
         GifSaver.ColorReduction = IECR:QUANTIZE
      of 'System'
         GifSaver.ColorReduction = IECR:WINDOWS256
      of 'Web'
         GifSaver.ColorReduction = IECR:NETSCAPE
      else
         Message('Unknown palette: ' & GifPalette, 'Huh?', Icon:Hand)
      end
      GifSaver.DitherMode = Choice(?GifDither)-1
      GifSaver.Compression = GifCompression
   of '.PNG'
      PngSaver.CompressionLevel = PngCompression
      PngSaver.Interlaced       = PngInterlaced
      PngSaver.SaveAlpha        = PngSaveAlpha
   of '.TIF'
      Case TiffCompr
      of 'None'
         TifSaver.Compression = IECA:NONE
      of 'CCITT'
         TifSaver.Compression = IECA:CCITT
      of 'Group 3'
         TifSaver.Compression = IECA:GROUP3
      of 'Group 4'
         TifSaver.Compression = IECA:GROUP4
      of 'LZW'
         TifSaver.Compression = IECA:LZW
      of 'Jpeg'
         TifSaver.Compression = IECA:JPEG
      of 'Packbits'
         TifSaver.Compression = IECA:PACKBITS
      else
         Message('Error: Unknown Tiff compression!', 'ERROR', ICON:HAND)
      end
      TifSaver.Resolution = 300
   of '.PCX'
      PcxSaver.Compression       = PcxCompress
   of '.JP2' orof '.J2K'
      Jp2Saver.CompressionQuality = Jpeg2000Compression
      J2KSaver.CompressionQuality = Jpeg2000Compression
   of '.PDF'
      Case PdfCompression
      of 'None'
         PdfSaver.Compression   = IECA:None
      of 'Group4'
         PdfSaver.Compression   = IECA:Group4
      of 'Group3'
         PdfSaver.Compression   = IECA:Group3
      of 'RLE'
         PdfSaver.Compression   = IECA:RLE
      of 'JPEG'
         PdfSaver.Compression   = IECA:Jpeg
      else
         Message('Error: Unknown PDF compression!', 'ERROR', ICON:HAND)
      end
      PdfSaver.PaperWidth       = PdfPaperWidth
      PdfSaver.PaperHeight      = PdfPaperHeight
   of '.PS'
      Case PsCompression
      of 'Group4'
         PsSaver.Compression   = IECA:Group4
      of 'Group3'
         PsSaver.Compression   = IECA:Group3
      of 'RLE'
         PsSaver.Compression   = IECA:RLE
      of 'JPEG'
         PsSaver.Compression   = IECA:Jpeg
      else
         Message('Error: Unknown PostScript compression!', 'ERROR', ICON:HAND)
      end
      PsSaver.PaperWidth       = PsPaperWidth
      PsSaver.PaperHeight      = PsPaperHeight
   end

ThisWindow.Ask PROCEDURE

  CODE
   PictureDialogResult# = ImageEx:PictureDialog(, Loc:SaveFilename, 'JPEG images (*.jpg)|*.jpg|Portable network graphic images  (*.png)|*.png|CompuServe images  (*.gif)|*.gif|Windows bitmaps (*.bmp)|*.bmp|ZSoft Paintbrush images (*.pcx)|*.pcx|Truevision images (*.tga)|*.tga|TIFF images (*.tif)|*.tif|Jpeg 2000 Codestream (*.j2k)|*.j2k|Jpeg 2000 file (*.jp2)|*.jp2|Portable Document Format (*.pdf)|*.pdf|PostScript (*.ps)|*.ps', FILE:SAVE+FILE:KEEPDIR+FILE:APPENDEXTENSION+FILE:NOERROR)
   if PictureDialogResult#
  
        ! Since we turned off error reporting for the PictureDialog (FILE:NOERROR)
        ! to be able to append images to existing TIFF files, we'll have to check for
        ! existance of the file ourselves here...
        Loc:Cstring = clip(Loc:SaveFileName)
        if Access(Loc:CString, 0) = 0 ! File exists
           if Upper(ExtractFileExt(loc:SaveFilename)) = '.TIF'
              Case Message('Append image to existing file?', 'CIMP', ICON:QUESTION, BUTTON:YES+BUTTON:NO+BUTTON:CANCEL)
              of Button:Yes
                 Loc:TiffAppend = true
              of Button:No
                 Loc:TiffAppend = false
              else
                 ThisWindow.Kill
              end
           else
              Loc:TiffAppend = false
              if Message('Replace existing file?', 'CIMP', ICON:QUESTION, BUTTON:YES+BUTTON:NO) <> BUTTON:YES
                 ThisWindow.Kill
              end
           end
        end
  
  
      bmp.GetSize(w#, h#)
      PDFSaver.PaperWidth  = w#
      PDFSaver.PaperHeight = h#
  
      PsSaver.PaperWidth  = w#
      PsSaver.PaperHeight = h#
  
      case upper(ExtractFileExt(loc:savefilename))
      of '.BMP'
        LocalResponse = RequestCompleted
        ThisWindow.Kill()
      of '.TGA'
        LocalResponse = RequestCompleted
        ThisWindow.Kill()
      of '.JPG'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
        else
           ThisWindow.FirstField = ?JpegTab
        end
      of '.GIF'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
        else
           ThisWindow.FirstField = ?GifTab
        end
      of '.PNG'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
        else
           ThisWindow.FirstField = ?PngTab
        end
      of '.TIF'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
        else
           ThisWindow.FirstField = ?TiffTab
        end
      of '.PCX'
         if not ShowOptions
            LocalResponse = RequestCompleted
            ThisWindow.Kill()
         else
           ThisWindow.FirstField = ?PcxTab
         end
      of '.JP2' orof '.J2K'
         if not ShowOptions
            LocalResponse = RequestCompleted
            ThisWindow.Kill()
         else
           ThisWindow.FirstField = ?J2000Tab
         end
      of '.PDF'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
         else
           ThisWindow.FirstField = ?PdfTab
            Disable(?Preview)
            Post(event:Accepted, ?Preview)
        end
      of '.PS'
        if not ShowOptions
           LocalResponse = RequestCompleted
           ThisWindow.Kill()
         else
           ThisWindow.FirstField = ?PsTab
            Disable(?Preview)
            Post(event:Accepted, ?Preview)
        end
      else
        Message('Unsupported file type for saving!')
        Loc:Result = false
        ThisWindow.Kill()
      end
   else
     Loc:Result = false
     THisWindow.Kill()
   end
  ImageExViewer2.Init(Window, ?Viewer)
  ImageExViewer2.SetBkColor(8421504)
  ImageExViewer2.Bitmap.SetStretchFilter(IMAGEEXSTRETCHFILTER:Nearest)
  ImageExViewer2.Bitmap.SetDrawMode(IMAGEEXDRAWMODE:Opaque)
  ImageExViewer2.Bitmap.SetMasterAlpha(255)
  ImageExViewer2.SetChessColor(16777215)
  ImageExViewer2.SetChessSize(15)
  ImageExViewer2.SetZoomPercent(100)
  ImageExViewer2.SetAllowFocus(1)
  ImageExViewer2.SetScrollsVisible(0)
  ImageExViewer2.SetMouseMode(1*IEMM:PAN + 1*IEMM:ZoomWheel + 1 * IEMM:HOTSPOTS)
     ImageExViewer2.Bitmap.Assign(bmp)
  
     ?Sheet1{PROP:WIZARD}  = true
     ?Sheet1{PROP:NOSHEET} = true
  
     JpegCompression = JpgSaver.CompressionQuality
     JpegProgressive = JpgSaver.Progressive
  
     GifPalette = 'Optimal'
     GifDither = 'FloydSteinberg'
  
     ?GifDither{PROP:SELECTED} = 1
  
     PngCompression = PngSaver.CompressionLevel
     PngInterlaced = PngSaver.Interlaced
  
     PcxCompress = PcxSaver.Compression
     Jpeg2000Compression = JP2Saver.CompressionQuality
  
     TiffCompr = 'None'
     TiffResolution = 300
  
     PdfCompression = 'None'
     PdfPaperWidth  = PdfSaver.PaperWidth
     PdfPaperHeight = PdfSaver.PaperHeight
  
     PsCompression = 'RLE'
     PsPaperWidth  = PsSaver.PaperWidth
     PsPaperHeight = PsSaver.PaperHeight
  
     GifCompression = GifSaver.Compression
  
     Do CreatePreview
  
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SaveImage')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?JpegCompression:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Loc:SaveFilename = filename
  Relate:SQLBLOB.Open                                      ! File SQLBLOB used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('SaveImage',Window)                         ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:SQLBLOB.Close
  END
  IF SELF.Opened
    INIMgr.Update('SaveImage',Window)                      ! Save window data to non-volatile store
  END
     if LocalResponse = RequestCompleted
        case Upper(ExtractFileExt(loc:savefilename))
        of '.BMP'
           Loc:result = bmp.SaveToFile(loc:savefilename, BmpSaver)
        of '.TGA'
           Loc:Result = bmp.SaveToFile(loc:savefilename, TgaSaver)
        of '.PCX'
           Loc:Result = bmp.SaveToFile(loc:savefilename, PcxSaver)
        of '.JPG'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, JpgSaver)
        of '.GIF'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, GifSaver)
        of '.PNG'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, PngSaver)
        of '.TIF'
           if ~Loc:TiffAppend
              Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, TifSaver)
           else
              Loc:Result = TifSaver.InsertIntoFile(Loc:SaveFilename, -1, Bmp)
           end
        of '.JP2'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, JP2Saver)
        of '.J2K'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, J2KSaver)
        of '.PDF'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, PdfSaver)
        of '.PS'
           Loc:Result = Bmp.SaveToFile(Loc:SaveFilename, PsSaver)
        end
  
        if ~Loc:Result then
           MESSAGE('Error saving file!', 'ImageEx', ICON:HAND)
        end
     else
        loc:result = false
     end
  
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
    OF ?GifPalette
         Do CreatePreview
      
    OF ?GifDither
         Do CreatePreview
      
    OF ?PngCompression
         Do CreatePreview
      
    OF ?PngInterlaced
         Do CreatePreview
      
    OF ?PdfPaperWidth
         Do CreatePreview
      
    OF ?PdfPaperHeight
         Do CreatePreview
      
    OF ?CancelButton
         LocalResponse = RequestCancelled
       POST(EVENT:CloseWindow)
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?JpegCompression
         do CreatePreview
      
    OF ?GifCompression
         Do CreatePreview
      
    OF ?PngSaveAlpha
         Do CreatePreview
      
    OF ?TiffCompr
         Do CreatePreview
      
    OF ?PcxCompress
         Do CreatePreview
      
    OF ?Jpeg2000Compression
         Do CreatePreview
      
    OF ?PdfCompression
         Do CreatePreview
      
    OF ?OkButton
      ThisWindow.Update()
         LocalResponse = RequestCompleted
      
         if upper(ExtractFileExt(loc:savefilename)) = '.TIF'
            c# = Bmp.CountColors()
            if c# > 2 and Inrange(Choice(?TiffCompr),2,4)
               if Message('You have selected a monochrome compression format, but your image currently has ' & c# & ' colors. You might want to reduce colors before saving to avoid quality loss. | | Continue saving?', 'ImageEx', ICON:QUESTION, BUTTON:YES+BUTTON:NO) <> BUTTON:YES
                  LocalResponse = RequestCancelled
               END
            end
         end
      
         LocalResponse = RequestCompleted
       POST(EVENT:CloseWindow)
    OF ?Preview
      ThisWindow.Update()
         if PreviewVisible
            PreviewVisible = false
            Window{PROP:HEIGHT} = ?OkButton{PROP:YPOS} + ?Preview{PROP:YPOS} + ?Preview{PROP:HEIGHT}
            ?Preview{PROP:TEXT} = '&Preview >>'
         else
            PreviewVisible = true
            Window{PROP:HEIGHT} = ?OkButton{PROP:YPOS} + ?FileSize{PROP:YPOS} + ?FileSize{PROP:HEIGHT}
            ?Preview{PROP:TEXT} = '&Preview <<<<'
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
    CASE FIELD()
    OF ?PngCompression
         Do CreatePreview
      
    END
  ReturnValue = PARENT.TakeNewSelection()
    CASE FIELD()
    OF ?JpegCompression
         do CreatePreview
      
    OF ?Jpeg2000Compression
         Do CreatePreview
      
    OF ?PdfCompression
         Do CreatePreview
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
ExtractFilePath      PROCEDURE  (STRING Filename)          ! Declare Procedure
Path  CSTRING(FILE:MAXFILENAME)
Drive CSTRING(FILE:MAXFILENAME)
Dir   CSTRING(FILE:MAXFILENAME)
Name  CSTRING(FILE:MAXFILENAME)
Ext   CSTRING(FILE:MAXFILENAME)

  CODE
   Path = clip(Filename)
   if fnsplit(Path, Drive, Dir, Name, Ext)
      return clip(Drive) & clip(Dir)
   else
      Return ''
   end
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
PasswordDecrypt      PROCEDURE  (sTexto)                   ! Declare Procedure
n USHORT
i USHORT
sText CString(255)
sCaracter  String(1)
wEsimPar BYTE
PasswordDecrypt    CString(255)



  CODE
        n = Len(sTexto)
        Loop i = 1 To Len(sTexto) by 2
            If i = Len(sTexto) Then
                wEsimPar = 0
            Else
                wEsimPar = 1    
            End 
        end
    
        i = Len(sTexto)
        Loop While i <> 0
            
            sCaracter = SUB(sTexto, i, 1)
            If wEsimPar Then
              sCaracter[1] = Chr(val(sCaracter[1]) + n)
              If sCaracter[1] = chr(39) Or sCaracter[1] = '|' Then
                 sCaracter[1] = Chr(val(sCaracter[1]) - n)
              End 
              wEsimPar = False
            Else
              sCaracter[1] = Chr(val(sCaracter[1]) - n)
              If sCaracter[1] = chr(39) Or sCaracter[1] = '|' Then
                 sCaracter[1] = Chr(val(sCaracter[1]) - n)
              End 
              wEsimPar = True
            End 
        
            sText = sText & sCaracter[1]
            i = i - 1
            n = n - 1
        END
    
        PasswordDecrypt = sText

    RETURN PasswordDecrypt
