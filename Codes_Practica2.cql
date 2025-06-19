//
// Código Práctica 2 - Sofía Maldonado García 
//

// 1 - FUENTE DE DATOS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/nodosp2.csv' AS row
CREATE (a:Aeropuerto)
SET a.id = row.id
SET a.label = row.Label
SET a.country = row.country
SET a.latitude = row.latitude
SET a.longitude = row.longitude