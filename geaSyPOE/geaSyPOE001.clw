

   MEMBER('geaSyPOE.clw')                                  ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('GEASYPOE001.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('GEASYPOE002.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('GEASYPOE003.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Frame
!!! Wizard Application for C:\Proyectos_Clarion\geaSyPOE\solicitud.dct
!!! </summary>
Main PROCEDURE 

SQLOpenWindow        WINDOW('Inicializando la Base de Datos'),AT(,,208,26),FONT('Microsoft Sans Serif',8,,FONT:regular),CENTER,GRAY,DOUBLE
                       STRING('Este proceso podría llevar varios segundos.'),AT(27,12)
                       IMAGE(Icon:Connect),AT(4,4,23,17)
                       STRING('Por favor espere mientras el programa se conecta con la Base de Datos.'),AT(27,3)
                     END
AppFrame             APPLICATION('GeaSyPOE'),AT(,,505,318),FONT('Microsoft Sans Serif',10,COLOR:Black,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,CENTER,ICON('Obra.ico'),IMM,MAX,STATUS(-1,80,120,45),SYSTEM
                       MENUBAR,USE(?Menubar)
                         MENU('&Archivo'),USE(?MenuArchivo)
                           ITEM('&Impresora'),USE(?ConfigImpresora),MSG('Configurar Impresora'),STD(STD:PrintSetup)
                           ITEM,USE(?SEPARATOR1),SEPARATOR
                           ITEM('&Salir'),USE(?Salir),MSG('Cerrar aplicación'),STD(STD:Close)
                         END
                         MENU('&Detalles'),USE(?MenuDetalles)
                           ITEM('Presupuestos Obras Eléctricas'),USE(?VisualizarPresupuestos)
                           ITEM('Solicitudes Obras Eléctricas'),USE(?VisualizarSolicitudes)
                           ITEM('Tipo de Obra'),USE(?VisualizarTiposObras)
                         END
                         MENU('&Reportes'),USE(?MenuReportes),MSG('Report data')
                           ITEM('Presupuestos de Obras Eléctricas'),USE(?ReportePresupuestos)
                           ITEM('Solicitudes de Obras Eléctricas'),USE(?ReporteSolicitudes)
                         END
                       END
                       TOOLBAR,AT(0,0,505,40),USE(?Toolbar),COLOR(008CE6F0h)
                         BUTTON('Solicitudes'),AT(10,10,70,20),USE(?Btn:Solicitudes),FONT(,12,,FONT:bold),LEFT,ICON('Solicitud.ico')
                         BUTTON('Presupuestos'),AT(100,10,80,20),USE(?Btn:Presupuestos:2),FONT(,12,,FONT:bold),LEFT, |
  ICON('presupuesto.ico')
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_Main_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
Menu::Menubar ROUTINE                                      ! Code for menu items on ?Menubar
Menu::MenuArchivo ROUTINE                                  ! Code for menu items on ?MenuArchivo
Menu::MenuDetalles ROUTINE                                 ! Code for menu items on ?MenuDetalles
  CASE ACCEPTED()
  OF ?VisualizarPresupuestos
    IF GLO:oneInstance_PresupuestosDetalles_thread = 0      		
       GLO:oneInstance_PresupuestosDetalles_thread = START(PresupuestosDetalles, 050000)
    ELSE      		
       NOTIFY(EVENT:GainFocus, GLO:oneInstance_PresupuestosDetalles_thread)      		
    END      		
  OF ?VisualizarSolicitudes
    IF GLO:oneInstance_SolicitudesDetalles_thread = 0      		
       GLO:oneInstance_SolicitudesDetalles_thread = START(SolicitudesDetalles, 050000)
    ELSE      		
       NOTIFY(EVENT:GainFocus, GLO:oneInstance_SolicitudesDetalles_thread)      		
    END      		
  OF ?VisualizarTiposObras
    IF GLO:oneInstance_TipoObra_thread = 0      		
       GLO:oneInstance_TipoObra_thread = START(TipoObra, 050000)
    ELSE      		
       NOTIFY(EVENT:GainFocus, GLO:oneInstance_TipoObra_thread)      		
    END      		
  END
Menu::MenuReportes ROUTINE                                 ! Code for menu items on ?MenuReportes
  CASE ACCEPTED()
  OF ?ReportePresupuestos
    START(POE_Reporte, 050000)
  OF ?ReporteSolicitudes
    START(SOE_Reporte, 050000)
  END

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = 1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SETCURSOR(Cursor:Wait)
  OPEN(SQLOpenWindow)
  ACCEPT
    IF EVENT() = Event:OpenWindow
  Relate:PRESUPUESTO_OBRA_ELECTRICA.Open                   ! File PRESUPUESTO_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
      POST(EVENT:CloseWindow)
    END
  END
  CLOSE(SQLOpenWindow)
  SETCURSOR()
  SELF.Open(AppFrame)                                      ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Main',AppFrame)                            ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  glo:parametros = COMMAND('1') !Comando Proyecto - Opciones - Depurar - Inicio - Argumento
  !MESSAGE(glo:parametros)
  !if glo:parametros = 'IMPRESOR' THEN
  !   POST(EVENT:Accepted,?Btn_menuImp)
  !end
  !   
  !if glo:parametros = 'NVLP' THEN
  !   BrowseCptesNVLP()
  !   HALT(0)
  !end
  
  IF glo:parametros = '' THEN
      PasswordScreen(glo:sistema,glo:permiso,glo:userdb,glo:connectstring)
      if glo:permiso = -1 then thiswindow.kill .
  !    if not (glo:esadmin or glo:esfacturador or glo:essuper or glo:esadmtar) then ThisWindow.kill .
  ELSIF glo:parametros = 'sistemas' THEN 
      glo:usuario = glo:parametros
  ELSE
      message('--acceso denegado--', 'geaSPO')
      thiswindow.kill
  END
  
  !if glo:esadmin then MESSAGE('ESADMIN').
  !if glo:esfacturador then MESSAGE('ESFACTURADOR').
      AppFrame{PROP:TabBarVisible}  = False
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
    INIMgr.Update('Main',AppFrame)                         ! Save window data to non-volatile store
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
    ELSE
      DO Menu::Menubar                                     ! Process menu items on ?Menubar menu
      DO Menu::MenuArchivo                                 ! Process menu items on ?MenuArchivo menu
      DO Menu::MenuDetalles                                ! Process menu items on ?MenuDetalles menu
      DO Menu::MenuReportes                                ! Process menu items on ?MenuReportes menu
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Btn:Solicitudes
      IF GLO:oneInstance_SolicitudesObrasElectricas_thread = 0      		
         GLO:oneInstance_SolicitudesObrasElectricas_thread = START(SolicitudesObrasElectricas, 25000)
      ELSE      		
         NOTIFY(EVENT:GainFocus, GLO:oneInstance_SolicitudesObrasElectricas_thread)      		
      END      		
    OF ?Btn:Presupuestos:2
      IF GLO:oneInstance_PresupuestosObrasElectricas_thread = 0      		
         GLO:oneInstance_PresupuestosObrasElectricas_thread = START(PresupuestosObrasElectricas, 25000)
      ELSE      		
         NOTIFY(EVENT:GainFocus, GLO:oneInstance_PresupuestosObrasElectricas_thread)      		
      END      		
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Window
!!! PRESUPUESTO_OBRA_ELECTRICA
!!! </summary>
PresupuestosObrasElectricas PROCEDURE 

CurrentTab           STRING(80)                            !
Loc:APYNOM           STRING(50)                            !
Loc:DIRECCION        STRING(50)                            !
BRW1::View:Browse    VIEW(PRESUPUESTO_OBRA_ELECTRICA)
                       PROJECT(POE:POE_SOE_ID)
                       PROJECT(POE:POE_ESTADO)
                       PROJECT(POE:POE_NRO_OBRA)
                       PROJECT(POE:POE_UPDATE_DATE)
                       PROJECT(POE:POE_USUARIO)
                       PROJECT(POE:POE_ID)
                       JOIN(SOE:PK_SOE_ID,POE:POE_SOE_ID)
                         PROJECT(SOE:SOE_ID)
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
POE:POE_SOE_ID         LIKE(POE:POE_SOE_ID)           !List box control field - type derived from field
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !List box control field - type derived from field
POE:POE_ESTADO         LIKE(POE:POE_ESTADO)           !List box control field - type derived from field
POE:POE_NRO_OBRA       LIKE(POE:POE_NRO_OBRA)         !List box control field - type derived from field
POE:POE_UPDATE_DATE    LIKE(POE:POE_UPDATE_DATE)      !List box control field - type derived from field
POE:POE_USUARIO        LIKE(POE:POE_USUARIO)          !List box control field - type derived from field
POE:POE_ID             LIKE(POE:POE_ID)               !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW8::View:Browse    VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ID)
                       PROJECT(SOE:SOE_ESTADO)
                       PROJECT(SOE:SOE_TIPO)
                       PROJECT(SOE:SOE_DNI)
                       PROJECT(SOE:SOE_TELEFONO)
                       PROJECT(SOE:SOE_EMAIL)
                       PROJECT(SOE:SOE_APELLIDO)
                       PROJECT(SOE:SOE_NOMBRE)
                       PROJECT(SOE:SOE_CALLE)
                       PROJECT(SOE:SOE_ALTURA)
                       PROJECT(SOE:SOE_PISO)
                       PROJECT(SOE:SOE_DPTO)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !List box control field - type derived from field
SOE:SOE_ESTADO         LIKE(SOE:SOE_ESTADO)           !List box control field - type derived from field
SOE:SOE_TIPO           LIKE(SOE:SOE_TIPO)             !List box control field - type derived from field
SOE:SOE_DNI            LIKE(SOE:SOE_DNI)              !List box control field - type derived from field
Loc:APYNOM             LIKE(Loc:APYNOM)               !List box control field - type derived from local data
Loc:DIRECCION          LIKE(Loc:DIRECCION)            !List box control field - type derived from local data
SOE:SOE_TELEFONO       LIKE(SOE:SOE_TELEFONO)         !List box control field - type derived from field
SOE:SOE_EMAIL          LIKE(SOE:SOE_EMAIL)            !List box control field - type derived from field
SOE:SOE_APELLIDO       LIKE(SOE:SOE_APELLIDO)         !Browse hot field - type derived from field
SOE:SOE_NOMBRE         LIKE(SOE:SOE_NOMBRE)           !Browse hot field - type derived from field
SOE:SOE_CALLE          LIKE(SOE:SOE_CALLE)            !Browse hot field - type derived from field
SOE:SOE_ALTURA         LIKE(SOE:SOE_ALTURA)           !Browse hot field - type derived from field
SOE:SOE_PISO           LIKE(SOE:SOE_PISO)             !Browse hot field - type derived from field
SOE:SOE_DPTO           LIKE(SOE:SOE_DPTO)             !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Presupuestos de Obras Eléctricas'),AT(,,450,205),FONT('Microsoft Sans Serif',10,,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,HLP('BrowsePRESUPUESTO_OBRA_ELECTRICA'),SYSTEM
                       SHEET,AT(5,5,440,180),USE(?CurrentTab:2)
                         TAB('&Presupuestos'),USE(?Tab:Presupuestos)
                           LIST,AT(8,20,433,161),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('35C|~Nro.~@N' & |
  '06B@40C|~Solicitud~@N06B@60L(1)|~Estado~C(0)@s15@45C|~Nro. Obra~@N06B@50C|~Fecha Mod' & |
  '.~@D06B@40L(1)|~Usuario~C(0)@s20@'),FROM(Queue:Browse:1),IMM,MSG('PRESUPUESTO_OBRA_ELECTRICA')
                           BUTTON('&Nuevo'),AT(5,188,47,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record')
                           BUTTON('&Modificar'),AT(59,188,47,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record')
                           BUTTON('&Borrar'),AT(112,188,47,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,HIDE,MSG('Delete the Record'), |
  TIP('Delete the Record')
                         END
                         TAB('&Solicitudes Pendientes/a Refinanciar'),USE(?Tab:Solicitudes)
                           LIST,AT(8,20,433,161),USE(?List),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('35C|~Nro.~@N06B@' & |
  '60L(1)|~Estado~C(0)@s15@30C|~Tipo~@s5@60R(1)|~DNI/CUIT~C(0)@S15@130L(1)|M~Apellido y' & |
  ' Nombre~C(0)@s50@130L(1)|M~Dirección~C(0)@s50@70R(1)|~Teléfono~C(0)@s20@40L(1)|~E-Ma' & |
  'il~C(0)@s50@'),FROM(Queue:Browse),IMM
                           BUTTON('Presupuestar'),AT(5,188,,14),USE(?Presupuestar),FONT(,12,,FONT:bold),COLOR(COLOR:Orange)
                         END
                       END
                       BUTTON('&Cerrar'),AT(406,188,37,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW8                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW8::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_PresupuestosObrasElectricas_thread = 0

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
  GlobalErrors.SetProcedureName('PresupuestosObrasElectricas')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('POE:POE_ESTADO',POE:POE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ESTADO',SOE:SOE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('POE:POE_SOE_ID',POE:POE_SOE_ID)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ID',SOE:SOE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('POE:POE_NRO_OBRA',POE:POE_NRO_OBRA)                ! Added by: BrowseBox(ABC)
  BIND('POE:POE_USUARIO',POE:POE_USUARIO)                  ! Added by: BrowseBox(ABC)
  BIND('POE:POE_ID',POE:POE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TIPO',SOE:SOE_TIPO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DNI',SOE:SOE_DNI)                          ! Added by: BrowseBox(ABC)
  BIND('Loc:APYNOM',Loc:APYNOM)                            ! Added by: BrowseBox(ABC)
  BIND('Loc:DIRECCION',Loc:DIRECCION)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TELEFONO',SOE:SOE_TELEFONO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_EMAIL',SOE:SOE_EMAIL)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_APELLIDO',SOE:SOE_APELLIDO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_NOMBRE',SOE:SOE_NOMBRE)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_CALLE',SOE:SOE_CALLE)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ALTURA',SOE:SOE_ALTURA)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_PISO',SOE:SOE_PISO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DPTO',SOE:SOE_DPTO)                        ! Added by: BrowseBox(ABC)
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
  BRW8.Init(?List,Queue:Browse.ViewPosition,BRW8::View:Browse,Queue:Browse,Relate:SOLICITUD_OBRA_ELECTRICA,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.FileLoaded = 1                                      ! This is a 'file loaded' browse
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,POE:PK_POE_ID)                        ! Add the sort order for POE:PK_POE_ID for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,POE:POE_ID,,BRW1)              ! Initialize the browse locator using  using key: POE:PK_POE_ID , POE:POE_ID
  BRW1.SetFilter('(POE:POE_ESTADO = ''Pendiente'' OR POE:POE_ESTADO = ''Aceptado'' OR POE:POE_ESTADO = ''Refinanciar'')') ! Apply filter expression to browse
  BRW1.AddField(POE:POE_SOE_ID,BRW1.Q.POE:POE_SOE_ID)      ! Field POE:POE_SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_ID,BRW1.Q.SOE:SOE_ID)              ! Field SOE:SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_ESTADO,BRW1.Q.POE:POE_ESTADO)      ! Field POE:POE_ESTADO is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_NRO_OBRA,BRW1.Q.POE:POE_NRO_OBRA)  ! Field POE:POE_NRO_OBRA is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_UPDATE_DATE,BRW1.Q.POE:POE_UPDATE_DATE) ! Field POE:POE_UPDATE_DATE is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_USUARIO,BRW1.Q.POE:POE_USUARIO)    ! Field POE:POE_USUARIO is a hot field or requires assignment from browse
  BRW1.AddField(POE:POE_ID,BRW1.Q.POE:POE_ID)              ! Field POE:POE_ID is a hot field or requires assignment from browse
  BRW8.Q &= Queue:Browse
  BRW8.FileLoaded = 1                                      ! This is a 'file loaded' browse
  BRW8.RetainRow = 0
  BRW8.AddSortOrder(,SOE:PK_SOE_ID)                        ! Add the sort order for SOE:PK_SOE_ID for sort order 1
  BRW8.AddLocator(BRW8::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW8::Sort0:Locator.Init(,SOE:SOE_ID,,BRW8)              ! Initialize the browse locator using  using key: SOE:PK_SOE_ID , SOE:SOE_ID
  BRW8.SetFilter('(SOE:SOE_ESTADO = ''Pendiente'' OR SOE:SOE_ESTADO = ''Refinanciar'')') ! Apply filter expression to browse
  BRW8.AddField(SOE:SOE_ID,BRW8.Q.SOE:SOE_ID)              ! Field SOE:SOE_ID is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_ESTADO,BRW8.Q.SOE:SOE_ESTADO)      ! Field SOE:SOE_ESTADO is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_TIPO,BRW8.Q.SOE:SOE_TIPO)          ! Field SOE:SOE_TIPO is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_DNI,BRW8.Q.SOE:SOE_DNI)            ! Field SOE:SOE_DNI is a hot field or requires assignment from browse
  BRW8.AddField(Loc:APYNOM,BRW8.Q.Loc:APYNOM)              ! Field Loc:APYNOM is a hot field or requires assignment from browse
  BRW8.AddField(Loc:DIRECCION,BRW8.Q.Loc:DIRECCION)        ! Field Loc:DIRECCION is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_TELEFONO,BRW8.Q.SOE:SOE_TELEFONO)  ! Field SOE:SOE_TELEFONO is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_EMAIL,BRW8.Q.SOE:SOE_EMAIL)        ! Field SOE:SOE_EMAIL is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_APELLIDO,BRW8.Q.SOE:SOE_APELLIDO)  ! Field SOE:SOE_APELLIDO is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_NOMBRE,BRW8.Q.SOE:SOE_NOMBRE)      ! Field SOE:SOE_NOMBRE is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_CALLE,BRW8.Q.SOE:SOE_CALLE)        ! Field SOE:SOE_CALLE is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_ALTURA,BRW8.Q.SOE:SOE_ALTURA)      ! Field SOE:SOE_ALTURA is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_PISO,BRW8.Q.SOE:SOE_PISO)          ! Field SOE:SOE_PISO is a hot field or requires assignment from browse
  BRW8.AddField(SOE:SOE_DPTO,BRW8.Q.SOE:SOE_DPTO)          ! Field SOE:SOE_DPTO is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('PresupuestosObrasElectricas',QuickWindow)  ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: Presupuesto
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW8.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
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
    INIMgr.Update('PresupuestosObrasElectricas',QuickWindow) ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Presupuesto
    ReturnValue = GlobalResponse
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Presupuestar
      ThisWindow.Update()
      !Abrir FORM de PRESUPUESTO
      CLEAR(POE:Record) !Limpio el Búfer
      POE:POE_SOE_ID = BRW8.Q.SOE:SOE_ID
      GET(PRESUPUESTO_OBRA_ELECTRICA,POE:FK_POE_SOE_ID) !Obtengo datos para ver si existe PRESUPUESTO
      IF NOT ERRORCODE() THEN !Existe Presupuesto
          GlobalRequest = ChangeRecord
          Presupuesto()
      ELSE
          GlobalRequest = InsertRecord
          Presupuesto()
      END
      ThisWindow.Reset(TRUE)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


