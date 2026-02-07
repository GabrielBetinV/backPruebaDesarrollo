CREATE TABLE usuarios (
    usuario_id      NUMBER PRIMARY KEY,
    username        VARCHAR2(50) NOT NULL UNIQUE,
    password_hash   VARCHAR2(200) NOT NULL,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    fecha_creacion  DATE DEFAULT SYSDATE NOT NULL
);


CREATE TABLE perfiles (
    perfil_id   NUMBER PRIMARY KEY,
    nombre      VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(200)
);


CREATE TABLE usuario_perfil (
    usuario_id  NUMBER NOT NULL,
    perfil_id   NUMBER NOT NULL,
    CONSTRAINT pk_usuario_perfil PRIMARY KEY (usuario_id, perfil_id),
    CONSTRAINT fk_up_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_up_perfil FOREIGN KEY (perfil_id) REFERENCES perfiles(perfil_id)
);


CREATE SEQUENCE seq_usuarios START WITH 1;
CREATE SEQUENCE seq_perfiles START WITH 1;


CREATE OR REPLACE PACKAGE pkg_seguridad AS

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


CREATE OR REPLACE PACKAGE BODY pkg_seguridad AS

  PROCEDURE crear_usuario_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_username VARCHAR2(50);
      v_hash     VARCHAR2(200);
  BEGIN
      v_username := json_value(p_json_in, '$.username');
      v_hash     := json_value(p_json_in, '$.passwordHash');

      INSERT INTO usuarios (
          usuario_id, username, password_hash
      )
      VALUES (
          seq_usuarios.NEXTVAL, v_username, v_hash
      );

      p_json_out := '{"codigo":0,"mensaje":"Usuario creado"}';

  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          p_json_out := '{"codigo":1001,"mensaje":"Usuario ya existe"}';

      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END crear_usuario_json;

  PROCEDURE login_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_username VARCHAR2(50);
      v_hash     VARCHAR2(200);
      v_count    NUMBER;
  BEGIN
      v_username := json_value(p_json_in, '$.username');
      v_hash     := json_value(p_json_in, '$.passwordHash');

      SELECT COUNT(*)
        INTO v_count
        FROM usuarios
       WHERE username = v_username
         AND password_hash = v_hash
         AND activo = 'S';

      IF v_count = 0 THEN
          p_json_out := '{"codigo":1002,"mensaje":"Credenciales inválidas"}';
          RETURN;
      END IF;

      p_json_out := '{"codigo":0,"mensaje":"Login OK"}';

  EXCEPTION
      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END login_json;

END pkg_seguridad;
/



