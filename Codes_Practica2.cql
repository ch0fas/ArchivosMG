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

//2 - ANÁLISIS BÁSICO

//2.1
call db.schema.visualization

//2.2
// Código para convertir latitud y longitud a float
MATCH (n)
SET n.latitude = toFloat(n.latitude)
SET n.longitude = toFloat(n.longitude)

//3 - CONSULTAS BÁSICAS

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

//3.3
MATCH p = (a:Airport {label:$Aeropuerto})-[*1..1]-()
RETURN p;

//3.4
MATCH p = (a:Airport {label:$Aeropuerto})-[*1..2]-()
RETURN p;

//4 - PREGUNTAS GUÍA
//4.1
MATCH (a:Airport {country:'Mexico'})
RETURN a.label AS Airport, a.PageRank AS PageRank
ORDER BY PageRank DESC
LIMIT 5;

//4.2
MATCH (a:Airport)
RETURN a.country AS Pais, avg(a.bc) AS CollectiveBC
ORDER BY CollectiveBC DESC
LIMIT 5; 

//4.3
MATCH (a:Airport)
WHERE a.outDegree > a.inDegree
RETURN a.label AS Name, a.PageRank AS PR
ORDER BY PR DESC;

//4.4
MATCH (a:Airport)
RETURN a.label AS Airport, a.wcc AS wcc
ORDER BY wcc DESC
LIMIT 5;

//4.5
MATCH (a:Airport {label:'Guadalajara'})-[*1]-(m)
RETURN m.label AS Airport, m.PageRank AS PR
ORDER BY PR DESC
LIMIT 10;

//4.6
MATCH (a:Airport)
RETURN a.label AS Name, a.triangle_count AS TC
ORDER BY TC DESC
LIMIT 10;

//5 - MODIFICACIONES DE LA ESTRUCTURA DEL GRAFO

//Previo - Creación de SubGrafos
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Airport', // Tipos de nodos
    {VUELA:
    {orientation: 'NATURAL'}}
)

CALL gds.graph.project(
    'myReverseGraph', // Nombre del sub grafo
    'Airport', // Tipos de nodos
    {VUELA:
    {orientation: 'REVERSE'}}
)

CALL gds.graph.project(
    'myUndirectedGraph', // Nombre del sub grafo
    'Airport', // Tipos de nodos
    {VUELA:
    {orientation: 'UNDIRECTED'}}
)

//5.1 
CALL gds.degree.write('myUndirectedGraph', {writeProperty:'degree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//5.2
CALL gds.degree.write('myReverseGraph', {writeProperty:'inDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//5.3
CALL gds.degree.write('myNaturalGraph', {writeProperty:'outDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//5.4 
CALL gds.pageRank.write(
        'myNaturalGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

//5.5
CALL gds.betweenness.write(
        'myNaturalGraph',
        {
                writeProperty: 'bc'
        }
)
YIELD centralityDistribution, nodePropertiesWritten

//5.6
call gds.closeness.write(
        'myNaturalGraph',
        {
                writeProperty: 'cc'
        }
)
YIELD centralityDistribution, nodePropertiesWritten

//5.7 
call gds.louvain.write('myNaturalGraph',{writeProperty: 'louvain'})
YIELD communityCount, modularity, modularities

//5.8
call gds.labelPropagation.write('myNaturalGraph', {writeProperty: 'labelPropagation'})
YIELD communityCount, ranIterations, didConverge

//5.9
CALL gds.triangleCount.write('myUndirectedGraph', {
  writeProperty: 'triangle_count'
})
YIELD globalTriangleCount, nodeCount

//5.10 
call gds.k1coloring.write('myNaturalGraph', {writeProperty: 'k1color'})
YIELD nodeCount, colorCount, ranIterations, didConverge;

//5.11
call gds.scc.write('myNaturalGraph', {writeProperty: 'scc'})
YIELD componentCount, componentDistribution

//5.12
call gds.wcc.write('myUndirectedGraph', {writeProperty: 'wcc'})
YIELD componentCount, componentDistribution
