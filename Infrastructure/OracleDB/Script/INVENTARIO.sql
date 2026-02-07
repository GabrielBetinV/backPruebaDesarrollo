CREATE TABLE productos (
    producto_id        NUMBER PRIMARY KEY,
    codigo              VARCHAR2(50) NOT NULL UNIQUE,
    nombre              VARCHAR2(150) NOT NULL,
    descripcion         VARCHAR2(500),
    activo              CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    fecha_creacion      DATE DEFAULT SYSDATE NOT NULL,
    usuario_creacion    VARCHAR2(50) NOT NULL,
    fecha_modificacion  DATE,
    usuario_modificacion VARCHAR2(50)
);


CREATE TABLE producto_detalle (
    detalle_id      NUMBER PRIMARY KEY,
    producto_id     NUMBER NOT NULL,
    stock_actual    NUMBER DEFAULT 0 NOT NULL,
    stock_minimo    NUMBER DEFAULT 0 NOT NULL,
    ubicacion       VARCHAR2(100),
    CONSTRAINT fk_pd_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
);


CREATE TABLE entradas (
    entrada_id      NUMBER PRIMARY KEY,
    producto_id     NUMBER NOT NULL,
    cantidad        NUMBER NOT NULL CHECK (cantidad > 0),
    fecha_entrada   DATE DEFAULT SYSDATE NOT NULL,
    referencia      VARCHAR2(100),
    usuario         VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_entrada_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
);

CREATE TABLE salidas (
    salida_id       NUMBER PRIMARY KEY,
    producto_id     NUMBER NOT NULL,
    cantidad        NUMBER NOT NULL CHECK (cantidad > 0),
    fecha_salida    DATE DEFAULT SYSDATE NOT NULL,
    motivo          VARCHAR2(200),
    usuario         VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_salida_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
);


CREATE SEQUENCE seq_productos START WITH 1;
CREATE SEQUENCE seq_producto_detalle START WITH 1;
CREATE SEQUENCE seq_entradas START WITH 1;
CREATE SEQUENCE seq_salidas START WITH 1;

CREATE OR REPLACE PACKAGE pkg_inventario AS

  PROCEDURE crear_producto_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );

  PROCEDURE entrada_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );

  PROCEDURE salida_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  );

END pkg_inventario;
/

CREATE OR REPLACE PACKAGE BODY pkg_inventario AS

  PROCEDURE crear_producto_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_codigo   VARCHAR2(50);
      v_nombre   VARCHAR2(150);
      v_usuario  VARCHAR2(50);
      v_id       NUMBER;
  BEGIN
      v_codigo  := json_value(p_json_in, '$.codigo');
      v_nombre  := json_value(p_json_in, '$.nombre');
      v_usuario := json_value(p_json_in, '$.usuario');

      v_id := seq_productos.NEXTVAL;

      INSERT INTO productos (
          producto_id, codigo, nombre, usuario_creacion
      )
      VALUES (
          v_id, v_codigo, v_nombre, v_usuario
      );

      INSERT INTO producto_detalle (
          detalle_id, producto_id, stock_actual
      )
      VALUES (
          seq_producto_detalle.NEXTVAL, v_id, 0
      );

      p_json_out := json_object(
          'codigo' VALUE 0,
          'mensaje' VALUE 'Producto creado',
          'data' VALUE json_object('productoId' VALUE v_id)
      );

  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          p_json_out := '{"codigo":2001,"mensaje":"Código duplicado"}';

      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END crear_producto_json;

  PROCEDURE entrada_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_producto NUMBER;
      v_cantidad NUMBER;
      v_usuario  VARCHAR2(50);
  BEGIN
      v_producto := json_value(p_json_in, '$.productoId');
      v_cantidad := json_value(p_json_in, '$.cantidad');
      v_usuario  := json_value(p_json_in, '$.usuario');

      INSERT INTO entradas (
          entrada_id, producto_id, cantidad, usuario
      )
      VALUES (
          seq_entradas.NEXTVAL, v_producto, v_cantidad, v_usuario
      );

      UPDATE producto_detalle
         SET stock_actual = stock_actual + v_cantidad
       WHERE producto_id = v_producto;

      p_json_out := '{"codigo":0,"mensaje":"Entrada registrada"}';

  EXCEPTION
      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END entrada_json;

  PROCEDURE salida_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_producto NUMBER;
      v_cantidad NUMBER;
      v_usuario  VARCHAR2(50);
      v_stock    NUMBER;
  BEGIN
      v_producto := json_value(p_json_in, '$.productoId');
      v_cantidad := json_value(p_json_in, '$.cantidad');
      v_usuario  := json_value(p_json_in, '$.usuario');

      SELECT stock_actual
        INTO v_stock
        FROM producto_detalle
       WHERE producto_id = v_producto
       FOR UPDATE;

      IF v_stock < v_cantidad THEN
          p_json_out := '{"codigo":3001,"mensaje":"Stock insuficiente"}';
          RETURN;
      END IF;

      INSERT INTO salidas (
          salida_id, producto_id, cantidad, usuario
      )
      VALUES (
          seq_salidas.NEXTVAL, v_producto, v_cantidad, v_usuario
      );

      UPDATE producto_detalle
         SET stock_actual = stock_actual - v_cantidad
       WHERE producto_id = v_producto;

      p_json_out := '{"codigo":0,"mensaje":"Salida registrada"}';

  EXCEPTION
      WHEN OTHERS THEN
          p_json_out := json_object(
              'codigo' VALUE SQLCODE,
              'mensaje' VALUE SQLERRM
          );
  END salida_json;

END pkg_inventario;
/

set serveroutpu on;
DECLARE
  v_json_in  CLOB;
  v_json_out CLOB;
BEGIN
  v_json_in := '{
    "codigo": "PROD-001",
    "nombre": "Laptop Dell",
    "usuario": "admin"
  }';

  pkg_inventario.crear_producto_json(
      v_json_in,
      v_json_out
  );

  DBMS_OUTPUT.PUT_LINE(v_json_out);
END;
/

set serveroutput on;
DECLARE
  v_json_in  CLOB;
  v_json_out CLOB;
BEGIN
  v_json_in := '{
    "productoId": 3,
    "cantidad": 10,
    "usuario": "admin"
  }';

  pkg_inventario.entrada_json(
      v_json_in,
      v_json_out
  );

  DBMS_OUTPUT.PUT_LINE(v_json_out);
END;
/

set serveroutpu on;
DECLARE
  v_json_in  CLOB;
  v_json_out CLOB;
BEGIN
  v_json_in := '{
    "productoId": 3,
    "cantidad": 3,
    "usuario": "admin"
  }';

  pkg_inventario.salida_json(
      v_json_in,
      v_json_out
  );

  DBMS_OUTPUT.PUT_LINE(v_json_out);
END;
/



