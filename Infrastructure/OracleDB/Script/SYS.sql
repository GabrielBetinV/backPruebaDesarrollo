-- SEGURIDAD
CREATE USER seguridad IDENTIFIED BY SegPwd123;
GRANT CREATE SESSION TO seguridad;

-- INVENTARIO
CREATE USER inventario IDENTIFIED BY InvPwd123;
GRANT CREATE SESSION TO inventario;

-- AUDITORIA
CREATE USER auditoria IDENTIFIED BY AudPwd123;
GRANT CREATE SESSION TO auditoria;

GRANT CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO seguridad;
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO inventario;
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO auditoria;

GRANT CREATE PROCEDURE TO seguridad;
GRANT CREATE PROCEDURE TO inventario;
GRANT CREATE PROCEDURE TO auditoria;

create synonym usuarios for seguridad.usuarios;
create synonym perfiles for seguridad.perfiles;

create synonym usuario_perfil for seguridad.usuario_perfil;



GRANT INSERT ON auditoria.log_transacciones TO inventario;

CREATE ROLE app_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON inventario.productos TO app_role;
GRANT EXECUTE ON inventario.pkg_inventario TO app_role;
GRANT app_role TO app_user;


GRANT SELECT, INSERT, UPDATE, DELETE ON seguridad.usuarios TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON seguridad.usuario_perfil TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON seguridad.perfiles TO app_role;
GRANT EXECUTE ON seguridad.pkg_seguridad TO app_role;


GRANT SELECT, INSERT, UPDATE, DELETE
ON seguridad.usuarios
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON seguridad.usuario_perfil
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON seguridad.perfiles
TO app_user;

SELECT * FROM user_tab_privs;
GRANT SELECT ON seguridad.seq_usuarios TO app_user;


GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.productos
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.producto_detalle
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.entradas
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.salidas
TO app_user;


GRANT SELECT ON inventario.seq_entradas TO app_user;
GRANT SELECT ON inventario.seq_salidas TO app_user;
GRANT SELECT ON inventario.seq_productos TO app_user;
GRANT SELECT ON inventario.seq_salidas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.productos
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.producto_detalle
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.entradas
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON inventario.salidas
TO app_user;


GRANT SELECT ON inventario.seq_entradas TO app_user;
GRANT SELECT ON inventario.seq_salidas TO app_user;
GRANT SELECT ON inventario.seq_productos TO app_user;
GRANT SELECT ON inventario.seq_producto_detalle TO app_user;