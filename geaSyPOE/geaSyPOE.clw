   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
_IMAGEEXEXTERNAL_	EQUATE(0)
_IMAGEEXDLLMODE_  EQUATE(0)
   INCLUDE('IMAGEEX.INC'), ONCE

   MAP
     MODULE('GEASYPOE_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('GEASYPOE001.CLW')
Main                   PROCEDURE   !Wizard Application for C:\Proyectos_Clarion\geaSyPOE\solicitud.dct
     END
     MODULE('GEASYPOE002.CLW')
ExtractFileExt         FUNCTION(STRING Filename), STRING   !
SaveImage              FUNCTION(ImageExBitmapClass Bmp, BOOL ShowOptions=false, <string>), BOOL, PROC   !
ExtractFilePath        FUNCTION(STRING Filename), STRING   !
PasswordDecrypt        FUNCTION(string),string   !
     END
     MODULE('GEASYPOE003.CLW')
PasswordEncrypt        FUNCTION(string),string   !
PasswordScreen         PROCEDURE(byte,*short,*string,string)   !
CheckLogin             FUNCTION(string,string,*string,string,*short),byte   !
SolicitudesDetalles    PROCEDURE   !SOLICITUD_OBRA_ELECTRICA
wndScanning            PROCEDURE   !
     END
     INCLUDE('CWUTIL.INC'),ONCE
     MODULE('Clarion runtime library')
         FnSplit(*cstring,*cstring,*cstring,*cstring,*cstring),short,raw,name('_fnsplit')
         Access(*cstring,signed),signed,raw,name('_access'), PROC
     END
   END

GLO:APP_SERVER       CSTRING(21)
GLO:TITULO           CSTRING(101)
GLO:NICKAPP          CSTRING(12)
GLO:GEA_PICO_GEASEGURIDAD_CNX CSTRING(51)
GLO:ODBC_DSN         CSTRING(31)
GLO:ODBC_USER        CSTRING(21)
GLO:ODBC_PASSWORD    CSTRING(21)
GLO:GEA_PICO_INTERFAZ_CNX CSTRING(51)
GLO:GEA_PICO_GEACORPICO_CNX CSTRING('GEA_PICO,GeaCorpico,sa<0>{28}')
GLO:GEA_PICO_PERSONAL_CNX CSTRING('GEA_PICO,Interfaz,sa<0>{30}')
GLO:ODBC_DENARIUS_CNX CSTRING('GEA_PICO,Interfaz,sa<0>{30}')
glo:connectstring    STRING(103)
glo:esadmin          BYTE
glo:fechalogin       DATE
glo:parametros       GROUP,PRE()
glo:parametros_string  STRING(10)
                     END
glo:password         STRING(20)
glo:permiso          SHORT
glo:sistema          BYTE
glo:userdb           STRING(20)
glo:usuario          STRING(20)
Glo:NroRecibo        STRING(15)
Glo:ObsMotivo        STRING(130)
Glo:Motivo           BYTE
Glo:Acciones         BYTE
Glo:SOE_ID           LONG
Glo:Path             STRING(255)
Glo:Save             BYTE
GLO:oneInstance_Main_thread LONG(0)
GLO:oneInstance_Presupuesto_thread LONG(0)
GLO:oneInstance_PresupuestosDetalles_thread LONG(0)
GLO:oneInstance_PresupuestosObrasElectricas_thread LONG(0)
GLO:oneInstance_SOE_Browse_thread LONG(0)
GLO:oneInstance_Solicitud_thread LONG(0)
GLO:oneInstance_SolicitudesDetalles_thread LONG(0)
GLO:oneInstance_SolicitudesObrasElectricas_thread LONG(0)
GLO:oneInstance_TDO_Formulario_thread LONG(0)
GLO:oneInstance_TipoObra_thread LONG(0)
GLO:oneInstance_wndScanning_thread LONG(0)
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
PRESUPUESTO_OBRA_ELECTRICA FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo."PRESUPUESTO_OBRA_ELECTRICA"'),PRE(POE),BINDABLE,THREAD !                    
PK_POE_ID                KEY(POE:POE_ID),PRIMARY           !                    
FK_POE_SOE_ID            KEY(POE:POE_SOE_ID),DUP           !                    
FK_POE_ESTADO            KEY(POE:POE_ESTADO),DUP,NOCASE    !                    
POE_DOCUMENTO               BLOB,BINARY,NAME('"POE_DOCUMENTO"') !                    
Record                   RECORD,PRE()
POE_ID                      LONG,NAME('"POE_ID"')          !                    
POE_SOE_ID                  LONG,NAME('"POE_SOE_ID"')      !                    
POE_ESTADO                  CSTRING(16),NAME('"POE_ESTADO"') !                    
POE_NRO_OBRA                LONG,NAME('"POE_NRO_OBRA"')    !                    
POE_USUARIO                 CSTRING(21),NAME('"POE_USUARIO"') !                    
POE_FECHA                   STRING(8),NAME('"POE_FECHA"')  !                    
POE_FECHA_GROUP             GROUP,OVER(POE_FECHA)          !                    
POE_FECHA_DATE                DATE                         !                    
POE_FECHA_TIME                TIME                         !                    
                            END                            !                    
POE_UPDATE                  STRING(8),NAME('"POE_UPDATE"') !                    
POE_UPDATE_GROUP            GROUP,OVER(POE_UPDATE)         !                    
POE_UPDATE_DATE               DATE                         !                    
POE_UPDATE_TIME               TIME                         !                    
                            END                            !                    
                         END
                     END                       

SOLICITUD_OBRA_ELECTRICA FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo."SOLICITUD_OBRA_ELECTRICA"'),PRE(SOE),BINDABLE,THREAD !                    
PK_SOE_ID                KEY(SOE:SOE_ID),PRIMARY           !                    
FK_SOE_DNI               KEY(SOE:SOE_DNI),DUP,NOCASE       !                    
FK_SOE_APELLIDO          KEY(SOE:SOE_APELLIDO),DUP,NOCASE  !                    
FK_SOE_TIPO              KEY(SOE:SOE_TIPO),DUP             !                    
FK_SOE_ESTADO            KEY(SOE:SOE_ESTADO),DUP           !                    
SOE_DOCUMENTO               BLOB,BINARY,NAME('"SOE_DOCUMENTO"') !                    
Record                   RECORD,PRE()
SOE_ID                      LONG,NAME('"SOE_ID"')          !                    
SOE_DNI                     CSTRING(21),NAME('"SOE_DNI"')  !                    
SOE_APELLIDO                CSTRING(31),NAME('"SOE_APELLIDO"') !                    
SOE_NOMBRE                  CSTRING(31),NAME('"SOE_NOMBRE"') !                    
SOE_CALLE                   CSTRING(21),NAME('"SOE_CALLE"') !                    
SOE_ALTURA                  CSTRING(7),NAME('"SOE_ALTURA"') !                    
SOE_PISO                    CSTRING(4),NAME('"SOE_PISO"')  !                    
SOE_DPTO                    CSTRING(4),NAME('"SOE_DPTO"')  !                    
SOE_TELEFONO                CSTRING(21),NAME('"SOE_TELEFONO"') !                    
SOE_EMAIL                   CSTRING(51),NAME('"SOE_EMAIL"') !                    
SOE_TIPO                    CSTRING(6),NAME('"SOE_TIPO"')  !                    
SOE_ESTADO                  CSTRING(16),NAME('"SOE_ESTADO"') !                    
SOE_USUARIO                 CSTRING(21),NAME('"SOE_USUARIO"') !                    
SOE_FECHA                   STRING(8),NAME('"SOE_FECHA"')  !                    
SOE_FECHA_GROUP             GROUP,OVER(SOE_FECHA)          !                    
SOE_FECHA_DATE                DATE                         !                    
SOE_FECHA_TIME                TIME                         !                    
                            END                            !                    
SOE_UPDATE                  STRING(8),NAME('"SOE_UPDATE"') !                    
SOE_UPDATE_GROUP            GROUP,OVER(SOE_UPDATE)         !                    
SOE_UPDATE_DATE               DATE                         !                    
SOE_UPDATE_TIME               TIME                         !                    
                            END                            !                    
SOE_NRECIBO                 CSTRING(16),NAME('"SOE_NRECIBO"') !                    
SOE_MOTIVO                  CSTRING(131),NAME('"SOE_MOTIVO"') !                    
SOE_PATH                    CSTRING(101)                   !                    
                         END
                     END                       

SQLBLOB              FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo.SQLBLOB'),PRE(SQB),BINDABLE,THREAD !                    
IMAGEN                      BLOB,BINARY                    !                    
Record                   RECORD,PRE()
VAR01                       CSTRING(201)                   !                    
VAR02                       CSTRING(201)                   !                    
VAR03                       CSTRING(201)                   !                    
VAR04                       CSTRING(201)                   !                    
VAR05                       CSTRING(201)                   !                    
VAR06                       CSTRING(201)                   !                    
VAR07                       CSTRING(201)                   !                    
VAR08                       CSTRING(201)                   !                    
VAR09                       CSTRING(201)                   !                    
VAR10                       CSTRING(201)                   !                    
                         END
                     END                       

SQLQUERY             FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo.SQLQUERY'),PRE(SQL),BINDABLE,THREAD !                    
Record                   RECORD,PRE()
COL01                       CSTRING(101)                   !                    
COL02                       CSTRING(101)                   !                    
COL03                       CSTRING(101)                   !                    
COL04                       CSTRING(101)                   !                    
COL05                       CSTRING(101)                   !                    
COL06                       CSTRING(101)                   !                    
COL07                       CSTRING(101)                   !                    
COL08                       CSTRING(101)                   !                    
COL09                       CSTRING(101)                   !                    
COL10                       CSTRING(101)                   !                    
COL11                       CSTRING(101)                   !                    
COL12                       CSTRING(101)                   !                    
COL13                       CSTRING(101)                   !                    
COL14                       CSTRING(101)                   !                    
COL15                       CSTRING(101)                   !                    
COL16                       CSTRING(101)                   !                    
COL17                       CSTRING(101)                   !                    
COL18                       CSTRING(101)                   !                    
COL19                       CSTRING(101)                   !                    
COL20                       CSTRING(101)                   !                    
COL21                       CSTRING(101)                   !                    
COL22                       CSTRING(101)                   !                    
COL23                       CSTRING(101)                   !                    
COL24                       CSTRING(101)                   !                    
COL25                       CSTRING(101)                   !                    
COL26                       CSTRING(101)                   !                    
COL27                       CSTRING(101)                   !                    
COL28                       CSTRING(101)                   !                    
COL29                       CSTRING(101)                   !                    
COL30                       CSTRING(101)                   !                    
COL31                       CSTRING(101)                   !                    
COL32                       CSTRING(101)                   !                    
COL33                       CSTRING(101)                   !                    
COL34                       CSTRING(101)                   !                    
COL35                       CSTRING(101)                   !                    
COL36                       CSTRING(101)                   !                    
COL37                       CSTRING(101)                   !                    
COL38                       CSTRING(101)                   !                    
COL39                       CSTRING(101)                   !                    
COL40                       CSTRING(101)                   !                    
COL41                       CSTRING(101)                   !                    
COL42                       CSTRING(101)                   !                    
COL43                       CSTRING(101)                   !                    
COL44                       CSTRING(101)                   !                    
COL45                       CSTRING(101)                   !                    
COL46                       CSTRING(101)                   !                    
COL47                       CSTRING(101)                   !                    
COL48                       CSTRING(101)                   !                    
COL49                       CSTRING(101)                   !                    
COL50                       CSTRING(101)                   !                    
COL51                       CSTRING(101)                   !                    
COL52                       CSTRING(101)                   !                    
COL53                       CSTRING(101)                   !                    
COL54                       CSTRING(101)                   !                    
COL55                       CSTRING(101)                   !                    
COL56                       CSTRING(101)                   !                    
COL57                       CSTRING(101)                   !                    
COL58                       CSTRING(101)                   !                    
COL59                       CSTRING(101)                   !                    
COL60                       CSTRING(101)                   !                    
COL61                       CSTRING(101)                   !                    
COL62                       CSTRING(101)                   !                    
                         END
                     END                       

TIPO_DE_OBRA         FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo."TIPO_DE_OBRA"'),PRE(TDO),BINDABLE,THREAD !                    
PK_TDO_TIPO              KEY(TDO:TDO_TIPO),PRIMARY         !                    
Record                   RECORD,PRE()
TDO_TIPO                    CSTRING(6),NAME('"TDO_TIPO"')  !                    
TDO_DESCRIPCION             CSTRING(51),NAME('"TDO_DESCRIPCION"') !                    
                         END
                     END                       

EMAIL_OBRA_PRESUPUESTADA FILE,DRIVER('MSSQL'),OWNER(GLO:GEA_PICO_GEACORPICO_CNX),NAME('dbo."EMAIL_OBRA_PRESUPUESTADA"'),PRE(EOP),BINDABLE,THREAD !                    
Record                   RECORD,PRE()
EOP_DESDE                   CSTRING(51),NAME('"EOP_DESDE"') !                    
EOP_PARA                    CSTRING(51),NAME('"EOP_PARA"') !                    
EOP_ASUNTO                  CSTRING(51),NAME('"EOP_ASUNTO"') !                    
EOP_MENSAJE                 CSTRING(256),NAME('"EOP_MENSAJE"') !                    
EOP_ADJUNTO                 STRING(1),NAME('"EOP_ADJUNTO"') !                    
EOP_FECHA                   STRING(8),NAME('"EOP_FECHA"')  !                    
EOP_FECHA_GROUP             GROUP,OVER(EOP_FECHA)          !                    
EOP_FECHA_DATE                DATE                         !                    
EOP_FECHA_TIME                TIME                         !                    
                            END                            !                    
EOP_USUARIO                 CSTRING(13),NAME('"EOP_USUARIO"') !                    
                         END
                     END                       

!endregion

Access:PRESUPUESTO_OBRA_ELECTRICA &FileManager,THREAD      ! FileManager for PRESUPUESTO_OBRA_ELECTRICA
Relate:PRESUPUESTO_OBRA_ELECTRICA &RelationManager,THREAD  ! RelationManager for PRESUPUESTO_OBRA_ELECTRICA
Access:SOLICITUD_OBRA_ELECTRICA &FileManager,THREAD        ! FileManager for SOLICITUD_OBRA_ELECTRICA
Relate:SOLICITUD_OBRA_ELECTRICA &RelationManager,THREAD    ! RelationManager for SOLICITUD_OBRA_ELECTRICA
Access:SQLBLOB       &FileManager,THREAD                   ! FileManager for SQLBLOB
Relate:SQLBLOB       &RelationManager,THREAD               ! RelationManager for SQLBLOB
Access:SQLQUERY      &FileManager,THREAD                   ! FileManager for SQLQUERY
Relate:SQLQUERY      &RelationManager,THREAD               ! RelationManager for SQLQUERY
Access:TIPO_DE_OBRA  &FileManager,THREAD                   ! FileManager for TIPO_DE_OBRA
Relate:TIPO_DE_OBRA  &RelationManager,THREAD               ! RelationManager for TIPO_DE_OBRA
Access:EMAIL_OBRA_PRESUPUESTADA &FileManager,THREAD        ! FileManager for EMAIL_OBRA_PRESUPUESTADA
Relate:EMAIL_OBRA_PRESUPUESTADA &RelationManager,THREAD    ! RelationManager for EMAIL_OBRA_PRESUPUESTADA

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\geaSyPOE.INI', NVD_INI)                   ! Configure INIManager to use INI file
  DctInit
  IF NOT BeginUnique('geaSyPOE.exe')
     BEEP(BEEP:SystemExclamation)
     YIELD()
     CASE MESSAGE('El programa ya está en ejecución!...','Alerta...',ICON:Asterisk,BUTTON:OK,BUTTON:OK,0)
     OF BUTTON:OK
        HALT()
     END
  END
  GLO:GEA_PICO_GEACORPICO_CNX='GEA_PICO,Geacorpico,sa,bmast24;App=geaSPO'
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

