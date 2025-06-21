//
// Código Práctica 2 - Sofía Maldonado García 
//

// 1 - FUENTE DE DATOS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/nodosp2.csv' AS row
CREATE (a:Airport)
SET a.id = row.Id
SET a.label = row.Label
SET a.country = row.country
SET a.latitude = row.latitude
SET a.longitude = row.longitude

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/enlacesp2.csv' AS row
MATCH (source:Airport {id:row.Source})
MATCH (target:Airport {id:row.Target})
MERGE (source)-[:VUELA]->(target)

// ANÁLISIS BÁSICO

//2.1
call db.schema.visualization


// CONSULTAS BÁSICAS

//3.1
MATCH (a:Airport)
RETURN a.country AS Pais, COUNT(a) AS NumDeAeropuertos
ORDER BY NumDeAeropuertos DESC 
LIMIT 12;

//3.2
MATCH (a:Airport)-[r:VUELA]-()
RETURN a.label AS Aeropuerto, a.country AS Pais, COUNT(r) AS Conexiones
ORDER BY Conexiones DESC
LIMIT 12; 