BRW8.SetQueueRecord PROCEDURE

  CODE
  Loc:APYNOM = SOE:SOE_APELLIDO & ', ' & SOE:SOE_NOMBRE
  Loc:DIRECCION = 'Calle ' & CLIP(SOE:SOE_CALLE) & ' Nº' & CLIP(SOE:SOE_ALTURA)
  IF SOE:SOE_PISO <> '' THEN
      Loc:DIRECCION = CLIP(Loc:DIRECCION) & ', P. ' & CLIP(SOE:SOE_PISO)
  END
  IF SOE:SOE_DPTO <> '' THEN
      Loc:DIRECCION = CLIP(Loc:DIRECCION) & ', D. ' & CLIP(SOE:SOE_DPTO)
  END
  PARENT.SetQueueRecord
  


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Report
!!! Print the PRESUPUESTO_OBRA_ELECTRICA File
!!! </summary>
POE_Reporte PROCEDURE 

Progress:Thermometer BYTE                                  !
Process:View         VIEW(PRESUPUESTO_OBRA_ELECTRICA)
                       PROJECT(POE:POE_ESTADO)
                       PROJECT(POE:POE_FECHA_DATE)
                       PROJECT(POE:POE_FECHA_TIME)
                       PROJECT(POE:POE_ID)
                       PROJECT(POE:POE_NRO_OBRA)
                       PROJECT(POE:POE_SOE_ID)
                       PROJECT(POE:POE_UPDATE_DATE)
                       PROJECT(POE:POE_UPDATE_TIME)
                       PROJECT(POE:POE_USUARIO)
                     END
