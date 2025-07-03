// Código Práctica 3
// Sofía Maldonado García

// 2 - FUENTE DE DATOS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/clientes_p3.csv' AS row
CREATE (c:Cliente)
SET c.id = row.id_cliente;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/productos_p3.csv' AS row
CREATE (p:Producto) 
SET p.nombreProducto = row.Producto
SET p.id = row.id_producto;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/operaciones_p3.csv' AS row
CREATE (o:Orden)
SET o.id = row.id_operacion
SET o.cliente = row.id_cliente
SET o.fecha = right(row.fecha_operacion,4)
SET o.fecha = toInteger(o.fecha);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/dedtalles_p3.csv' AS row
MATCH (o:Orden {id:row.id_operacion})
MATCH (p:Producto {id:row.id_producto})
MERGE (o)-[:CONTIENE {qty:row.cantidad_producto}]->(p);

MATCH (o:Orden)
MATCH (c:Cliente {id:o.cliente})
MERGE (c)-[:ORDENA]->(o);

MATCH (c:Cliente)-[r:ORDENA]->(o:Orden)-[r2:CONTIENE]->(p:Producto)
SET c.id = toInteger(c.id)
SET p.id = toInteger(p.id)
SET r.qty = toInteger(r.qty);



// 5