  MEMBER('geaSyPOE.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('geaSyPOE_BC0.CLW')
geaSyPOE_BC0:DctInit             PROCEDURE
geaSyPOE_BC0:DctKill             PROCEDURE
geaSyPOE_BC0:FilesInit           PROCEDURE
    END
  END

DctInit PROCEDURE
  CODE
  geaSyPOE_BC0:DctInit
  geaSyPOE_BC0:FilesInit


DctKill PROCEDURE
  CODE
  geaSyPOE_BC0:DctKill

