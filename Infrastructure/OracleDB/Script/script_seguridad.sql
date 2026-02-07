--------------------------------------------------------
-- Archivo creado  - viernes-febrero-06-2026   
--------------------------------------------------------
DROP SEQUENCE "SEGURIDAD"."SEQ_PERFILES";
DROP SEQUENCE "SEGURIDAD"."SEQ_USUARIOS";
DROP TABLE "SEGURIDAD"."PERFILES" cascade constraints;
DROP TABLE "SEGURIDAD"."USUARIO_PERFIL" cascade constraints;
DROP TABLE "SEGURIDAD"."USUARIOS" cascade constraints;
DROP PACKAGE "SEGURIDAD"."PKG_SEGURIDAD";
DROP PACKAGE BODY "SEGURIDAD"."PKG_SEGURIDAD";
--------------------------------------------------------
--  DDL for Sequence SEQ_PERFILES
--------------------------------------------------------

   CREATE SEQUENCE  "SEGURIDAD"."SEQ_PERFILES"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_USUARIOS
--------------------------------------------------------

   CREATE SEQUENCE  "SEGURIDAD"."SEQ_USUARIOS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 61 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table PERFILES
--------------------------------------------------------

  CREATE TABLE "SEGURIDAD"."PERFILES" 
   (	"PERFIL_ID" NUMBER, 
	"NOMBRE" VARCHAR2(50 BYTE), 
	"DESCRIPCION" VARCHAR2(200 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  GRANT DELETE ON "SEGURIDAD"."PERFILES" TO "APP_ROLE";
  GRANT INSERT ON "SEGURIDAD"."PERFILES" TO "APP_ROLE";
  GRANT SELECT ON "SEGURIDAD"."PERFILES" TO "APP_ROLE";
  GRANT UPDATE ON "SEGURIDAD"."PERFILES" TO "APP_ROLE";
--------------------------------------------------------
--  DDL for Table USUARIO_PERFIL
--------------------------------------------------------

  CREATE TABLE "SEGURIDAD"."USUARIO_PERFIL" 
   (	"USUARIO_ID" NUMBER, 
	"PERFIL_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  GRANT DELETE ON "SEGURIDAD"."USUARIO_PERFIL" TO "APP_ROLE";
  GRANT INSERT ON "SEGURIDAD"."USUARIO_PERFIL" TO "APP_ROLE";
  GRANT SELECT ON "SEGURIDAD"."USUARIO_PERFIL" TO "APP_ROLE";
  GRANT UPDATE ON "SEGURIDAD"."USUARIO_PERFIL" TO "APP_ROLE";
--------------------------------------------------------
--  DDL for Table USUARIOS
--------------------------------------------------------

  CREATE TABLE "SEGURIDAD"."USUARIOS" 
   (	"USUARIO_ID" NUMBER, 
	"USERNAME" VARCHAR2(50 BYTE), 
	"PASSWORD_HASH" VARCHAR2(200 BYTE), 
	"ACTIVO" CHAR(1 BYTE) DEFAULT 'S', 
	"FECHA_CREACION" DATE DEFAULT SYSDATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  GRANT DELETE ON "SEGURIDAD"."USUARIOS" TO "APP_ROLE";
  GRANT INSERT ON "SEGURIDAD"."USUARIOS" TO "APP_ROLE";
  GRANT SELECT ON "SEGURIDAD"."USUARIOS" TO "APP_ROLE";
  GRANT UPDATE ON "SEGURIDAD"."USUARIOS" TO "APP_ROLE";
REM INSERTING into SEGURIDAD.PERFILES
SET DEFINE OFF;
Insert into SEGURIDAD.PERFILES (PERFIL_ID,NOMBRE,DESCRIPCION) values ('1','ADMIN','ADMINISTRADOR DEL SISTEMA');
Insert into SEGURIDAD.PERFILES (PERFIL_ID,NOMBRE,DESCRIPCION) values ('2','OPERATIVO','REALIZARA LAS OPERACIONES DE LA APLICACION');
REM INSERTING into SEGURIDAD.USUARIO_PERFIL
SET DEFINE OFF;
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('1','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('2','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('3','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('4','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('6','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('7','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('8','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('21','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('41','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('42','2');
Insert into SEGURIDAD.USUARIO_PERFIL (USUARIO_ID,PERFIL_ID) values ('43','2');
REM INSERTING into SEGURIDAD.USUARIOS
SET DEFINE OFF;
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('21','Abetin','$2a$11$30odYjL6J947PTTo1UuwcOjrk9tq8LDpscUjh2Dn15KgHg8KuWXeW','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('41','Abetin3','$2a$11$mbM0Rg6bVSQ4R0qEVRjIvu6lfqXLCJ/CyP1/2pddlx132ipcvrtJm','S',to_date('07/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('42','Scoba','$2a$11$89mZmICUJYPs3lcEWdgJ9uLsKNHx2HnJ2FXIeQ8eYlreHXAdUfYLe','S',to_date('07/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('43','Scoba2','$2a$11$v5d7afCg0xLObAHyrEe6C.WP056S.NfQ0zoa3pQQ0.JdajpreLEAu','S',to_date('07/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('1','Gbetin','$2a$11$DsMWSLFylzgRuo0R8OtkzOV5dsHKWXlXnaYsgta8/.wGm9oGjTeN6','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('2','Gbetin2','$2a$11$KzckP7XuTyF7Bw93pXW3ku5mh3ovDuhprFkKjc.HvCptnJaLB5i.O','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('3','Gbetin3','$2a$11$8P0jyIlAzfcXk9WqtZh72OU1V2.sDUn5EcDvwFMPIPIvwfPRlwblu','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('4','Gbetin4','$2a$11$d3LmDgHsOXtD9bHfIyul2e3qfPG0jpQ/WfgLttDRENPcTOhzw09i6','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('6','Gbetin5','$2a$11$lCsckswQJ3MhnnnTKtilVeh3mK2ZN8BRaBEiLUxhp6yAMLoyGz2AG','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('7','Gbetin6','$2a$11$JB01IezavKYSsk4/d4XrXOmdoTug9EviI5VQgrMeCpDtRLjU3O7Oy','S',to_date('06/02/26','DD/MM/RR'));
Insert into SEGURIDAD.USUARIOS (USUARIO_ID,USERNAME,PASSWORD_HASH,ACTIVO,FECHA_CREACION) values ('8','Gbetin8','$2a$11$RBMqJWOItPQVXIyHfE81z.WdXI.5i31hLN73X6RiAR5j/AphtYP9e','S',to_date('06/02/26','DD/MM/RR'));
--------------------------------------------------------
--  DDL for Index PK_USUARIO_PERFIL
--------------------------------------------------------

  CREATE UNIQUE INDEX "SEGURIDAD"."PK_USUARIO_PERFIL" ON "SEGURIDAD"."USUARIO_PERFIL" ("USUARIO_ID", "PERFIL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Package PKG_SEGURIDAD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SEGURIDAD"."PKG_SEGURIDAD" AS

  PROCEDURE crear_usuario_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );

  PROCEDURE login_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );

END pkg_seguridad;

/

  GRANT EXECUTE ON "SEGURIDAD"."PKG_SEGURIDAD" TO "APP_ROLE";
--------------------------------------------------------
--  DDL for Package Body PKG_SEGURIDAD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SEGURIDAD"."PKG_SEGURIDAD" AS

PROCEDURE crear_usuario_json (
    p_json_in  IN  CLOB,
    p_json_out OUT CLOB
) IS
    v_username usuarios.username%TYPE;
    v_hash     usuarios.password_hash%TYPE;
    v_usuario_id usuarios.usuario_id%TYPE;

    -- Constantes de estado
    c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
    c_info    CONSTANT VARCHAR2(10) := 'INFO';
    c_error   CONSTANT VARCHAR2(10) := 'ERROR';

BEGIN
    -- Extraer datos del JSON
    v_username := json_value(p_json_in, '$.username');
    v_hash     := json_value(p_json_in, '$.passwordHash');

    -- Insertar usuario
    INSERT INTO usuarios (
        usuario_id, username, password_hash
    )
    VALUES (
        seq_usuarios.NEXTVAL, v_username, v_hash
    )
    RETURNING usuario_id INTO v_usuario_id;
    
    
    
    -- Agregar perfil
    INSERT INTO usuario_perfil (
        usuario_id, perfil_id
    )
    VALUES (
        v_usuario_id,2
    );
    

    COMMIT;

    -- Respuesta estándar (data como ARRAY)
    p_json_out := json_object(
        'Status'  VALUE c_success,
        'Message' VALUE 'Usuario creado correctamente',
        'Data'    VALUE json_array(
                        json_object(
                            'Usuario_id' VALUE v_usuario_id,
                            'Username'   VALUE v_username
                        )
                     )
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;

        p_json_out := json_object(
            'Status'  VALUE c_info,
            'Message' VALUE 'El usuario ya existe',
            'Data'    VALUE json_array()
        );

    WHEN OTHERS THEN
        ROLLBACK;

        p_json_out := json_object(
            'Status'  VALUE c_error,
            'Message' VALUE 'Error interno al crear usuario',
            'Data'    VALUE json_array(
                            json_object(
                                'error_code' VALUE SQLCODE
                            )
                         )
        );
END crear_usuario_json;


PROCEDURE login_json (
    p_json_in  IN  CLOB,
    p_json_out OUT CLOB
) IS
    v_username   usuarios.username%TYPE;
    v_usuario_id usuarios.usuario_id%TYPE;
    v_hash       usuarios.password_hash%TYPE;

    c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
    c_info    CONSTANT VARCHAR2(10) := 'INFO';
    c_error   CONSTANT VARCHAR2(10) := 'ERROR';

BEGIN
    v_username := json_value(p_json_in, '$.username');

    SELECT usuario_id, password_hash
      INTO v_usuario_id, v_hash
      FROM usuarios
     WHERE username = v_username
       AND activo = 'S';

    p_json_out := json_object(
        'Status'  VALUE c_success,
        'Message' VALUE 'Usuario encontrado',
        'Data'    VALUE json_array(
                        json_object(
                            'Usuario_id' VALUE v_usuario_id,
                            'Username'   VALUE v_username,
                            'PasswordHash' VALUE v_hash
                        )
                     )
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_json_out := json_object(
            'Status'  VALUE c_info,
            'Message' VALUE 'Credenciales inválidas',
            'Data'    VALUE json_array()
        );

    WHEN OTHERS THEN
        p_json_out := json_object(
            'Status'  VALUE c_error,
            'Message' VALUE 'Error interno en login',
            'Data'    VALUE json_array(
                            json_object(
                                'error_code' VALUE SQLCODE
                            )
                         )
        );
END login_json;

END pkg_seguridad;

/

  GRANT EXECUTE ON "SEGURIDAD"."PKG_SEGURIDAD" TO "APP_ROLE";
--------------------------------------------------------
--  Constraints for Table USUARIO_PERFIL
--------------------------------------------------------

  ALTER TABLE "SEGURIDAD"."USUARIO_PERFIL" MODIFY ("USUARIO_ID" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."USUARIO_PERFIL" MODIFY ("PERFIL_ID" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."USUARIO_PERFIL" ADD CONSTRAINT "PK_USUARIO_PERFIL" PRIMARY KEY ("USUARIO_ID", "PERFIL_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table USUARIOS
--------------------------------------------------------

  ALTER TABLE "SEGURIDAD"."USUARIOS" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."USUARIOS" MODIFY ("PASSWORD_HASH" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."USUARIOS" MODIFY ("FECHA_CREACION" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."USUARIOS" ADD CHECK (activo IN ('S','N')) ENABLE;
  ALTER TABLE "SEGURIDAD"."USUARIOS" ADD PRIMARY KEY ("USUARIO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SEGURIDAD"."USUARIOS" ADD UNIQUE ("USERNAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table PERFILES
--------------------------------------------------------

  ALTER TABLE "SEGURIDAD"."PERFILES" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "SEGURIDAD"."PERFILES" ADD PRIMARY KEY ("PERFIL_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SEGURIDAD"."PERFILES" ADD UNIQUE ("NOMBRE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table USUARIO_PERFIL
--------------------------------------------------------

  ALTER TABLE "SEGURIDAD"."USUARIO_PERFIL" ADD CONSTRAINT "FK_UP_USUARIO" FOREIGN KEY ("USUARIO_ID")
	  REFERENCES "SEGURIDAD"."USUARIOS" ("USUARIO_ID") ENABLE;
  ALTER TABLE "SEGURIDAD"."USUARIO_PERFIL" ADD CONSTRAINT "FK_UP_PERFIL" FOREIGN KEY ("PERFIL_ID")
	  REFERENCES "SEGURIDAD"."PERFILES" ("PERFIL_ID") ENABLE;
