  MEMBER('geaSyPOE.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
geaSyPOE_BC0:DctInit    PROCEDURE
geaSyPOE_BC0:DctKill    PROCEDURE
geaSyPOE_BC0:FilesInit  PROCEDURE
  END

Hide:Access:PRESUPUESTO_OBRA_ELECTRICA CLASS(FileManager),TYPE ! FileManager for PRESUPUESTO_OBRA_ELECTRICA
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA CLASS(RelationManager),TYPE ! RelationManager for PRESUPUESTO_OBRA_ELECTRICA
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:SOLICITUD_OBRA_ELECTRICA CLASS(FileManager),TYPE ! FileManager for SOLICITUD_OBRA_ELECTRICA
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PreInsert              PROCEDURE(SIGNED OpCode,UNSIGNED AddLen,*CSTRING ErrCode,*CSTRING ErrMsg),BYTE,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:SOLICITUD_OBRA_ELECTRICA CLASS(RelationManager),TYPE ! RelationManager for SOLICITUD_OBRA_ELECTRICA
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:SQLBLOB  CLASS(FileManager),TYPE               ! FileManager for SQLBLOB
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:SQLBLOB  CLASS(RelationManager),TYPE           ! RelationManager for SQLBLOB
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:SQLQUERY CLASS(FileManager),TYPE               ! FileManager for SQLQUERY
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:SQLQUERY CLASS(RelationManager),TYPE           ! RelationManager for SQLQUERY
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:TIPO_DE_OBRA CLASS(FileManager),TYPE           ! FileManager for TIPO_DE_OBRA
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:TIPO_DE_OBRA CLASS(RelationManager),TYPE       ! RelationManager for TIPO_DE_OBRA
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:EMAIL_OBRA_PRESUPUESTADA CLASS(FileManager),TYPE ! FileManager for EMAIL_OBRA_PRESUPUESTADA
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:EMAIL_OBRA_PRESUPUESTADA CLASS(RelationManager),TYPE ! RelationManager for EMAIL_OBRA_PRESUPUESTADA
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:PRESUPUESTO_OBRA_ELECTRICA &Hide:Access:PRESUPUESTO_OBRA_ELECTRICA,AUTO,THREAD
_Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA &Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA,AUTO,THREAD
_Hide:Access:SOLICITUD_OBRA_ELECTRICA &Hide:Access:SOLICITUD_OBRA_ELECTRICA,AUTO,THREAD
_Hide:Relate:SOLICITUD_OBRA_ELECTRICA &Hide:Relate:SOLICITUD_OBRA_ELECTRICA,AUTO,THREAD
_Hide:Access:SQLBLOB &Hide:Access:SQLBLOB,AUTO,THREAD
_Hide:Relate:SQLBLOB &Hide:Relate:SQLBLOB,AUTO,THREAD
_Hide:Access:SQLQUERY &Hide:Access:SQLQUERY,AUTO,THREAD
_Hide:Relate:SQLQUERY &Hide:Relate:SQLQUERY,AUTO,THREAD
_Hide:Access:TIPO_DE_OBRA &Hide:Access:TIPO_DE_OBRA,AUTO,THREAD
_Hide:Relate:TIPO_DE_OBRA &Hide:Relate:TIPO_DE_OBRA,AUTO,THREAD
_Hide:Access:EMAIL_OBRA_PRESUPUESTADA &Hide:Access:EMAIL_OBRA_PRESUPUESTADA,AUTO,THREAD
_Hide:Relate:EMAIL_OBRA_PRESUPUESTADA &Hide:Relate:EMAIL_OBRA_PRESUPUESTADA,AUTO,THREAD


geaSyPOE_BC0:DctInit PROCEDURE
  CODE
  _Hide:Access:PRESUPUESTO_OBRA_ELECTRICA &= NEW(Hide:Access:PRESUPUESTO_OBRA_ELECTRICA)
  _Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA &= NEW(Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA)
  _Hide:Access:SOLICITUD_OBRA_ELECTRICA &= NEW(Hide:Access:SOLICITUD_OBRA_ELECTRICA)
  _Hide:Relate:SOLICITUD_OBRA_ELECTRICA &= NEW(Hide:Relate:SOLICITUD_OBRA_ELECTRICA)
  _Hide:Access:SQLBLOB &= NEW(Hide:Access:SQLBLOB)
  _Hide:Relate:SQLBLOB &= NEW(Hide:Relate:SQLBLOB)
  _Hide:Access:SQLQUERY &= NEW(Hide:Access:SQLQUERY)
  _Hide:Relate:SQLQUERY &= NEW(Hide:Relate:SQLQUERY)
  _Hide:Access:TIPO_DE_OBRA &= NEW(Hide:Access:TIPO_DE_OBRA)
  _Hide:Relate:TIPO_DE_OBRA &= NEW(Hide:Relate:TIPO_DE_OBRA)
  _Hide:Access:EMAIL_OBRA_PRESUPUESTADA &= NEW(Hide:Access:EMAIL_OBRA_PRESUPUESTADA)
  _Hide:Relate:EMAIL_OBRA_PRESUPUESTADA &= NEW(Hide:Relate:EMAIL_OBRA_PRESUPUESTADA)
  Relate:PRESUPUESTO_OBRA_ELECTRICA &= _Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA
  Relate:SOLICITUD_OBRA_ELECTRICA &= _Hide:Relate:SOLICITUD_OBRA_ELECTRICA
  Relate:SQLBLOB &= _Hide:Relate:SQLBLOB
  Relate:SQLQUERY &= _Hide:Relate:SQLQUERY
  Relate:TIPO_DE_OBRA &= _Hide:Relate:TIPO_DE_OBRA
  Relate:EMAIL_OBRA_PRESUPUESTADA &= _Hide:Relate:EMAIL_OBRA_PRESUPUESTADA


geaSyPOE_BC0:FilesInit PROCEDURE
  CODE
  _Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA.Init
  _Hide:Relate:SOLICITUD_OBRA_ELECTRICA.Init
  _Hide:Relate:SQLBLOB.Init
  _Hide:Relate:SQLQUERY.Init
  _Hide:Relate:TIPO_DE_OBRA.Init
  _Hide:Relate:EMAIL_OBRA_PRESUPUESTADA.Init


geaSyPOE_BC0:DctKill PROCEDURE
  CODE
  _Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA.Kill
  DISPOSE(_Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA)
  _Hide:Relate:SOLICITUD_OBRA_ELECTRICA.Kill
  DISPOSE(_Hide:Relate:SOLICITUD_OBRA_ELECTRICA)
  _Hide:Relate:SQLBLOB.Kill
  DISPOSE(_Hide:Relate:SQLBLOB)
  _Hide:Relate:SQLQUERY.Kill
  DISPOSE(_Hide:Relate:SQLQUERY)
  _Hide:Relate:TIPO_DE_OBRA.Kill
  DISPOSE(_Hide:Relate:TIPO_DE_OBRA)
  _Hide:Relate:EMAIL_OBRA_PRESUPUESTADA.Kill
  DISPOSE(_Hide:Relate:EMAIL_OBRA_PRESUPUESTADA)


Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA.Init PROCEDURE
  CODE
  _Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.Init
  SELF.Init(Access:PRESUPUESTO_OBRA_ELECTRICA,1)


Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= POE:Record
  SELF.FileNameValue = 'PRESUPUESTO_OBRA_ELECTRICA'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= PRESUPUESTO_OBRA_ELECTRICA
  PARENT.Init
  Access:PRESUPUESTO_OBRA_ELECTRICA &= SELF


Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:PRESUPUESTO_OBRA_ELECTRICA &= NULL                ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(PRESUPUESTO_OBRA_ELECTRICA,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
    SELF.AddKey(POE:PK_POE_ID,'POE:PK_POE_ID',0)
    SELF.AddKey(POE:FK_POE_SOE_ID,'POE:FK_POE_SOE_ID',0)
    SELF.AddKey(POE:FK_POE_ESTADO,'POE:FK_POE_ESTADO',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:SOLICITUD_OBRA_ELECTRICA2 USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 2
    GlobalErrors.SetField('POE:POE_SOE_ID')
    Save:SOLICITUD_OBRA_ELECTRICA2 = Access:SOLICITUD_OBRA_ELECTRICA.SaveFile()
    SOE:SOE_ID = POE:POE_SOE_ID
    ReturnValue = Access:SOLICITUD_OBRA_ELECTRICA.TryFetch(SOE:PK_SOE_ID)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'SOLICITUD_OBRA_ELECTRICA')
      END
    END
    Access:SOLICITUD_OBRA_ELECTRICA.RestoreFile(Save:SOLICITUD_OBRA_ELECTRICA2)
  END
  RETURN ReturnValue


Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:SOLICITUD_OBRA_ELECTRICA)


Hide:Relate:PRESUPUESTO_OBRA_ELECTRICA.Kill PROCEDURE

  CODE
  _Hide:Access:PRESUPUESTO_OBRA_ELECTRICA.Kill             ! Kill the file manager
  PARENT.Kill
  Relate:PRESUPUESTO_OBRA_ELECTRICA &= NULL                ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:PRESUPUESTO_OBRA_ELECTRICA)         ! destroy the file manager