ProgressWindow       WINDOW('Report PRESUPUESTO_OBRA_ELECTRICA'),AT(,,142,59),FONT('Microsoft Sans Serif',8,,FONT:regular, |
  CHARSET:DEFAULT),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(46,42,49,15),USE(?Progress:Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel Report'), |
  TIP('Cancel Report')
                     END

Report               REPORT('PRESUPUESTO_OBRA_ELECTRICA Report'),AT(250,1190,7750,9998),PRE(RPT),PAPER(PAPER:A4), |
  LANDSCAPE,FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT),THOUS
                       HEADER,AT(250,250,7750,940),USE(?Header),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT)
                         STRING('Report PRESUPUESTO_OBRA_ELECTRICA file'),AT(0,20,7750,220),USE(?ReportTitle),FONT('Microsoft ' & |
  'Sans Serif',8,,FONT:regular,CHARSET:DEFAULT),CENTER
                         BOX,AT(0,350,7750,610),USE(?HeaderBox),COLOR(COLOR:Black)
                         LINE,AT(1937,350,0,610),USE(?HeaderLine:1),COLOR(COLOR:Black)
                         LINE,AT(3874,350,0,610),USE(?HeaderLine:2),COLOR(COLOR:Black)
                         LINE,AT(5811,350,0,610),USE(?HeaderLine:3),COLOR(COLOR:Black)
                         STRING('POE ID'),AT(50,390,1837,170),USE(?HeaderTitle:1),TRN
                         STRING('POE SOE ID'),AT(1987,390,1837,170),USE(?HeaderTitle:2),TRN
                         STRING('POE ESTADO'),AT(3924,390,1837,170),USE(?HeaderTitle:3),TRN
                         STRING('POE NRO OBRA'),AT(5861,390,1837,170),USE(?HeaderTitle:4),TRN
                         STRING('POE USUARIO'),AT(50,570,1837,170),USE(?HeaderTitle:5),TRN
                         STRING('POE FECHA DATE'),AT(1987,570,1837,170),USE(?HeaderTitle:6),TRN
                         STRING('POE FECHA TIME'),AT(3924,570,1837,170),USE(?HeaderTitle:7),TRN
                         STRING('POE UPDATE DATE'),AT(5861,570,1837,170),USE(?HeaderTitle:8),TRN
                         STRING('POE UPDATE TIME'),AT(50,750,1837,170),USE(?HeaderTitle:9),TRN
                       END
