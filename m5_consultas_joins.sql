-- Entregable M5: Consultas con JOINs
-- Archivo: m5_consultas_joins.sql

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Cruce de ventas con clientes, productos y categorías para formar la tabla principal de análisis.
SELECT 
    v.fecha_venta, 
    c.id_cliente, 
    c.nombre AS nombre_cliente, 
    c.ciudad AS region_o_ciudad, 
    p.nombre_producto, 
    cat.nombre_categoria AS categoria, 
    v.cantidad, 
    v.precio_unitario, 
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Identifica clientes registrados que aún no han realizado ninguna compra.
SELECT 
    c.nombre, 
    c.email, 
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Identifica productos del catálogo, con su respectiva categoría, que no tienen ventas registradas.
SELECT 
    p.nombre_producto, 
    cat.nombre_categoria, 
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Creación de una columna literal 'canal' separando las ventas según un criterio temporal,
-- agrupando finalmente para obtener el total por canal.
WITH ConsolidadoCanales AS (
    -- Asumimos como ejemplo que las ventas hasta el 10 de marzo son del canal 'Online'
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal 
    FROM ventas 
    WHERE fecha_venta <= '2024-03-10'
    
    UNION ALL
    
    -- Las ventas posteriores al 10 de marzo se marcan como 'Presencial'
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal 
    FROM ventas 
    WHERE fecha_venta > '2024-03-10'
)
SELECT 
    canal, 
    SUM(total) AS total_por_canal
FROM ConsolidadoCanales
GROUP BY canal;
