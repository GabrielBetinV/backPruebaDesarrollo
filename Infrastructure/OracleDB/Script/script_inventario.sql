--------------------------------------------------------
-- Archivo creado  - viernes-febrero-06-2026   
--------------------------------------------------------
DROP SEQUENCE "INVENTARIO"."SEQ_ENTRADAS";
DROP SEQUENCE "INVENTARIO"."SEQ_PRODUCTO_DETALLE";
DROP SEQUENCE "INVENTARIO"."SEQ_PRODUCTOS";
DROP SEQUENCE "INVENTARIO"."SEQ_SALIDAS";
DROP TABLE "INVENTARIO"."ENTRADAS" cascade constraints;
DROP TABLE "INVENTARIO"."PRODUCTO_DETALLE" cascade constraints;
DROP TABLE "INVENTARIO"."PRODUCTOS" cascade constraints;
DROP TABLE "INVENTARIO"."SALIDAS" cascade constraints;
DROP PACKAGE "INVENTARIO"."PKG_INVENTARIO";
DROP PACKAGE BODY "INVENTARIO"."PKG_INVENTARIO";
--------------------------------------------------------
--  DDL for Sequence SEQ_ENTRADAS
--------------------------------------------------------

   CREATE SEQUENCE  "INVENTARIO"."SEQ_ENTRADAS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 61 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PRODUCTO_DETALLE
--------------------------------------------------------

   CREATE SEQUENCE  "INVENTARIO"."SEQ_PRODUCTO_DETALLE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 81 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PRODUCTOS
--------------------------------------------------------

   CREATE SEQUENCE  "INVENTARIO"."SEQ_PRODUCTOS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 81 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SALIDAS
--------------------------------------------------------

   CREATE SEQUENCE  "INVENTARIO"."SEQ_SALIDAS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 61 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table ENTRADAS
