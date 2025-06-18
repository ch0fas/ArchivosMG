// Limpia la pantalla
:clear

// Historial de comandos que se han corrido
:history

// Nodos
()
:Persona
:persona // TODAS son etiquetas distintas, en Cypher si importan las mayúsculas y minúsculas
:PERSONA
:personA

(:Persona) // Representación de un nodo con la etiqueta "Persona"

// Atributos
{}
nombre
NOMBRE // De nuevo, atributos distintos
Nombre

{nombre:'Juan'} // Representación de un atributo con un valor

// Relaciones
-- <-- -->


-[]- <-[]- -[]->
:AMIGO
:amigo
:Amigo

CREATE // Sirve para crear relaciones, nodos, etc

CREATE (:Persona);
CREATE (:Persona {nombre:"Juan"});
CREATE (:Persona {nombre:"Juan"})-[:AMIGO]->(:Persona{nombre:"Luis"})

MERGE (:Persona {nombre:"Juan"});

// Terminología SQL vs Cypher
// SELECT = RETURN
// FROM = MATCH
// WHERE = WHERE

RETURN 100*3

MATCH (n)
RETURN n AS Nodos;

MATCH (n:Persona)

MATCH (n)-[r:AMIGO]->(m)
RETURN n, r,m;

MERGE (:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Monitor"})

CREATE (:Producto {desc:"Monitor"})<-[:TIENE]-(:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})

// Para agregarle otro más
MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)-[:TIENE]->(:Producto {desc:"Teclado"})


// BORRAR TODO
MATCH (n) DETACH DELETE (n);

MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}) 


MATCH (t:Tienda {nombre:"Superpapelerias"})
RETURN t;

MATCH (t:Tienda {nombre:"Superpapelerias"})
MERGE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}); 

MATCH (t:Tienda {nombre:"Superpapelerias"})
MATCH (p:Persona{nombre:"Luis"})
MERGE (t)<-[r:OWNER]-(p); 

// Muestra el schema
call db.schema.visualization

// Mostrar atributos de nodos
call db.schema.nodeTypeProperties

// Mostrar atributos de relaciones
call db.schema.relTypeProperties

// Contar todos los nodos tipo Person
MATCH (p:Person)
RETURN COUNT(DISTINCT p);

// Contar todos los nodos de un tipo
MATCH (p:Person)-[r:FOLLOWS]->(p:Person)
RETURN COUNT(DISTINCT r);

// AZul - Zoé (Muestra películas donde actúa Tom Hanks)
MATCH (p:Person {name:"Tom Hanks"})-[r:ACTED_IN]->(m:Movie)
RETURN p,r,m

// Ver si coinciden dos personas en una peli, en cualquier rol
MATCH (p:Person {name:"Tom Hanks"})-[r]->(m:Movie)<-[r2]-(p2:Person {name:"Keanu Reeves"})
RETURN p,m,p2;

// DEGREE TOTAL KEVIN BACON
MATCH (p:Person {name:"Kevin Bacon"})-[r]->()
MATCH (p:Person {name:"Kevin Bacon"})<-[2]-()
MATCH (p:Person {name:"Kevin Bacon"})-[r3]-()
RETURN p.name AS Persona,
        COUNT(DISTINCT r) as OutDegree,
        COUNT(DISTINCT r2) as InDegree,
        COUNT(DISTINCT r3) as Degree;

// Consulta para in, out, y Degree de un nodo
// Out
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]->(m)
RETURN p.name, COUNT(DISTINCT r) AS OutDegree; 

// IN
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)<-[r]-(m)
RETURN p.name, COUNT(DISTINCT r) AS InDegree; 

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r) AS Degree;

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r1]->(m) 
MATCH (p)<-[r2]-(m) 
MATCH (p)-[r3]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r1) AS OutDegree, COUNT(DISTINCT r2) AS InDegree, COUNT(DISTINCT r3) AS Degree;

// Subconsulta

MATCH (p:Person)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.name, OutDegree,InDegree,Degree
ORDER BY Degree DESC LIMIT 5;

// Peliculas con mayor Degree
MATCH (p:Movie)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.title, OutDegree,InDegree,Degree
ORDER BY Degree DESC;

// Crear parametros
:help param

:param name => 'Kevin Bacon';
:param num => 2; 
RETURN $name, $num;

// Muestra las transacciones y los parametros creados
SHOW TRANSACTIONS YIELD *;

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos
MATCH (p:Person{name:'Kevin Bacon'})-[*1..2]-(m)
RETURN COUNT(DISTINCT m);

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos EXACTOS
MATCH (p:Person{name:'Kevin Bacon'})-[*2]-(m)
RETURN COUNT(DISTINCT m);

// BLOOM

/// DATASET Star Wars


// Cuantos nodos persona y cuantos nodos movie hay?
MATCH (p:Person)
RETURN p.name AS Nombre, p.born AS Fecha De Nacimiento
ORDER BY p.born;

// # de actores por película
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas DESC; 

// Top 5 películas con más actores
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas
ORDER BY Personas DESC
LIMIT 5;

// 
// ALGORITMOS DE CENTRALIDAD
//

// PAGERANK
// Paso 1. Crear SubGrafo
call gds.graph.project(
        'myGraph',
        'Villian',
        'COMPANION',
        {relationshipProperties:'Weight'}
)

