SELECT
	RIGHT(t.name,LEN(t.name) - CHARINDEX('__0',t.name)-1) AS session_id,
	t.object_id table_id, 
	t.name table_full_name, 
	RIGHT(LEFT(t.name,CHARINDEX('__',t.name)-1), LEN(LEFT(t.name,CHARINDEX('__',t.name)-1)) - 1) AS table_name,
	col.column_id col_id, 
	col.name col_name, 
	DataType.name data_name, 
	col.max_length data_len, 
	col.precision precision,
	col.scale scale,
	col.is_nullable data_nullable,
	columns_max.col_max col_max
	
FROM
	tempdb.sys.objects t
LEFT JOIN
	tempdb.sys.columns col
ON
	t.object_id = col.object_id
LEFT JOIN 
	tempdb.sys.types DataType 
ON 
	col.user_type_id = DataType.user_type_id
LEFT JOIN
	(SELECT
		object_id,
		max(column_id) col_max
	from
		tempdb.sys.columns
	group by
		object_id
	) columns_max
ON
	t.object_id = columns_max.object_id
where
	t.is_ms_shipped = 0
	and t.name like '#tt%'
order by
	RIGHT(t.name,LEN(t.name) - CHARINDEX('__0',t.name)-1),
	t.object_id,
	col.column_id