Detail                 DETAIL,AT(0,0,7750,750),USE(?Detail)
                         LINE,AT(0,0,0,750),USE(?DetailLine:0),COLOR(COLOR:Black)
                         LINE,AT(1937,0,0,750),USE(?DetailLine:1),COLOR(COLOR:Black)
                         LINE,AT(3874,0,0,750),USE(?DetailLine:2),COLOR(COLOR:Black)
                         LINE,AT(5811,0,0,750),USE(?DetailLine:3),COLOR(COLOR:Black)
                         LINE,AT(7750,0,0,750),USE(?DetailLine:4),COLOR(COLOR:Black)
                         STRING(@n-14),AT(50,50,1837,170),USE(POE:POE_ID)
                         STRING(@n-14),AT(1987,50,1837,170),USE(POE:POE_SOE_ID)
                         STRING(@s15),AT(3924,50,1837,170),USE(POE:POE_ESTADO)
                         STRING(@n-14),AT(5861,50,1837,170),USE(POE:POE_NRO_OBRA)
                         STRING(@s20),AT(50,230,1837,170),USE(POE:POE_USUARIO)
                         STRING(@d17),AT(1987,230,1837,170),USE(POE:POE_FECHA_DATE)
                         STRING(@t7),AT(3924,230,1837,170),USE(POE:POE_FECHA_TIME)
                         STRING(@d17),AT(5861,230,1837,170),USE(POE:POE_UPDATE_DATE)
                         STRING(@t7),AT(50,410,1837,170),USE(POE:POE_UPDATE_TIME)
                         LINE,AT(0,750,7750,0),USE(?DetailEndLine),COLOR(COLOR:Black)
                       END
                       FOOTER,AT(250,11188,7750,250),USE(?Footer)
                         STRING('Date:'),AT(115,52,344,135),USE(?ReportDatePrompt:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('<<-- Date Stamp -->'),AT(490,52,927,135),USE(?ReportDateStamp:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('Time:'),AT(1625,52,271,135),USE(?ReportTimePrompt:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('<<-- Time Stamp -->'),AT(1927,52,927,135),USE(?ReportTimeStamp:2),FONT('Arial',8,, |
  FONT:regular),TRN
                         STRING(@pPage <<#p),AT(6950,52,700,135),USE(?PageCount:2),FONT('Arial',8,,FONT:regular),PAGENO
                       END
                       FORM,AT(250,250,7750,11188),USE(?Form),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT)
                         IMAGE,AT(0,0,7750,11188),USE(?FormImage),TILED
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
OpenReport             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

Previewer            PrintPreviewClass                     ! Print Previewer

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
  GlobalErrors.SetProcedureName('POE_Reporte')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:PRESUPUESTO_OBRA_ELECTRICA.Open                   ! File PRESUPUESTO_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('POE_Reporte',ProgressWindow)               ! Restore window settings from non-volatile store
  ThisReport.Init(Process:View, Relate:PRESUPUESTO_OBRA_ELECTRICA, ?Progress:PctText, Progress:Thermometer)
  ThisReport.AddSortOrder()
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:PRESUPUESTO_OBRA_ELECTRICA.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  Previewer.Maximize = True
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:PRESUPUESTO_OBRA_ELECTRICA.Close
  END
  IF SELF.Opened
    INIMgr.Update('POE_Reporte',ProgressWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.OpenReport PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.OpenReport()
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportDateStamp:2{PROP:Text} = FORMAT(TODAY(),@D17)
  END
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportTimeStamp:2{PROP:Text} = FORMAT(CLOCK(),@T7)
  END
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:Detail)
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Window
!!! SOLICITUD_OBRA_ELECTRICA
!!! </summary>
SolicitudesObrasElectricas PROCEDURE 

CurrentTab           STRING(80)                            !
Loc:APYNOM           STRING(50)                            !
Loc:DIRECCION        STRING(50)                            !
BRW1::View:Browse    VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ID)
                       PROJECT(SOE:SOE_ESTADO)
                       PROJECT(SOE:SOE_TIPO)
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
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !List box control field - type derived from field
SOE:SOE_ESTADO         LIKE(SOE:SOE_ESTADO)           !List box control field - type derived from field
SOE:SOE_TIPO           LIKE(SOE:SOE_TIPO)             !List box control field - type derived from field
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
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Solicitudes de Obra Eléctrica'),AT(,,400,160),FONT('Microsoft Sans Serif',10,,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,SYSTEM
                       LIST,AT(5,5,390,131),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('35C|~Nro~@N06' & |
  'B@65L(1)|~Estado~C(0)@s15@25C|~Tipo~@s5@60R(1)|~DNI/CUIT~C(0)@S15@130L(1)|M~Apellido' & |
  ' y Nombre~C(0)@s50@130L(1)|M~Dirección~C(0)@s50@75R(1)|~Teléfono~C(0)@s20@115L(1)|M~' & |
  'E-Mail~C(0)@s50@50C|~Última Mod.~@D06B@40L(1)|~Usuario~C(0)@s20@'),FROM(Queue:Browse:1), |
  IMM,MSG('SOLICITUD_OBRA_ELECTRICA')
                       BUTTON('&Nueva'),AT(4,141,47,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Modificar'),AT(54,141,47,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record')
                       BUTTON('&Eliminar'),AT(104,141,47,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,HIDE,MSG('Delete the Record'), |
  TIP('Delete the Record')
                       BUTTON('&Cerrar'),AT(358,141,37,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                       BUTTON('Documento'),AT(186,141,53,14),USE(?Scan),LEFT,ICON('scanner.ico'),DISABLE,TIP('Escanear D' & |
  'ocumento de Solicitud')
                       BUTTON('Abir PDF'),AT(242,141,49,14),USE(?Abrir),LEFT,ICON(ICON:Open),DISABLE
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
TakeNewSelection       PROCEDURE(),DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_SolicitudesObrasElectricas_thread = 0

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
ActSolicitud          ROUTINE
    SOE:SOE_USUARIO = glo:usuario
    SOE:SOE_UPDATE_DATE = TODAY()
    SOE:SOE_UPDATE_TIME = CLOCK()

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SolicitudesObrasElectricas')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('SOE:SOE_ESTADO',SOE:SOE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ID',SOE:SOE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TIPO',SOE:SOE_TIPO)                        ! Added by: BrowseBox(ABC)
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
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,SOE:SOE_ID,,BRW1)              ! Initialize the browse locator using  using key: SOE:PK_SOE_ID , SOE:SOE_ID
  BRW1.SetFilter('(SOE:SOE_ESTADO = ''Iniciada''  OR SOE:SOE_ESTADO = ''Pendiente'' OR SOE:SOE_ESTADO = ''Presupuestada'' OR SOE:SOE_ESTADO = ''Observada'')') ! Apply filter expression to browse
  BRW1.AddField(SOE:SOE_ID,BRW1.Q.SOE:SOE_ID)              ! Field SOE:SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_ESTADO,BRW1.Q.SOE:SOE_ESTADO)      ! Field SOE:SOE_ESTADO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_TIPO,BRW1.Q.SOE:SOE_TIPO)          ! Field SOE:SOE_TIPO is a hot field or requires assignment from browse
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
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('SolicitudesObrasElectricas',QuickWindow)   ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: Solicitud
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
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
    INIMgr.Update('SolicitudesObrasElectricas',QuickWindow) ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Solicitud
    ReturnValue = GlobalResponse
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Scan
      ThisWindow.Update()
      CLEAR(SOE:Record) !Limpio el Búfer
      SOE:SOE_ID = BRW1.Q.SOE:SOE_ID
      GET(SOLICITUD_OBRA_ELECTRICA, SOE:PK_SOE_ID)
      IF NOT ERRORCODE() THEN
          Glo:Save = 0
          Glo:SOE_ID = SOE:SOE_ID
          wndScanning()
          SOE:SOE_PATH = Glo:Path
          IF Glo:Save = 1 AND SOE:SOE_ESTADO <> 'Observada' THEN
              SOE:SOE_ESTADO = 'Pendiente'
              DO ActSolicitud
              Access:SOLICITUD_OBRA_ELECTRICA.Update()
          END
          SOE:SOE_PATH = ''
      ELSE
          MESSAGE(ERRORCODE(), ERROR(), ICON:Hand, BUTTON:OK, 1)
          SELECT(?Scan)
          CYCLE
      END
      ThisWindow.Reset(1)
    OF ?Abrir
      ThisWindow.Update()
      CLEAR(SOE:Record) !Limpio el Búfer
      SOE:SOE_ID = BRW1.Q.SOE:SOE_ID
      GET(SOLICITUD_OBRA_ELECTRICA, SOE:PK_SOE_ID)
      IF NOT ERRORCODE() THEN
          IF SOE:SOE_PATH <> '' THEN
              RUN(SOE:SOE_PATH)
          ELSE
              MESSAGE('Documento PDF no encontrado o eliminado', 'PDF', ICON:Hand, BUTTON:OK, 1)
              SELECT(?Abrir)
              CYCLE
          END
      ELSE
          MESSAGE(ERRORCODE(), ERROR(), ICON:Hand, BUTTON:OK, 1)
          SELECT(?Abrir)
          CYCLE
      END
      ThisWindow.Reset(1)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


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
  PARENT.SetQueueRecord
  


BRW1.TakeNewSelection PROCEDURE

  CODE
  PARENT.TakeNewSelection
  ! CONDICIÓN QUE EVALÚA LA LÓGICA DE LOS BOTONES
  ! SE MUESTRAN LOS BOTONES SEGÚN EL ESTADO DE LA SOLICITUD
  IF RECORDS(BRW1.Q) > 0 THEN
      CASE SOE:SOE_ESTADO
      OF 'Iniciada'
          ENABLE(?Scan)
          DISABLE(?Abrir)
      OF 'Observada'
          ENABLE(?Scan)
          ENABLE(?Abrir)
      OF 'Pendiente' OROF 'Presupuestada' OROF 'Aceptada' OROF 'Cerrada'
          DISABLE(?Scan)
          ENABLE(?Abrir)
      END        
  !ELSE
  !    DISABLE(?Abrir)
  !    DISABLE(?Scan)
  END


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Report
!!! Print the SOLICITUD_OBRA_ELECTRICA File
!!! </summary>
SOE_Reporte PROCEDURE 

Progress:Thermometer BYTE                                  !
Process:View         VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ALTURA)
                       PROJECT(SOE:SOE_APELLIDO)
                       PROJECT(SOE:SOE_CALLE)
                       PROJECT(SOE:SOE_DNI)
                       PROJECT(SOE:SOE_DPTO)
                       PROJECT(SOE:SOE_EMAIL)
                       PROJECT(SOE:SOE_ESTADO)
                       PROJECT(SOE:SOE_ID)
                       PROJECT(SOE:SOE_MOTIVO)
                       PROJECT(SOE:SOE_NOMBRE)
                       PROJECT(SOE:SOE_NRECIBO)
                       PROJECT(SOE:SOE_PISO)
                       PROJECT(SOE:SOE_TELEFONO)
                       PROJECT(SOE:SOE_TIPO)
                       PROJECT(SOE:SOE_UPDATE_DATE)
                       PROJECT(SOE:SOE_USUARIO)
                     END