// Paso 2. Calcular la memoria 
CALL gds.pageRank.write.estimate(
        'myGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }
);

// Paso 3. Ejecutar algoritmo
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score AS PageRankScore
ORDER BY PageRankScore DESC;

// Paso 4. Añadir atributo de score de PageRank a los nodos/relaciones.  
CALL gds.pageRank.write(
        'MyGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

//
// Betweenness Centrality
//

// Paso 1. Crear SubGrafo
call gds.graph.project(
        'myGraph',
        'Villian',
        'COMPANION',
        {relationshipProperties:'Weight'}
)

// Paso 2. Calcular la memoria 
CALL gds.betweenness.write.estimate(
        'myGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory;

// Paso 3. Aplicar algoritmo
CALL gds.betweenness.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score AS BetweennessScore
ORDER BY BetweennessScore DESC;

// Paso 4. Añadir atributo del algoritmo a los nodos
CALL gds.betweenness.write(
        'myGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimunScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

// Centrality
// 1. Crear un sub grafo
// NATURAL = outDegree
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// REVERSE = inDegree
CALL gds.graph.project(centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimumScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten
    'myReverseGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'REVERSE',
     Properties: 'Weight'
    }}
)

// UNDIRECTED = Degree
CALL gds.graph.project(
    'myUndirectedGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'UNDIRECTED',
     Properties: 'Weight'
    }}
)

// 4. Añadir un nuevo atributo a los nodos/relaciones

// OutDegree
CALL gds.degree.write('myNaturalGraph', {writeProperty:'outDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//InDegree
CALL gds.degree.write('myReverseGraph', {writeProperty:'inDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//Degre
CALL gds.degree.write('myUndirectedGraph', {writeProperty:'degree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

// Consulta que regrese Name, PageRank, BC, In, Out, Degree
MATCH (v:Villian )
RETURN v.Name, v.PageRank, v.betweenness, v.inDegree, v.outDegree, v.degree
ORDER BY v.degree DESC

//
// Closeness Centrality
//

// 1.
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// 4. Añadir atributo closeness centrality
call gds.closeness.write(
        'myNaturalGraph',
        {
                writeProperty: 'Closeness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimumScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

//
// Bridges
//

// 1. 
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// 4. 
// Sub Grafo para TODO el Dataset
CALL gds.graph.project(
  'myNaturalGraph',
  ['Person', 'Droid', 'Movie'],
  {
    APPEARS_IN: {
      orientation: 'NATURAL'
    },
    SPEAKS_WITH: {
      orientation: 'NATURAL'
    }
  }
)

//
// Actividad Dashboard, Códigos
//

// 1.
call db.schema.visualization

// 2.
MATCH (n)
RETURN labels(n) AS Nodes, count(n) AS NodeCount
ORDER BY NodeCount DESC;

// 3.
MATCH (s:SuperHero)-[r]-(s2:SuperHero)
RETURN s,r,s2;

// 5.
MATCH (s:SuperHero)
RETURN s.degree AS Degree, COUNT(s) AS NumHero
ORDER BY Degree DESC;

// 6.
MATCH (s:SuperHero)
RETURN s.PageRank AS PageRank, COUNT(s) AS NumHero
ORDER BY PageRank DESC;

// 7.
MATCH (s:SuperHero)
RETURN s.betweenness AS Betweenness, COUNT(s) AS NumHero
ORDER BY Betweenness DESC;

// 8.
MATCH (s:SuperHero {Name:$neodash_superhero_name})
RETURN s.Name AS Name, s.inDegree AS InDegree, s.outDegree1 AS OutDegree, s.degree AS Degree, s.PageRank AS PageRank, s.betweenness AS Betweenness;

// 
// ALGORITMOS DE COMUNIDAD
//


// 1. LOUVAIN
// Subgrafo no(!!) dirigido
call gds.graph.project(
        'myGraph',
        'Villian',
        {COMPANION: {orientation: 'UNDIRECTED'}}
)

// Implementación
call gds.louvain.write('myGraph',{writeProperty: 'louvain'})
YIELD communityCount, modularity, modularities

// Código que muestra cada comunidad, su # de miembros y los miembros en una lista
MATCH (v:Villian)
RETURN v.louvain AS Louvain, COUNT(DISTINCT v) AS NumberOfMembers, COLLECT(v.Name) AS Members;

// Para ver las comunidades entre las iteraciones
call gds.louvain.stream('myGraph', {includeIntermediateCommunities: true})
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name AS Name, communityId, intermediateCommunityIds
ORDER BY communityId ASC, intermediateCommunityIds ASC, Name ASC;

// 2. K-1 COLORING

// Subgrafo
call gds.graph.project(
        'myUndirectedGraph',
        'Villian',
        {COMPANION: {orientation: 'UNDIRECTED'}}
)

// Implementado
call gds.k1coloring.write('myUndirectedGraph', {writeProperty: 'k1color'})
YIELD nodeCount, colorCount, ranIterations, didConverge;

// Para ver colores, cuántos nodos tienen cada color, y los nodos
MATCH (v:Villian)
RETURN v.k1color AS Color, COUNT(DISTINCT v) AS MembersPerColor, COLLECT(v.Name) AS Names;

// Cambiar color 0 a otro color, para Bloom
MATCH (v:Villian)
SET v.k1color = k1color + 1