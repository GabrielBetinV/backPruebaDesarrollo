CREATE TABLE log_transacciones (
    log_id          NUMBER PRIMARY KEY,
    modulo          VARCHAR2(50),
    accion          VARCHAR2(100),
    usuario         VARCHAR2(50),
    fecha           DATE DEFAULT SYSDATE,
    detalle         VARCHAR2(500)
);


CREATE SEQUENCE seq_log_transacciones START WITH 1;


CREATE OR REPLACE PACKAGE pkg_auditoria AS
  PROCEDURE log_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );
END pkg_auditoria;
/


CREATE OR REPLACE PACKAGE BODY pkg_auditoria AS

  PROCEDURE log_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_modulo   VARCHAR2(50);
      v_accion   VARCHAR2(100);
      v_usuario  VARCHAR2(50);
      v_detalle  VARCHAR2(500);
  BEGIN
      v_modulo  := json_value(p_json_in, '$.modulo');
      v_accion  := json_value(p_json_in, '$.accion');
      v_usuario := json_value(p_json_in, '$.usuario');
      v_detalle := json_value(p_json_in, '$.detalle');

      INSERT INTO log_transacciones (
          log_id, modulo, accion, usuario, detalle
      )
      VALUES (
          seq_log_transacciones.NEXTVAL,
          v_modulo, v_accion, v_usuario, v_detalle
      );

      p_json_out := '{"codigo":0,"mensaje":"OK"}';

  EXCEPTION
      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END log_json;

END pkg_auditoria;
/





