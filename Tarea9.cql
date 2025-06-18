//
// Tarea 9 - Sofía Maldonado García
//

// Código para importar datos
// Query 1 - Nodos
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/Tarea9Nodos.csv" AS row
CREATE (s:State)
SET s = row

//Query 2 - Relaciones
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/Tarea9Relaciones.csv" AS row
MATCH (source:State {id:row.src})
MATCH (target:State {id:row.dst})
MERGE (source)-[:BORDERS]->(target)

// Algoritmo K-1

// Código para Sub-Grafo
call gds.graph.project(
        'myGraph',
        'State',
        {BORDERS: {orientation: 'NATURAL'}}
)

// Implementación de Algoritmo
call gds.k1coloring.write('myGraph', {writeProperty: 'k1color'})
YIELD nodeCount, colorCount, ranIterations, didConverge;

// Muestra comunidades
MATCH (s:State)
RETURN s.k1color AS Color, COUNT(s) AS TotalMembers, COLLECT(s.id) AS Members
ORDER BY Color ASC;

// Para evitar errores en Bloom
MATCH (s:State)
SET s.k1color = s.k1color + 1