ProgressWindow       WINDOW('Report SOLICITUD_OBRA_ELECTRICA'),AT(,,142,59),FONT('Microsoft Sans Serif',8,,FONT:regular, |
  CHARSET:DEFAULT),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(46,42,49,15),USE(?Progress:Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel Report'), |
  TIP('Cancel Report')
                     END

Report               REPORT('SOLICITUD_OBRA_ELECTRICA Report'),AT(250,1530,7750,9658),PRE(RPT),PAPER(PAPER:A4), |
  LANDSCAPE,FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT),THOUS
                       HEADER,AT(250,250,7750,1115),USE(?Header),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT)
                         STRING('Reporte SOLICITUD de OBRA ELECTRICA'),AT(0,20,7750,220),USE(?ReportTitle),FONT('Microsoft ' & |
  'Sans Serif',8,,FONT:regular,CHARSET:DEFAULT),CENTER
                         BOX,AT(0,355,7750,760),USE(?HeaderBox),COLOR(COLOR:Black),LINEWIDTH(1)
                         LINE,AT(1937,354,0,760),USE(?HeaderLine:1),COLOR(COLOR:Black)
                         LINE,AT(3875,354,0,750),USE(?HeaderLine:2),COLOR(COLOR:Black)
                         LINE,AT(5812,354,0,760),USE(?HeaderLine:3),COLOR(COLOR:Black)
                         STRING('SOLICITUD'),AT(50,390,1837,170),USE(?HeaderTitle:1),TRN
                         STRING('DNI/CUIT'),AT(2000,562,1837,170),USE(?HeaderTitle:2),TRN
                         STRING('APELLIDO'),AT(3937,562,1837,170),USE(?HeaderTitle:3),TRN
                         STRING('NOMBRE'),AT(5865,562,1837,170),USE(?HeaderTitle:4),TRN
                         STRING('CALLE'),AT(52,740,1837,170),USE(?HeaderTitle:5),TRN
                         STRING('ALTURA'),AT(2000,740,1837,170),USE(?HeaderTitle:6),TRN
                         STRING('PISO'),AT(3937,740,1837,170),USE(?HeaderTitle:7),TRN
                         STRING('DPTO'),AT(5865,740,1837,170),USE(?HeaderTitle:8),TRN
                         STRING('TELEFONO'),AT(52,917,1837,170),USE(?HeaderTitle:9),TRN
                         STRING('EMAIL'),AT(2000,917,1837,170),USE(?HeaderTitle:10),TRN
                         STRING('TIPO'),AT(52,562,1837,170),USE(?HeaderTitle:11),TRN
                         STRING('ESTADO'),AT(2000,385,1837,170),USE(?HeaderTitle:12),TRN
                         STRING('USUARIO'),AT(3937,385,1837,170),USE(?HeaderTitle:13),TRN
                         STRING('UPDATE'),AT(5865,385,1837,170),USE(?HeaderTitle:16),TRN
                         STRING('RECIBO'),AT(3937,917,1837,170),USE(?HeaderTitle:18),TRN
                         STRING('MOTIVO'),AT(5865,917,1837,170),USE(?HeaderTitle:19),TRN
                       END