Hide:Relate:SOLICITUD_OBRA_ELECTRICA.Init PROCEDURE
  CODE
  _Hide:Access:SOLICITUD_OBRA_ELECTRICA.Init
  SELF.Init(Access:SOLICITUD_OBRA_ELECTRICA,1)


Hide:Access:SOLICITUD_OBRA_ELECTRICA.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= SOE:Record
  SELF.FileNameValue = 'SOLICITUD_OBRA_ELECTRICA'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= SOLICITUD_OBRA_ELECTRICA
  PARENT.Init
  Access:SOLICITUD_OBRA_ELECTRICA &= SELF


Hide:Access:SOLICITUD_OBRA_ELECTRICA.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:SOLICITUD_OBRA_ELECTRICA &= NULL                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:SOLICITUD_OBRA_ELECTRICA.PreInsert PROCEDURE(SIGNED OpCode,UNSIGNED AddLen,*CSTRING ErrCode,*CSTRING ErrMsg)

ReturnValue          BYTE,AUTO

Buffer LIKE(SOE:RECORD)
  CODE
  PUSHERRORS()
  IF SELF.SavePreviousBuffer AND NOT(SELF.PreviousBuffer &= NULL)
     Buffer = SELF.PreviousBuffer
  END
  SOLICITUD_OBRA_ELECTRICA{PROP:ServerAutoInc}
  SOLICITUD_OBRA_ELECTRICA{PROP:ServerAutoInc,1}=1 !SOE:SOE_ID
  ReturnValue = PARENT.PreInsert(OpCode,AddLen,ErrCode,ErrMsg)
  POPERRORS()
  RETURN ReturnValue