--------------------------------------------------------

  CREATE TABLE "INVENTARIO"."ENTRADAS" 
   (	"ENTRADA_ID" NUMBER, 
	"PRODUCTO_ID" NUMBER, 
	"CANTIDAD" NUMBER, 
	"FECHA_ENTRADA" DATE DEFAULT SYSDATE, 
	"REFERENCIA" VARCHAR2(100 BYTE), 
	"USUARIO" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table PRODUCTO_DETALLE
--------------------------------------------------------

  CREATE TABLE "INVENTARIO"."PRODUCTO_DETALLE" 
   (	"DETALLE_ID" NUMBER, 
	"PRODUCTO_ID" NUMBER, 
	"STOCK_ACTUAL" NUMBER DEFAULT 0, 
	"STOCK_MINIMO" NUMBER DEFAULT 0, 
	"UBICACION" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table PRODUCTOS
--------------------------------------------------------

  CREATE TABLE "INVENTARIO"."PRODUCTOS" 
   (	"PRODUCTO_ID" NUMBER, 
	"CODIGO" VARCHAR2(50 BYTE), 
	"NOMBRE" VARCHAR2(150 BYTE), 
	"DESCRIPCION" VARCHAR2(500 BYTE), 
	"ACTIVO" CHAR(1 BYTE) DEFAULT 'S', 
	"FECHA_CREACION" DATE DEFAULT SYSDATE, 
	"USUARIO_CREACION" VARCHAR2(50 BYTE), 
	"FECHA_MODIFICACION" DATE, 
	"USUARIO_MODIFICACION" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  GRANT DELETE ON "INVENTARIO"."PRODUCTOS" TO "APP_ROLE";
  GRANT INSERT ON "INVENTARIO"."PRODUCTOS" TO "APP_ROLE";
  GRANT SELECT ON "INVENTARIO"."PRODUCTOS" TO "APP_ROLE";
  GRANT UPDATE ON "INVENTARIO"."PRODUCTOS" TO "APP_ROLE";
--------------------------------------------------------
--  DDL for Table SALIDAS
--------------------------------------------------------

  CREATE TABLE "INVENTARIO"."SALIDAS" 
   (	"SALIDA_ID" NUMBER, 
	"PRODUCTO_ID" NUMBER, 
	"CANTIDAD" NUMBER, 
	"FECHA_SALIDA" DATE DEFAULT SYSDATE, 
	"MOTIVO" VARCHAR2(200 BYTE), 
	"USUARIO" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Package PKG_INVENTARIO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "INVENTARIO"."PKG_INVENTARIO" AS

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

  PROCEDURE listar_productos_stock_json (
      p_json_out OUT CLOB
  );

END pkg_inventario;

/

  GRANT EXECUTE ON "INVENTARIO"."PKG_INVENTARIO" TO "APP_ROLE";
--------------------------------------------------------
--  DDL for Package Body PKG_INVENTARIO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "INVENTARIO"."PKG_INVENTARIO" AS

  ----------------------------------------------------------------------
  -- CREAR PRODUCTO
  ----------------------------------------------------------------------
  PROCEDURE crear_producto_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_codigo   productos.codigo%TYPE;
      v_nombre   productos.nombre%TYPE;
      v_usuario  productos.usuario_creacion%TYPE;
      v_id       productos.producto_id%TYPE;

      c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
      c_info    CONSTANT VARCHAR2(10) := 'INFO';
      c_error   CONSTANT VARCHAR2(10) := 'ERROR';
  BEGIN
      v_codigo  := json_value(p_json_in, '$.Codigo');
      v_nombre  := json_value(p_json_in, '$.Nombre');
      v_usuario := json_value(p_json_in, '$.Usuario');

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

      COMMIT;

      p_json_out := json_object(
          'Status'  VALUE c_success,
          'Message' VALUE 'Producto creado correctamente',
          'Data'    VALUE json_array(
                          json_object(
                              'ProductoId' VALUE v_id,
                              'Codigo'     VALUE v_codigo,
                              'Nombre'     VALUE v_nombre
                          )
                       )
      );

  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK;

          p_json_out := json_object(
              'Status'  VALUE c_info,
              'Message' VALUE 'El código del producto ya existe',
              'Data'    VALUE json_array()
          );

      WHEN OTHERS THEN
          ROLLBACK;

          p_json_out := json_object(
              'Status'  VALUE c_error,
              'Message' VALUE 'Error interno al crear producto ' || SQLERRM ,
              'Data'    VALUE json_array(
                              json_object(
                                  'error_code' VALUE SQLCODE
                              )
                           )
          );
  END crear_producto_json;

  ----------------------------------------------------------------------
  -- ENTRADA DE INVENTARIO
  ----------------------------------------------------------------------
  PROCEDURE entrada_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_producto NUMBER;
      v_cantidad NUMBER;
      v_usuario  VARCHAR2(50);

      c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
      c_error   CONSTANT VARCHAR2(10) := 'ERROR';
  BEGIN
      v_producto := json_value(p_json_in, '$.ProductoId');
      v_cantidad := json_value(p_json_in, '$.Cantidad');
      v_usuario  := json_value(p_json_in, '$.Usuario');

      INSERT INTO entradas (
          entrada_id, producto_id, cantidad, usuario
      )
      VALUES (
          seq_entradas.NEXTVAL, v_producto, v_cantidad, v_usuario
      );

      UPDATE producto_detalle
         SET stock_actual = stock_actual + v_cantidad
       WHERE producto_id = v_producto;

      COMMIT;

      p_json_out := json_object(
          'Status'  VALUE c_success,
          'Message' VALUE 'Entrada registrada correctamente',
          'Data'    VALUE json_array()
      );

  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;

          p_json_out := json_object(
              'Status'  VALUE c_error,
              'Message' VALUE 'Error interno al registrar entrada' || SQLERRM,
              'Data'    VALUE json_array(
                              json_object(
                                  'error_code' VALUE SQLCODE
                              )
                           )
          );
  END entrada_json;

  ----------------------------------------------------------------------
  -- SALIDA DE INVENTARIO
  ----------------------------------------------------------------------
  PROCEDURE salida_json (
      p_json_in  IN  CLOB,
      p_json_out OUT CLOB
  ) IS
      v_producto NUMBER;
      v_cantidad NUMBER;
      v_usuario  VARCHAR2(50);
      v_stock    NUMBER;

      c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
      c_info    CONSTANT VARCHAR2(10) := 'INFO';
      c_error   CONSTANT VARCHAR2(10) := 'ERROR';
  BEGIN
      v_producto := json_value(p_json_in, '$.ProductoId');
      v_cantidad := json_value(p_json_in, '$.Cantidad');
      v_usuario  := json_value(p_json_in, '$.Usuario');

      SELECT stock_actual
        INTO v_stock
        FROM producto_detalle
       WHERE producto_id = v_producto
       FOR UPDATE;

      IF v_stock < v_cantidad THEN
          p_json_out := json_object(
              'Status'  VALUE c_info,
              'Message' VALUE 'Stock insuficiente',
              'Data'    VALUE json_array()
          );
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

      COMMIT;

      p_json_out := json_object(
          'Status'  VALUE c_success,
          'Message' VALUE 'Salida registrada correctamente',
          'Data'    VALUE json_array()
      );

  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;

          p_json_out := json_object(
              'Status'  VALUE c_error,
              'Message' VALUE 'Error interno al registrar salida' || SQLERRM,
              'Data'    VALUE json_array(
                              json_object(
                                  'error_code' VALUE SQLCODE
                              )
                           )
          );
  END salida_json;
  
  
 PROCEDURE listar_productos_stock_json (
    p_json_out OUT CLOB
) IS
    v_data    CLOB;

    c_success CONSTANT VARCHAR2(10) := 'SUCCESS';
    c_error   CONSTANT VARCHAR2(10) := 'ERROR';
BEGIN
    -- Construir el ARRAY JSON primero
    SELECT json_arrayagg(
               json_object(
                   'ProductoId'  VALUE p.producto_id,
                   'Codigo'      VALUE p.codigo,
                   'Nombre'      VALUE p.nombre,
                   'StockActual' VALUE d.stock_actual
               )
           )
      INTO v_data
      FROM productos p
      JOIN producto_detalle d
        ON d.producto_id = p.producto_id;

    -- Armar respuesta estándar
   p_json_out := json_object(
    'Status'  VALUE c_success,
    'Message' VALUE 'Listado de productos',
    'Data'    VALUE COALESCE(v_data, json_array()) FORMAT JSON
);


EXCEPTION
    WHEN OTHERS THEN
        p_json_out := json_object(
            'Status'  VALUE c_error,
            'Message' VALUE SQLERRM,
            'Data'    VALUE json_array()
        );
END listar_productos_stock_json;


END pkg_inventario;

/

  GRANT EXECUTE ON "INVENTARIO"."PKG_INVENTARIO" TO "APP_ROLE";
--------------------------------------------------------
--  Constraints for Table PRODUCTO_DETALLE
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."PRODUCTO_DETALLE" MODIFY ("PRODUCTO_ID" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTO_DETALLE" MODIFY ("STOCK_ACTUAL" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTO_DETALLE" MODIFY ("STOCK_MINIMO" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTO_DETALLE" ADD PRIMARY KEY ("DETALLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table PRODUCTOS
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."PRODUCTOS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTOS" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTOS" MODIFY ("FECHA_CREACION" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTOS" MODIFY ("USUARIO_CREACION" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."PRODUCTOS" ADD CHECK (activo IN ('S','N')) ENABLE;
  ALTER TABLE "INVENTARIO"."PRODUCTOS" ADD PRIMARY KEY ("PRODUCTO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "INVENTARIO"."PRODUCTOS" ADD UNIQUE ("CODIGO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ENTRADAS
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."ENTRADAS" MODIFY ("PRODUCTO_ID" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."ENTRADAS" MODIFY ("CANTIDAD" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."ENTRADAS" MODIFY ("FECHA_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."ENTRADAS" MODIFY ("USUARIO" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."ENTRADAS" ADD CHECK (cantidad > 0) ENABLE;
  ALTER TABLE "INVENTARIO"."ENTRADAS" ADD PRIMARY KEY ("ENTRADA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table SALIDAS
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."SALIDAS" MODIFY ("PRODUCTO_ID" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."SALIDAS" MODIFY ("CANTIDAD" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."SALIDAS" MODIFY ("FECHA_SALIDA" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."SALIDAS" MODIFY ("USUARIO" NOT NULL ENABLE);
  ALTER TABLE "INVENTARIO"."SALIDAS" ADD CHECK (cantidad > 0) ENABLE;
  ALTER TABLE "INVENTARIO"."SALIDAS" ADD PRIMARY KEY ("SALIDA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ENTRADAS
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."ENTRADAS" ADD CONSTRAINT "FK_ENTRADA_PRODUCTO" FOREIGN KEY ("PRODUCTO_ID")
	  REFERENCES "INVENTARIO"."PRODUCTOS" ("PRODUCTO_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCTO_DETALLE
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."PRODUCTO_DETALLE" ADD CONSTRAINT "FK_PD_PRODUCTO" FOREIGN KEY ("PRODUCTO_ID")
	  REFERENCES "INVENTARIO"."PRODUCTOS" ("PRODUCTO_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SALIDAS
--------------------------------------------------------

  ALTER TABLE "INVENTARIO"."SALIDAS" ADD CONSTRAINT "FK_SALIDA_PRODUCTO" FOREIGN KEY ("PRODUCTO_ID")
	  REFERENCES "INVENTARIO"."PRODUCTOS" ("PRODUCTO_ID") ENABLE;