Detail                 DETAIL,AT(0,-165,7750,950),USE(?Detail)
                         LINE,AT(0,0,0,760),USE(?DetailLine:0),COLOR(COLOR:Black)
                         LINE,AT(1937,0,0,760),USE(?DetailLine:1),COLOR(COLOR:Black)
                         LINE,AT(3875,0,0,760),USE(?DetailLine:2),COLOR(COLOR:Black)
                         LINE,AT(5812,0,0,760),USE(?DetailLine:3),COLOR(COLOR:Black)
                         LINE,AT(7750,0,0,760),USE(?DetailLine:4),COLOR(COLOR:Black)
                         STRING(@N06B),AT(52,21,1837,170),USE(SOE:SOE_ID)
                         STRING(@N11B),AT(2000,198,1837,170),USE(SOE:SOE_DNI)
                         STRING(@s30),AT(3937,198,1837,170),USE(SOE:SOE_APELLIDO)
                         STRING(@s30),AT(5865,198,1837,170),USE(SOE:SOE_NOMBRE)
                         STRING(@s20),AT(52,385,1837,170),USE(SOE:SOE_CALLE)
                         STRING(@s6),AT(2000,385,1837,170),USE(SOE:SOE_ALTURA)
                         STRING(@s3),AT(3937,385,1837,170),USE(SOE:SOE_PISO)
                         STRING(@s3),AT(5865,385,1837,170),USE(SOE:SOE_DPTO)
                         STRING(@s20),AT(52,573,1837,170),USE(SOE:SOE_TELEFONO)
                         STRING(@s50),AT(2000,573,1837,170),USE(SOE:SOE_EMAIL)
                         STRING(@s5),AT(52,198,1837,170),USE(SOE:SOE_TIPO)
                         STRING(@s15),AT(2000,21,1837,170),USE(SOE:SOE_ESTADO)
                         STRING(@s20),AT(3937,21,1837,170),USE(SOE:SOE_USUARIO)
                         STRING(@D06B),AT(5865,21,1837,170),USE(SOE:SOE_UPDATE_DATE)
                         STRING(@s15),AT(3937,573,1837,170),USE(SOE:SOE_NRECIBO)
                         STRING(@s130),AT(5865,573,1837,170),USE(SOE:SOE_MOTIVO)
                         LINE,AT(0,760,7750,0),USE(?DetailEndLine),COLOR(COLOR:Black)
                       END
                       FOOTER,AT(250,11188,7750,250),USE(?Footer)
                         STRING('Date:'),AT(115,52,344,135),USE(?ReportDatePrompt:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('<<-- Date Stamp -->'),AT(490,52,927,135),USE(?ReportDateStamp:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('Time:'),AT(1625,52,271,135),USE(?ReportTimePrompt:2),FONT('Arial',8,,FONT:regular), |
  TRN
                         STRING('<<-- Time Stamp -->'),AT(1927,52,927,135),USE(?ReportTimeStamp:2),FONT('Arial',8,, |
  FONT:regular),TRN
                         STRING(@pPage <<#p),AT(6950,52,700,135),USE(?PageCount:2),FONT('Arial',8,,FONT:regular),PAGENO
                       END
                       FORM,AT(250,250,7750,11188),USE(?Form),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT)
                         IMAGE,AT(-1198,-156,7750,11188),USE(?FormImage),TILED
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
OpenReport             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

Previewer            PrintPreviewClass                     ! Print Previewer

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
  GlobalErrors.SetProcedureName('SOE_Reporte')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('SOE_Reporte',ProgressWindow)               ! Restore window settings from non-volatile store
  ThisReport.Init(Process:View, Relate:SOLICITUD_OBRA_ELECTRICA, ?Progress:PctText, Progress:Thermometer)
  ThisReport.AddSortOrder()
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:SOLICITUD_OBRA_ELECTRICA.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  Previewer.Maximize = True
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
    INIMgr.Update('SOE_Reporte',ProgressWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.OpenReport PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.OpenReport()
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportDateStamp:2{PROP:Text} = FORMAT(TODAY(),@D17)
  END
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportTimeStamp:2{PROP:Text} = FORMAT(CLOCK(),@T7)
  END
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:Detail)
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Window
!!! TIPO_DE_OBRA
!!! </summary>
TipoObra PROCEDURE 

CurrentTab           STRING(80)                            !
BRW1::View:Browse    VIEW(TIPO_DE_OBRA)
                       PROJECT(TDO:TDO_TIPO)
                       PROJECT(TDO:TDO_DESCRIPCION)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
TDO:TDO_TIPO           LIKE(TDO:TDO_TIPO)             !List box control field - type derived from field
TDO:TDO_DESCRIPCION    LIKE(TDO:TDO_DESCRIPCION)      !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Tipos de Obras'),AT(,,230,150),FONT('Microsoft Sans Serif',10,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,GRAY,IMM,MDI,SYSTEM
                       LIST,AT(5,5,220,120),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('30C|~Tipo~@s5' & |
  '@80L(1)|M~Descripción~C(0)@s50@'),FROM(Queue:Browse:1),IMM,MSG('TIPO_DE_OBRA')
                       BUTTON('&Nuevo'),AT(4,131,47,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Modificar'),AT(54,131,47,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record')
                       BUTTON('&Eliminar'),AT(104,131,47,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,MSG('Delete the Record'), |
  TIP('Delete the Record')
                       BUTTON('&Cerrar'),AT(188,131,37,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_TipoObra_thread = 0

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
  GlobalErrors.SetProcedureName('TipoObra')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('TDO:TDO_TIPO',TDO:TDO_TIPO)                        ! Added by: BrowseBox(ABC)
  BIND('TDO:TDO_DESCRIPCION',TDO:TDO_DESCRIPCION)          ! Added by: BrowseBox(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:TIPO_DE_OBRA.Open                                 ! File TIPO_DE_OBRA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:TIPO_DE_OBRA,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,TDO:PK_TDO_TIPO)                      ! Add the sort order for TDO:PK_TDO_TIPO for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,TDO:TDO_TIPO,,BRW1)            ! Initialize the browse locator using  using key: TDO:PK_TDO_TIPO , TDO:TDO_TIPO
  BRW1.AddField(TDO:TDO_TIPO,BRW1.Q.TDO:TDO_TIPO)          ! Field TDO:TDO_TIPO is a hot field or requires assignment from browse
  BRW1.AddField(TDO:TDO_DESCRIPCION,BRW1.Q.TDO:TDO_DESCRIPCION) ! Field TDO:TDO_DESCRIPCION is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('TipoObra',QuickWindow)                     ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: TDO_Formulario
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
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
    INIMgr.Update('TipoObra',QuickWindow)                  ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    TDO_Formulario
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! Select a SOLICITUD_OBRA_ELECTRICA Record
!!! </summary>
SOE_Browse PROCEDURE 

CurrentTab           STRING(80)                            !
BRW1::View:Browse    VIEW(SOLICITUD_OBRA_ELECTRICA)
                       PROJECT(SOE:SOE_ID)
                       PROJECT(SOE:SOE_TIPO)
                       PROJECT(SOE:SOE_DNI)
                       PROJECT(SOE:SOE_APELLIDO)
                       PROJECT(SOE:SOE_NOMBRE)
                       PROJECT(SOE:SOE_CALLE)
                       PROJECT(SOE:SOE_ALTURA)
                       PROJECT(SOE:SOE_PISO)
                       PROJECT(SOE:SOE_DPTO)
                       PROJECT(SOE:SOE_TELEFONO)
                       PROJECT(SOE:SOE_EMAIL)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
SOE:SOE_ID             LIKE(SOE:SOE_ID)               !List box control field - type derived from field
SOE:SOE_TIPO           LIKE(SOE:SOE_TIPO)             !List box control field - type derived from field
SOE:SOE_DNI            LIKE(SOE:SOE_DNI)              !List box control field - type derived from field
SOE:SOE_APELLIDO       LIKE(SOE:SOE_APELLIDO)         !List box control field - type derived from field
SOE:SOE_NOMBRE         LIKE(SOE:SOE_NOMBRE)           !List box control field - type derived from field
SOE:SOE_CALLE          LIKE(SOE:SOE_CALLE)            !List box control field - type derived from field
SOE:SOE_ALTURA         LIKE(SOE:SOE_ALTURA)           !List box control field - type derived from field
SOE:SOE_PISO           LIKE(SOE:SOE_PISO)             !List box control field - type derived from field
SOE:SOE_DPTO           LIKE(SOE:SOE_DPTO)             !List box control field - type derived from field
SOE:SOE_TELEFONO       LIKE(SOE:SOE_TELEFONO)         !List box control field - type derived from field
SOE:SOE_EMAIL          LIKE(SOE:SOE_EMAIL)            !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Solicitudes Pendientes/Refinanciar'),AT(,,400,200),FONT('Microsoft Sans Serif',10, |
  ,FONT:regular,CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,HLP('SelectSOLICITUD_OBRA_ELECTRICA'), |
  SYSTEM
                       LIST,AT(5,5,390,171),USE(?Browse:1),FONT(,12,,FONT:bold),HVSCROLL,FORMAT('40C|~Nro.~@N0' & |
  '6B@30C|~Tipo~@s5@50C|~DNI~@P##.###.###PB@60L(1)|M~Apellido~C(0)@s30@60L(1)|M~Nombre~' & |
  'C(0)@s30@60C|M~Calle~@s20@35C|~Altura~@s6@30C|~Piso~@s3@30C|M~Dpto.~@s3@70R(1)|~Telé' & |
  'fono~C(0)@s20@60L(1)|~E-Mail~C(0)@s50@'),FROM(Queue:Browse:1),IMM,MSG('SOLICITUD_OBR' & |
  'A_ELECTRICA')
                       BUTTON('&Select'),AT(296,181,49,14),USE(?Select:2),LEFT,ICON('WASELECT.ICO'),FLAT,HIDE,MSG('Select the Record'), |
  TIP('Select the Record')
                       BUTTON('&Cerrar'),AT(358,181,37,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_SOE_Browse_thread = 0

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
  GlobalErrors.SetProcedureName('SOE_Browse')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('SOE:SOE_ESTADO',SOE:SOE_ESTADO)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ID',SOE:SOE_ID)                            ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TIPO',SOE:SOE_TIPO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DNI',SOE:SOE_DNI)                          ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_APELLIDO',SOE:SOE_APELLIDO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_NOMBRE',SOE:SOE_NOMBRE)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_CALLE',SOE:SOE_CALLE)                      ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_ALTURA',SOE:SOE_ALTURA)                    ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_PISO',SOE:SOE_PISO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_DPTO',SOE:SOE_DPTO)                        ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_TELEFONO',SOE:SOE_TELEFONO)                ! Added by: BrowseBox(ABC)
  BIND('SOE:SOE_EMAIL',SOE:SOE_EMAIL)                      ! Added by: BrowseBox(ABC)
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
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:SOLICITUD_OBRA_ELECTRICA,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.FileLoaded = 1                                      ! This is a 'file loaded' browse
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,SOE:PK_SOE_ID)                        ! Add the sort order for SOE:PK_SOE_ID for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,SOE:SOE_ID,,BRW1)              ! Initialize the browse locator using  using key: SOE:PK_SOE_ID , SOE:SOE_ID
  BRW1.SetFilter('(SOE:SOE_ESTADO = ''Pendiente'' OR SOE:SOE_ESTADO = ''Refinanciar'')') ! Apply filter expression to browse
  BRW1.AddField(SOE:SOE_ID,BRW1.Q.SOE:SOE_ID)              ! Field SOE:SOE_ID is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_TIPO,BRW1.Q.SOE:SOE_TIPO)          ! Field SOE:SOE_TIPO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_DNI,BRW1.Q.SOE:SOE_DNI)            ! Field SOE:SOE_DNI is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_APELLIDO,BRW1.Q.SOE:SOE_APELLIDO)  ! Field SOE:SOE_APELLIDO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_NOMBRE,BRW1.Q.SOE:SOE_NOMBRE)      ! Field SOE:SOE_NOMBRE is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_CALLE,BRW1.Q.SOE:SOE_CALLE)        ! Field SOE:SOE_CALLE is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_ALTURA,BRW1.Q.SOE:SOE_ALTURA)      ! Field SOE:SOE_ALTURA is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_PISO,BRW1.Q.SOE:SOE_PISO)          ! Field SOE:SOE_PISO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_DPTO,BRW1.Q.SOE:SOE_DPTO)          ! Field SOE:SOE_DPTO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_TELEFONO,BRW1.Q.SOE:SOE_TELEFONO)  ! Field SOE:SOE_TELEFONO is a hot field or requires assignment from browse
  BRW1.AddField(SOE:SOE_EMAIL,BRW1.Q.SOE:SOE_EMAIL)        ! Field SOE:SOE_EMAIL is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('SOE_Browse',QuickWindow)                   ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
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
    INIMgr.Update('SOE_Browse',QuickWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select:2
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! Form PRESUPUESTO_OBRA_ELECTRICA
!!! </summary>
Presupuesto PROCEDURE 

CurrentTab           STRING(80)                            !
ActionMessage        CSTRING(40)                           !
Loc:Refinancia       BYTE                                  !
Loc:Obra             BYTE                                  !
Loc:accion           BYTE                                  !
Loc:comando          STRING(1024)                          !
Loc:Ejecutable       STRING(50)                            !
Loc:Desde            STRING(50)                            !
Loc:Para             STRING(50)                            !
Loc:Server           STRING(50)                            !
Loc:User             STRING(50)                            !
Loc:Pass             STRING(50)                            !
Loc:Asunto           STRING(50)                            !
Loc:Mensaje          STRING(255)                           !
Loc:Adjunto          STRING(255)                           !
Loc:LogFile          STRING(255)                           !
History::POE:Record  LIKE(POE:RECORD),THREAD
QuickWindow          WINDOW('Presupuesto'),AT(,,245,120),FONT('Microsoft Sans Serif',10,,FONT:regular,CHARSET:DEFAULT), |
  DOUBLE,CENTER,GRAY,IMM,MDI,HLP('UpdatePRESUPUESTO_OBRA_ELECTRICA'),SYSTEM
                       PROMPT('Usuario:'),AT(5,5),USE(?POE:POE_USUARIO:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s20),AT(42,6,45,11),USE(POE:POE_USUARIO),FONT(,12,COLOR:Blue),CENTER
                       PROMPT('Fecha:'),AT(100,5),USE(?POE:POE_UPDATE_DATE:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@D06B),AT(132,6,45,11),USE(POE:POE_UPDATE_DATE),FONT(,12,COLOR:Blue),CENTER
                       BUTTON('Solicitud'),AT(190,5,51,12),USE(?Btn:Abrir),FONT(,12,,FONT:bold),LEFT,ICON(ICON:Open), |
  CURSOR(CURSOR:Hand),TIP('Abrir documento de solicitud adjunto')
                       LINE,AT(5,22,235,0),USE(?LINE2),COLOR(COLOR:Black)
                       PROMPT('Nro:'),AT(5,30,,12),USE(?POE:POE_ID:Prompt),FONT(,14,,FONT:bold),TRN
                       BUTTON('Solicitud'),AT(5,48,38,12),USE(?CallLookup),FONT(,12,,FONT:bold)
                       ENTRY(@N06B),AT(60,48,45,11),USE(POE:POE_SOE_ID),FONT(,12),CENTER,READONLY
                       CHECK('Nro. Obra'),AT(5,65,50),USE(Loc:Obra),FONT(,12,,FONT:bold),VALUE('1','0')
                       ENTRY(@N06B),AT(60,66,45,11),USE(POE:POE_NRO_OBRA),FONT(,12),CENTER,DISABLE
                       PROMPT('Estado:'),AT(5,82),USE(?POE:POE_ESTADO:Prompt),FONT(,12,,FONT:bold),TRN
                       ENTRY(@s15),AT(50,83,55,11),USE(POE:POE_ESTADO),FONT(,12)
                       LINE,AT(116,30,0,65),USE(?LINE1),COLOR(COLOR:Red)
                       OPTION('Acciones'),AT(127,30,114,53),USE(Glo:Acciones),FONT(,12,,FONT:bold),BOXED
                         RADIO('Presupuestar Solicitud'),AT(134,40,100),USE(?Glo:Acciones:RADIO1),VALUE('1')
                         RADIO('Observar Solicitud'),AT(134,53),USE(?Glo:Acciones:RADIO2),VALUE('2')
                         RADIO('Cancelar Solicitud'),AT(134,66),USE(?Glo:Acciones:RADIO3),VALUE('3')
                       END
                       BUTTON('&Aceptar'),AT(64,101,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancelar'),AT(116,101,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       CHECK('Solicitud Refinanciada'),AT(127,86),USE(Loc:Refinancia),FONT(,12,,FONT:bold),VALUE('1', |
  '0')
                       ENTRY(@N06B),AT(60,30,45,11),USE(POE:POE_SOE_ID,,?POE:POE_SOE_ID:2),FONT(,12,,FONT:bold),CENTER
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
Reset                  PROCEDURE(BYTE Force=0),DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
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
Bitmap           &ImageExBitmapClass
TheBitmap        ImageExBitmapClass
JpgSaver         ImageExJpegSaverClass
PDFSaver         ImageExPdfSaverClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_Presupuesto_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
ActPresupuesto          ROUTINE
    POE:POE_UPDATE_DATE = TODAY()
    POE:POE_UPDATE_TIME = CLOCK()
    POE:POE_USUARIO = glo:usuario
ActSolicitud        ROUTINE
    SOE:SOE_USUARIO = glo:usuario
    SOE:SOE_UPDATE_DATE = TODAY()
    SOE:SOE_UPDATE_TIME = CLOCK()
ParamEmail          ROUTINE
    Loc:Ejecutable = '\\gea_pico\CorpSys\sendEmail'
    Loc:Server = 'mail.corpico.com.ar'              !SMTP Server
    Loc:User = 'otecnica_electrico1@corpico.com.ar' !SMTP User
    Loc:Pass = 'o11948to'                           !SMTP Password
    Loc:Desde = 'otecnica_electrico1@corpico.com.ar'
    Loc:Para = SOE:SOE_EMAIL
    Loc:LogFile = '"\\Adm_pico\docu.net\ATP\Solicitudes y Presupuestos\E-mail_Log\LogFile.log"'
    CASE Glo:Acciones
        OF 1 !Presupuesto
            Loc:Asunto = '"Solicitud de Obra Eléctrica Presupuestada"'
            Loc:Mensaje = '"A quien corresponda, se le comunica que el área técnica de Corpico Ltd. ha generado el presupuesto perteneciente a la solicitud de obra nº:' & CLIP(SOE:SOE_ID) & ' a nombre de: ' & CLIP(SOE:SOE_APELLIDO) & ', ' & CLIP(SOE:SOE_NOMBRE) & '. Saludos atte.-"'
            Loc:Adjunto = '"\\Adm_pico\docu.net\ATP\Solicitudes y Presupuestos\Presupuestos\' & CLIP(SOE:SOE_ID) & '.pdf"'
        OF 2 !Observación
            Loc:Asunto = '"Solicitud de Obra Eléctrica Observada"'
            Loc:Mensaje = '"' & SOE:SOE_MOTIVO & '"'
        OF 3 !Cancelación
            Loc:Asunto = '"Solicitud de Obra Eléctrica Cancelada"'
            Loc:Mensaje = '"' & SOE:SOE_MOTIVO & '"'
    END

!    Loc:Ejecutable = '\\gea_pico\CorpSys\sendEmail'
!    Loc:Server = 'mail.corpico.com.ar'              !SMTP Server
!    Loc:User = 'otecnica_electrico1@corpico.com.ar' !SMTP User
!    Loc:Pass = 'o11948to'                           !SMTP Password
!    Loc:Desde = 'otecnica_electrico1@corpico.com.ar'
!    Loc:Para = 'cesarbarrera@corpico.com.ar'
!    Loc:Asunto = '"[Mensaje de Prueba]"'
!    Loc:Mensaje = '"Esto es un mensaje enviado directamente desde Clarion mediante ejecución de sendEmail"'
!    Loc:Adjunto = '"\\Adm_pico\docu.net\ATP\Solicitudes y Presupuestos\Presupuestos\087_Ponce _Walter.pdf"'
!    Loc:LogFile = '"\\Adm_pico\docu.net\ATP\Solicitudes y Presupuestos\E-mail_Log\LogFile.log"'
ActEmail            ROUTINE
    EOP:EOP_DESDE = Loc:Desde
    EOP:EOP_PARA = Loc:Para
    EOP:EOP_ASUNTO = Loc:Asunto
    EOP:EOP_MENSAJE = Loc:Mensaje
    EOP:EOP_ADJUNTO = Loc:Adjunto
    EOP:EOP_FECHA_DATE = TODAY()
    EOP:EOP_FECHA_TIME = CLOCK()
    EOP:EOP_USUARIO = glo:usuario

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Alarma'
  OF InsertRecord
    ActionMessage = 'Se agregará nuevo Presupuesto'
  OF ChangeRecord
    ActionMessage = 'EL Presupuesto será modificado'
  END
  QuickWindow{PROP:StatusText,2} = ActionMessage           ! Display status message in status bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Presupuesto')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?POE:POE_USUARIO:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(POE:Record,History::POE:Record)
  SELF.AddHistoryField(?POE:POE_USUARIO,5)
  SELF.AddHistoryField(?POE:POE_UPDATE_DATE,12)
  SELF.AddHistoryField(?POE:POE_SOE_ID,2)
  SELF.AddHistoryField(?POE:POE_NRO_OBRA,4)
  SELF.AddHistoryField(?POE:POE_ESTADO,3)
  SELF.AddHistoryField(?POE:POE_SOE_ID:2,2)
  SELF.AddUpdateFile(Access:PRESUPUESTO_OBRA_ELECTRICA)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:EMAIL_OBRA_PRESUPUESTADA.Open                     ! File EMAIL_OBRA_PRESUPUESTADA used by this procedure, so make sure it's RelationManager is open
  Relate:PRESUPUESTO_OBRA_ELECTRICA.Open                   ! File PRESUPUESTO_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  Relate:SOLICITUD_OBRA_ELECTRICA.Open                     ! File SOLICITUD_OBRA_ELECTRICA used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:PRESUPUESTO_OBRA_ELECTRICA
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
      ENABLE(?Glo:Acciones)
      ENABLE(?CallLookup)
      DISABLE(?Loc:Obra)
      DISABLE(?Loc:Refinancia)
      !HIDE(?POE:POE_ID:Prompt)
      !HIDE(?POE:POE_ID)
  ELSE
      !UNHIDE(?POE:POE_ID:Prompt)
      !UNHIDE(?POE:POE_ID)
      CASE POE:POE_ESTADO
      OF 'Refinanciar'
          DISABLE(?CallLookup)
          DISABLE(?Loc:Obra)
          DISABLE(?Glo:Acciones)
          ENABLE(?Loc:Refinancia)
      OF 'Pendiente' OROF 'Cerrado'
          SELF.Request = ViewRecord
      OF 'Aceptado'
          DISABLE(?CallLookup)
          DISABLE(?Glo:Acciones)
          DISABLE(?Loc:Refinancia)
          ENABLE(?Loc:Obra)
          Loc:Obra = 0
      END
  END
  Do DefineListboxStyle
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?POE:POE_USUARIO{PROP:ReadOnly} = True
    ?POE:POE_UPDATE_DATE{PROP:ReadOnly} = True
    DISABLE(?Btn:Abrir)
    DISABLE(?CallLookup)
    ?POE:POE_SOE_ID{PROP:ReadOnly} = True
    ?POE:POE_NRO_OBRA{PROP:ReadOnly} = True
    ?POE:POE_ESTADO{PROP:ReadOnly} = True
    ?POE:POE_SOE_ID:2{PROP:ReadOnly} = True
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('Presupuesto',QuickWindow)                  ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  IF ?Loc:Obra{Prop:Checked}
    ENABLE(?POE:POE_NRO_OBRA)
  END
  IF NOT ?Loc:Obra{PROP:Checked}
    DISABLE(?POE:POE_NRO_OBRA)
  END
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:EMAIL_OBRA_PRESUPUESTADA.Close
    Relate:PRESUPUESTO_OBRA_ELECTRICA.Close
    Relate:SOLICITUD_OBRA_ELECTRICA.Close
  END
  IF SELF.Opened
    INIMgr.Update('Presupuesto',QuickWindow)               ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.PrimeFields PROCEDURE

  CODE
  POE:POE_USUARIO = glo:usuario
  POE:POE_FECHA_DATE = TODAY()
  POE:POE_FECHA_TIME = CLOCK()
  POE:POE_UPDATE_DATE = TODAY()
  POE:POE_UPDATE_TIME = CLOCK()
  POE:POE_ESTADO = 'Pendiente'
  PARENT.PrimeFields


ThisWindow.Reset PROCEDURE(BYTE Force=0)

  CODE
  SELF.ForcedReset += Force
  IF QuickWindow{Prop:AcceptAll} THEN RETURN.
  SOE:SOE_ID = POE:POE_SOE_ID                              ! Assign linking field value
  Access:SOLICITUD_OBRA_ELECTRICA.Fetch(SOE:PK_SOE_ID)
  PARENT.Reset(Force)


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    SOE_Browse
    ReturnValue = GlobalResponse
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Btn:Abrir
      ThisWindow.Update()
      RUN(SOE:SOE_PATH)
    OF ?CallLookup
      ThisWindow.Update()
      SOE:SOE_ID = POE:POE_SOE_ID
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        POE:POE_SOE_ID = SOE:SOE_ID
      END
      ThisWindow.Reset(1)
    OF ?POE:POE_SOE_ID
      SOE:SOE_ID = POE:POE_SOE_ID
      IF Access:SOLICITUD_OBRA_ELECTRICA.TryFetch(SOE:PK_SOE_ID)
        IF SELF.Run(1,SelectRecord) = RequestCompleted
          POE:POE_SOE_ID = SOE:SOE_ID
        ELSE
          SELECT(?POE:POE_SOE_ID)
          CYCLE
        END
      END
      ThisWindow.Reset(0)
      IF Access:PRESUPUESTO_OBRA_ELECTRICA.TryValidateField(2) ! Attempt to validate POE:POE_SOE_ID in PRESUPUESTO_OBRA_ELECTRICA
        SELECT(?POE:POE_SOE_ID)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?POE:POE_SOE_ID
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?POE:POE_SOE_ID{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
    OF ?Loc:Obra
      IF ?Loc:Obra{PROP:Checked}
        ENABLE(?POE:POE_NRO_OBRA)
      END
      IF NOT ?Loc:Obra{PROP:Checked}
        DISABLE(?POE:POE_NRO_OBRA)
      END
      ThisWindow.Reset()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    OF ?POE:POE_SOE_ID:2
      IF Access:PRESUPUESTO_OBRA_ELECTRICA.TryValidateField(2) ! Attempt to validate POE:POE_SOE_ID in PRESUPUESTO_OBRA_ELECTRICA
        SELECT(?POE:POE_SOE_ID:2)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?POE:POE_SOE_ID:2
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?POE:POE_SOE_ID:2{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
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
  CLEAR(SOE:Record)
  SOE:SOE_ID = POE:POE_SOE_ID
  GET(SOLICITUD_OBRA_ELECTRICA, SOE:PK_SOE_ID) !Obtengo datos de la solicitud deseada
  IF NOT ERRORCODE() THEN !Si no hay error, verifico
      IF SELF.Request = InsertRecord THEN
          CASE Glo:Acciones
              OF 1
                  SOE:SOE_ESTADO = 'Presupuestada'
                  DO ActSolicitud
                  Access:SOLICITUD_OBRA_ELECTRICA.Update()
                  IF SOE:SOE_EMAIL <> '' THEN
                      SETCURSOR(Cursor:Wait)
                      DO ParamEmail
                      Loc:comando = CLIP(Loc:Ejecutable) & ' -f ' & CLIP(Loc:Desde) & ' -t ' & CLIP(Loc:Para) & ' -s ' & CLIP(Loc:Server) & ' -o username=' & CLIP(Loc:User) & ' -o password=' & CLIP(Loc:Pass) & ' -u ' & CLIP(Loc:Asunto) & ' -m ' & CLIP(Loc:Mensaje) & ' -a ' & CLIP(Loc:Adjunto) & ' -l ' & CLIP(Loc:LogFile)
                      RUN(Loc:comando,0)
                      SETCURSOR()
                      DO ActEmail
                      Access:EMAIL_OBRA_PRESUPUESTADA.Insert()
                  ELSE
                      MESSAGE('El asociado no posee un e-mail adjunto, recordar avisar por otro medio de contacto!', 'Error E-mail', ICON:Exclamation, BUTTON:ok, 1)
                  END
              OF 2
                  RechazoSolicitud()
                  SOE:SOE_ESTADO = 'Observada'
                  SOE:SOE_MOTIVO = Glo:ObsMotivo
                  DO ActSolicitud
                  Access:SOLICITUD_OBRA_ELECTRICA.Update()
                  IF SOE:SOE_EMAIL <> '' THEN
                      SETCURSOR(Cursor:Wait)
                      DO ParamEmail
                      Loc:comando = CLIP(Loc:Ejecutable) & ' -f ' & CLIP(Loc:Desde) & ' -t ' & CLIP(Loc:Para) & ' -s ' & CLIP(Loc:Server) & ' -o username=' & CLIP(Loc:User) & ' -o password=' & CLIP(Loc:Pass) & ' -u ' & CLIP(Loc:Asunto) & ' -m ' & CLIP(Loc:Mensaje) & ' -l ' & CLIP(Loc:LogFile)
                      RUN(Loc:comando,0)
                      SETCURSOR()
                      DO ActEmail
                      Access:EMAIL_OBRA_PRESUPUESTADA.Insert()
                  ELSE
                      MESSAGE('El asociado no posee un e-mail adjunto, recordar avisar por otro medio de contacto!', 'Error E-mail', ICON:Exclamation, BUTTON:ok, 1)
                  END
                  RETURN Level:Fatal
              OF 3
                  RechazoSolicitud()
                  SOE:SOE_ESTADO = 'Cerrada'
                  SOE:SOE_MOTIVO = 'Of. Técnica - ' & Glo:ObsMotivo
                  DO ActSolicitud
                  Access:SOLICITUD_OBRA_ELECTRICA.Update()
                  IF SOE:SOE_EMAIL <> '' THEN
                      SETCURSOR(Cursor:Wait)
                      DO ParamEmail
                      Loc:comando = CLIP(Loc:Ejecutable) & ' -f ' & CLIP(Loc:Desde) & ' -t ' & CLIP(Loc:Para) & ' -s ' & CLIP(Loc:Server) & ' -o username=' & CLIP(Loc:User) & ' -o password=' & CLIP(Loc:Pass) & ' -u ' & CLIP(Loc:Asunto) & ' -m ' & CLIP(Loc:Mensaje) & ' -l ' & CLIP(Loc:LogFile)
                      RUN(Loc:comando,0)
                      SETCURSOR()
                      DO ActEmail
                      Access:EMAIL_OBRA_PRESUPUESTADA.Insert()
                  ELSE
                      MESSAGE('El asociado no posee un e-mail adjunto, recordar avisar por otro medio de contacto!', 'Error E-mail', ICON:Exclamation, BUTTON:ok, 1)
                  END
                  RETURN Level:Fatal
              END
      ELSIF SELF.Request = ChangeRecord THEN
          CASE POE:POE_ESTADO
          OF 'Aceptado'
              IF Loc:Obra = 1 AND POE:POE_NRO_OBRA <> 0 THEN
                  SOE:SOE_ESTADO = 'Cerrada'
                  DO ActSolicitud
                  Access:SOLICITUD_OBRA_ELECTRICA.Update()
                  POE:POE_ESTADO = 'Cerrado'
              END
          OF 'Refinanciar'
              IF Loc:Refinancia = 1 THEN
                  SOE:SOE_ESTADO = 'Presupuestada'
                  DO ActSolicitud
                  Access:SOLICITUD_OBRA_ELECTRICA.Update()
                  POE:POE_ESTADO = 'Pendiente'
              END
          END
      END
  ELSE
      MESSAGE(ERROR() & ' - ' & ERRORCODE(), 'ERROR', ICON:Hand, BUTTON:ok, 1)
  END
  DO ActPresupuesto
  ReturnValue = PARENT.TakeCompleted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

