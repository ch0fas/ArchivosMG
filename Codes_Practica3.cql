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

// Código para formar relaciones entre productos comprados en conjunto
MATCH (p:Producto)<-[:CONTIENE]-(o:Orden)-[:CONTIENE]->(p2:Producto)
WITH p, p2, COUNT(o.id) AS qty
MERGE (p)-[:COMPRA_CONJUNTA{quantity:qty}]->(p2);

MATCH (p)-[r:COMPRA_CONJUNTA]->(p2)
SET r.quantity = toInteger(r.quantity); 

// 3
// 3.1

call db.schema.visualization

MATCH (c:Cliente)-[r1:ORDENA]->(o:Orden)-[r2:CONTIENE]->(p:Producto)
RETURN COUNT(DISTINCT c) AS nodosCliente, COUNT(DISTINCT r1) AS relacionesOrdena, COUNT(DISTINCT o) AS nodosOrden, COUNT(DISTINCT r2) AS relacionesContiene, COUNT(DISTINCT p) AS nodosProducto

MATCH ()-[r3:COMPRA_CONJUTNA]->()
RETURN COUNT(DISTINCT r3) AS relacionesConjunta;

// 4

// Implementado usando el Python Driver. El código, junto con las queries, se puede ver en el archivo notebook adjunto.


// 5