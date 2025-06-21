//
// Código Examen 1 - Sofía Maldonado García
//

// 1
LOAD CSV WITH HEADERS FROM 'file:///Personas.csv' AS row
CREATE (p:Persona)
SET p.nombre = row.Persona
SET p.id = row.IdPersona
SET p.colonia = row.Colonia

LOAD CSV FROM 'file:///Relaciones.csv' AS row
MATCH (source:Persona {id:row[0]})
MATCH (target:Persona {id:row[1]})
MERGE (source)-[:CONOCE {weight:toInteger(row[2])}]->(target);

// 2
// 2.1
call db.schema.visualization

// 2.2
MATCH (n:Persona)
RETURN n;

//2.3
MATCH (n)
RETURN COUNT(n), COLLECT(properties(n));

//2.4
call db.shcema.relTypeProperties

MATCH ()-[r:CONOCE]->()
RETURN COUNT(r);

//2.5 - Usando Gephi

// 3

// Código previo a las preguntas, implemetación de algoritmos

// NATURAL = outDegree
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Persona', // Tipos de nodos
    {CONOCE:
    {orientation: 'NATURAL',
     Properties: 'weight'
    }}
)

// REVERSE = inDegree
CALL gds.graph.project(
    'myReverseGraph', // Nombre del sub grafo
    'Persona', // Tipos de nodos
    {CONOCE:
    {orientation: 'REVERSE',
     Properties: 'weight'
    }}
)

// UNDIRECTED = Degree
CALL gds.graph.project(
    'myUndirectedGraph', // Nombre del sub grafo
    'Persona', // Tipos de nodos
    {CONOCE:
    {orientation: 'UNDIRECTED',
     Properties: 'weight'
    }}
)

// OutDegree
CALL gds.degree.write('myNaturalGraph', {writeProperty:'outDegree'})
YIELD centralityDistribution, nodePropertiesWritten


//InDegree
CALL gds.degree.write('myReverseGraph', {writeProperty:'inDegree'})
YIELD centralityDistribution, nodePropertiesWritten


//Degre
CALL gds.degree.write('myUndirectedGraph', {writeProperty:'degree'})
YIELD centralityDistribution, nodePropertiesWritten

// Closeness Centrality
call gds.closeness.write(
        'myNaturalGraph',
        {
                writeProperty: 'Closeness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten

// PageRank
CALL gds.pageRank.write(
        'myNaturalGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

// Betweenness Centrality
CALL gds.betweenness.write(
        'myNaturalGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten

//3.1
MATCH (p:Persona)
RETURN p.nombre AS Name, p.degree AS Degree
ORDER BY Degree DESC 
LIMIT 3;

//3.2
MATCH (p:Persona)
RETURN p.nombre AS Name, p.inDegree AS InDegree
ORDER BY InDegree DESC 
LIMIT 3;

MATCH (p:Persona)
RETURN p.nombre AS Name, p.outDegree AS OutDegree
ORDER BY OutDegree DESC 
LIMIT 3;

// 3.3
MATCH (p:Persona)
RETURN p.nombre AS Name, p.Closeness AS CC
ORDER BY CC DESC 
LIMIT 3;

// 3.4
MATCH (p:Persona)
RETURN p.nombre AS Name, p.PageRank AS PageRank
ORDER BY PageRank DESC 
LIMIT 3;

// 3.5
MATCH (p:Persona)
RETURN p.nombre AS Name, p.betweenness AS BC
ORDER BY BC DESC 
LIMIT 3;

// 4
MATCH p = (:Persona{nombre:$Person})-[*1..2]-()
RETURN p;