Hide:Access:SOLICITUD_OBRA_ELECTRICA.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(SOLICITUD_OBRA_ELECTRICA,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
    SELF.AddKey(SOE:PK_SOE_ID,'SOE:PK_SOE_ID',0)
    SELF.AddKey(SOE:FK_SOE_DNI,'SOE:FK_SOE_DNI',0)
    SELF.AddKey(SOE:FK_SOE_APELLIDO,'SOE:FK_SOE_APELLIDO',0)
    SELF.AddKey(SOE:FK_SOE_TIPO,'SOE:FK_SOE_TIPO',0)
    SELF.AddKey(SOE:FK_SOE_ESTADO,'SOE:FK_SOE_ESTADO',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:SOLICITUD_OBRA_ELECTRICA.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:TIPO_DE_OBRA11 USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 11
    GlobalErrors.SetField('SOE:SOE_TIPO')
    Save:TIPO_DE_OBRA11 = Access:TIPO_DE_OBRA.SaveFile()
    TDO:TDO_TIPO = SOE:SOE_TIPO
    ReturnValue = Access:TIPO_DE_OBRA.TryFetch(TDO:PK_TDO_TIPO)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'TIPO_DE_OBRA')
      END
    END
    Access:TIPO_DE_OBRA.RestoreFile(Save:TIPO_DE_OBRA11)
  END
  RETURN ReturnValue


Hide:Relate:SOLICITUD_OBRA_ELECTRICA.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:PRESUPUESTO_OBRA_ELECTRICA,RI:None,RI:None,POE:FK_POE_SOE_ID)
  SELF.AddRelationLink(SOE:SOE_ID,POE:POE_SOE_ID)

  SELF.AddRelation(Relate:TIPO_DE_OBRA)


Hide:Relate:SOLICITUD_OBRA_ELECTRICA.Kill PROCEDURE

  CODE
  _Hide:Access:SOLICITUD_OBRA_ELECTRICA.Kill               ! Kill the file manager
  PARENT.Kill
  Relate:SOLICITUD_OBRA_ELECTRICA &= NULL                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:SOLICITUD_OBRA_ELECTRICA)           ! destroy the file manager


Hide:Relate:SQLBLOB.Init PROCEDURE
  CODE
  _Hide:Access:SQLBLOB.Init
  SELF.Init(Access:SQLBLOB,1)


Hide:Access:SQLBLOB.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= SQB:Record
  SELF.FileNameValue = 'SQLBLOB'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= SQLBLOB
  PARENT.Init
  Access:SQLBLOB &= SELF


Hide:Access:SQLBLOB.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:SQLBLOB &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:SQLBLOB.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(SQLBLOB,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:SQLBLOB.Kill PROCEDURE

  CODE
  _Hide:Access:SQLBLOB.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:SQLBLOB &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:SQLBLOB)                            ! destroy the file manager


Hide:Relate:SQLQUERY.Init PROCEDURE
  CODE
  _Hide:Access:SQLQUERY.Init
  SELF.Init(Access:SQLQUERY,1)


Hide:Access:SQLQUERY.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= SQL:Record
  SELF.FileNameValue = 'SQLQUERY'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= SQLQUERY
  PARENT.Init
  Access:SQLQUERY &= SELF


Hide:Access:SQLQUERY.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:SQLQUERY &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:SQLQUERY.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(SQLQUERY,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:SQLQUERY.Kill PROCEDURE

  CODE
  _Hide:Access:SQLQUERY.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:SQLQUERY &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:SQLQUERY)                           ! destroy the file manager


Hide:Relate:TIPO_DE_OBRA.Init PROCEDURE
  CODE
  _Hide:Access:TIPO_DE_OBRA.Init
  SELF.Init(Access:TIPO_DE_OBRA,1)


Hide:Access:TIPO_DE_OBRA.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= TDO:Record
  SELF.FileNameValue = 'TIPO_DE_OBRA'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= TIPO_DE_OBRA
  PARENT.Init
  Access:TIPO_DE_OBRA &= SELF


Hide:Access:TIPO_DE_OBRA.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:TIPO_DE_OBRA &= NULL                              ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:TIPO_DE_OBRA.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(TIPO_DE_OBRA,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
    SELF.AddKey(TDO:PK_TDO_TIPO,'TDO:PK_TDO_TIPO',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:TIPO_DE_OBRA.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:SOLICITUD_OBRA_ELECTRICA,RI:None,RI:None,SOE:FK_SOE_TIPO)
  SELF.AddRelationLink(TDO:TDO_TIPO,SOE:SOE_TIPO)


Hide:Relate:TIPO_DE_OBRA.Kill PROCEDURE

  CODE
  _Hide:Access:TIPO_DE_OBRA.Kill                           ! Kill the file manager
  PARENT.Kill
  Relate:TIPO_DE_OBRA &= NULL                              ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:TIPO_DE_OBRA)                       ! destroy the file manager


Hide:Relate:EMAIL_OBRA_PRESUPUESTADA.Init PROCEDURE
  CODE
  _Hide:Access:EMAIL_OBRA_PRESUPUESTADA.Init
  SELF.Init(Access:EMAIL_OBRA_PRESUPUESTADA,1)


Hide:Access:EMAIL_OBRA_PRESUPUESTADA.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= EOP:Record
  SELF.FileNameValue = 'EMAIL_OBRA_PRESUPUESTADA'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= EMAIL_OBRA_PRESUPUESTADA
  PARENT.Init
  Access:EMAIL_OBRA_PRESUPUESTADA &= SELF


Hide:Access:EMAIL_OBRA_PRESUPUESTADA.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:EMAIL_OBRA_PRESUPUESTADA &= NULL                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:EMAIL_OBRA_PRESUPUESTADA.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(EMAIL_OBRA_PRESUPUESTADA,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:EMAIL_OBRA_PRESUPUESTADA.Kill PROCEDURE

  CODE
  _Hide:Access:EMAIL_OBRA_PRESUPUESTADA.Kill               ! Kill the file manager
  PARENT.Kill
  Relate:EMAIL_OBRA_PRESUPUESTADA &= NULL                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:EMAIL_OBRA_PRESUPUESTADA)           ! destroy the file manager

